using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using OrderAPI.Data;
using OrderAPI.DTO;
using OrderAPI.Model;

namespace OrderAPI.Controllers
{
    
    [ApiController]
    [Route("api/order")]
    public class OrderController : ControllerBase
    {
        private readonly IOrderRepo _repo;
        private readonly IMapper _mapper;
        private readonly IHttpClientFactory _clientFactory;

        public OrderController( IOrderRepo repo,IMapper mapper,IHttpClientFactory clientFactory)
        {
            _repo = repo;
            _mapper = mapper;
            _clientFactory = clientFactory;
        }


        [HttpGet("getAllOrder")]
        public ActionResult<IEnumerable<OrderReadDto>> GetAllOrders()
        {
            var orders = _repo.GetAllOrders();
            if (orders == null)
            {
                return NotFound();
            }

            var mappedOrders = _mapper.Map<IEnumerable<OrderReadDto>>(orders);
            return Ok(mappedOrders);
        }

        [HttpGet("getOrderById/{id}")]
        public ActionResult<OrderReadDto> GetOrderById(Guid id)
        {
            var order = _repo.GetOrderById(id);
            if (order == null)
            {
                return NotFound();
            }

            var mappedOrder = _mapper.Map<OrderReadDto>(order);
            return Ok(mappedOrder);
        }
        //this method receive the new oreder request what it responsibilty : first to check if there is a stock of the required book 
        // if yes update the stock decrese the book stock (all that done in a server to server request)
        // if no send back a Problem message to the client
        [HttpPost("addOrder")]
        public  ActionResult<OrderReadDto> Purchase(OrderCreateDto order)
        {
            var mappedCreateOrder = _mapper.Map<Order>(order);
            Guid itemId = mappedCreateOrder.ItemId;
            var client = _clientFactory.CreateClient();//create a mock client to send the "check request"
            var request = new HttpRequestMessage(HttpMethod.Post,"http://catalog_server/api/books/decrease/"+itemId );

            var response=  client.Send(request);
            
                //check the response StatusCode to determine the response of the client request
           if (response.StatusCode == HttpStatusCode.OK)//everything is ok and the order have been stored
           {
               _repo.Purchase(mappedCreateOrder);
               _repo.SaveChanges();
               var mappedRead = _mapper.Map<OrderReadDto>(mappedCreateOrder);
               return Ok(mappedRead);
           }
           else if (response.StatusCode == HttpStatusCode.NotFound)// the required book is not exist in our database
           {
               return NotFound();
           }
           else if (response.StatusCode == HttpStatusCode.NoContent)// the book is out of stock
           {
               return Problem("Book out of stock");
           }

           return Problem("There is Something wrong !! MahdeSouqi");

        }





    }
}
