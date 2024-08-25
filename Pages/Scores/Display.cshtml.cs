using EventScoring.DataAccess.Repository.IRepository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Security.Claims;
using static EventScoringWeb.Pages.Scores.IndexModel;

namespace EventScoringWeb.Pages.Scores
{
    public class DisplayModel : PageModel
    {
        private readonly IEventRepository _events;
        private readonly ICompetitionRepository _competitions;
        private readonly IContestantRepository _contestants;

        public DisplayModel(
            ICompetitionRepository competitions,
            IEventRepository events,
            IContestantRepository contestants)
        {
            _events = events;
            _competitions = competitions;
            _contestants = contestants; 

        }

        public ScoresViewModel ScoresVM { get; set; }

        public IActionResult OnGet(Guid eventId, Guid competitionId)
        {
            // authorize if logged in user is the owner of the event.
            var evenT = _events.GetFirstOrDefault(filter: p => p.EventId.Equals(eventId), p => p.ApplicationUser);
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (evenT.ApplicationUserId != userId)
            {
                return RedirectToPage("/Event/Index", new { eventId = eventId });
            }

            InitializeScoresVM(eventId, competitionId);

            return Page();
        }

        public void InitializeScoresVM(Guid eventId, Guid competitionId)
        {
            var contestants = _contestants.GetAll(
                u => u.CompetitionId.Equals(competitionId),
                include => include.Scores, includes => includes.Team, includes => includes.Competition).ToList();
            var competition = _competitions.GetFirstOrDefault(
                u => u.CompetitionId.Equals(competitionId),
                include => include.Event);

            ScoresVM = new ScoresViewModel()
            {
                Competition = competition,
                Contestants = contestants
            };

        }
    }
}
