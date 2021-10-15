using System;
using System.Collections.Generic;
using System.Linq;
using CatalogServer.Model;
using Microsoft.EntityFrameworkCore;

namespace CatalogServer.Data
{
    public class SqlCatalogRepo : ICatalogRepo
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

        public bool SaveChanges()
        {
            return (_context.SaveChanges() >= 0);
        }

        public void Update(Book book)
        {
            
        }

        public void DecreaseBookCount(Guid id)
        {
           var row= _context.Database.ExecuteSqlInterpolated(
                $"UPDATE Catalogs SET CountInStock= CountInStock - 1 WHERE Id={id} and CountInStock > 0");
           if (row == 0)
           {
               throw new InvalidOperationException($"Book with id : {id} is out of stock.");
           }
        }
    }
}