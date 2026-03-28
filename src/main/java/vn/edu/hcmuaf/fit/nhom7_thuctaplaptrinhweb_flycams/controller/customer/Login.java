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

@WebServlet(name = "Login", value = "/Login")
public class Login extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/page/login.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String input = request.getParameter("loginInput");
        String password = request.getParameter("password");
        boolean isPossibleEmail = input.contains("@");
        boolean isPossiblePhone = input.matches("\\d+");

        if (isPossibleEmail) {
            if (!vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.validate.Validator.isValidEmail(input)) {
                request.setAttribute("error", "Email không đúng định dạng. Vui lòng kiểm tra lại.");
                request.getRequestDispatcher("/page/login.jsp").forward(request, response);
                return;
            }
        } else if (isPossiblePhone) {
            if (!vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.validate.Validator.isValidPhoneNumber(input)) {
                request.setAttribute("error", "Số điện thoại không đúng định dạng. Vui lòng kiểm tra lại.");
                request.getRequestDispatcher("/page/login.jsp").forward(request, response);
                return;
            }
        } else {
            request.setAttribute("error", "Vui lòng nhập đúng định dạng Email hoặc Số điện thoại.");
            request.getRequestDispatcher("/page/login.jsp").forward(request, response);
            return;
        }

        AuthService authService = new AuthService();
        User user = authService.login(input, password);
        if (user == null) {
            String msg = "Thông tin đăng nhập chưa hợp lệ";
            request.setAttribute("error", msg);
            request.getRequestDispatcher("/page/login.jsp").forward(request, response);
            return;
        }
        if (!user.isStatus()) {
            String reason = user.getLockReason() != null ? user.getLockReason() : "Vi phạm chính sách.";
            request.setAttribute("lockedError", "Tài khoản bạn đã bị khoá");
            request.setAttribute("lockReason", reason);
            request.setAttribute("lockedUserId", user.getId());
            request.getRequestDispatcher("/page/login.jsp").forward(request, response);
            return;
        }
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        response.sendRedirect(request.getContextPath() + "/home");
    }
}