using EventScoring.DataAccess.Repository.IRepository;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Security.Claims;
using Utils;

namespace EventScoringWeb.Pages {
    public class IndexModel : PageModel {
        private readonly ILogger<IndexModel> _logger;
        private readonly IApplicationUserRepository _users;
        private readonly UserManager<IdentityUser> _userManager;

        public IndexModel(ILogger<IndexModel> logger,
            IApplicationUserRepository users,
            UserManager<IdentityUser> userManager)
        {
            _logger = logger;
            _users = users;
            _userManager = userManager;
        }

        public IActionResult OnGet() {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            var user = _users.GetFirstOrDefault(u => u.Id == userId);
            //if (user == null)
            //{
            //    return RedirectToPage("/Auth/Login");
            //}

            if (user != null && _userManager.IsInRoleAsync(user, AppRoles.Judge).GetAwaiter().GetResult())
            {
                return RedirectToPage("/Judge/Home");
            }

            if (user != null && _userManager.IsInRoleAsync(user, AppRoles.EventHost).GetAwaiter().GetResult())
            {
                return RedirectToPage("/Event/Index");
            }

            return Page();
        }
    }
}