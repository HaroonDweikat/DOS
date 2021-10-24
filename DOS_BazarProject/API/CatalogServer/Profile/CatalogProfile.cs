
using CatalogServer.DTO;
using CatalogServer.Model;

namespace CatalogServer.Profile
{
    public class CatalogProfile : AutoMapper.Profile
    {

        public CatalogProfile()
        {
            CreateMap<Book, BookReadDto>();//used to map between Book class (source) and the BookReadDto class(Destination)
            CreateMap<Book, BookUpdateDto>();
            CreateMap<BookUpdateDto,Book >();
        }
        
    }
}