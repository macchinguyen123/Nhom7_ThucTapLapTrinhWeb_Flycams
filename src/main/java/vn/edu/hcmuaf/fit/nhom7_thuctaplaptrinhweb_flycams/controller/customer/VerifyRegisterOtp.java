package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;

import java.io.IOException;

@WebServlet(name = "VerifyRegisterOtp", value = "/VerifyRegisterOtp")
public class VerifyRegisterOtp extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/page/register.jsp");
            return;
        }
        String otpInput = request.getParameter("otp");
        String otpSession = (String) session.getAttribute("registerOtp");
        Long otpExpire = (Long) session.getAttribute("registerOtpExpire");
        User user = (User) session.getAttribute("registerUser");
        if (otpSession == null || otpExpire == null || user == null) {
            request.setAttribute("error", "Phiên xác thực không hợp lệ. Vui lòng đăng ký lại.");
            request.getRequestDispatcher("/page/otp.jsp").forward(request, response);
            return;
        }
        if (System.currentTimeMillis() > otpExpire) {
            request.setAttribute("error", "Mã OTP đã hết hạn. Vui lòng gửi lại mã.");
            request.getRequestDispatcher("/page/otp.jsp").forward(request, response);
            return;
        }
        if (!otpSession.equals(otpInput)) {
            request.setAttribute("error", "Mã OTP không chính xác!");
            request.getRequestDispatcher("/page/otp.jsp").forward(request, response);
            return;
        }
        userDAO.insertUser(user);
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/page/register-success.jsp");
    }

}