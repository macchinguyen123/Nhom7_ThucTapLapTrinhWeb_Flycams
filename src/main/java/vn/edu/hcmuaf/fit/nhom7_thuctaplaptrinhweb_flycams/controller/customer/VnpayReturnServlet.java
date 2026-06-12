package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.OrderService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.VnpayConfig;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.VnpayUtil;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

@WebServlet("/VnpayReturnServlet")
public class VnpayReturnServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String responseCode = request.getParameter("vnp_ResponseCode");
        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");
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
        boolean signatureValid = signValue.equalsIgnoreCase(vnp_SecureHash);

        if ("00".equals(responseCode) && signatureValid) {
            if (vnp_TxnRef != null && !vnp_TxnRef.isEmpty()) {
                try {
                    OrderService orderService = new OrderService();
                    orderService.confirmVnpayPayment(vnp_TxnRef);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            session.removeAttribute("BUY_NOW_ITEM");
            session.removeAttribute("note");
            session.removeAttribute("vnp_TxnRef");
            session.setAttribute("paymentSuccess", "Thanh toán thành công! Đơn hàng của bạn đã được xác nhận.");
            response.sendRedirect(request.getContextPath() + "/personal?tab=orders");

        } else {
            String errorMessage;
            if (!signatureValid) {
                errorMessage = "Chữ ký không hợp lệ! Vui lòng không thay đổi tham số trên URL.";
            } else {
                errorMessage = "Thanh toán thất bại! Mã lỗi: " + responseCode;
            }
            session.setAttribute("paymentError", errorMessage);
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}