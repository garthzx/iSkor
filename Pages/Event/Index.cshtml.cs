using EventScoring.DataAccess.Repository.IRepository;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Utils;
using Microsoft.AspNetCore.Identity;
using System.Security.Claims;
using System.Reflection.Metadata.Ecma335;

namespace EventScoringWeb.Pages.Event
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin},{AppRoles.Judge}")]
    public class IndexModel : PageModel
    {

        private readonly IEventRepository _events;
        private readonly IApplicationUserRepository _users;
        private readonly UserManager<IdentityUser> _userManager;
        

        #region ctor
        public IndexModel(
            IEventRepository eventRepo, 
            IApplicationUserRepository users,
            UserManager<IdentityUser> userManager)
        {
            _events = eventRepo;
            _users = users;
            _userManager = userManager;

            Sorter = new Sorter<EventModel>(new Sorter<EventModel>.SortItem()
            {
                SortSelector = s => s.EventName,
                SelectorName = "A-Z"
            });
        }

        #endregion ctor

        [BindProperty]
        public IEnumerable<EventModel> Events { get; set; }

        public Sorter<EventModel> Sorter { get; set; }


        #region Page Handlers

        public IActionResult OnGet(string? sortOrder = "A-Z")
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var user = _users.GetFirstOrDefault(u => u.Id == userId);
            if (user == null)
            {
                return RedirectToPage("/Auth/Login");
            }

            if (_userManager.IsInRoleAsync(user, AppRoles.Judge).GetAwaiter().GetResult())
            {
                return RedirectToPage("/Judge/Home");
            }

            InitializeSortOptions();
            Sorter.Selected = Sorter.SortOptions.FirstOrDefault(u => u.SelectorName == sortOrder);

            Events = _events.GetAll(p => p.ApplicationUserId == userId, p => p.ApplicationUser);
            Events = Sorter.Sort(Events);

            return Page();
        }

        public async Task<IActionResult> OnPostDelete(Guid id)
        {
            var eventFromDb = _events.GetFirstOrDefault(u => u.EventId.Equals(id), 
                p => p.Categories);

            if (eventFromDb == null)
            {
                return Page();
            }

            _events.Remove(eventFromDb);
            _events.Save();

            return RedirectToAction("Index");
        }

        #endregion Page Handlers

        #region Helper Methods
        public void InitializeSortOptions()
        {
            Sorter.AddSortOptions(new Sorter<EventModel>.SortItem()
            {
                SortSelector = s => s.EventName,
                SelectorName = "Z-A",
                Desc = true
            },
            new()
            {
                SortSelector = s => s.EventStartDate,
                SelectorName = "Date (oldest)"
            },
            new()
            {
                SortSelector = s => s.EventStartDate,
                SelectorName = "Date (latest)",
                Desc = true
            });
        }

        #endregion Helper Methods

    }
}
