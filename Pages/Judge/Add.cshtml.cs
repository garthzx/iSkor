using EventScoring.DataAccess.Repository.IRepository;
using EventScoring.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Logging;
using System.ComponentModel.DataAnnotations;
using System.Security.Claims;
using Utils;

namespace EventScoringWeb.Pages.Judge
{
    [Authorize(Roles = $"{AppRoles.EventHost},{AppRoles.Admin}")]
    public class AddModel : PageModel
    {
        private readonly UserManager<IdentityUser> _userManager;
        private readonly SignInManager<IdentityUser> _signInManager;
        private readonly ICompetitionRepository _competitions;
        private readonly IEventRepository _events;

        public AddModel(
            UserManager<IdentityUser> userManager,
            SignInManager<IdentityUser> signInManager,
            ICompetitionRepository competitions,
            IEventRepository events)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _competitions = competitions;
            _events = events;
        }

        [BindProperty]
        public InputModel Input { get; set; }

        public class InputModel
        {
            public InputModel()
            {
                CompetitionIds = new List<Guid>();
            }

            [Required]
            [EmailAddress]
            public string Email { get; set; }
            [Required]
            [Display(Name = "First Name")]
            public string FirstName { get; set; }
            [Required]
            [Display(Name = "Last Name")]
            public string LastName { get; set; }
            [Required]
            [StringLength(100, ErrorMessage = "{0} must be at least {2} long", MinimumLength = 8)]
            public string Password { get; set; }
            [Required]
            [DataType(DataType.Password)]
            [Display(Name = "Confirm Password")]
            [Compare("Password", ErrorMessage = "Confirmation password must match with your password.")]
            public string ConfirmPassword { get; set; }

            [Required]
            public Guid EventId { get; set; }

            // [required] might not work for lists
            [Required]
            // CompetitionIds might be the cause to the error competitionId
            // is null or enumeration yielded no results. However as you hit 
            // foreach loop in OnPost, wierdly enough, the error goes away.
            // Optionally fix tomorrow.
            // Might want to read this:
            // https://www.learnrazorpages.com/razor-pages/forms/select-lists#enabling-multiple-selections
            [Display(Name = "Competitions")]
            public List<Guid> CompetitionIds { get; set; }
        }

        public MultiSelectList Competitions { get; set; }

        public IActionResult OnGet(Guid eventId)
        {
            string userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            var evenT = _events.GetFirstOrDefault(p => p.EventId.Equals(eventId),
                p => p.ApplicationUser);

            if (evenT.ApplicationUserId != userId)
            {
                return RedirectToPage("Index");
            }

            Input = new InputModel();
            Input.EventId = eventId;

            Competitions = new MultiSelectList(
                _competitions
                    .GetAll(p => p.EventId.Equals(eventId))
                    .Select(u => new
                    {
                        Value = u.CompetitionId,
                        Text = u.Name
                    })
                    .ToList(), "Value", "Text");
            return Page();
        }

        public async Task<IActionResult> OnPost()
        {
            if (!ModelState.IsValid)
            {
                PopulateCompetitionsList(Input.EventId);
                return Page();
            }
            if (Input.CompetitionIds.Count() == 0)
            {
                ModelState.AddModelError("no-competition-selected", "Please select at least one competition");
                PopulateCompetitionsList(Input.EventId);
                return Page();
            }

            var user = new ApplicationUser()
            {
                UserName = Input.Email,
                FirstName = Input.FirstName,
                LastName = Input.LastName,
                Email = Input.Email
            };

            var result = await _userManager.CreateAsync(user, Input.Password);
            if (result.Succeeded)
            {
                await _userManager.AddToRoleAsync(user, AppRoles.Judge);

                // maybe encapsulate this code by defining a method in ICompetitionRepository.
                foreach (Guid competitionId in Input.CompetitionIds)
                {
                    var competition = _competitions.GetFirstOrDefault(c => c.CompetitionId.Equals(competitionId));
                    if (competition != null)
                    {
                        competition.Judges.Add(user);
                    }
                }
                _competitions.Save();

                return RedirectToPage("Index", new { eventId = Input.EventId });
            }

            foreach (var error in result.Errors)
            {
                ModelState.AddModelError(string.Empty, error.Description);
            }

            PopulateCompetitionsList(Input.EventId);

            return Page();
        }


        public void PopulateCompetitionsList(Guid eventId)
        {
            Competitions = new MultiSelectList(
            _competitions
                .GetAll(p => p.EventId.Equals(eventId))
                .Select(u => new
                {
                    Value = u.CompetitionId,
                    Text = u.Name
                })
                .ToList(), "Value", "Text");
        }

    }
}
