using System;
using System.Collections.Generic;
using AutoMapper;
using CatalogServer.Data;
using CatalogServer.DTO;
using CatalogServer.Model;
using Microsoft.AspNetCore.JsonPatch;
using Microsoft.AspNetCore.Mvc;

namespace CatalogServer.Controllers
{
    [Controller]
    [Route("api/books")]// tha main URL for this server 
    public class CatalogController : ControllerBase// this class represent the conrol unit in the server which is the unit that receive 
        //the client request and handle it and sned back the response 
    {
        
        private readonly ICatalogRepo _repo;
        private readonly IMapper _mapper;

        public CatalogController( ICatalogRepo repo,IMapper mapper)
        {
            _repo = repo;
            _mapper = mapper;
        }


        //this method response is a list of all the books that we have in the database
        [HttpGet("getAllBooks")]// when the request http://host/api/books/getAllBooks   this method will receive the request and handel it
        public ActionResult<IEnumerable<BookReadDto>> GetAllBooks()
        {
            var books=_repo.GetAllBooks();// bring the data from the database
            if (books == null)// check if the data value is null that mean that there is no data 
            {
                Console.WriteLine("(CatalogServer)--->There is no books to display in the CatalogServer DB");
                return NotFound();
            }
            Console.WriteLine("(CatalogServer)--->The books have been sent");
            var mappedBook= _mapper.Map<IEnumerable<BookReadDto>>(books);//map from Book to BookReadDto
            return Ok(mappedBook);
        }

        
        //this method response is a book info that have the passin id
        [HttpGet("getInfoById/{id}")]//same
        public ActionResult<BookReadDto> GetBookById(Guid id)
        {
            var book = _repo.GetInfoById(id);
            if (book == null)
            {
                Console.WriteLine("(CatalogServer)--->There is no book with this ID :"+id);
                return NotFound();
            }
            Console.WriteLine("(CatalogServer)--->The book has been sent");
            var mappedBook= _mapper.Map<BookReadDto>(book);
            return Ok(mappedBook);
        }

        
       // this method response is a list of all the books that we have the passin topic
        [HttpGet("searchByTopic/{topic}")]//same
        public ActionResult<IEnumerable<BookReadDto>> SearchByTopic(string topic)
        {
            var books = _repo.SearchByTopic(topic);
            if (books == null)
            {
                Console.WriteLine("(CatalogServer)--->There is no books with this topic :"+topic);
                return NotFound();
            }
            Console.WriteLine("(CatalogServer)--->The books have been sent");
            var mappedBook= _mapper.Map<IEnumerable<BookReadDto>>(books);
            return Ok(mappedBook);
        }


        //this method used to update a value in the database for the book that have the passin id
        [HttpPatch("update/{id}")]
        public ActionResult UpdateCost(Guid id ,[FromBody]JsonPatchDocument<BookUpdateDto> pathDoc)
        {
            var bookFromDb = _repo.GetInfoById(id);//bring the data form the database
            if (bookFromDb == null)//check it value 
            {
                Console.WriteLine("(CatalogServer)--->There is no book with this Id :"+id);
                return NotFound();
            }
            var commandToPatch = _mapper.Map<BookUpdateDto>(bookFromDb);//mapped it to the DTO that contain the field that can the client
            
            //update
            pathDoc.ApplyTo(commandToPatch,ModelState);// apply the method which is update to the given field which will be extract from the
            //json request obj
            if (!TryValidateModel(commandToPatch))//to check if the update have been done correctly
            {
                Console.WriteLine("(CatalogServer)--->Something goes wrong in updating process");
                return ValidationProblem(ModelState);
            }
            _mapper.Map(commandToPatch,bookFromDb);
            _repo.Update(bookFromDb);
            _repo.SaveChanges();//save the update change in the database 
            return NoContent();
        }

        
        //this method used to create a new book in the database 
        [HttpPost("addBook")]
        public ActionResult<BookReadDto> AddBook([FromBody] BookCreateDto book)
        {
            var mappedBook = _mapper.Map<Book>(book);
            _repo.AddBook(mappedBook);
            _repo.SaveChanges();
            var mappedReadBook = _mapper.Map<BookReadDto>(mappedBook);
            return Ok(mappedReadBook);
        }

        //this method usage is to decrease the book stock count in the database when a Purchase operation occur
        [HttpGet("checkStock/{id}")]
        public ActionResult CheckBookCount(Guid id)
        {
            
            int result= _repo.CheckStock(id);
            

            if(result == 0 )//to check if the book exist or no
            {
                return NotFound();
            }else if(result == 1 )//the book exist 
            {
                return Ok();
            }else // the book is out of stock
            {
                return NoContent();//out of stock
            }
            
            
        }
        
         [HttpPost("decrease/{id}")]
         public ActionResult DecreaseBookCount(Guid id)
         {
             
             _repo.DecreaseBookCount(id);
        
             return Ok();
        }
        
        
        
        // [HttpPost("Increase/{id}")]
        // public ActionResult IncreaseBookCount(Guid id)
        // {
        //     if (_repo.GetInfoById(id) == null)
        //     {
        //         return NotFound();
        //     }
        //     _repo.IncreaseBookCount(id);
        //
        //     return Ok();
        //}

        




    }
}
