package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.OrderService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.MailProperties.EmailSender;

import java.io.IOException;
import java.text.NumberFormat;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@WebServlet(name = "UpdateOrderController", value = "/admin/update-order")
public class UpdateOrderController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> json = mapper.readValue(req.getInputStream(), Map.class);
        int orderId = Integer.parseInt(json.get("orderId").toString());
        int userId = Integer.parseInt(json.get("userId").toString());
        String fullName = json.get("fullName") != null ? json.get("fullName").toString() : "";
        String email = json.get("email") != null ? json.get("email").toString() : "";
        String phoneNumber = json.get("phoneNumber") != null ? json.get("phoneNumber").toString() : "";
        String fullAddress = json.get("fullAddress") != null ? json.get("fullAddress").toString() : "";
        String paymentMethod = json.get("paymentMethod") != null ? json.get("paymentMethod").toString() : "";
        String status = json.get("status") != null ? json.get("status").toString() : "";
        String note = json.get("note") != null ? json.get("note").toString() : "";
        LocalDate completedAt = null;
        if ("Hoàn thành".equalsIgnoreCase(status) || "Giao thành công".equalsIgnoreCase(status)) {
            completedAt = LocalDate.now();
        }
        String[] addrParts = fullAddress.split(",");
        String addressLine = addrParts.length > 0 ? addrParts[0].trim() : "";
        String district = addrParts.length > 1 ? addrParts[1].trim() : "";
        String province = addrParts.length > 2 ? addrParts[2].trim() : "";

        OrderService orderService = new OrderService();
        boolean success = orderService.updateOrderFull(
                orderId, userId, fullName, email, phoneNumber,
                addressLine, province, district, paymentMethod, status, note, completedAt);
        Map<String, Object> res = new HashMap<>();
        res.put("success", success);
        mapper.writeValue(resp.getWriter(), res);
        if (success && email != null && !email.trim().isEmpty()) {
            final String finalEmail = email;
            final String finalFullName = fullName;
            final String finalPaymentMethod = paymentMethod;
            final String finalStatus = status;
            final int finalOrderId = orderId;
            new Thread(() -> {
                try {
                    Map<String, Object> orderDetail = orderService.getOrderDetailAdmin(finalOrderId);
                    List<Map<String, Object>> items = orderService.getOrderItemsAdmin(finalOrderId);
                    StringBuilder itemRows = new StringBuilder();
                    NumberFormat fmt = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                    for (Map<String, Object> item : items) {
                        String productName = item.get("productName") != null ? item.get("productName").toString() : "N/A";
                        double priceVal = item.get("price") != null ? Double.parseDouble(item.get("price").toString()) : 0;
                        int qtyVal = item.get("quantity") != null ? (int)Double.parseDouble(item.get("quantity").toString()) : 0;
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
                            + "<li>Mã đơn hàng: <b>#" + finalOrderId + "</b></li>"
                            + "<li>Khách hàng: " + finalFullName + "</li>"
                            + "<li>Phương thức thanh toán: " + finalPaymentMethod + "</li>"
                            + "</ul>";
                    EmailSender emailSender = new EmailSender();
                    if ("Đang giao".equalsIgnoreCase(finalStatus)) {
                        String htmlContent = "<p>Xin chào <b>" + finalFullName + "</b>,</p>"
                                + "<p>Đơn hàng <b>#" + finalOrderId + "</b> của bạn đang được giao.</p>"
                                + "<p><b>Thông tin đơn hàng:</b></p>"
                                + baseInfo
                                + "<p><b>Danh sách sản phẩm:</b></p>"
                                + productTable
                                + "<p>Vui lòng chú ý điện thoại để nhận hàng.</p>"
                                + "<p>Trân trọng,<br>Đội ngũ SkyDrone</p>";
                        emailSender.sendOrderHtmlEmail(finalEmail, "[SkyDrone] Đơn hàng #" + finalOrderId + " đang được giao!", htmlContent);
                    } else if ("Hoàn thành".equalsIgnoreCase(finalStatus) || "Giao thành công".equalsIgnoreCase(finalStatus)) {
                        String htmlContent = "<p>Xin chào <b>" + finalFullName + "</b>,</p>"
                                + "<p>Đơn hàng <b>#" + finalOrderId + "</b> của bạn đã được giao thành công.</p>"
                                + "<p><b>Thông tin đơn hàng:</b></p>"
                                + baseInfo
                                + "<p><b>Danh sách sản phẩm:</b></p>"
                                + productTable
                                + "<p>Cảm ơn bạn đã tin tưởng và sử dụng dịch vụ của SkyDrone. Hẹn gặp lại!</p>"
                                + "<p>Trân trọng,<br>Đội ngũ SkyDrone</p>";
                        emailSender.sendOrderHtmlEmail(finalEmail, "[SkyDrone] Đơn hàng #" + finalOrderId + " đã giao thành công!", htmlContent);
                    } else if ("Hủy".equalsIgnoreCase(finalStatus)) {
                        String htmlContent = "<p>Xin chào <b>" + finalFullName + "</b>,</p>"
                                + "<p>Chúng tôi xin thông báo đơn hàng <b>#" + finalOrderId + "</b> của bạn đã bị hủy.</p>"
                                + "<p><b>Thông tin đơn hàng:</b></p>"
                                + baseInfo
                                + "<p><b>Danh sách sản phẩm:</b></p>"
                                + productTable
                                + "<p>Nếu bạn có thắc mắc, vui lòng liên hệ: <b>support@skydrone.vn</b></p>"
                                + "<p>Trân trọng,<br>Đội ngũ SkyDrone</p>";
                        emailSender.sendOrderHtmlEmail(finalEmail, "[SkyDrone] Đơn hàng #" + finalOrderId + " đã bị hủy", htmlContent);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }).start();
        }
    }
}