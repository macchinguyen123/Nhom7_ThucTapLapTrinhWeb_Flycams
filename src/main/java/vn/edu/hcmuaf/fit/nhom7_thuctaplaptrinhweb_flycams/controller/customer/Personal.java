package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Address;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.AddressService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.AuthService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.OrderService;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.Map;

@WebServlet(name = "Personal", value = "/personal")
public class Personal extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderService orderService = new OrderService();
        AddressService addressService = new AddressService();
        AuthService authService = new AuthService();
        long startTime = System.currentTimeMillis();
        HttpSession session = request.getSession();
        User sessionUser = (User) session.getAttribute("user");
        User user;
        String refresh = request.getParameter("refresh");

        if ("true".equals(refresh)) {
            user = sessionUser;
        } else {
            user = sessionUser;
        }

        request.setAttribute("user", user);
        long t2 = System.currentTimeMillis();
        List<Orders> orders = orderService.getOrdersByUser(user.getId());
        request.setAttribute("orders", orders);

        try {
            long t6 = System.currentTimeMillis();
            List<Address> addresses = addressService.findByUserId(user.getId());
            request.setAttribute("addresses", addresses);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        String orderIdParam = request.getParameter("orderId");
        Orders selectedOrder = null;
        List<OrderItems> orderItems = null;
        if (orderIdParam != null && !orderIdParam.isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdParam);

                long t3 = System.currentTimeMillis();
                selectedOrder = orderService.getOrderById(orderId, user.getId());
                if (selectedOrder != null) {
                    long t4 = System.currentTimeMillis();
                    orderItems = orderService.getOrderItems(orderId);
                    LocalDateTime created = selectedOrder.getCreatedAt()
                            .toInstant()
                            .atZone(ZoneId.systemDefault())
                            .toLocalDateTime();

                    LocalDateTime expected = created.plusDays(3);
                    Date expectedDate = Date.from(expected.atZone(ZoneId.systemDefault()).toInstant());
                    request.setAttribute("expectedDeliveryDate", expectedDate);
                    request.setAttribute("orderItems", orderItems);
                    long t5 = System.currentTimeMillis();
                    Map<String, String> shippingInfo = orderService.getShippingInfoByOrder(orderId);
                    request.setAttribute("shippingInfo", shippingInfo);
                    request.setAttribute("activeTab", "orders");
                }
            } catch (NumberFormatException e) {
            }
        }
        String tabParam = request.getParameter("tab");
        if ("orders".equals(tabParam)) {
            request.setAttribute("activeTab", "orders");
        } else if ("addresses".equals(tabParam)) {
            request.setAttribute("activeTab", "addresses");
        }
        request.setAttribute("selectedOrder", selectedOrder);
        long totalTime = System.currentTimeMillis() - startTime;
        request.getRequestDispatcher("/page/personal-page.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderService orderService = new OrderService();
        User user = (User) request.getSession().getAttribute("user");
        String action = request.getParameter("action");
        if ("cancelOrder".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                orderService.cancelOrder(orderId, user.getId());
                response.sendRedirect(request.getContextPath() + "/personal?tab=orders");
                return;
            } catch (NumberFormatException e) {
            }
        } else if ("returnOrder".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                boolean success = orderService.returnOrder(orderId, user.getId());
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/personal?tab=orders&message=Y%C3%AAu%20c%E1%BA%A7u%20tr%E1%BA%A3%20h%C3%A0ng%20th%C3%A0nh%20c%C3%B4ng&status=success");
                } else {
                    response.sendRedirect(request.getContextPath() + "/personal?tab=orders&message=Kh%C3%B4ng%20th%E1%BB%83%20tr%E1%BA%A3%20h%C3%A0ng&status=error");
                }
                return;
            } catch (NumberFormatException e) {
                System.err.println(" Return order failed: " + e.getMessage());
            }
        } else if ("undoReturnOrder".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                boolean success = orderService.undoReturnOrder(orderId, user.getId());
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/personal?tab=orders&message=Ho%C3%A0n%20t%C3%A1c%20tr%E1%BA%A3%20h%C3%A0ng%20th%C3%A0nh%20c%C3%B4ng&status=success");
                } else {
                    response.sendRedirect(request.getContextPath() + "/personal?tab=orders&message=Kh%C3%B4ng%20th%E1%BB%83%20ho%C3%A0n%20t%C3%A1c%20tr%E1%BA%A3%20h%C3%A0ng&status=error");
                }
                return;
            } catch (NumberFormatException e) {
                System.err.println(" Undo return order failed: " + e.getMessage());
            }
        } else if ("receiveOrder".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                boolean success = orderService.receiveOrder(orderId, user.getId());
                String message = success
                        ? "Xác nhận nhận hàng thành công"
                        : "Không thể xác nhận nhận hàng";
                String status = success ? "success" : "error";

                response.sendRedirect(request.getContextPath()
                        + "/personal?tab=orders"
                        + "&message=" + java.net.URLEncoder.encode(message, "UTF-8")
                        + "&status=" + status);
                return;
            } catch (NumberFormatException e) {
                System.err.println("Receive order failed: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/personal");
        }
    }
}