using Microsoft.AspNetCore.Mvc;

namespace EventScoringWeb.ViewComponents {
    public class HeaderViewComponent : ViewComponent {

        public async Task<IViewComponentResult> InvokeAsync() {
            return View();
        }
    }
}
