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

@WebServlet(name = "ChangePassword", value = "/ChangePassword")
public class ChangePasswordController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/page/login.jsp");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm");
        String otpInput = request.getParameter("otp");
        String otpSession = (String) session.getAttribute("otp");

        AuthService authService = new AuthService();
        String error = authService.changePassword(
                currentUser.getId(),
                currentUser.getEmail(),
                currentPassword,
                newPassword,
                confirmPassword,
                otpSession,
                otpInput);

        if (error != null) {
            request.setAttribute("error", error);
            request.getRequestDispatcher("page/personal-page.jsp").forward(request, response);
            return;
        }

        session.removeAttribute("otp");
        session.removeAttribute("otpSent");
        session.setAttribute("success", "Đổi mật khẩu thành công!");
        response.sendRedirect(request.getContextPath() + "/personal");
    }
}