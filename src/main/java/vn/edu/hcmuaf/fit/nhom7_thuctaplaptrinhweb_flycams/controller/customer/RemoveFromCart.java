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

@WebServlet(name = "RemoveFromCart", value = "/RemoveFromCart")
public class RemoveFromCart extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        Carts cart = (Carts) session.getAttribute("cart");
        if (cart == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int productId = Integer.parseInt(request.getParameter("productId"));

        vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User user = (vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User) session.getAttribute("user");
        Integer userId = (user != null) ? user.getId() : null;
        CartService cartService = new CartService();
        cartService.removeFromCart(cart, productId, userId);

        session.setAttribute("cart", cart);

        Integer unviewedCount = (Integer) session.getAttribute("unviewedCartCount");
        if (unviewedCount == null) unviewedCount = 0;
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"success\":true,\"cartSize\":" + unviewedCount + "}");
        response.setStatus(HttpServletResponse.SC_OK);
    }
}