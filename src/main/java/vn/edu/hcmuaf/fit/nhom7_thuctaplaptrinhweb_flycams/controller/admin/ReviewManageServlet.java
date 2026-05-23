package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Reviews;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.ReviewService;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "ReviewManageServlet", value = "/admin/review-manage")
public class ReviewManageServlet extends HttpServlet {
    private ReviewService reviewService;
    @Override
    public void init() {
        reviewService = new ReviewService();
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("countPending".equalsIgnoreCase(action)) {
            resp.setContentType("application/json;charset=UTF-8");
            List<Reviews> badReviews = reviewService.getAllBadReviews();
            long count = badReviews.stream()
                    .filter(r -> r.getStatus() == null || "PENDING".equalsIgnoreCase(r.getStatus()))
                    .count();
            resp.getWriter().write("{\"count\":" + count + "}");
            return;
        }

        List<Reviews> badReviews = reviewService.getAllBadReviews();
        List<Reviews> badReviewsPending = badReviews.stream() .filter(r -> r.getStatus() == null || "PENDING".equalsIgnoreCase(r.getStatus()))
.collect(Collectors.toList());
        req.setAttribute("badReviews", badReviews);
        req.setAttribute("badReviewsPending", badReviewsPending);
        req.getRequestDispatcher("/page/admin/review-manage.jsp")
.forward(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");
        String action = req.getParameter("action");
        String idRaw = req.getParameter("id");
        String adminNote = req.getParameter("adminNote");
        if (idRaw == null || action == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Thiếu thông tin yêu cầu.\"}");
            return;
        }
        try {
            int id = Integer.parseInt(idRaw);
            String status;
            if ("keep".equalsIgnoreCase(action)) {
                status = "KEPT";
            } else if ("delete".equalsIgnoreCase(action)) {
                status = "DELETED";
            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"status\":\"error\",\"message\":\"Hành động không hợp lệ.\"}");
                return;
            }
            boolean success = reviewService.updateReviewStatus(id, status, adminNote);
            if (success) {
                resp.getWriter().write("{\"status\":\"success\",\"message\":\"Cập nhật đánh giá thành công!\"}");
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("{\"status\":\"error\",\"message\":\"Không tìm thấy đánh giá hoặc lỗi cập nhật.\"}");
            }
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Mã đánh giá không hợp lệ.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Đã xảy ra lỗi hệ thống.\"}");
        }
    }
}