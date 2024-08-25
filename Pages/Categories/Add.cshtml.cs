using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Security.Claims;
using Utils;

namespace EventScoringWeb.Pages.Categories
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin}")]
    public class AddModel : PageModel
    {
        private readonly ICategoryRepository _categories;
        private readonly IEventRepository _events;

        public AddModel(ICategoryRepository categories, IEventRepository events)
        {
            _categories = categories;
            _events = events;
        }

        [BindProperty]
        public Category Category { get; set; }

        public IActionResult OnGet(Guid eventId)
        {
            Category = new Category();
            Category.EventId = eventId;

            // authorize if logged in user is the owner of the event.
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var evenT = _events.GetFirstOrDefault(u => u.EventId.Equals(eventId), p => p.ApplicationUser);
            if (evenT == null || evenT.ApplicationUserId != userId)
            {
                return RedirectToPage("Index");
            }

            return Page();
        }

        public async Task<IActionResult> OnPost()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }

            _categories.Add(Category);
            _categories.Save();

            return RedirectToPage(nameof(Index), new { eventid = Category.EventId });
        }
    }
}
