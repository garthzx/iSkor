using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Security.Claims;
using Utils;

namespace EventScoringWeb.Pages.Teams
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin}")]
    public class AddModel : PageModel
    {
        private readonly IEventRepository _events;
        private readonly ITeamRepository _teams;

        public AddModel(
            IEventRepository events, ITeamRepository teams)
        {
            _events = events;
            _teams = teams;
        }

        [BindProperty]
        public Team Team { get; set; }

        public IActionResult OnGet(Guid eventId)
        {
            // authorize if logged in user is the owner of the event.
            var evenT = _events.GetFirstOrDefault(filter: p => p.EventId.Equals(eventId), p => p.ApplicationUser);
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (evenT.ApplicationUserId != userId)
            {
                return RedirectToPage("/Event/Index", new { eventId = eventId });
            }

            Team = new Team();
            Team.EventId = eventId;

            return Page();
        }

        public IActionResult OnPost()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }

            _teams.Add(Team);
            _teams.Save();

            return RedirectToPage("Index", new { eventId = Team.EventId });
        }
    }
}
