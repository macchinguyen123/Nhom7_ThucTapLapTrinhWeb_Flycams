package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.AuthService;

import java.io.IOException;

@WebServlet(name = "ForgotPassword", value = "/ForgotPassword")
public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        AuthService authService = new AuthService();
        String otp = authService.forgotPassword(email);

        if (otp == null) {
            request.setAttribute("message", "Email không tồn tại trong hệ thống!");
            request.getRequestDispatcher("/page/forgot-password.jsp").forward(request, response);
            return;
        }
        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("email", email);
        session.setMaxInactiveInterval(5 * 60);

        request.setAttribute("message", "OTP đã được gửi về email của bạn!");
        request.getRequestDispatcher("/page/otp-forgot-password.jsp").forward(request, response);
    }
}
