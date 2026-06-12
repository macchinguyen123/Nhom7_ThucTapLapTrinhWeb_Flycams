package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.AuthService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.CsrfTokenUtil;

import java.io.IOException;

@WebServlet(name = "AdminProfileServlet", value = "/admin/profile")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class AdminProfileServlet extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        CsrfTokenUtil.getOrCreate(session);
        User admin = (User) request.getSession().getAttribute("user");
        User refreshedAdmin = authService.getUserByEmail(admin.getEmail());
        if (refreshedAdmin != null) {
            request.getSession().setAttribute("user", refreshedAdmin);
            admin = refreshedAdmin;
        }
        request.setAttribute("admin", admin);
        request.getRequestDispatcher("/page/admin/profile-admin.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        switch (action) {
            case "update-info":
                updateInfo(request, response);
                break;
            case "change-password":
                changePassword(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void updateInfo(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        boolean isAjax = "XMLHttpRequest".equals(req.getHeader("X-Requested-With"))
                || req.getContentType() != null && req.getContentType().contains("multipart/form-data")
                   && req.getHeader("Accept") != null && req.getHeader("Accept").contains("application/json");
        boolean hasAvatarPart = false;
        try {
            Part testPart = req.getPart("avatar");
            hasAvatarPart = testPart != null && testPart.getSize() > 0;
        } catch (Exception ignored) {}
        isAjax = isAjax || hasAvatarPart;
        User admin = (User) req.getSession().getAttribute("user");
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        if (fullName == null || fullName.trim().isEmpty()) {
            sendResponse(req, resp, isAjax, false, "Họ tên không được để trống");
            return;
        }
        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            sendResponse(req, resp, isAjax, false, "Email không hợp lệ");
            return;
        }
        if (phone == null || !phone.matches("^0\\d{9}$")) {
            sendResponse(req, resp, isAjax, false, "Số điện thoại không hợp lệ (10 số, bắt đầu bằng 0)");
            return;
        }
        User currentAdmin = authService.getUserByEmail(admin.getEmail());
        if (currentAdmin == null) {
            sendResponse(req, resp, isAjax, false, "Không tìm thấy thông tin admin");
            return;
        }
        currentAdmin.setFullName(fullName.trim());
        currentAdmin.setEmail(email.trim());
        currentAdmin.setPhoneNumber(phone.trim());
        // Xử lý avatar
        String newAvatarUrl = null;
        try {
            Part avatarPart = req.getPart("avatar");
            if (avatarPart != null && avatarPart.getSize() > 0) {
                String contentType = avatarPart.getContentType();
                if (contentType == null || !contentType.startsWith("image/")) {
                    sendResponse(req, resp, isAjax, false, "File avatar phải là hình ảnh");
                    return;
                }
                if (avatarPart.getSize() > 5 * 1024 * 1024) {
                    sendResponse(req, resp, isAjax, false, "File avatar không được vượt quá 5MB");
                    return;
                }
                String originalFileName = avatarPart.getSubmittedFileName();
                if (originalFileName == null || originalFileName.trim().isEmpty()) {
                    sendResponse(req, resp, isAjax, false, "Tên file không hợp lệ");
                    return;
                }
                String deploymentPath = getServletContext().getRealPath("/image/avatar/");
                newAvatarUrl = vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.FileStorageUtil.saveFile(avatarPart, deploymentPath, "avatar");
                currentAdmin.setAvatar(newAvatarUrl);
                System.out.println("[AdminProfile] Avatar URL được lưu: " + newAvatarUrl);
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendResponse(req, resp, isAjax, false, "Lỗi upload avatar: " + e.getMessage());
            return;
        }

        boolean success = authService.updateProfileAdmin(currentAdmin);
        if (success) {
            User updatedAdmin = authService.getUserByEmail(currentAdmin.getEmail());
            if (updatedAdmin != null) {
                req.getSession().setAttribute("user", updatedAdmin);
            }
            if (newAvatarUrl != null && isAjax) {
                resp.setContentType("application/json;charset=UTF-8");
                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write("{\"success\":true,\"avatarUrl\":\"" + newAvatarUrl.replace("\"", "\\\"") + "\"}");
                return;
            }
            sendResponse(req, resp, isAjax, true, "Cập nhật thông tin thành công");
        } else {
            sendResponse(req, resp, isAjax, false, "Cập nhật thất bại, vui lòng thử lại");
        }
    }

    private void sendResponse(HttpServletRequest req, HttpServletResponse resp,
                              boolean isAjax, boolean success, String message) throws IOException {
        if (isAjax) {
            resp.setContentType("application/json;charset=UTF-8");
            resp.setStatus(success ? HttpServletResponse.SC_OK : HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"success\":" + success + ",\"message\":\"" + message.replace("\"", "\\\"") + "\"}");
        } else {
            req.getSession().setAttribute("infoMsg", message);
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
        }
    }

    private void changePassword(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User admin = (User) req.getSession().getAttribute("user");
        String oldPass = req.getParameter("oldPassword");
        String newPass = req.getParameter("newPassword");
        String confirmPass = req.getParameter("confirmPassword");
        if (oldPass == null || oldPass.trim().isEmpty()) {
            req.getSession().setAttribute("passMsg", "Vui lòng nhập mật khẩu cũ");
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }
        if (newPass == null || newPass.trim().isEmpty()) {
            req.getSession().setAttribute("passMsg", "Vui lòng nhập mật khẩu mới");
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }
        // Kiểm tra xác nhận
        if (!newPass.equals(confirmPass)) {
            req.getSession().setAttribute("passMsg", "Mật khẩu xác nhận không khớp");
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }
        // Kiểm tra độ mạnh
        if (!isStrongPassword(newPass)) {
            req.getSession().setAttribute("passMsg",
                    "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt");
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }
        String error = authService.changePassword(
                admin.getId(),
                admin.getEmail(),
                oldPass,
                newPass,
                confirmPass,
                null,
                null
        );
        if (error == null) {
            admin.setPassword(newPass);
            req.getSession().setAttribute("user", admin);
            req.getSession().setAttribute("passMsg", "Đổi mật khẩu thành công");
        } else {
            req.getSession().setAttribute("passMsg", error);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/profile");
    }

    private boolean isStrongPassword(String password) {
        return password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&]).{8,}$");
    }
}