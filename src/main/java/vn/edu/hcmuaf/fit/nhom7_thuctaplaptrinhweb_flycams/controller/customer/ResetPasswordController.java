package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.AuthService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.LoginAttemptService;

import java.io.IOException;

@WebServlet(name = "ResetPassword", value = "/ResetPassword")
public class ResetPasswordController extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm");
        boolean hasError = false;
        if (password == null || password.length() < 8) {
            request.setAttribute("passwordError", "Mật khẩu ít nhất 8 ký tự");
            hasError = true;
        } else if (!password.matches(".*[A-Z].*")) {
            request.setAttribute("passwordError", "Mật khẩu thiếu chữ hoa");
            hasError = true;
        } else if (!password.matches(".*[a-z].*")) {
            request.setAttribute("passwordError", "Mật khẩu thiếu chữ thường");
            hasError = true;
        } else if (!password.matches(".*\\d.*")) {
            request.setAttribute("passwordError", "Mật khẩu thiếu số");
            hasError = true;
        } else if (!password.matches(".*[\\W_].*")) {
            request.setAttribute("passwordError", "Mật khẩu thiếu ký đặc biệt");
            hasError = true;
        }
        if (!password.equals(confirm)) {
            request.setAttribute("confirmPasswordError", "Mật khẩu nhập lại không khớp");
            hasError = true;
        }
        if (hasError) {
            request.getRequestDispatcher("/page/create-new-password.jsp").forward(request, response);
            return;
        }
        if (email != null) {
            boolean updated = authService.resetPassword(email, password);
            if (updated) {
                LoginAttemptService.successAttempt(email);
                response.sendRedirect(request.getContextPath() + "/page/login.jsp?resetSuccess=1");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật mật khẩu hoặc không tìm thấy tài khoản!");
                request.getRequestDispatcher("/page/create-new-password.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Session hết hạn hoặc không tìm thấy email!");
            request.getRequestDispatcher("/page/create-new-password.jsp").forward(request, response);
        }
    }
}
