using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using EventScoringWeb.Pages.Account;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations;
using System.Reflection.Metadata.Ecma335;
using System.Security.Claims;
using Utils;

namespace EventScoringWeb.Pages.Judge
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin}")]
    public class EditModel : PageModel
    {
        private readonly IEventRepository _events;
        private readonly ICompetitionRepository _competitions;
        private readonly IApplicationUserRepository _users;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly SignInManager<IdentityUser> _signInManager;

        public EditModel(
            IEventRepository events,
            ICompetitionRepository competitions,
            IApplicationUserRepository users,
            UserManager<IdentityUser> userManager,
            SignInManager<IdentityUser> signInManager
            )
        {
            _events = events;
            _competitions = competitions;
            _users = users;
            _userManager = userManager;
            _signInManager = signInManager;
        }

        public class InputModel
        {
            [Required]
            public string Id { get; set; }
            [Required]
            [Display(Name = "First Name")]
            public string FirstName { get; set; }
            [Required]
            [Display(Name = "Last Name")]
            public string LastName { get; set; }
            [Required]
            [EmailAddress]
            public string Email { get; set; }
            //[Required]
            //[Display(Name = "Old Password")]
            //public string OldPassword { get; set; }
            //[Required]
            //[StringLength(100, ErrorMessage = "{0} must be at least {2} long", MinimumLength = 8)]
            //[Display(Name = "New Password")]
            //public string NewPassword { get; set; }
            [Required]
            public Guid EventId { get; set; }
            [Required]
            [Display(Name = "Selected Competitions")]
            public List<Guid> SelectedCompetitions { get; set; }
        }

        [BindProperty]
        public InputModel Input { get; set; }
        public List<SelectListItem> CompetitionList { get; set; }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="eventId">The eventId from this user judge</param>
        /// <param name="id">The application user (judge) id</param>
        public async Task<IActionResult> OnGet(Guid eventId, string id)
        {
            string userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null)
            {
                return RedirectToPage("/Auth/Login");
            }

            var evenT = _events.GetFirstOrDefault(e => e.EventId.Equals(eventId),
                p => p.ApplicationUser);
            if (evenT != null && evenT.ApplicationUserId != userId)
            {
                return Forbid();
            }

            Input = new InputModel();

            CompetitionList = new List<SelectListItem>(
                    _competitions
                    .GetAll(p => p.EventId.Equals(eventId))
                    .Select(u => new SelectListItem()
                    {
                        Value = u.CompetitionId.ToString(),
                        Text = u.Name
                    }).ToList());

            var user = (ApplicationUser)(await _userManager.FindByIdAsync(id));
            if (user == null)
            {
                return RedirectToPage("Index", new { eventId = eventId });
            }

            Input.Id = id;
            Input.Email = user.Email;
            Input.FirstName = user.FirstName;
            Input.LastName = user.LastName;
            Input.EventId = eventId;

            return Page();
        }

        public async Task<IActionResult> OnPost()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }

            var user = (ApplicationUser)(await _userManager.FindByIdAsync(Input.Id));
            if (user == null)
            {
                ModelState.AddModelError("not-found", "An error has occurred. Cannot find user.");
                return Page();
            }

            //var result = await _userManager.ChangePasswordAsync(user, Input.OldPassword, Input.NewPassword);

            //if (result.Succeeded)
            //{
            // remove all judges from competition first.
            var judge = _users.GetFirstOrDefault(u => u.Id == Input.Id, p => p.Competitions);
            judge.Competitions.Clear();
            _users.Save();

            foreach (var guid in Input.SelectedCompetitions)
            {
                var competition = _competitions.GetFirstOrDefault(u => u.CompetitionId.Equals(guid));
                if (competition != null)
                {
                    competition.Judges.Add(user);
                }
            }
            _competitions.Save();

            user.UserName = Input.Email;
            user.Email = Input.Email.Trim();
            user.FirstName = Input.FirstName;
            user.LastName = Input.LastName;

            await _userManager.UpdateAsync(user);
            return RedirectToPage("Index", new { eventId = Input.EventId });
            //}

            //return Page();
        }
    }
}
