package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.MailProperties.EmailSender;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.cart.Carts;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.*;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;

import java.sql.Timestamp;
import java.text.NumberFormat;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class OrderService {
    private OrdersDAO ordersDAO = new OrdersDAO();
    private OrderItemsDAO orderItemsDAO = new OrderItemsDAO();
    private ProductManagement productManagement = new ProductManagement();
    private CartDAO cartDAO = new CartDAO();

    // Đặt hàng
    public int placeOrder(User user, int addressId, String phone, String note, String paymentMethod,
                          List<OrderItems> items, Carts cart, double shippingFee) throws Exception {
        if (items == null || items.isEmpty()) {
            return 0;
        }
        double totalPrice = shippingFee;
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
        order.setShippingFee(shippingFee);

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
                if (user != null) {
                    cartDAO.removeCartItem(user.getId(), item.getProductId());
                }
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
            case RETURN_REQUESTED -> {
                o.setStatusLabel("Yêu cầu trả hàng");
                o.setStatusClass("yeu-cau-tra-hang");
            }
            case RETURNED -> {
                o.setStatusLabel("Đã trả hàng");
                o.setStatusClass("da-tra-hang");
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

    // Trả đơn hàng
    public boolean returnOrder(int orderId, int userId) {
        return ordersDAO.returnOrder(orderId, userId);
    }

    // Hoàn tác trả đơn hàng
    public boolean undoReturnOrder(int orderId, int userId) {
        return ordersDAO.undoReturnOrder(orderId, userId);
    }

    // Xác nhận đã nhận hàng
    public boolean receiveOrder(int orderId, int userId) {
        return ordersDAO.receiveOrder(orderId, userId);
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

    public List<Orders> getRejectedOrders() {
        return orderDaoAdmin.getRejectedOrders();
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
        String randomDigits = String.valueOf((int) (Math.random() * 900000) + 100000);
        String shippingCode = "VC" + randomDigits;
        return orderDaoAdmin.updateOrderStatusAndShippingCode(orderId, "Đang xử lý", shippingCode);
    }

    // Cập nhật trạng thái đơn hàng
    public boolean updateOrderStatus(int orderId, String status) {
        return orderDaoAdmin.updateOrderStatus(orderId, status);
    }

    // Cập nhật trạng thái đơn hàng kèm ghi chú (ví dụ Lý do hủy)
    public boolean updateOrderStatusAndNote(int orderId, String status, String note) {
        return orderDaoAdmin.updateOrderStatusAndNote(orderId, status, note);
    }

    // Cập nhật toàn bộ thông tin đơn hàng
    public boolean updateOrderFull(int orderId, int userId, String fullName, String email, String phoneNumber,
                                   String addressLine, String province, String district,
                                   String paymentMethod, String status, String note, java.time.LocalDate completedAt) {
        boolean success = orderDaoAdmin.updateOrderFull(orderId, userId, fullName, email, phoneNumber,
                addressLine, province, district, paymentMethod, status, note, completedAt);
        if (success) {
            sendStatusChangeEmail(orderId, status, fullName, email, paymentMethod, note);
        }
        return success;
    }

    public void sendStatusChangeEmail(int orderId, String status, String fullName, String email, String paymentMethod, String note) {
        if (email == null || email.trim().isEmpty()) return;
        new Thread(() -> {
            try {
                Map<String, Object> orderDetail = getOrderDetailAdmin(orderId);
                List<Map<String, Object>> items = getOrderItemsAdmin(orderId);
                StringBuilder itemRows = new StringBuilder();
                NumberFormat fmt = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                for (Map<String, Object> item : items) {
                    String productName = item.get("productName") != null ? item.get("productName").toString() : "N/A";
                    double priceVal = item.get("price") != null ? Double.parseDouble(item.get("price").toString()) : 0;
                    int qtyVal = item.get("quantity") != null ? (int) Double.parseDouble(item.get("quantity").toString()) : 0;
                    long subtotal = (long) (priceVal * qtyVal);
                    itemRows.append("<tr>")
                            .append("<td style='padding:4px 8px;border:1px solid #ddd;'>").append(productName).append("</td>")
                            .append("<td style='padding:4px 8px;border:1px solid #ddd;text-align:center;'>").append(qtyVal).append("</td>")
                            .append("<td style='padding:4px 8px;border:1px solid #ddd;text-align:right;'>").append(fmt.format(priceVal)).append("đ</td>")
                            .append("<td style='padding:4px 8px;border:1px solid #ddd;text-align:right;'>").append(fmt.format(subtotal)).append("đ</td>")
                            .append("</tr>");
                }
                double finalTotal = orderDetail.get("totalPrice") != null ? Double.parseDouble(orderDetail.get("totalPrice").toString()) : 0;
                String productTable = "<table style='width:100%;border-collapse:collapse;margin:10px 0;'>"
                        + "<tr style='background:#f0f0f0;'>"
                        + "<th style='padding:4px 8px;border:1px solid #ddd;text-align:left;'>Sản phẩm</th>"
                        + "<th style='padding:4px 8px;border:1px solid #ddd;'>SL</th>"
                        + "<th style='padding:4px 8px;border:1px solid #ddd;'>Đơn giá</th>"
                        + "<th style='padding:4px 8px;border:1px solid #ddd;'>Thành tiền</th>"
                        + "</tr>"
                        + itemRows
                        + "<tr><td colspan='3' style='padding:4px 8px;border:1px solid #ddd;text-align:right;'><b>Tổng tiền:</b></td>"
                        + "<td style='padding:4px 8px;border:1px solid #ddd;text-align:right;'><b>" + fmt.format(finalTotal) + "đ</b></td></tr>"
                        + "</table>";
                String baseInfo = "<ul>"
                        + "<li>Mã đơn hàng: <b>#" + orderId + "</b></li>"
                        + "<li>Khách hàng: " + fullName + "</li>"
                        + "<li>Phương thức thanh toán: " + (paymentMethod != null ? paymentMethod : "N/A") + "</li>"
                        + "</ul>";
                EmailSender emailSender = new EmailSender();
                String subject = "";
                String htmlContent = "";
                if ("Đang giao".equalsIgnoreCase(status)) {
                    subject = "[SkyDrone] Đơn hàng #" + orderId + " đang được giao!";
                    htmlContent = "<p>Xin chào <b>" + fullName + "</b>,</p>"
                            + "<p>Đơn hàng <b>#" + orderId + "</b> của bạn đang được giao.</p>"
                            + "<p><b>Thông tin đơn hàng:</b></p>"
                            + baseInfo
                            + "<p><b>Danh sách sản phẩm:</b></p>"
                            + productTable
                            + "<p>Vui lòng chú ý điện thoại để nhận hàng.</p>"
                            + "<p>Trân trọng,<br>Đội ngũ SkyDrone</p>";
                } else if ("Hoàn thành".equalsIgnoreCase(status) || "Giao thành công".equalsIgnoreCase(status)) {
                    subject = "[SkyDrone] Đơn hàng #" + orderId + " đã giao thành công!";
                    htmlContent = "<p>Xin chào <b>" + fullName + "</b>,</p>"
                            + "<p>Đơn hàng <b>#" + orderId + "</b> của bạn đã được giao thành công.</p>"
                            + "<p><b>Thông tin đơn hàng:</b></p>"
                            + baseInfo
                            + "<p><b>Danh sách sản phẩm:</b></p>"
                            + productTable
                            + "<p>Cảm ơn bạn đã tin tưởng và sử dụng dịch vụ của SkyDrone. Hẹn gặp lại!</p>"
                            + "<p>Trân trọng,<br>Đội ngũ SkyDrone</p>";
                } else if ("Hủy".equalsIgnoreCase(status)) {
                    subject = "[SkyDrone] Đơn hàng #" + orderId + " đã bị hủy";
                    String reasonHtml = (note != null && !note.trim().isEmpty())
                            ? "<p><b>Lý do hủy:</b> " + note + "</p>"
                            : "";
                    htmlContent = "<p>Xin chào <b>" + fullName + "</b>,</p>"
                            + "<p>Chúng tôi xin thông báo đơn hàng <b>#" + orderId + "</b> của bạn đã bị hủy.</p>"
                            + reasonHtml
                            + "<p><b>Thông tin đơn hàng:</b></p>"
                            + baseInfo
                            + "<p><b>Danh sách sản phẩm:</b></p>"
                            + productTable
                            + "<p>Nếu bạn có thắc mắc, vui lòng liên hệ: <b>support@skydrone.vn</b></p>"
                            + "<p>Trân trọng,<br>Đội ngũ SkyDrone</p>";
                }
                if (!subject.isEmpty()) {
                    emailSender.sendOrderHtmlEmail(email, subject, htmlContent);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }).start();
    }
}
