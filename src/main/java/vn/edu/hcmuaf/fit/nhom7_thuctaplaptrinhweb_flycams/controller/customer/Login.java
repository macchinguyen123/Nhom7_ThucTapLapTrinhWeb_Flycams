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
        AuthService authService = new AuthService();
        User user = authService.login(input, password);
        if (user == null) {
            String msg = "<b>Số điện thoại hoặc mật khẩu không hợp lệ</b>" +
                    "<div class='sub-msg'>Vui lòng nhập lại</div>";
            request.setAttribute("error", msg);
            request.getRequestDispatcher("/page/login.jsp").forward(request, response);
            return;
        }
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        System.out.println("LOGIN SESSION ID = " + session.getId());
        response.sendRedirect(request.getContextPath() + "/home");
    }
}