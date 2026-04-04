package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.PasswordUtil;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "CheckCurrentPasswordServlet", value = "/CheckCurrentPasswordServlet")
public class CheckCurrentPasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Boolean> result = new HashMap<>();
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            result.put("valid", false);
        } else {
            String currentPasswordInput = request.getParameter("currentPassword");
            UserDAO userDAO = new UserDAO();
            User dbUser = userDAO.findById(user.getId());
            boolean isValid = false;
            if (dbUser != null && currentPasswordInput != null && dbUser.getPassword() != null) {
                String hashedPw = dbUser.getPassword();
                if (hashedPw.startsWith("$2a$")) {
                    isValid = PasswordUtil.checkPassword(currentPasswordInput, hashedPw);
                } else {
                    isValid = currentPasswordInput.equals(hashedPw);
                }
            }
            result.put("valid", isValid);
        }
        Gson gson = new Gson();
        response.getWriter().write(gson.toJson(result));
    }
}
