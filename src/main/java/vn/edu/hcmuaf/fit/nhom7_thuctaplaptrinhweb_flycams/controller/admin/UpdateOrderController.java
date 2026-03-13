package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.OrderService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
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

        String fullName = json.get("fullName").toString();
        String email = json.get("email").toString();
        String phoneNumber = json.get("phoneNumber").toString();
        String fullAddress = json.get("fullAddress").toString();
        String paymentMethod = json.get("paymentMethod").toString();
        String status = json.get("status").toString();
        String note = json.get("note").toString();
        //completedAt chỉ set khi giao thành công

        LocalDate completedAt = null;
        if ("Hoàn thành".equals(status)) {
            completedAt = LocalDate.now();
        }
        String[] addrParts = fullAddress.split(",");
        String addressLine = addrParts.length > 0 ? addrParts[0].trim() : "";
        String district = addrParts.length > 1 ? addrParts[1].trim() : "";
        String province = addrParts.length > 2 ? addrParts[2].trim() : "";

        OrderService orderService = new OrderService();
        boolean success = orderService.updateOrderFull(
                orderId,
                userId,
                fullName,
                email,
                phoneNumber,
                addressLine,
                province,
                district,
                paymentMethod,
                status,
                note,
                completedAt);

        Map<String, Object> res = new HashMap<>();
        res.put("success", success);

        mapper.writeValue(resp.getWriter(), res);
    }
}