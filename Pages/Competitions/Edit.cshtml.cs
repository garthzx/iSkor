using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Logging;
using Utils;

namespace EventScoringWeb.Pages.Competitions
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin}")]
    public class EditModel : PageModel
    {
        private readonly ICompetitionRepository _competitions;
        private readonly ICategoryRepository _categories;

        public EditModel(ICompetitionRepository competitions, ICategoryRepository categories)
        {
            _competitions = competitions;
            _categories = categories;
        }

        [BindProperty]
        public Competition Competition { get; set; }
        //[BindProperty]
        public SelectList Categories { get; set; }

        public void OnGet(Guid id)
        {
            Competition = _competitions.GetFirstOrDefault(
                filter: p => p.CompetitionId.Equals(id),
                p => p.Event,
                p => p.Category
            );

            Categories = new SelectList(
            _categories
                .GetAll(filter: p => p.EventId.Equals(Competition.EventId), includes: p => p.Event)
                .Select(i => new
                {
                    Text = i.Name,
                    Value = i.CategoryId,
                }).ToList(), "Value", "Text", Competition.CategoryId);
        }

        public IActionResult OnPost()
        {
            if (!ModelState.IsValid)
            {
                Categories = new SelectList(
                    _categories
                        .GetAll(filter: p => p.EventId.Equals(Competition.EventId), includes: p => p.Event)
                        .Select(i => new
                        {
                            Text = i.Name,
                            Value = i.CategoryId,
                        }).ToList(), "Value", "Text", Competition.CategoryId);
                return Page();
            }

            _competitions.Update(Competition);

            return RedirectToPage("Index", new { eventId = Competition.EventId });
        }
    }
}
