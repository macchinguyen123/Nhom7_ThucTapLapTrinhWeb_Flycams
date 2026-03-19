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
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet(name = "PaymentServlet", value = "/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        List<OrderItems> items = (List<OrderItems>) session.getAttribute("BUY_NOW_ITEM");
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        Integer addressId = (Integer) session.getAttribute("addressId");
        String phone = (String) session.getAttribute("phone");
        String note = (String) session.getAttribute("note");
        Long shippingFee = (Long) session.getAttribute("shippingFee");
        if (shippingFee == null) shippingFee = 0L;
        String paymentMethod = req.getParameter("paymentMethod");
        if (paymentMethod == null) paymentMethod = "COD";
        if (items == null || items.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/shopping-cart.jsp");
            return;
        }
        try {
            long totalAmount = shippingFee;
            for (OrderItems item : items) {
                totalAmount += (long) item.getPrice() * item.getQuantity();
            }
            if ("VNPAY".equals(paymentMethod)) {
                String vnp_TxnRef = String.valueOf(System.currentTimeMillis());
                String vnp_IpAddr = getClientIp(req);
                Map<String, String> vnp_Params = new TreeMap<>();
                vnp_Params.put("vnp_Version", "2.1.0");
                vnp_Params.put("vnp_Command", "pay");
                vnp_Params.put("vnp_TmnCode", VnpayConfig.vnp_TmnCode);
                vnp_Params.put("vnp_Amount", String.valueOf(totalAmount * 100));
                vnp_Params.put("vnp_CurrCode", "VND");
                vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
                vnp_Params.put("vnp_OrderInfo", "Thanhtoandonhang" + vnp_TxnRef);
                vnp_Params.put("vnp_OrderType", "other");
                vnp_Params.put("vnp_Locale", "vn");
                vnp_Params.put("vnp_ReturnUrl", VnpayConfig.vnp_ReturnUrl);
                vnp_Params.put("vnp_IpAddr", vnp_IpAddr);
                Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
                SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMddHHmmss");
                fmt.setTimeZone(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
                vnp_Params.put("vnp_CreateDate", fmt.format(cld.getTime()));
                cld.add(Calendar.MINUTE, 15);
                vnp_Params.put("vnp_ExpireDate", fmt.format(cld.getTime()));
                StringBuilder hashData = new StringBuilder();
                StringBuilder queryString = new StringBuilder();
                List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
                Collections.sort(fieldNames);
                boolean first = true;
                for (String fieldName : fieldNames) {
                    String fieldValue = vnp_Params.get(fieldName);
                    if ((fieldValue != null) && (fieldValue.length() > 0)) {
                        if (!first) {
                            hashData.append('&');
                            queryString.append('&');
                        }
                        hashData.append(fieldName);
                        hashData.append('=');
                        hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                        queryString.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                        queryString.append('=');
                        queryString.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                        first = false;
                    }
                }
                String vnp_SecureHash = VnpayUtil.hmacSHA512(VnpayConfig.vnp_HashSecret, hashData.toString());
                String paymentUrl = VnpayConfig.vnp_PayUrl + "?" + queryString + "&vnp_SecureHash=" + vnp_SecureHash;
                resp.sendRedirect(paymentUrl);
                return;
            }
            Carts cart = (Carts) session.getAttribute("cart");
            OrderService orderService = new OrderService();
            int orderId = orderService.placeOrder(user, addressId, phone, note, paymentMethod, items, cart, shippingFee.doubleValue());
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
                                + "<p>Cảm ơn bạn đã đặt hàng tại <b>SkyDrone</b>. Đơn hàng <b>#" + finalOrderId + "</b> của bạn đã được ghi nhận thành công.</p>"
                                + "<p><b>Thông tin đơn hàng:</b></p>"
                                + "<ul>"
                                + "<li>Mã đơn hàng: <b>#" + finalOrderId + "</b></li>"
                                + "<li>Khách hàng: " + finalFullName + "</li>"
                                + "<li>Phương thức thanh toán: Thanh toán khi nhận hàng (COD)</li>"
                                + "<li>Trạng thái: Chờ xác nhận</li>"
                                + "</ul>"
                                + "<p><b>Danh sách sản phẩm:</b></p>"
                                + productTable
                                + "<p>Chúng tôi sẽ liên hệ xác nhận và giao hàng sớm nhất có thể.</p>"
                                + "<p>Trân trọng,<br>Đội ngũ SkyDrone</p>";
                        emailSender.sendOrderHtmlEmail(finalEmail, "[SkyDrone] Xác nhận đặt hàng #" + finalOrderId, htmlContent);
                    } catch (Exception mailEx) {
                        mailEx.printStackTrace();
                    }
                }).start();
            }
            if (cart != null) session.setAttribute("cart", cart);
            session.removeAttribute("BUY_NOW_ITEM");
            session.removeAttribute("note");
            resp.sendRedirect(req.getContextPath() + "/personal?tab=orders");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Payment failed", e);
        }
    }
    private String getClientIp(HttpServletRequest req) {
        String ip = req.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getRemoteAddr();
        }
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        if ("0:0:0:0:0:0:0:1".equals(ip) || "::1".equals(ip)) {
            ip = "127.0.0.1";
        }
        return ip;
    }
}