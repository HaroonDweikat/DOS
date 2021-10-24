using System;
using System.ComponentModel.DataAnnotations;

namespace OrderAPI.Model
{
    public class Order
    {
        
        [Key] 
        public Guid Id { get; set; }
        [Required] 
        public Guid ItemId { get; set; }
        [Required] 
        public string Date { get; set; }
        
    }
}