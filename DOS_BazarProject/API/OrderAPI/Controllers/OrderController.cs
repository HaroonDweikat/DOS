using Microsoft.AspNetCore.Mvc;
using OrderAPI.Data;

namespace OrderAPI.Controllers
{
    
    [ApiController]
    [Route("api/order")]
    public class OrderController : ControllerBase
    {
        private readonly IOrderRepo _repo;

        public OrderController( IOrderRepo repo)
        {
            _repo = repo;
        }
        
        
        
        
        
    }
}