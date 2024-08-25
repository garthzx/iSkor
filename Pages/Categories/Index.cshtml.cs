using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Runtime.CompilerServices;
using Utils;

namespace EventScoringWeb.Pages.Categories
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin}")]
    public class IndexModel : PageModel
    {
        private readonly ICategoryRepository _categories;

        public IndexModel(ICategoryRepository categoryRepository)
        {
            _categories = categoryRepository;
            Sorter = new Sorter<Category>(new Sorter<Category>.SortItem()
            {
                SelectorName = "A-Z",
                SortSelector = c => c.Name
            });
        }

        [BindProperty]
        public IEnumerable<Category> Categories { get; set; }
        public Sorter<Category> Sorter { get; set; }
        [BindProperty]
        public Guid EventId { get; set; }

        public void OnGet(Guid eventid, string? sortOrder = "A-Z")
        {
            InitializeSortOptions();
            Sorter.Selected = Sorter.SortOptions.FirstOrDefault(s => s.SelectorName == sortOrder);

            Categories = _categories.GetAll(filter: p => p.EventId.Equals(eventid), p => p.Event, p => p.Competitions);
            Categories = Sorter.Sort(Categories);

            EventId = eventid;
        }

        public async Task<IActionResult> OnPost()
        {
            return Page();
        }

        public async Task<IActionResult> OnPostDelete(Category category)
        {
            var categoryFromDb = _categories.GetFirstOrDefault(p => p.CategoryId.Equals(category.CategoryId),
                    p => p.Event, p => p.Competitions);
            if (categoryFromDb != null)
            {
                _categories.Remove(categoryFromDb);
                _categories.Save();
                return RedirectToPage("Index", new { eventid = categoryFromDb.EventId });
            }

            return Page();
        }

        #region Helper Methods
        public void InitializeSortOptions()
        {
            Sorter.AddSortOptions(new Sorter<Category>.SortItem()
            {
                SelectorName = "Z-A",
                SortSelector = s => s.Name,
                Desc = true
            });
        }
        #endregion Helper Methods
    }
}
