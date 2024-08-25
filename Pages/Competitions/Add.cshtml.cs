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
    public class AddModel : PageModel
    {
        private readonly ICompetitionRepository _competitions;
        private readonly ICategoryRepository _categories;

        public AddModel(ICompetitionRepository competitions, ICategoryRepository categories)
        {
            _competitions = competitions;
            _categories = categories;
        }

        [BindProperty]
        public Competition Competition { get; set; }
        //[BindProperty]
        public SelectList Categories { get; set; }

        public void OnGet(Guid eventId)
        {
            Competition = new Competition();
            Competition.EventId = eventId;

            Categories = new SelectList(
                _categories
                    .GetAll(filter: p => p.EventId.Equals(eventId), includes: p => p.Event)
                    .Select(i => new
                    {
                        Text = i.Name,
                        Value = i.CategoryId
                    }).ToList(), "Value", "Text");

        }

        public async Task<IActionResult> OnPost()
        {
            if (!ModelState.IsValid)
            {
                PopulateCategoriesList(Competition.EventId);
                return Page();
            }
            if (Competition.CategoryId == null)
            {
                PopulateCategoriesList(Competition.EventId);
                ModelState.AddModelError("no-selected-category", "Please select a category");
                return Page();
            }

            _competitions.Add(Competition);
            _competitions.Save();

            return RedirectToPage("Index", new { eventId = Competition.EventId });
        }

        public void PopulateCategoriesList(Guid? eventId)
        {
            Categories = new SelectList(
            _categories
                .GetAll(filter: p => p.EventId.Equals(eventId), includes: p => p.Event)
                .Select(i => new
                {
                    Text = i.Name,
                    Value = i.CategoryId
                }).ToList(), "Value", "Text");
        }
    }
}
