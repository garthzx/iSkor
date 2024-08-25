using EventScoring.DataAccess.Repository.IRepository;
using Microsoft.AspNetCore.Mvc;

namespace EventScoringWeb.ViewComponents
{
    public class DashboardViewComponent : ViewComponent
    {
        private readonly IEventRepository _events;
        public DashboardViewComponent(IEventRepository events)
        {
            _events = events;
        }

        public async Task<IViewComponentResult> InvokeAsync(DashboardViewModel viewModel)
        {
            viewModel.EventName = _events.GetFirstOrDefault(u => u.EventId.Equals(viewModel.EventId)).EventName;
            return View(viewModel);
        }
    }

    public class DashboardViewModel
    {
        public string Selected { get; set; }
        public Guid EventId { get; set; }
        public string EventName { get; set; }

        public string? Url { get; set; }
    }
}
