using Microsoft.AspNetCore.Mvc;

namespace EventScoringWeb.ViewComponents {
    public class FooterViewComponent : ViewComponent {

        public async Task<IViewComponentResult> InvokeAsync() {
            return View();
        }
    }
}
