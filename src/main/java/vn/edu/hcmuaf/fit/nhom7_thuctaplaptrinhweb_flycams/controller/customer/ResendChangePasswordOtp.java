package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.AuthService;

import java.io.IOException;

@WebServlet(name = "ResendChangePasswordOtp", value = "/ResendChangePasswordOtp")
public class ResendChangePasswordOtp extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/page/login.jsp");
            return;
        }
        User dbUser = authService.getUserByEmail(user.getEmail());
        if (dbUser == null) {
            response.sendRedirect(request.getContextPath() + "/personal?tab=repass");
            return;
        }
        try {
            String title = "Gửi lại mã OTP đổi mật khẩu - SKYDRONE";
            String content = "Mã OTP mới của bạn là";
            String thanks = "Vui lòng nhập mã OTP này để hoàn tất việc đổi mật khẩu.<br>" +
                    "<strong style='color: #dc3545;'>Lưu ý:</strong> Mã OTP có hiệu lực trong 5 phút.";
            String otp = authService.resendOtp(dbUser.getEmail(), dbUser.getUsername(), title, content, thanks);
            session.setAttribute("otp", otp);
            session.setMaxInactiveInterval(5 * 60);
            session.setAttribute("otpSent", true);
            response.setContentType("text/plain; charset=UTF-8");
            response.getWriter().write("success");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("error");
        }
    }
}