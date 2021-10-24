using CatalogServer.Model;
using Microsoft.EntityFrameworkCore;

namespace CatalogServer.Data
{
    public class CatalogContext : DbContext
    {
        public DbSet<Book> Catalogs { get; set; }
        public CatalogContext(DbContextOptions<CatalogContext> opt) : base(opt)
        {
        }
        
    }
}