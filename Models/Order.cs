using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TechStore.Models
{
    public class Order
    {
        [Key]
        public int OrderId { get; set; }

        [Required]
        public int CustomerId { get; set; }

        [ForeignKey("CustomerId")]
        public virtual Customer Customer { get; set; }

        [Required(ErrorMessage = "Ngày đặt hàng là bắt buộc")]
        public DateTime OrderDate { get; set; } = DateTime.Now;

        [Required(ErrorMessage = "Trạng thái đơn hàng là bắt buộc")]
        public OrderStatus Status { get; set; } = OrderStatus.Pending;

        [Required(ErrorMessage = "Tổng tiền là bắt buộc")]
        [Column(TypeName = "decimal(18,2)")]
        public decimal TotalAmount { get; set; }

        [StringLength(500, ErrorMessage = "Ghi chú không được vượt quá 500 ký tự")]
        public string Notes { get; set; }

        [StringLength(200, ErrorMessage = "Địa chỉ giao hàng không được vượt quá 200 ký tự")]
        public string ShippingAddress { get; set; }

        [StringLength(100, ErrorMessage = "Thành phố giao hàng không được vượt quá 100 ký tự")]
        public string ShippingCity { get; set; }

        [StringLength(10, ErrorMessage = "Mã bưu điện giao hàng không được vượt quá 10 ký tự")]
        public string ShippingPostalCode { get; set; }

        public DateTime? ShippedDate { get; set; }

        public DateTime? DeliveredDate { get; set; }

        // Navigation properties
        public virtual ICollection<OrderDetail> OrderDetails { get; set; } = new List<OrderDetail>();
    }

    public enum OrderStatus
    {
        Pending = 0,        // Chờ xử lý
        Processing = 1,     // Đang xử lý
        Shipped = 2,        // Đã giao hàng
        Delivered = 3,      // Đã nhận hàng
        Cancelled = 4       // Đã hủy
    }
}
