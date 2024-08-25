using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.ComponentModel.DataAnnotations;
using System.Security.Claims;
using Utils;

namespace EventScoringWeb.Pages.Teams
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin}")]
    public class IndexModel : PageModel
    {
        private readonly ITeamRepository _teams;
        private readonly IEventRepository _events;

        public IndexModel(
            ITeamRepository teams,
            IEventRepository events)
        {
            _teams = teams;
            _events = events;
        }

        public IEnumerable<Team> Teams { get; set; }

        // for url navigation
        [BindProperty]
        public Guid EventId { get;  set; }

        public IActionResult OnGet(Guid eventId)
        {
            // authorize if logged in user is the owner of the event.
            var evenT = _events.GetFirstOrDefault(filter: p => p.EventId.Equals(eventId), p => p.ApplicationUser);
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (evenT.ApplicationUserId != userId)
            {
                return RedirectToPage("/Event/Index", new { eventId = eventId });
            }

            Teams = _teams.GetAll(filter: p => p.EventId.Equals(eventId), p => p.Event);
            EventId = eventId;

            return Page();
        }

        public IActionResult OnPostDelete(Guid id)
        {
            var teamFromDb = _teams.GetFirstOrDefault(t => t.TeamId.Equals(id));
            if (teamFromDb == null)
            {
                return NotFound($"Cannot find team with id {id.ToString()}"); 
            }

            _teams.Remove(teamFromDb);
            _teams.Save();

            return RedirectToPage("Index", new { eventId = EventId });
        }
    }
}
