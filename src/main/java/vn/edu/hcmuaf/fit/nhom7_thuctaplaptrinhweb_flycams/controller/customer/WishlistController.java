package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.WishlistService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.PriceFormatter;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "Wishlist", value = "/wishlist")
public class WishlistController extends HttpServlet {
    private final WishlistService wishlistService = new WishlistService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user != null) {
            List<Product> products = wishlistService.getWishlistProducts(user.getId());
            request.setAttribute("products", products);
        } else {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        request.setAttribute("formatter", new PriceFormatter());
        request.getRequestDispatcher("/page/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        response.setContentType("application/json;charset=UTF-8");
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\":false,\"message\":\"NOT_LOGIN\"}");
            return;
        }
        String action = request.getParameter("action");
        if (action == null || action.isBlank()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"ACTION_NULL\"}");
            return;
        }
        boolean success = false;
        switch (action) {
            case "add":
            case "remove":
            case "toggle": {
                String productIdRaw = request.getParameter("productId");

                if (productIdRaw == null || productIdRaw.isBlank()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"success\":false,\"message\":\"PRODUCT_ID_NULL\"}");
                    return;
                }

                int productId;
                try {
                    productId = Integer.parseInt(productIdRaw);
                } catch (NumberFormatException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"success\":false,\"message\":\"PRODUCT_ID_INVALID\"}");
                    return;
                }
                switch (action) {
                    case "add":
                        success = wishlistService.add(user.getId(), productId);
                        break;
                    case "remove":
                        success = wishlistService.remove(user.getId(), productId);
                        break;
                    case "toggle":
                        success = wishlistService.toggleWishlist(user.getId(), productId);
                        break;
                }
                break;
            }
            case "removeSelected": {
                String idsRaw = request.getParameter("productIds"); // chuỗi CSV từ JS

                if (idsRaw != null && !idsRaw.isBlank()) {
                    String[] arr = idsRaw.split(",");
                    success = true;
                    for (String idStr : arr) {
                        try {
                            int id = Integer.parseInt(idStr.trim());
                            boolean removed = wishlistService.remove(user.getId(), id);
                            if (!removed)
                                success = false; // nếu có cái nào xóa fail thì báo fail
                        } catch (NumberFormatException e) {
                            success = false;
                        }
                    }
                } else {
                    success = false;
                }
                break;
            }
            default:
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\":false,\"message\":\"ACTION_INVALID\"}");
                return;
        }
        response.getWriter().write("{\"success\":" + success + "}");
    }

}
