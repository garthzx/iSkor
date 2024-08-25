using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Security.Claims;
using Utils;

namespace EventScoringWeb.Pages.Criteria
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin}")]
    public class IndexModel : PageModel
    {
        private readonly IEventRepository _events;
        private readonly ICriterionRepository _criteria;

        public IndexModel(
            IEventRepository events, 
            ICriterionRepository criteria)
        {
            _events = events;
            _criteria = criteria;
        }

        [BindProperty]
        public IEnumerable<IGrouping<string, Criterion>> Criteria { get; set; }
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

            Criteria = _criteria.GetAll(
                c => c.Competition.EventId.Equals(eventId),
                include => include.Competition
            ).GroupBy(g => g.Competition.Name);

            EventId = eventId;

            return Page();
        }

        public IActionResult OnPostDelete(Guid id)
        {
            Criterion objFromDb = _criteria.GetFirstOrDefault(filter: c => c.CriterionId.Equals(id));
            if (objFromDb == null) 
            {
                return NotFound($"Could not delete criterion with ID {id}");
            }

            _criteria.Remove(objFromDb);
            _criteria.Save();

            return RedirectToPage("Index", new { eventId = EventId });
        }
    }
}
