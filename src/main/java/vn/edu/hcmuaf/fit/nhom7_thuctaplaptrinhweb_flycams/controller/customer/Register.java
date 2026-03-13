package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.AuthService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.validate.Validator;

import java.io.IOException;
import java.sql.Date;

@WebServlet(name = "Register", value = "/Register")

public class Register extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("page/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm");
        String phone = request.getParameter("phoneNumber");
        String birthdayStr = request.getParameter("birthday");
        boolean hasError = false;
        Date birthday = null;
        try {
            birthday = Date.valueOf(birthdayStr);
        } catch (Exception e) {
            request.setAttribute("birthdayError", "Ngày sinh không hợp lệ");
            hasError = true;
        }
        if (Validator.isEmpty(fullName)) {
            request.setAttribute("fullNameError", "Họ tên không được để trống");
            hasError = true;
        }
        if (!Validator.isValidEmail(email)) {
            request.setAttribute("emailError", "Email không hợp lệ");
            hasError = true;
        }
        if (Validator.containsWhitespace(username)) {
            request.setAttribute("usernameError", "Username không được chứa khoảng trắng");
            hasError = true;
        } else if (Validator.isEmpty(username)) {
            request.setAttribute("usernameError", "Username không được để trống");
            hasError = true;
        }
        if (!Validator.isValidPassword(password)) {
            request.setAttribute("passwordError",
                    "Mật khẩu phải có chữ hoa, chữ thường, số và ký tự đặc biệt");
            hasError = true;
        }
        if (!password.equals(confirmPassword)) {
            request.setAttribute("confirmPasswordError", "Mật khẩu nhập lại không khớp");
            hasError = true;
        }
        if (!Validator.isValidPhoneNumber(phone)) {
            request.setAttribute("phoneError", "Số điện thoại không đúng định dạng");
            hasError = true;
        }
        if (authService.isPhoneNumberExists(phone)) {
            request.setAttribute("phoneError", "Số điện thoại đã tồn tại trong hệ thống");
            hasError = true;
        }
        if (authService.isEmailExists(email)) {
            request.setAttribute("emailError", "Email đã tồn tại");
            hasError = true;
        }
        if (authService.isUsernameExists(username)) {
            request.setAttribute("usernameError", "Username đã tồn tại");
            hasError = true;
        }
        if (hasError) {
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("username", username);
            request.setAttribute("phoneNumber", phone);
            request.getRequestDispatcher("page/register.jsp").forward(request, response);
            return;
        }
        AuthService.RegisterDTO registerData = authService.prepareRegister(
                fullName, email, username, password, phone, birthday);
        HttpSession session = request.getSession();
        session.setAttribute("registerUser", registerData.getUser());
        session.setAttribute("registerOtp", registerData.getOtp());
        session.setAttribute("registerOtpTime", System.currentTimeMillis());
        session.setAttribute("registerOtpExpire", registerData.getExpireTime());
        response.sendRedirect("page/otp.jsp");
    }

}
