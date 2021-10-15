using System;
using System.Collections.Generic;
using CatalogServer.Model;

namespace CatalogServer.Data
{
    public interface ICatalogRepo
    {
        
        public IEnumerable<Book> SearchByTopic(string topic);

        public IEnumerable<Book> GetAllBooks();
        public Book GetInfoById(Guid id);

        public bool SaveChanges();

        public void Update(Book book);

        public void DecreaseBookCount(Guid id);
    }
}