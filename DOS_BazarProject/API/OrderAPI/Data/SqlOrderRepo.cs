using System;
using System.Collections.Generic;
using System.Linq;
using OrderAPI.Model;

namespace OrderAPI.Data
{
    public class SqlOrderRepo : IOrderRepo
    {
        private readonly OrderContext _context;

        public SqlOrderRepo(OrderContext context)
        {
            _context = context;
        }
        public void Purchase(Order order)
        {
            if (order == null)
            {
                throw new ArgumentNullException();
            }

            _context.Orders.Add(order);
        }

        public bool SaveChanges()
        {
            return (_context.SaveChanges()>=0);
        }

        public IEnumerable<Order> GetAllOrders()
        {
            var orders = _context.Orders.ToList();
            return orders;
        }

        public Order GetOrderById(Guid id)
        {
            return _context.Orders.FirstOrDefault(p => p.Id == id);
        }
    }
}