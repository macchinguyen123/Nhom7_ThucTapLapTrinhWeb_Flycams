package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.MailProperties.EmailSender;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.AuthService;

import java.io.IOException;

@WebServlet(name = "SendOtpChangePassword", value = "/SendOtpChangePassword")
public class SendOtpChangePassword extends HttpServlet {
    private final AuthService userDAO = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/page/login.jsp");
            return;
        }
        User dbUser = userDAO.getUserByEmail(currentUser.getEmail());
        if (dbUser == null) {
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Không tìm thấy thông tin người dùng!\"}");
            return;
        }
        try {
            String otp = String.valueOf((int) (Math.random() * 9000) + 1000);
            session.setAttribute("otp", otp);
            session.setAttribute("otpUserId", dbUser.getId());
            session.setAttribute("otpTime", System.currentTimeMillis());
            session.setMaxInactiveInterval(5 * 60); // 5 phút
            EmailSender emailSender = new EmailSender();
            String title = "Xác nhận đổi mật khẩu - SKYDRONE";
            String content = "Bạn đang thực hiện thay đổi mật khẩu tài khoản. Mã OTP của bạn là";
            String thanks = "Vui lòng nhập mã OTP này để hoàn tất việc đổi mật khẩu.<br>" +
                    "<strong style='color: #dc3545;'>Lưu ý:</strong> Mã OTP có hiệu lực trong 5 phút.";

            String otpHtml = "<div style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);" +
                    "padding: 25px; border-radius: 12px; text-align: center; margin: 20px 0;" +
                    "box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);'>" +
                    "<h1 style='color: #ffffff; font-size: 56px; margin: 0;" +
                    "letter-spacing: 12px; font-weight: 700;'>" +
                    otp +
                    "</h1></div>";
            emailSender.sendVerificationEmail(
                    dbUser.getEmail(),
                    title,
                    dbUser.getUsername(),
                    otpHtml,
                    content,
                    thanks);
            session.setAttribute("otpSent", true);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"ok\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\":\"error\"}");
        }
    }
}
