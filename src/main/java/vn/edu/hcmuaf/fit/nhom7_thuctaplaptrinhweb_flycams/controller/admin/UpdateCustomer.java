package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.CustomerService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.PasswordUtil;

import java.io.IOException;

@WebServlet(name = "UpdateCustomer", value = "/admin/update-customer")
@MultipartConfig
public class UpdateCustomer extends HttpServlet {
    private CustomerService customerService = new CustomerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String fullName = req.getParameter("fullName");
            String email = req.getParameter("email");
            String phone = req.getParameter("phoneNumber");
            String gender = req.getParameter("gender");
            String birthDateRaw = req.getParameter("birthDate");
            boolean status = req.getParameter("status") != null;
            User u = customerService.getUserById(id);
            if (u == null) {
                resp.getWriter().write("{\"success\":false, \"msg\":\"User not found\"}");
                return;
            }
            if (fullName != null && !fullName.isEmpty())
                u.setFullName(fullName);
            if (email != null && !email.isEmpty())
                u.setEmail(email);
            if (phone != null && !phone.isEmpty())
                u.setPhoneNumber(phone);
            if (gender != null && !gender.isEmpty())
                u.setGender(gender);
            u.setStatus(status);
            if (birthDateRaw != null && !birthDateRaw.isEmpty()) {
                try {
                    u.setBirthDate(java.sql.Date.valueOf(birthDateRaw));
                } catch (IllegalArgumentException e) {
                    resp.getWriter().write("{\"success\":false, \"msg\":\"Invalid birth date format\"}");
                    return;
                }
            } else {
                u.setBirthDate(null);
            }
            String roleIdStr = req.getParameter("roleId");
            if (roleIdStr != null && !roleIdStr.isEmpty()) {
                try {
                    u.setRoleId(Integer.parseInt(roleIdStr));
                } catch (NumberFormatException e) {
                    resp.getWriter().write("{\"success\":false, \"msg\":\"Invalid Role ID\"}");
                    return;
                }
            }
            if (req.getParameter("username") != null)
                u.setUsername(req.getParameter("username"));
            String newPassword = req.getParameter("newPassword");
            if (newPassword != null && !newPassword.isBlank()) {
                String hashed = PasswordUtil.hashPassword(newPassword);
                u.setPassword(hashed);
            }

            if (req.getParameter("avatar") != null)
                u.setAvatar(req.getParameter("avatar"));

            String address = req.getParameter("address");
            boolean addrUpdated = true;
            if (address != null && !address.trim().isEmpty()) {
                addrUpdated = customerService.updateUserAddress(u.getId(), address.trim());
            } else {
                addrUpdated = customerService.updateUserAddress(u.getId(), "");
            }
            boolean updated = customerService.updateUser(u);
            if (updated) {
                resp.getWriter().write("{\"success\":true}");
            } else {
                resp.getWriter().write("{\"success\":false, \"msg\":\"Update failed\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"success\":false, \"msg\":\"" + e.toString().replace("\"", "'") + "\"}");
        }
    }
}