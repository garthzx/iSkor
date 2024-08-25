using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Query;
using System.Security.Claims;
using Utils;

namespace EventScoringWeb.Pages.Judge
{
    /// <summary>
    /// This page is for Judge users only. In each competition, a list of criteria will be shown
    /// with each criterion having pending/completed statuses. This is the main landing page
    /// when judge users are logged in the site.
    /// </summary>
    [Authorize(Roles = $"{AppRoles.Judge},{AppRoles.Admin}")]
    public class HomeModel : PageModel
    {
        private readonly IEventRepository _events;
        private readonly IContestantRepository _contestants;
        private readonly ICompetitionRepository _competitions;

        public HomeModel(
            IEventRepository events,
            IContestantRepository contestants,
            ICompetitionRepository competitions)
        {
            _events = events;
            _contestants = contestants;

            JudgeHomeVM = new JudgeHomeViewModel();
            _competitions = competitions;
        }
        public JudgeHomeViewModel JudgeHomeVM { get; set; }

        public IActionResult OnGet()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            // Perform check if user is a judge

            JudgeHomeVM.Competitions = _competitions
                .GetAllWithThenInclude(
                    predicate: c => c.Judges.FirstOrDefault(j => j.Id == userId) != null,
                    include: source => source
                        .Include(a => a.Event)
                        .Include(a => a.Judges!)
                        .Include(a => a.Criteria)
                        .Include(a => a.Contestants!)
                        .ThenInclude(a => a.Team)
                        .Include(a => a.Contestants!)
                        .ThenInclude(a => a.Scores)
                )
                .ToList();

            if (JudgeHomeVM.Competitions.Any())
            {
                JudgeHomeVM.Event = JudgeHomeVM.Competitions.First().Event;
            }

            return Page();
        }
    }


    public class JudgeHomeViewModel
    {
        /// <summary>
        /// Contestants in every competition
        /// </summary>
        public List<Competition> Competitions { get; set;  }
        public EventModel Event { get; set; }
    }
}
