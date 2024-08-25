using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Security.Claims;
using Utils;

namespace EventScoringWeb.Pages.Judge
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin}")]
    public class IndexModel : PageModel
    {
        private readonly IApplicationUserRepository _users;
        private readonly IEventRepository _events;
        private readonly ICompetitionRepository _competitions;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly UserManager<IdentityUser> _userManager;

        public IndexModel(
            IApplicationUserRepository users, 
            IEventRepository events,
            ICompetitionRepository competitions,
            RoleManager<IdentityRole> roleManager, 
            UserManager<IdentityUser> userManager)
        {
            _users = users;
            _roleManager = roleManager;
            _userManager = userManager;
            _events = events;
            _competitions = competitions;
        }

        [BindProperty]
        public List<ApplicationUser> Judges { get; set; }

        public Guid EventId { get; set; }

        public IActionResult OnGet(Guid eventId)
        {
            // get id of logged in user
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            EventId = eventId;

            // get the associiated event 
            var evenT = _events.GetFirstOrDefault(u => u.EventId.Equals(eventId),
                includes: p => p.ApplicationUser);

            // do not allow access if logged in user is not the owner of the event
            if (evenT.ApplicationUserId != userId)
            {
                //return RedirectToPage("/AccessDenied");
                //return StatusCode(403);

                // To forbid user or just redirect back to /event/index?
                return Forbid();
            }


            var competitions = _competitions.GetAll(
                filter: p => p.EventId.Equals(eventId),
                p => p.Event, p => p.Judges);

            Judges = new List<ApplicationUser>();
            foreach (var competition in competitions)
            {
                foreach (var judge in competition.Judges)
                {
                    if (_userManager.IsInRoleAsync(judge, AppRoles.Judge).GetAwaiter().GetResult())
                    {
                        //Judges.AddRange(competition.Judges);
                        if (Judges.FirstOrDefault(u => u.Id == judge.Id) == null)
                        {
                            Judges.Add(judge);
                        }
                    }
                }
            }

            return Page();
        }

        public async Task<IActionResult> OnPostDelete(Guid eventId, string id)
        {
            var judge = (ApplicationUser)(await _userManager.FindByIdAsync(id));
            if (judge == null)
            {
                return NotFound($"Unable to load user with ID '{id}'");
            }

            try
            {
                _users.Remove(judge);
                _users.Save();
            }
            catch (Exception ex)
            {
                ViewData["delete-error"] = "An error occurred while attempting to delete user";
                return Page();
            }

            return RedirectToPage(nameof(Index), new { eventId });
        }
    }
}
