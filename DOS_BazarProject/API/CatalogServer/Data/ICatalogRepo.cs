using System;
using System.Collections.Generic;
using CatalogServer.Model;

namespace CatalogServer.Data
{
    public interface ICatalogRepo // this interface represent the functionality that this server can do 
    {
        
        public IEnumerable<Book> SearchByTopic(string topic);

        public IEnumerable<Book> GetAllBooks();
        
        public Book GetInfoById(Guid id);

        public void AddBook(Book book);
        
        public bool SaveChanges();

        public void Update(Book book);

        public int DecreaseBookCount(Guid id);

        public void IncreaseBookCount(Guid id);
    }
}
