using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Security.Claims;
using Utils;

namespace EventScoringWeb.Pages.Competitions
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin}")]
    public class IndexModel : PageModel
    {
        private readonly ICompetitionRepository _competitions;
        private readonly IApplicationUserRepository _users;
        private readonly IEventRepository _events;

        public IndexModel(ICompetitionRepository competitions, IApplicationUserRepository users, IEventRepository events)
        {
            _competitions = competitions;
            _users = users;
            _events = events;
        }

        [BindProperty]
        public IEnumerable<Competition> Competitions { get; set; }

        //[BindProperty]
        public Guid EventId { get; set; }
        
        public IActionResult OnGet(Guid eventId)
        {
            // id of logged in user
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            Competitions = _competitions.GetAll(
                filter: p => p.EventId.Equals(eventId), include => include.Category);

            // get event object
            var fromEvent = _events.GetFirstOrDefault(p => p.EventId.Equals(eventId), includes: p => p.ApplicationUser);

            // checks if the user is the owner if this event. Redirects back to event index if true.
            if (fromEvent != null && fromEvent.ApplicationUserId != userId)
            {
                return RedirectToPage("/Event/Index");
            }

            EventId = eventId;

            // successful
            return Page();
        }

        public async Task<IActionResult> OnPostDelete(Guid id, Guid eventId)
        {
            var objFromDb = _competitions.GetFirstOrDefault(p => p.CompetitionId.Equals(id));
            if (objFromDb != null)
            {
                _competitions.Remove(objFromDb);
                _competitions.Save();
            }

            return RedirectToPage(new { eventId = eventId });
        }
    }
}
