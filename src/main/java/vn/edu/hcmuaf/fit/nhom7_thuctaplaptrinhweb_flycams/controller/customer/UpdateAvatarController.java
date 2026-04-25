package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.AuthService;

import java.io.File;
import java.io.IOException;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.FileStorageUtil;

@WebServlet(name = "UpdateAvatar", value = "/UpdateAvatar")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class UpdateAvatarController extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        Part filePart = request.getPart("avatar");
        if (filePart == null || filePart.getSize() == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            String deploymentPath = getServletContext().getRealPath("/") + "image" + File.separator + "avatar";
            String newFileName = FileStorageUtil.saveFile(filePart, deploymentPath, "avatar");
            boolean updated = authService.updateAvatar(user.getId(), newFileName);
            if (updated) {
                user.setAvatar(newFileName);
                session.setAttribute("user", user);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(newFileName);
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Lỗi: " + e.getMessage());
        }
    }
}
