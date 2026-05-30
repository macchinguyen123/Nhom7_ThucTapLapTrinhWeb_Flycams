package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.OrderService;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "OrderActionServlet", value = "/admin/order-action")
public class OrderActionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    private OrderService orderService = new OrderService();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            // Đảm bảo encoding đúng
            req.setCharacterEncoding("UTF-8");
            String action = req.getParameter("action");
            if (action == null || action.trim().isEmpty()) {
                Map<String, Object> error = new HashMap<>();
                error.put("success", false);
                error.put("message", "Missing action parameter");
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().print(new Gson().toJson(error));
                return;
            }
            // Xử lý thao tác hàng loạt
            if (action.startsWith("batch-")) {
                String idsStr = req.getParameter("ids");
                if (idsStr == null || idsStr.trim().isEmpty()) {
                    Map<String, Object> error = new HashMap<>();
                    error.put("success", false);
                    error.put("message", "Missing order ids");
                    resp.setContentType("application/json;charset=UTF-8");
                    resp.getWriter().print(new Gson().toJson(error));
                    return;
                }
                String[] ids = idsStr.split(",");
                boolean overallSuccess = true;
                if ("batch-confirm".equals(action)) {
                    for (String id : ids) {
                        if (!id.trim().isEmpty()) {
                            overallSuccess &= orderService.confirmOrder(Integer.parseInt(id.trim()));
                        }
                    }
                } else if ("batch-cancel".equals(action)) {
                    String note = req.getParameter("note");
                    for (String id : ids) {
                        if (!id.trim().isEmpty()) {
                            int oid = Integer.parseInt(id.trim());
                            boolean s = false;
                            if (note != null && !note.isEmpty()) {
                                s = orderService.updateOrderStatusAndNote(oid, "Hủy", note);
                            } else {
                                s = orderService.updateOrderStatus(oid, "Hủy");
                            }
                            overallSuccess &= s;
                            // Gửi email
                            if (s) {
                                Map<String, Object> orderDetail = orderService.getOrderDetailAdmin(oid);
                                if (orderDetail != null) {
                                    String fullName = (String) orderDetail.get("customerName");
                                    String email = (String) orderDetail.get("email");
                                    String paymentMethod = (String) orderDetail.get("paymentMethod");
                                    orderService.sendStatusChangeEmail(oid, "Hủy", fullName, email, paymentMethod, note);
                                }
                            }
                        }
                    }
                }
                Map<String, Object> result = new HashMap<>();
                result.put("success", overallSuccess);
                result.put("status", "batch-processed");
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().print(new Gson().toJson(result));
                return;
            }
            // Xử lý thao tác đơn lẻ
            String idStr = req.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                Map<String, Object> error = new HashMap<>();
                error.put("success", false);
                error.put("message", "Missing order id");
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().print(new Gson().toJson(error));
                return;
            }
            int orderId = Integer.parseInt(idStr);
            boolean success = false;
            String newStatus = null;
            if ("confirm".equals(action)) {
                newStatus = "Đang xử lý";
                success = orderService.confirmOrder(orderId);
            } else if ("cancel".equals(action)) {
                newStatus = "Hủy";
                String note = req.getParameter("note");
                if (note != null && !note.isEmpty()) {
                    success = orderService.updateOrderStatusAndNote(orderId, newStatus, note);
                } else {
                    success = orderService.updateOrderStatus(orderId, newStatus);
                }
                // Gửi email thông báo hủy
                if (success) {
                    Map<String, Object> orderDetail = orderService.getOrderDetailAdmin(orderId);
                    if (orderDetail != null) {
                        String fullName = (String) orderDetail.get("customerName");
                        String email = (String) orderDetail.get("email");
                        String paymentMethod = (String) orderDetail.get("paymentMethod");
                        orderService.sendStatusChangeEmail(orderId, newStatus, fullName, email, paymentMethod, note);
                    }
                }
            } else if ("restore".equals(action)) {
                newStatus = "Xác nhận";
                success = orderService.updateOrderStatus(orderId, newStatus);
            }
            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("status", newStatus);
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().print(new Gson().toJson(result));
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", e.getMessage());
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().print(new Gson().toJson(error));
        }
    }
}