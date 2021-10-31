using System;
using System.Collections.Generic;
using System.Linq;
using CatalogServer.Model;
using Microsoft.EntityFrameworkCore;

namespace CatalogServer.Data
{
    public class SqlCatalogRepo : ICatalogRepo // this class implement the interface that contain the functionality that we have 
    {
        private readonly CatalogContext _context;

        public SqlCatalogRepo( CatalogContext context)
        {
            _context = context;
        }


       

        public IEnumerable<Book> SearchByTopic(string topic)
        {
            var dataFromDb = _context.Catalogs.Where(row => row.BookTopic.Contains(topic)).ToList();
            return dataFromDb;
        }

        public IEnumerable<Book> GetAllBooks()
        {
            return _context.Catalogs.ToList();
        }

        public Book GetInfoById(Guid id)
        {
            return _context.Catalogs.FirstOrDefault(p => p.Id == id);
        }

        public void AddBook(Book book)
        {
            if (book == null)
            {
                throw new ArgumentNullException();
            }

            _context.Catalogs.Add(book);
        }


        public bool SaveChanges()
        {
            return (_context.SaveChanges() >= 0);
        }

        public void Update(Book book)
        {
            
        }

        public int DecreaseBookCount(Guid id)
        {
        
            var bookToCheckValue =GetInfoById(id);

            if(bookToCheckValue == null)
            {
                return 0;
            }
            else if (bookToCheckValue.CountInStock > 0)
            {
                var row = _context.Database.ExecuteSqlInterpolated(
                    $"UPDATE Catalogs SET CountInStock= CountInStock - 1 WHERE Id={id} ");
                return 1;
            }else
                return 2;
        }

        public void IncreaseBookCount(Guid id)
        {
            

             
            var row= _context.Database.ExecuteSqlInterpolated(
                $"UPDATE Catalogs SET CountInStock= CountInStock + 1 WHERE Id={id} ");

               
        }
    }
}
