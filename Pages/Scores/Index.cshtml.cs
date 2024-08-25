using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System.Security.Claims;
using Utils;

namespace EventScoringWeb.Pages.Scores
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin}")]
    public class IndexModel : PageModel
    {
        private readonly IEventRepository _events;
        private readonly ICompetitionRepository _competitions;
        private readonly IContestantRepository _contestants;
        private readonly IScoreRepository _scores;
        private readonly ICriterionRepository _criteria;

        public IndexModel(
            IEventRepository events, 
            ICompetitionRepository competitions,
            IContestantRepository contestants,
            IScoreRepository scores,
            ICriterionRepository criteria)
        {
            _events = events;
            _competitions = competitions;   
            _contestants = contestants;
            _scores = scores;
            _criteria = criteria;
        }

        public class ScoresViewModel
        {
            public ScoresViewModel()
            {
                Contestants = new List<Contestant>();
            }
            public Competition Competition { get; set; }
            public List<Contestant> Contestants { get; set; }
        }

        public List<ScoresViewModel> ScoresVM { get; set; }
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

            EventId = eventId;

            InitializeScoresVM(eventId);

            return Page();
        }

        public void InitializeScoresVM(Guid eventId)
        {
            var competitionsInEvent = _competitions
                .GetAllWithThenInclude(
                    predicate: u => u.EventId.Equals(eventId),
                    include: source =>  source
                        .Include(t => t.Judges)
                        .Include(t => t.Contestants!)
                        .ThenInclude(t => t.Scores)
                        .Include(t => t.Contestants!)
                        .ThenInclude(t => t.Team),
                    disableTracking: false
                )
                .ToList();

            ScoresVM = new List<ScoresViewModel>();

            var scores = _scores.GetAll();

            var criteria = _criteria.GetAll();

            for (int i = 0; i < competitionsInEvent.Count; i++)
            {
                ScoresViewModel singleVM = new ScoresViewModel();

                // edit
                singleVM.Competition = competitionsInEvent[i];
                singleVM.Contestants = competitionsInEvent[i].Contestants;

                // Get the number of criteria for the current competition
                var criteriaCountForCompetition = criteria.Where(
                    u => u.CompetitionId.Equals(singleVM.Competition.CompetitionId)).Count();

                for (int j = 0; j < singleVM.Contestants.Count; j++)
                {
                    var contestantId = singleVM.Contestants[j].ContestantId;

                    // Get all scores of the current contestant
                    var scoresForContestant = scores.Where(
                        u => u.ContestantId.Equals(contestantId));

                    // Ex: 2 judges in a competition (with 6 criterion), should have exactly 12 scores in db.
                    int totalExpectedNumberOfScores =
                        criteriaCountForCompetition * competitionsInEvent[i].Judges.Count();

                    if (scoresForContestant.Count() == totalExpectedNumberOfScores)
                    {
                        singleVM.Contestants[j].IsCompleted = true;
                    }

                    decimal averageScore = 0.0m;
                    foreach (var score in scoresForContestant)
                    {
                        averageScore += score.CriterionScore;
                    }

                    averageScore = averageScore / competitionsInEvent[i].Judges.Count();

                    singleVM.Contestants[j].AverageScore = Math.Round(averageScore, 2);
                }
                // new 12/9/2023
                singleVM.Contestants = singleVM.Contestants.OrderByDescending(u => u.AverageScore).ToList();

                ScoresVM.Add(singleVM);

                _competitions.UpdateRange(competitionsInEvent);
            }
        }
    }
}
