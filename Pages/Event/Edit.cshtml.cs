using EventScoring.DataAccess.Repository;
using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Security.Claims;
using Utils;

namespace EventScoringWeb.Pages.Event
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin}")]
    public class EditModel : PageModel
    {
        private readonly IEventRepository _eventRepository;
        public EditModel(IEventRepository eventRepository)
        {
            _eventRepository = eventRepository;
        }

        [BindProperty]
        public EventModel Event { get; set; }

        public async Task<IActionResult> OnGet(Guid id)
        {
            Event = _eventRepository.GetFirstOrDefault(
                p => p.EventId.Equals(id),
                p => p.ApplicationUser);

            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId != Event.ApplicationUserId)
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

            _eventRepository.Update(Event);

            return RedirectToPage("Index");
        }
    }
}
