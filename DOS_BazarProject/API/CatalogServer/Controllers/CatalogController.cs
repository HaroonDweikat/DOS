using System;
using System.Web;
using System.Collections.Generic;
using System.Web.Http.Cors;
using AutoMapper;
using CatalogServer.Data;
using CatalogServer.DTO;
using CatalogServer.Model;
using Microsoft.AspNetCore.Http;
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
                return NotFound();
            }
            
            var mappedBook= _mapper.Map<IEnumerable<BookReadDto>>(books);//mape from Book to BookReadDto
            return Ok(mappedBook);
        }

        
        //this method response is a book info that have the passin id
        [HttpGet("getInfoById/{id}")]//same
        public ActionResult<BookReadDto> GetBookById(Guid id)
        {
            var book = _repo.GetInfoById(id);
            if (book == null)
            {
                return NotFound();
            }

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
                return NotFound();
            }
            var mappedBook= _mapper.Map<IEnumerable<BookReadDto>>(books);
            return Ok(mappedBook);
        }


        //this method used to update a value in the database for the book that have the passin id
        [HttpPatch("update/{id}")]
        public ActionResult UpdateCost(Guid id ,JsonPatchDocument<BookUpdateDto> pathDoc)
        {
            var bookFromDb = _repo.GetInfoById(id);//bring the data form the database
            if (bookFromDb == null)//check it value 
            {
                return NotFound();
            }
            var commandToPatch = _mapper.Map<BookUpdateDto>(bookFromDb);//mapped it to the DTO that contain the field that can the client
            
            //update
            pathDoc.ApplyTo(commandToPatch,ModelState);// apply the method which is update to the given field which will be extract from the
            //json request obj
            if (!TryValidateModel(commandToPatch))//to check if the update have been done correctly
            {
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
            _repo.SaveChanges();
            return Ok(mappedReadBook);
        }

        //this method usage is to decrease the book stock count in the database when a Purchase operation occur
        [HttpPost("decrease/{id}")]
        public ActionResult DecreaseBookCount(Guid id)
        {
            
            int result= _repo.DecreaseBookCount(id);
            

            if(result == 0 )//to check if the book exist or no
            {
                return NotFound();
            }else if(result == 1 )//the book exist and we decrease the stock count
            {
                return Ok();
            }else // the book is out of stock
            {
                return NoContent();//out of stock
            }
            
            
        }
        
        
        
        [HttpPost("Increase/{id}")]
        public ActionResult IncreaseBookCount(Guid id)
        {
            if (_repo.GetInfoById(id) == null)
            {
                return NotFound();
            }
            _repo.IncreaseBookCount(id);

            return Ok();
        }

        




    }
}
