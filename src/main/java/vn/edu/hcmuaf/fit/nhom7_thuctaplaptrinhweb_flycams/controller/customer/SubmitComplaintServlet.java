package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.ComplaintDAO;

import java.io.IOException;

@WebServlet(name = "SubmitComplaintServlet", value = "/submit-complaint")
public class SubmitComplaintServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        if (userIdStr != null) {
            request.setAttribute("userId", userIdStr);
            request.getRequestDispatcher("/page/complaint.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/Login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        String content = request.getParameter("content");
        String evidence = request.getParameter("evidence");
        if (userIdStr != null && content != null && !content.trim().isEmpty()) {
            if (evidence != null && !evidence.trim().isEmpty()) {
                content = content + "\n\nMinh chứng: " + evidence.trim();
            }
            try {
                int userId = Integer.parseInt(userIdStr);
                ComplaintDAO dao = new ComplaintDAO();
                boolean success = dao.createComplaint(userId, content);
                if (success) {
                    request.setAttribute("message", "Yêu cầu xem xét tài khoản. Vui lòng cung cấp chi tiết lý do và minh chứng nếu có. Gửi khiếu nại thành công! Chúng tôi sẽ xem xét sớm nhất.");
                    request.setAttribute("messageType", "success");
                } else {
                    request.setAttribute("message", "Có lỗi xảy ra, vui lòng thử lại sau.");
                    request.setAttribute("messageType", "error");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("message", "ID người dùng không hợp lệ.");
                request.setAttribute("messageType", "error");
            }
        } else {
            request.setAttribute("message", "Vui lòng nhập nội dung khiếu nại.");
            request.setAttribute("messageType", "error");
        }
        request.setAttribute("userId", userIdStr);
        request.getRequestDispatcher("/page/complaint.jsp").forward(request, response);
    }
}
