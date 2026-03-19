package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.cart.Carts;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.OrderService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.MailProperties.EmailSender;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.VnpayConfig;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.VnpayUtil;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.NumberFormat;
import java.util.*;

@WebServlet("/VnpayReturnServlet")
public class VnpayReturnServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String responseCode = request.getParameter("vnp_ResponseCode");
        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements(); ) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }
        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    hashData.append('&');
                }
            }
        }
        String signValue = "";
        try {
            signValue = VnpayUtil.hmacSHA512(VnpayConfig.vnp_HashSecret, hashData.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
        HttpSession session = request.getSession();
        if ("00".equals(responseCode) && signValue.equalsIgnoreCase(vnp_SecureHash)) {
            try {
                User user = (User) session.getAttribute("user");
                List<OrderItems> items = (List<OrderItems>) session.getAttribute("BUY_NOW_ITEM");
                Carts cart = (Carts) session.getAttribute("cart");
                Integer addressId = (Integer) session.getAttribute("addressId");
                String phone = (String) session.getAttribute("phone");
                String note = (String) session.getAttribute("note");
                Long shippingFee = (Long) session.getAttribute("shippingFee");
                if (shippingFee == null) shippingFee = 0L;
                if (user != null && items != null && !items.isEmpty()) {
                    OrderService orderService = new OrderService();
                    int orderId = orderService.placeOrder(user, addressId, phone, note, "VNPAY", items, cart, shippingFee.doubleValue());
                    if (orderId > 0 && user.getEmail() != null && !user.getEmail().isEmpty()) {
                        final String finalEmail = user.getEmail();
                        final String finalFullName = user.getFullName();
                        final int finalOrderId = orderId;
                        final List<OrderItems> finalItems = new ArrayList<>(items);
                        new Thread(() -> {
                            try {
                                StringBuilder itemRows = new StringBuilder();
                                long total = 0;
                                NumberFormat fmt = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
                                for (OrderItems item : finalItems) {
                                    long price = (long) item.getPrice();
                                    int qty = item.getQuantity();
                                    long subtotal = price * qty;
                                    total += subtotal;
                                    itemRows.append("<tr>")
                                            .append("<td style='padding:4px 8px;border:1px solid #ddd;'>").append(item.getProduct().getProductName()).append("</td>")
                                            .append("<td style='padding:4px 8px;border:1px solid #ddd;text-align:center;'>").append(qty).append("</td>")
                                            .append("<td style='padding:4px 8px;border:1px solid #ddd;text-align:right;'>").append(fmt.format(price)).append("đ</td>")
                                            .append("<td style='padding:4px 8px;border:1px solid #ddd;text-align:right;'>").append(fmt.format(subtotal)).append("đ</td>")
                                            .append("</tr>");
                                }
                                String productTable = "<table style='width:100%;border-collapse:collapse;margin:10px 0;'>"
                                        + "<tr style='background:#f0f0f0;'>"
                                        + "<th style='padding:4px 8px;border:1px solid #ddd;text-align:left;'>Sản phẩm</th>"
                                        + "<th style='padding:4px 8px;border:1px solid #ddd;'>SL</th>"
                                        + "<th style='padding:4px 8px;border:1px solid #ddd;'>Đơn giá</th>"
                                        + "<th style='padding:4px 8px;border:1px solid #ddd;'>Thành tiền</th>"
                                        + "</tr>"
                                        + itemRows
                                        + "<tr><td colspan='3' style='padding:4px 8px;border:1px solid #ddd;text-align:right;'><b>Tổng tiền:</b></td>"
                                        + "<td style='padding:4px 8px;border:1px solid #ddd;text-align:right;'><b>" + fmt.format(total) + "đ</b></td></tr>"
                                        + "</table>";
                                EmailSender emailSender = new EmailSender();
                                String htmlContent = "<p>Xin chào <b>" + finalFullName + "</b>,</p>"
                                        + "<p>Thanh toán qua <b>VNPAY</b> cho đơn hàng <b>#" + finalOrderId + "</b> của bạn đã được xử lý thành công.</p>"
                                        + "<p><b>Thông tin đơn hàng:</b></p>"
                                        + "<ul>"
                                        + "<li>Mã đơn hàng: <b>#" + finalOrderId + "</b></li>"
                                        + "<li>Khách hàng: " + finalFullName + "</li>"
                                        + "<li>Phương thức thanh toán: VNPAY (Đã thanh toán)</li>"
                                        + "<li>Trạng thái: Đã thanh toán</li>"
                                        + "</ul>"
                                        + "<p><b>Danh sách sản phẩm:</b></p>"
                                        + productTable
                                        + "<p>Đơn hàng đang được chuẩn bị và sẽ được giao sớm nhất có thể.</p>"
                                        + "<p>Trân trọng,<br>Đội ngũ SkyDrone</p>";
                                emailSender.sendOrderHtmlEmail(finalEmail, "[SkyDrone] Xác nhận thanh toán VNPAY - Đơn hàng #" + finalOrderId, htmlContent);
                            } catch (Exception mailEx) {
                                mailEx.printStackTrace();
                            }
                        }).start();
                    }
                    if (cart != null) session.setAttribute("cart", cart);
                    session.removeAttribute("BUY_NOW_ITEM");
                    session.removeAttribute("note");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            request.setAttribute("message", "Thanh toán thành công!");
        } else {
            if (!signValue.equalsIgnoreCase(vnp_SecureHash)) {
                request.setAttribute("message", "Chữ ký không hợp lệ! Vui lòng không thay đổi tham số trên URL.");
            } else {
                request.setAttribute("message", "Thanh toán thất bại! Mã lỗi: " + responseCode);
            }
        }
        request.getRequestDispatcher("/page/paymentresult.jsp").forward(request, response);
    }
}