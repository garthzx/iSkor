using EventScoring.DataAccess.Repository.IRepository;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.ComponentModel.DataAnnotations;
using System.Security.Claims;
using Utils;

namespace EventScoringWeb.Pages.Account
{
    public class LoginModel : PageModel
    {

        [BindProperty]
        public InputModel InputModel { get; set; }

        private readonly SignInManager<IdentityUser> _signInManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly UserManager<IdentityUser> _userManager;
        private readonly IApplicationUserRepository _users;

        public LoginModel(
            SignInManager<IdentityUser> signInManager, 
            RoleManager<IdentityRole> roleManager, 
            UserManager<IdentityUser> userManager,
            IApplicationUserRepository users)
        {
            _signInManager = signInManager;
            _roleManager = roleManager;
            _userManager = userManager;
            _users = users;
        }

        public IActionResult OnGet(string? returnUrl = null)
        {
            ViewData["ReturnUrl"] = returnUrl;
            return Page();
        }

        public async Task<IActionResult> OnPost(string? returnUrl = null)
        {
            ViewData["ReturnUrl"] = returnUrl;

            // if null, set return url to events
            returnUrl ??= Url.Page("/Event/Index");

            if (!ModelState.IsValid)
            {
                return Page();
            }

            var user = _users.GetFirstOrDefault(u => u.Email == InputModel.Email);
            if (user == null)
            {
                ModelState.AddModelError("random-error", $"Could not find user with email {InputModel.Email}");
                return Page();
            }

            var result = await _signInManager.PasswordSignInAsync(InputModel.Email, InputModel.Password,
                isPersistent: InputModel.RememberMe, lockoutOnFailure: false);

            if (result.Succeeded)
            {
                if (await _userManager.IsInRoleAsync(user, AppRoles.Judge))
                {
                    return RedirectToPage("/Judge/Home");
                }

                return LocalRedirect(returnUrl);
            }
            // TODO: Perform additional checks on result such as IsLockedOut

            // unsuccessful login attempt
            ModelState.AddModelError(string.Empty, "Email or Password is incorrect.");
            return Page();
        }
    }

    public class InputModel
    {
        [Required]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        [Display(Name = "Remember me?")]
        public bool RememberMe { get; set; }
    }
}
