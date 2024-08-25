using EventScoring.DataAccess.Data;
using EventScoring.DataAccess.DbInitializer;
using EventScoring.DataAccess.Repository;
using EventScoring.DataAccess.Repository.IRepository;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace EventScoringWeb
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);
            

            // Add services to the container.
            builder.Services.AddRazorPages(options =>
            {
            });

            builder.Services.AddDbContext<ApplicationDbContext>(options =>
            {
                options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"));
            }
            );

            // Add Identity
            // Should go first before ConfigureApplicationCookie()
            builder.Services
                .AddIdentity<IdentityUser, IdentityRole>()
                .AddEntityFrameworkStores<ApplicationDbContext>(); // connects our dbcontext to identity

            builder.Services.ConfigureApplicationCookie(options =>
            {
                options.LoginPath = "/auth/login";
                options.LogoutPath = "/auth/logout";
                options.AccessDeniedPath = "/auth/accessdenied";
                options.AccessDeniedPath = "/AccessDenied";
            });

            // neater url 
            builder.Services.Configure<RouteOptions>(options =>
            {
                options.AppendTrailingSlash = true;
                options.LowercaseUrls = true;
                options.LowercaseQueryStrings = false; // need to set to false for email to work
            });

            // Register Repositories
            builder.Services.AddScoped<IApplicationUserRepository, ApplicationUserRepository>();
            builder.Services.AddScoped<ICategoryRepository, CategoryRepository>();
            builder.Services.AddScoped<ICompetitionRepository, CompetitionRepository>();
            builder.Services.AddScoped<IContestantRepository, ContestantRepository>();
            builder.Services.AddScoped<ICriterionRepository, CriterionRepository>();
            builder.Services.AddScoped<IEventRepository, EventRepository>();
            builder.Services.AddScoped<IScoreRepository, ScoreRepository>();
            builder.Services.AddScoped<ITeamRepository, TeamRepository>();

            builder.Services.AddScoped<IDbInitializer, DbInitializer>();

            var app = builder.Build();


            // Configure the HTTP request pipeline.
            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseStatusCodePages(async context =>
            {
                if (context.HttpContext.Response.StatusCode == 403)
                {
                    context.HttpContext.Response.Redirect("~/AccessDenied");
                }
            });

            // Got it from here
            // https://stackoverflow.com/questions/31606521/displaying-a-404-not-found-page-for-asp-net-core-mvc
            app.Use(async (context, next) =>
            {
                await next();
                if (context.Response.StatusCode == 404)
                {
                    context.Request.Path = "/PageNotFound";
                    await next(); 
                }
            });

            app.UseHttpsRedirection();
            app.UseStaticFiles();

            app.UseRouting();


            SeedDatabase(app);

            // Authentication should come before UseAuthorization.
            app.UseAuthentication();

            app.UseAuthorization();

            app.MapRazorPages();

            app.Run();
        }

        public static void SeedDatabase(WebApplication app)
        {
            using (var scope = app.Services.CreateScope())
            {
                var dbInitializer = scope.ServiceProvider.GetRequiredService<IDbInitializer>();
                dbInitializer.Initialize();
            }
        }
    }
}