package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Address;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.AddressService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.CartService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "BuyNowFromCartServlet", value = "/BuyNowFromCart")
public class BuyNowFromCartServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        // Check login
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }
        User user = (User) session.getAttribute("user");
        List<OrderItems> buyNowItems;
        CartService cartService = new CartService();
        String orderIdParam = req.getParameter("orderId");
        if (orderIdParam != null && !orderIdParam.isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdParam);
                buyNowItems = cartService.prepareBuyNowFromOrder(orderId, user.getId());
                if (buyNowItems.isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/purchase-history");
                    return;
                }
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/purchase-history");
                return;
            }
        } else {
            String[] productIds = req.getParameterValues("productId");
            String[] quantities = req.getParameterValues("quantities");
            if (productIds == null || quantities == null) {
                resp.sendRedirect(req.getContextPath() + "/page/shoppingcart.jsp");
                return;
            }
            buyNowItems = cartService.prepareBuyNowFromSelection(productIds, quantities);
        }

        if (buyNowItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/page/shoppingcart.jsp");
            return;
        }

        session.setAttribute("BUY_NOW_ITEM", buyNowItems);

        AddressService addressService = new AddressService();
        List<Address> addresses = null;
        try {
            addresses = addressService.findByUserId(user.getId());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        req.setAttribute("addresses", addresses);

        req.getRequestDispatcher("/page/delivery-info.jsp")
                .forward(req, resp);
    }
}