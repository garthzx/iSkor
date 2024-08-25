using EventScoring.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.ComponentModel.DataAnnotations;
using Utils;

namespace EventScoringWeb.Pages.Auth {
    public class RegisterModel : PageModel {

        [BindProperty]
        public InputModel Input { get; set; }

        private readonly UserManager<IdentityUser> _userManager;
        private readonly SignInManager<IdentityUser> _signInManager;

        public RegisterModel(UserManager<IdentityUser> userManager, SignInManager<IdentityUser> signInManager) {
            _userManager = userManager;
            _signInManager = signInManager;
        }

        public void OnGet() {

        }

        public async Task<IActionResult> OnPostAsync() { 
            if (!ModelState.IsValid) {
                return Page();
            }

            var user = new ApplicationUser {
                Email = Input.Email,
                FirstName = Input.FirstName,
                LastName = Input.LastName,
                UserName = Input.Email
            };

            var result = await _userManager.CreateAsync(user, Input.Password);
            if (result.Succeeded) {
                await _userManager.AddToRoleAsync(user, AppRoles.EventHost);

                await _signInManager.SignInAsync(user, isPersistent: false);
                return RedirectToPage("/Event/Index");
            }
            else {
                AddErrors(result);
            }

            return Page();
        }

        private void AddErrors(IdentityResult result) {
            foreach (var error in result.Errors) {
                ModelState.AddModelError(string.Empty, error.Description);
            }
        }
    }



    public class InputModel {
        [Required(ErrorMessage = "First name is required.")]
        [Display(Name = "First Name")]
        public string FirstName { get; set; }

        [Required(ErrorMessage = "Last name is required.")]
        [Display(Name = "Last Name")]
        public string LastName { get; set; }
        [Required]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        [StringLength(100, ErrorMessage = "{0} must be at least {2} long", MinimumLength = 8)]
        public string Password { get; set; }

        [Required]
        [DataType(DataType.Password)]
        [Display(Name = "Confirm Password")]
        [Compare("Password", ErrorMessage = "Confirmation password must match with your password.")]
        public string ConfirmPassword { get; set; }
    }
}
