using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using RandomDataGenerator.FieldOptions;
using RandomDataGenerator.Randomizers;
using System.Security.Claims;
using Utils;

namespace EventScoringWeb.Pages.Event
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin}")]
    public class AddModel : PageModel
    {
        private readonly IEventRepository _events;

        public AddModel(IEventRepository events)
        {
            _events = events;
        }

        [BindProperty]
        public EventModel Event { get; set; }

        public void OnGet()
        {
            Event = new EventModel();
        }

        public async Task<IActionResult> OnPost()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null)
            {
                return Page();
            }

            Event.ApplicationUserId = userId;
            if (Event.EventStartDate != null)
            {
                Event.EventStartDate = Convert.ToDateTime(
                    Event.EventStartDate.Value.ToShortDateString() + " " + DateTime.Now.ToShortTimeString() 
                );
            }
            if (Event.EventEndDate != null)
            {
                Event.EventEndDate = Convert.ToDateTime(
                    Event.EventEndDate.Value.ToShortDateString() + " " + DateTime.Now.ToShortTimeString()
                );
            }

            // Generate a random text (no numbers or special characters allowed)
            var randomizerText = RandomizerFactory.GetRandomizer(new FieldOptionsText { UseNumber = true, UseSpecial = false, Min = 10, Max = 10});
            string text = randomizerText.Generate()!;

            Event.Url = text;

            _events.Add(Event);
            _events.Save();

            return RedirectToPage("EventSingle", new { eventId = Event.EventId });
        }
    }
}
