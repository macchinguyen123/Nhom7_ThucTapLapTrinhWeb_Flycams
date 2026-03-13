package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.CartService;

import java.io.IOException;
import java.util.List;

@WebServlet("/rebuy")
public class ReBuyController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        CartService cartService = new CartService();
        String orderIdRaw = req.getParameter("orderId");
        if (orderIdRaw == null || orderIdRaw.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/purchasehistory");
            return;
        }
        int orderId;
        try {
            orderId = Integer.parseInt(orderIdRaw);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/purchasehistory");
            return;
        }
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        List<OrderItems> items = cartService.prepareBuyNowFromOrder(orderId, user.getId());
        if (items == null || items.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/purchasehistory");
            return;
        }
        session.setAttribute("BUY_NOW_ITEM", items);
        resp.sendRedirect(req.getContextPath() + "/page/delivery-info.jsp");
    }
}
