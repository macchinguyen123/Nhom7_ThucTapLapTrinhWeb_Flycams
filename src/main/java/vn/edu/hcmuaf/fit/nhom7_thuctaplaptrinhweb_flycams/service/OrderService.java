package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.cart.Carts;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.OrderDaoAdmin;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.OrderItemsDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.OrdersDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.ProductManagement;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public class OrderService {
    private OrdersDAO ordersDAO = new OrdersDAO();
    private OrderItemsDAO orderItemsDAO = new OrderItemsDAO();
    private ProductManagement productManagement = new ProductManagement();

    //Đặt hàng
    public int placeOrder(User user, int addressId, String phone, String note, String paymentMethod,
            List<OrderItems> items, Carts cart) throws Exception {
        if (items == null || items.isEmpty()) {
            return 0;
        }

        double totalPrice = 0;
        for (OrderItems item : items) {
            totalPrice += item.getPrice() * item.getQuantity();
        }

        Orders order = new Orders();
        order.setUserId(user.getId());
        order.setAddressId(addressId);
        order.setPhoneNumber(phone);
        order.setPaymentMethod(paymentMethod);
        order.setNote(note);
        order.setStatus(Orders.Status.PENDING);
        order.setCreatedAt(Timestamp.valueOf(LocalDateTime.now()));
        order.setTotalPrice(totalPrice);

        int orderId = ordersDAO.insert(order);

        if (orderId <= 0) {
            throw new Exception("Insert order failed");
        }

        for (OrderItems item : items) {
            item.setOrderId(orderId);
            orderItemsDAO.insert(item);

            // Reduce Product stock
            productManagement.reduceQuantity(item.getProductId(), item.getQuantity());

            // Update Cart
            if (cart != null) {
                cart.removeItem(item.getProductId());
            }
        }

        return orderId;
    }

    // Lấy danh sách đơn hàng của người dùng
    public List<Orders> getOrdersByUser(int userId) {
        return ordersDAO.getOrdersByUser(userId);
    }

    // Lấy lịch sử đơn hàng
    public List<Orders> getOrdersWithItemsByUser(int userId) {
        List<Orders> orders = ordersDAO.getOrdersByUser1(userId);
        for (Orders o : orders) {
            o.setItems(orderItemsDAO.getItemsByOrderId(o.getId()));
            mapStatus(o);
        }
        return orders;
    }

    // trạng thái đơn hàng
    private void mapStatus(Orders o) {
        switch (o.getStatus()) {
            case DELIVERED -> {
                o.setStatusLabel("Đã nhận hàng");
                o.setStatusClass("da-nhan-hang");
            }
            case CANCELLED -> {
                o.setStatusLabel("Đã hủy");
                o.setStatusClass("da-huy");
            }
            default -> {
                // Giữ trạng thái mặc định
            }
        }
    }

    // Lấy chi tiết một đơn hàng theo ID
    public Orders getOrderById(int orderId, int userId) {
        return ordersDAO.getOrderById(orderId, userId);
    }

    // Lấy thông tin giao hàng của đơn hàng
    public Map<String, String> getShippingInfoByOrder(int orderId) {
        return ordersDAO.getShippingInfoByOrder(orderId);
    }

    // Lấy danh sách sản phẩm trong một đơn hàng
    public List<OrderItems> getOrderItems(int orderId) {
        return ordersDAO.getOrderItems(orderId);
    }

    // Hủy đơn hàng
    public void cancelOrder(int orderId, int userId) {
        ordersDAO.cancelOrder(orderId, userId);
    }

    // Kiểm tra người dùng đã từng mua sản phẩm hay chưa, để ktr đánh giá
    public boolean hasUserPurchasedProduct(int userId, int productId) {
        return ordersDAO.hasUserPurchasedProduct(userId, productId);
    }

    // Admin
    private OrderDaoAdmin orderDaoAdmin = new OrderDaoAdmin();

    // Lấy toàn bộ đơn hàng cho Admin
    public List<Orders> getOrdersForAdmin() {
        return orderDaoAdmin.getOrdersForAdmin();
    }

    // Lấy danh sách đơn hàng đang chờ xử lý
    public List<Orders> getPendingOrders() {
        return orderDaoAdmin.getPendingOrders();
    }

    // Lấy chi tiết đơn hàng cho Admin
    public Map<String, Object> getOrderDetailAdmin(int orderId) {
        return orderDaoAdmin.getOrderDetail(orderId);
    }

    // Lấy danh sách sản phẩm trong đơn hàng
    public List<Map<String, Object>> getOrderItemsAdmin(int orderId) {
        return orderDaoAdmin.getOrderItems(orderId);
    }

    // Xác nhận đơn hàng + Random mã vận chuyển
    public boolean confirmOrder(int orderId) {
        // Random VC + 6 số
        String randomDigits = String.valueOf((int) (Math.random() * 900000) + 100000); // 100000 -> 999999
        String shippingCode = "VC" + randomDigits;

        return orderDaoAdmin.updateOrderStatusAndShippingCode(orderId, "Đang xử lý", shippingCode);
    }

    // Cập nhật trạng thái đơn hàng
    public boolean updateOrderStatus(int orderId, String status) {
        return orderDaoAdmin.updateOrderStatus(orderId, status);
    }

    // Cập nhật toàn bộ thông tin đơn hàng
    public boolean updateOrderFull(int orderId, int userId, String fullName, String email, String phoneNumber,
            String addressLine, String province, String district,
            String paymentMethod, String status, String note, java.time.LocalDate completedAt) {
        return orderDaoAdmin.updateOrderFull(orderId, userId, fullName, email, phoneNumber,
                addressLine, province, district, paymentMethod, status, note, completedAt);
    }
}
