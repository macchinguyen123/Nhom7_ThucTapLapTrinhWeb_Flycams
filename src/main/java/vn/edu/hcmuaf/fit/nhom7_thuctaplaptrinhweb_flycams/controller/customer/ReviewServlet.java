package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.OrderService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.ReviewService;

import java.io.IOException;

@WebServlet(name = "ReviewServlet", value = "/ReviewServlet")
public class ReviewServlet extends HttpServlet {
    private ReviewService reviewService = new ReviewService();
    private OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        User user = (User) request.getSession().getAttribute("user");
        System.out.println("[Servlet] user = " + user);

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\":\"login_required\",\"message\":\"Bạn cần đăng nhập để đánh giá\"}");
            return;
        }
        try {
            String productIdRaw = request.getParameter("product_id");
            String ratingRaw = request.getParameter("rating");
            String content = request.getParameter("content");
            System.out.println("[Servlet] product_id = " + productIdRaw);
            System.out.println("[Servlet] rating     = " + ratingRaw);
            System.out.println("[Servlet] content    = " + content);
            if (productIdRaw == null || ratingRaw == null || content == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Thiếu thông tin\"}");
                return;
            }
            int productId = Integer.parseInt(productIdRaw);
            int rating = Integer.parseInt(ratingRaw);
            if (!orderService.hasUserPurchasedProduct(user.getId(), productId)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter()
                        .write("{\"status\":\"error\",\"message\":\"Bạn chỉ có thể đánh giá sản phẩm đã mua\"}");
                return;
            }
            if (reviewService.hasUserReviewedProduct(user.getId(), productId)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Bạn đã đánh giá sản phẩm này rồi\"}");
                return;
            }

            reviewService.saveReview(user.getId(), productId, rating, content);
            double avg = reviewService.getAverageRating(productId);
            int count = reviewService.countReviews(productId);
            response.getWriter().write(
                    "{\"status\":\"success\"," +
                            "\"message\":\"Cảm ơn bạn đã đánh giá!\"," +
                            "\"avg\":" + String.format("%.1f", avg) +
                            ",\"count\":" + count + "}");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Dữ liệu không hợp lệ\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Lỗi server\"}");
        }
    }
}