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
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.VnpayConfig;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.VnpayUtil;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
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
        String phone    = (String) session.getAttribute("phone");
        String note     = (String) session.getAttribute("note");
        String paymentMethod = req.getParameter("paymentMethod");
        if (paymentMethod == null) paymentMethod = "COD";
        if (items == null || items.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/shopping-cart.jsp");
            return;
        }
        try {
            long total = 0;
            for (OrderItems item : items) {
                total += (long) item.getPrice() * item.getQuantity();
            }
            if ("VNPAY".equals(paymentMethod)) {
                String vnp_TxnRef   = String.valueOf(System.currentTimeMillis());
                String vnp_IpAddr   = getClientIp(req);
                Map<String, String> vnp_Params = new TreeMap<>();
                vnp_Params.put("vnp_Version",   "2.1.0");
                vnp_Params.put("vnp_Command",    "pay");
                vnp_Params.put("vnp_TmnCode",    VnpayConfig.vnp_TmnCode);
                vnp_Params.put("vnp_Amount",     String.valueOf(total * 100));
                vnp_Params.put("vnp_CurrCode",   "VND");
                vnp_Params.put("vnp_TxnRef",     vnp_TxnRef);
                vnp_Params.put("vnp_OrderInfo",  "Thanh toan don hang " + vnp_TxnRef);
                vnp_Params.put("vnp_OrderType",  "other");
                vnp_Params.put("vnp_Locale",     "vn");
                vnp_Params.put("vnp_ReturnUrl",  VnpayConfig.vnp_ReturnUrl);
                vnp_Params.put("vnp_IpAddr",     vnp_IpAddr);
                Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
                SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMddHHmmss");
                vnp_Params.put("vnp_CreateDate", fmt.format(cld.getTime()));
                cld.add(Calendar.MINUTE, 15);
                vnp_Params.put("vnp_ExpireDate", fmt.format(cld.getTime()));
                StringBuilder hashData    = new StringBuilder();
                StringBuilder queryString = new StringBuilder();
                boolean first = true;
                for (Map.Entry<String, String> entry : vnp_Params.entrySet()) {
                    String key   = entry.getKey();
                    String value = entry.getValue();
                    if (value == null || value.isEmpty()) continue;
                    if (!first) {
                        hashData.append('&');
                        queryString.append('&');
                    }
                    first = false;
                    hashData.append(key).append('=').append(value);
                    queryString.append(URLEncoder.encode(key, StandardCharsets.UTF_8.name()))
                            .append('=')
                            .append(URLEncoder.encode(value, StandardCharsets.UTF_8.name()));
                }
                String vnp_SecureHash = VnpayUtil.hmacSHA512(
                        VnpayConfig.vnp_HashSecret,
                        hashData.toString()
                );
                String paymentUrl = VnpayConfig.vnp_PayUrl
                        + "?" + queryString
                        + "&vnp_SecureHash=" + vnp_SecureHash;
                resp.sendRedirect(paymentUrl);
                return;
            }
            Carts cart = (Carts) session.getAttribute("cart");
            OrderService orderService = new OrderService();
            orderService.placeOrder(user, addressId, phone, note, paymentMethod, items, cart);
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
        return ip;
    }
}