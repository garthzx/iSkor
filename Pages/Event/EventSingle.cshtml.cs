using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Query;
using RandomDataGenerator.FieldOptions;
using RandomDataGenerator.Randomizers;
using System.Security.Claims;
using Utils;
using static EventScoringWeb.Pages.Event.EventSingleViewModel;

namespace EventScoringWeb.Pages.Event
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin},{AppRoles.Judge}")]
    public class EventSingleModel : PageModel
    {

        private readonly IEventRepository _events;
        private readonly IContestantRepository _contestants;
        private readonly ICompetitionRepository _competitions;

        public EventSingleModel(
            IEventRepository events, IContestantRepository contestants, ICompetitionRepository competitions)
        {
            _events = events;
            _contestants = contestants;
            _competitions = competitions;
        }

        [BindProperty]
        public EventModel Event { get; set; }
        public EventSingleViewModel ViewModel { get; set; }

        public IActionResult OnGet(Guid eventId)
        {
            // Get the event with eager load
            Event = _events.GetFirstOrDefault(filter: p => p.EventId.Equals(eventId),
                p => p.ApplicationUser,
                p => p.Categories,
                p => p.Competitions,
                p => p.Contestants);

            // authorize if logged in user is the owner of the event.
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (Event.ApplicationUserId != userId)
            {
                return RedirectToPage("Index");
            }
            InitializeViewModel(eventId);

            //_events.Update(Event);

;            return Page();
        }

        public void InitializeViewModel(Guid eventId)
        {
            ViewModel = new EventSingleViewModel();
            ViewModel.Rows = new List<TableRow>();

            var competitionsInEvent = _competitions.GetAllWithThenInclude(
                predicate: u => u.EventId.Equals(eventId),
                include: source => source
                    .Include(u => u.Contestants!)
                    .ThenInclude(u => u.Scores)
                    .Include(u => u.Contestants!)
                    .ThenInclude(u => u.Team)
                    .Include(u => u.Judges!),
                disableTracking: false
            );

            foreach (var competition in competitionsInEvent)
            {
                var topScorers = GetTopScorers(competition);

                ViewModel.Rows.Add(new TableRow()
                {
                    Competition = competition,
                    ContestantChampions = topScorers
                });
            }
            _competitions.UpdateRange(competitionsInEvent);
        }

        public List<Contestant> GetTopScorers(Competition competition)
        {
            var numJudgesInCompetition = competition.Judges.Count();
            foreach (var contestant in competition.Contestants)
            {
                if (contestant.Scores.Any())
                {
                    var avgScore = CalculateAverageScore(contestant.Scores, numJudgesInCompetition);
                    contestant.AverageScore = avgScore;
                }
            }

            var topAverageScore = competition.Contestants.Max(u => u.AverageScore);
            var topContestants = competition.Contestants.Where(u => u.AverageScore == topAverageScore).ToList();

            // if only 1, meaning only one champion which will automatically be declared as the champion.
            if (topContestants.Count() == 1)
            {
                topContestants.First().DeclareAsChampion = true;
            }

            return topContestants;
        }

        public decimal CalculateAverageScore(IEnumerable<Score> scores, int numberOfJudgesInCompetition)
        {
            return (scores.Sum(s => s.CriterionScore) / numberOfJudgesInCompetition);
        }
    }



    public class EventSingleViewModel
    {
        public class TableRow
        {
            public Competition Competition { get; set; }
            // Make it a list in case of tied scores
            public List<Contestant> ContestantChampions { get; set; }
        }

        public List<TableRow> Rows { get; set; }
        // Ordered by rank (1st to last)
        public List<Team> TeamStandings { get; set; }
    }
}
