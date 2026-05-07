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

@WebServlet(name = "AddCart", value = "/add-cart")
public class AddCart extends HttpServlet {
    private final CartService cartService = new CartService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        response.setContentType("application/json;charset=UTF-8");
        try {
            String pid = request.getParameter("productId");
            String quantityStr = request.getParameter("quantity");
            if (pid == null || pid.isEmpty()) {
                response.getWriter().write("{\"success\":false,\"message\":\"Thiếu ID sản phẩm\"}");
                return;
            }
            int productId = Integer.parseInt(pid);
            int quantity = 1;
            if (quantityStr != null && !quantityStr.isEmpty()) {
                quantity = Integer.parseInt(quantityStr);
            }
            vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User user = (vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User) session.getAttribute("user");
            if (user == null) {
                response.getWriter().write("{\"success\":false,\"needLogin\":true,\"message\":\"Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng\"}");
                return;
            }
            Integer userId = user.getId();
            Carts cart = (Carts) session.getAttribute("cart");
            if (cart == null) cart = new Carts();

            boolean added = cartService.addToCart(cart, productId, quantity, userId);
            if (added) {
                // Tăng số lượng sản phẩm chưa xem trong session
                Integer unviewedCount = (Integer) session.getAttribute("unviewedCartCount");
                if (unviewedCount == null) unviewedCount = 0;
                unviewedCount += 1;
                session.setAttribute("unviewedCartCount", unviewedCount);
                session.setAttribute("cart", cart);
                response.getWriter().write("{\"success\":true,\"totalQuantity\":" + unviewedCount + "}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"Sản phẩm không tồn tại\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"message\":\"Lỗi server: " + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}