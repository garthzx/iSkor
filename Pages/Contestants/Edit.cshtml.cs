using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Logging;
using System.Security.Claims;
using Utils;

namespace EventScoringWeb.Pages.Contestants
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin}")]
    public class EditModel : PageModel
    {
        private readonly IEventRepository _events;
        private readonly IContestantRepository _contestants;
        private readonly ITeamRepository _teams;
        private readonly ICompetitionRepository _competitions;

        public EditModel(
            IEventRepository events,
            IContestantRepository contestants,
            ITeamRepository teams,
            ICompetitionRepository competitions)
        {
            _events = events;
            _contestants = contestants;
            _teams = teams;
            _competitions = competitions;
        }

        [BindProperty]
        public Contestant Contestant { get; set; }
        public List<SelectListItem> Teams { get; set; }
        public List<SelectListItem> Competitions { get; set; }


        public IActionResult OnGet(Guid eventId, Guid contestantId)
        {
            // authorize if logged in user is the owner of the event.
            var evenT = _events.GetFirstOrDefault(filter: p => p.EventId.Equals(eventId), p => p.ApplicationUser);
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (evenT.ApplicationUserId != userId)
            {
                return RedirectToPage("/Event/Index", new { eventId = eventId });
            }

            Contestant = _contestants.GetFirstOrDefault(
                p => p.ContestantId.Equals(contestantId),
                p => p.Event
            );

            PopulateSelectLists(eventId);

            return Page();
        }

        public IActionResult OnPost()
        {
            if (!ModelState.IsValid)
            {
                PopulateSelectLists(Contestant.EventId);
                return Page();
            }

            _contestants.Update(Contestant);

            return RedirectToPage("Index", new { eventId = Contestant.EventId });
        }


        public void PopulateSelectLists(Guid? eventId)
        {
            Teams = _teams
                .GetAll(
                    u => u.EventId.Equals(eventId),
                    include => include.Event)
                .Select(u => new SelectListItem
                {
                    Value = u.TeamId.ToString(),
                    Text = String.IsNullOrEmpty(u.Abbreviation) ? u.FullName : u.Abbreviation
                })
                .ToList();

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
