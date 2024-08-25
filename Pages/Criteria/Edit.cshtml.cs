using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Logging;
using System.Security.Claims;
using Utils;

namespace EventScoringWeb.Pages.Criteria
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin}")]
    public class EditModel : PageModel
    {
        private readonly IEventRepository _events;
        private readonly ICriterionRepository _criteria;
        private readonly ICompetitionRepository _competitions;

        public EditModel(
            ICriterionRepository criteria,
            IEventRepository events,
            ICompetitionRepository competitions)
        {
            _events = events;
            _criteria = criteria;
            _competitions = competitions;
        }

        [BindProperty]
        public Criterion Criterion { get; set; }
        [BindProperty]
        public Guid EventId { get; set; }
        public List<SelectListItem> Competitions { get; set; }

        public IActionResult OnGet(Guid eventId, Guid criterionId)
        {
            // authorize if logged in user is the owner of the event.
            var evenT = _events.GetFirstOrDefault(filter: p => p.EventId.Equals(eventId), p => p.ApplicationUser);
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (evenT.ApplicationUserId != userId)
            {
                return RedirectToPage("/Event/Index", new { eventId = eventId });
            }

            EventId = eventId;

            Criterion = _criteria.GetFirstOrDefault(
                c => c.CriterionId.Equals(criterionId));

            if (Criterion == null)
            {
                return NotFound($"Could not find criterion with ID {criterionId}");
            }

            PopulateSelectLists(eventId);

            return Page();
        }

        public IActionResult OnPost()
        {
            if (!ModelState.IsValid)
            {
                PopulateSelectLists(EventId);
                return Page();
            }

            _criteria.Update(Criterion);

            return RedirectToPage("Index", new { eventId = EventId });
        }

        public void PopulateSelectLists(Guid? eventId)
        {
            Competitions = _competitions
                .GetAll(
                    u => u.EventId.Equals(eventId),
                    include => include.Event)
                .Select(u => new SelectListItem
                {
                    Value = u.CompetitionId.ToString(),
                    Text = u.Name
                })
                .ToList();
        }
    }
}
