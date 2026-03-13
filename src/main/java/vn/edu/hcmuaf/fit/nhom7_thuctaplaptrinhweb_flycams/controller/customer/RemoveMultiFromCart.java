package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.cart.Carts;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.CartService;

import java.io.IOException;

@WebServlet(name = "RemoveMultiFromCart", value = "/RemoveMultiFromCart")
public class RemoveMultiFromCart extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null)
            return;
        Carts cart = (Carts) session.getAttribute("cart");
        if (cart == null)
            return;
        String[] ids = request.getParameterValues("productIds[]");
        CartService cartService = new CartService();
        cartService.removeMultiFromCart(cart, ids);
        session.setAttribute("cart", cart);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"success\":true,\"cartSize\":" + cart.totalQuantity() + "}");
        response.setStatus(HttpServletResponse.SC_OK);
    }
}