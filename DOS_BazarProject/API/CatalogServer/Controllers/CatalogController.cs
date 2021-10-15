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
    [Route("api/books")]
    public class CatalogController : ControllerBase
    {
        
        private readonly ICatalogRepo _repo;
        private readonly IMapper _mapper;

        public CatalogController( ICatalogRepo repo,IMapper mapper)
        {
            _repo = repo;
            _mapper = mapper;
        }



        [HttpGet]
        public ActionResult<IEnumerable<Book>> GetAllBooks()
        {
            var books=_repo.GetAllBooks();
            return Ok(books);
        }

        
        
        [HttpGet("getInfoById/{id}")]
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

        
        
        [HttpGet("searchByTopic/{topic}")]
        public ActionResult<IEnumerable<Book>> SearchByTopic(string topic)
        {
            var books = _repo.SearchByTopic(topic);
            if (books == null)
            {
                return NotFound();
            }

            return Ok(books);
        }



        [HttpPatch("updateCost/{id}")]
        public ActionResult UpdateCost(Guid id ,JsonPatchDocument<BookUpdateDto> pathDoc)
        {
            var bookFromDb = _repo.GetInfoById(id);
            if (bookFromDb == null)
            {
                return NotFound();
            }
            var commandToPatch = _mapper.Map<BookUpdateDto>(bookFromDb);
            pathDoc.ApplyTo(commandToPatch,ModelState);
            if (!TryValidateModel(commandToPatch))
            {
                return ValidationProblem(ModelState);
            }
            _mapper.Map(commandToPatch,bookFromDb);
            _repo.Update(bookFromDb);
            _repo.SaveChanges();
            return NoContent();
        }


        [HttpPost("decrease/{id}")]
        public ActionResult DecreaseBookCount(Guid id)
        {
            if (_repo.GetInfoById(id) == null)
            {
                return NotFound();
            }
            _repo.DecreaseBookCount(id);
            return NoContent();
        }




    }
}