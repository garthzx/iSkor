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
    public class EditModel : PageModel
    {
        private readonly ITeamRepository _teams;
        private readonly IEventRepository _events;

        public EditModel(ITeamRepository teams, IEventRepository events)
        {
            _teams = teams;
            _events = events;
        }

        [BindProperty]
        public Team Team { get; set; }

        public IActionResult OnGet(Guid eventId, Guid teamId)
        {
            // authorize if logged in user is the owner of the event.
            var evenT = _events.GetFirstOrDefault(filter: p => p.EventId.Equals(eventId), p => p.ApplicationUser);
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (evenT.ApplicationUserId != userId)
            {
                return RedirectToPage("/Event/Index", new { eventId = eventId });
            }

            Team = _teams.GetFirstOrDefault(t => t.TeamId.Equals(teamId), p => p.Event);

            return Page();
        }

        public IActionResult OnPost()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }

            _teams.Update(Team);

            return RedirectToPage("Index", new { eventId = Team.EventId });
        }
    }
}
