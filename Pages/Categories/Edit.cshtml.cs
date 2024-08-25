using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Logging;
using Utils;

namespace EventScoringWeb.Pages.Categories
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin}")]
    public class EditModel : PageModel
    {

        private readonly ICategoryRepository _categories;

        public EditModel(ICategoryRepository categories)
        {
            _categories = categories;
        }

        [BindProperty]
        public Category Category { get; set; }
        // for dashboard
        public Guid EventId { get; set; }

        public IActionResult OnGet(Guid id)
        {
            Category = _categories.GetFirstOrDefault(
                p => p.CategoryId.Equals(id),
                includes: p => p.Event);

            if (Category == null)
            {
               // maybe redirect to error page (?)
                return RedirectToPage("Index");
            }

            EventId = (Guid)Category.EventId;
            return Page();
        }

        public async Task<IActionResult> OnPost()
        {
            if (!ModelState.IsValid)
            {
                // Maybe give more error information
                return Page();
            }

            _categories.Update(Category);
            return RedirectToPage("Index", new { eventid = Category.EventId });
        }
    }
}
