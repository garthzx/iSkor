using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Logging;
using System.ComponentModel.DataAnnotations;
using System.Security.Claims;

namespace EventScoringWeb.Pages.Judge
{
    [Authorize]
    public class ScoreContestantModel : PageModel
    {
        private readonly IContestantRepository _contestants;
        private readonly ICriterionRepository _criteria;
        private readonly ICompetitionRepository _competitions;
        private readonly IScoreRepository _scores;
        private readonly UserManager<IdentityUser> _userManager;

        public ScoreContestantModel(
                IContestantRepository contestants,
                ICriterionRepository criteria,
                ICompetitionRepository competitions,
                IScoreRepository scores,
                UserManager<IdentityUser> userManager
            )
        {
            _contestants = contestants;
            _criteria = criteria;
            _competitions = competitions;
            _userManager = userManager;
            _scores = scores;
        }

        public class InputModel
        {
            [Required]
            public decimal Total { get; set; }
            public Score[] Scores { get; set; }
            public string? Remarks { get; set; }

            [Required]
            public Guid ContestantId { get; set; }
            [Required]
            public Guid CompetitionId { get; set; }
        }

        public class ScoreContestantViewModel
        {
            public Competition Competition { get; set; }
            public Contestant Contestant { get; set; }
            public List<Criterion> Criteria { get; set; }
        }

        [BindProperty]
        public InputModel Input { get; set; }
        public ScoreContestantViewModel ScoreContestantVM { get; set; }

        public async Task<IActionResult> OnGet(Guid contestantId, Guid competitionId)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null)
            {
                return RedirectToPage("/Auth/Login");
            }

            var user = (ApplicationUser)(await _userManager.FindByIdAsync(userId));

            InitializeVM(contestantId, competitionId);

            InitializeScores(userId, competitionId, contestantId);

            // unused variable
            var numberOfScoresInDb = _scores.GetAll(s => s.ContestantId.Equals(contestantId)).Count();

            var userScores = _scores.GetAll(s => s.JudgeId == user.Id && s.ContestantId.Equals(contestantId));

            if (userScores.Any())
            {
                ViewData["done"] = "You have completed scoring this contestant";
            }

            return Page();
        }

        public async Task<IActionResult> OnPost()
        {
            InitializeVM(Input.ContestantId, Input.CompetitionId);

            if (!ValidScores())
            {
                ModelState.AddModelError("above-max", "At least one of your input scores are above the max criterion score");
                return Page();
            }

            if (!ValidTotal())
            {
                ModelState.AddModelError("above-total", "The total score is above the total criteria score");
                return Page();
            }

            foreach (var score in Input.Scores)
            {
                score.Remarks = Input.Remarks;
            }

            _scores.AddRange(Input.Scores);
            _scores.Save();

            return RedirectToPage("Home");
        }

        public bool ValidScores()
        {
            for (int i = 0; i < Input.Scores.Length; i++)
            {
                if (Input.Scores[i].CriterionScore > ScoreContestantVM.Criteria[i].PercentFromTotal)
                {
                    return false;
                }
            }
            return true;
        }

        public bool ValidTotal()
        {
            decimal criteriaTotalScore = GetCriteriaTotalScore();

            decimal total = 0.0m;
            foreach (var score in Input.Scores)
            {
                total += score.CriterionScore;
            }

            if (total > criteriaTotalScore)
            {
                return false;
            }

            return true;
        }

        public decimal GetCriteriaTotalScore()
        {
            decimal total = 0.0m;
            foreach (var criteria in ScoreContestantVM.Criteria)
            {
                total += criteria.PercentFromTotal;
            }
            return total;
        }

        public void InitializeScores(string userId, Guid competitionId, Guid contestantId)
        {
            Input = new InputModel() 
            { 
                Scores = new Score[ScoreContestantVM.Criteria.Count],
                CompetitionId = competitionId,
                ContestantId = contestantId
            };

            for (int i = 0; i < Input.Scores.Length; i++)
            {
                Input.Scores[i] = new Score()
                {
                    ContestantId = ScoreContestantVM.Contestant.ContestantId,
                    JudgeId = userId,
                    CriterionId = ScoreContestantVM.Criteria[i].CriterionId,
                };
            }
        }

        public void InitializeVM(Guid contestantId, Guid competitionId)
        {
            ScoreContestantVM = new ScoreContestantViewModel()
            {
                Contestant = _contestants.GetFirstOrDefault(u => u.ContestantId.Equals(contestantId),
                    include => include.Competition!, include => include.Team),
                Competition = _competitions.GetFirstOrDefault(u => u.CompetitionId.Equals(competitionId))
            };

            ScoreContestantVM.Criteria = _criteria.GetAll(
                    c => c.CompetitionId.Equals(ScoreContestantVM.Competition.CompetitionId),
                    include => include.Competition!
                ).ToList();
        }
    }
}
