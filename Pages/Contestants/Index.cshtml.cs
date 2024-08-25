using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Security.Claims;
using Utils;

namespace EventScoringWeb.Pages.Contestants
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin}")]
    public class IndexModel : PageModel
    {
        private readonly IEventRepository _events;
        private readonly IContestantRepository _contestants;

        public IndexModel(
            IEventRepository events,
            IContestantRepository contestants)
        {
            _events = events;
            _contestants = contestants;
        }

        public IEnumerable<Contestant> Contestants { get; set; }
        // for url navigation
        [BindProperty]
        public Guid EventId { get; set; }

        public IActionResult OnGet(Guid eventId)
        {
            // authorize if logged in user is the owner of the event.
            var evenT = _events.GetFirstOrDefault(filter: p => p.EventId.Equals(eventId), p => p.ApplicationUser);
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (evenT.ApplicationUserId != userId)
            {
                return RedirectToPage("/Event/Index", new { eventId = eventId });
            }

            Contestants = _contestants.GetAll(
                p => p.EventId.Equals(eventId),
                p => p.Event,
                p => p.Team,
                p => p.Competition
            );

            EventId = eventId;

            return Page();
        }

        public IActionResult OnPostDelete(Guid id)
        {
            var objFromDb = _contestants.GetFirstOrDefault(c => c.ContestantId.Equals(id));

            if (objFromDb == null)
            {
                return NotFound($"Could not delete contestant with ID: {id}");
            }

            _contestants.Remove(objFromDb);
            _contestants.Save();

            return RedirectToPage("Index", new { eventId = EventId });
        }
    }
}
