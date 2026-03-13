package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "VerifyOtp", value = "/VerifyOtp")
public class VerifyOtpController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String otpInput = request.getParameter("otp");
        HttpSession session = request.getSession();
        String otpSession = (String) session.getAttribute("otp");
        if (otpSession != null && otpSession.equals(otpInput)) {
            request.getRequestDispatcher("/page/create-new-password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Mã OTP không đúng!");
            request.getRequestDispatcher("/page/otp-forgot-password.jsp").forward(request, response);
        }
    }
}
