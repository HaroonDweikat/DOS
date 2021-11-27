using System;
using System.Collections.Generic;
using CacheAPI.Model;
using Microsoft.AspNetCore.Mvc;

namespace CacheAPI.Controller
{
    [ApiController]
    [Route("api/cache")]
    public class CacheController : ControllerBase
    {
        private readonly Dictionary<string, Cache> _dictionary;


        public CacheController(Dictionary<string,Cache> dictionary)
        {
            _dictionary = dictionary;
        }


        [HttpGet("{key}")]
        public ActionResult GetStoredCacheByKey(string key)
        {

            if (_dictionary.ContainsKey(key))
            {
                if (_dictionary[key].Book == null)
                {
                    if (_dictionary[key].Books == null)
                    {
                        Console.WriteLine("Data(orders) from cache have been sent");
                        return Ok(_dictionary[key].Orders);
                    }
                    Console.WriteLine("Data(books) from cache have been sent");
                    return Ok(_dictionary[key].Books);
                }
                Console.WriteLine("Data(book) from cache have been sent");
                return Ok(_dictionary[key].Book);
            }
            Console.WriteLine("Caches Miss");
            return NotFound();

        }


        [HttpPost("book/{key}")]
        public ActionResult AddBookToCache(string key, [FromBody] Book book)
        {

            if (ModelState.IsValid)
            {
                _dictionary[key] = new Cache
                {
                    Book = book,
                    Books = null,
                    Orders = null
                };
                Console.WriteLine("The book added to the cache successfully");
                return Ok();
            }
            
            Console.WriteLine("There is an error in the given data");
            return BadRequest();
        }
        
        
        [HttpPost("books/{key}")]
        public ActionResult AddBooksToCache(string key,[FromBody] IEnumerable<Book> books)
        {
           
            if (ModelState.IsValid)
            {
                _dictionary[key] = new Cache
                {
                    Book = null,
                    Books = books,
                    Orders = null
                };
                Console.WriteLine("The books  added to the cache successfully");
                return Ok();
            }
            
            Console.WriteLine("There is an error in the given data");
            return BadRequest();
        }
        
        
        [HttpPost("orders")]
        public ActionResult AddOrdersToCache( [FromBody] IEnumerable<Order> orders)
        {
            string key = "orders";
            if (ModelState.IsValid)
            {
                _dictionary[key] = new Cache
                {
                    Book = null,
                    Books = null,
                    Orders = orders
                };
                Console.WriteLine("The Orders added to the cache successfully");
                return Ok();
            }
            
            Console.WriteLine("There is an error in the given data");
            return BadRequest();
        }


        [HttpDelete("{key}")]
        public ActionResult DeleteCache(string key)
        {
            if (_dictionary.ContainsKey(key))
            {
                _dictionary.Remove(key);
            }

            return NotFound();

        }
        
        
    }
}