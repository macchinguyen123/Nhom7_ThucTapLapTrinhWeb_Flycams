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
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileController extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        String fullName = req.getParameter("fullName");
        String username = req.getParameter("username");
        String phoneNumber = req.getParameter("phoneNumber");
        String gender = req.getParameter("gender");
        String birthDateStr = req.getParameter("birthDate");
        try {
            if (birthDateStr != null && !birthDateStr.isEmpty()) {
                Date birthDate = new SimpleDateFormat("yyyy-MM-dd").parse(birthDateStr);
                user.setBirthDate(birthDate);
            } else {
                user.setBirthDate(null);
            }
            user.setFullName(fullName);
            user.setUsername(username);
            user.setPhoneNumber(phoneNumber);
            user.setGender(gender);
            authService.updateProfile(user);
            session.setAttribute("user", user);
            session.setAttribute("success", "Cập nhật hồ sơ thành công!");
            resp.sendRedirect(req.getContextPath() + "/personal");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Cập nhật thất bại!");
            req.getRequestDispatcher("/page/personal-page.jsp").forward(req, resp);
        }
    }
}
