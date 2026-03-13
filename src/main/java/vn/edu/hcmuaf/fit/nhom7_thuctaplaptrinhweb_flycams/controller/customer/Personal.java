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
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");
        System.out.println(" PERSONAL PAGE - USER ID: " + sessionUser.getId());
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
        System.out
                .println("️ getOrdersByUser: " + (System.currentTimeMillis() - t2) + "ms | Orders: " + orders.size());
        request.setAttribute("orders", orders);

        try {
            long t6 = System.currentTimeMillis();
            List<Address> addresses = addressService.findByUserId(user.getId());
            System.out.println(" getAddressesByUserId: " + (System.currentTimeMillis() - t6) + "ms | Addresses: "
                    + addresses.size());
            request.setAttribute("addresses", addresses);
        } catch (SQLException e) {
            System.err.println(" Error loading addresses: " + e.getMessage());
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
                System.out.println("️ getOrderById: " + (System.currentTimeMillis() - t3) + "ms");

                if (selectedOrder != null) {
                    long t4 = System.currentTimeMillis();
                    orderItems = orderService.getOrderItems(orderId);
                    System.out.println(" getOrderItems: " + (System.currentTimeMillis() - t4) + "ms | Items: "
                            + orderItems.size());
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
                    System.out.println(" getShippingInfo: " + (System.currentTimeMillis() - t5) + "ms");
                    request.setAttribute("shippingInfo", shippingInfo);
                    request.setAttribute("activeTab", "orders");
                }
            } catch (NumberFormatException e) {
                System.err.println(" Invalid orderId: " + orderIdParam);
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
        System.out.println(" TOTAL SERVLET TIME: " + totalTime + "ms\n");
        request.getRequestDispatcher("/page/personal-page.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderService orderService = new OrderService();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        if ("cancelOrder".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                orderService.cancelOrder(orderId, user.getId());
                System.out.println(" Order #" + orderId + " cancelled by user #" + user.getId());
                response.sendRedirect(request.getContextPath() + "/personal?tab=orders");
                return;

            } catch (NumberFormatException e) {
                System.err.println(" Cancel order failed: " + e.getMessage());
            }
        }
        response.sendRedirect(request.getContextPath() + "/personal");
    }
}