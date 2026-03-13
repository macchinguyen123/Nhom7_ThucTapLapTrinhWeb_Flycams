package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.AuthService;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

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
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        Part filePart = request.getPart("avatar");
        if (filePart == null || filePart.getSize() == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String rawFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String sanitizedFileName = rawFileName.replaceAll("[^a-zA-Z0-9\\\\. -]", "_").replace(" ", "_");
        String newFileName = user.getId() + "_" + System.currentTimeMillis() + "_" + sanitizedFileName;
        String deploymentPath = getServletContext().getRealPath("/") + "image" + File.separator + "avatar";
        String sourcePath = "D:/Nhom12LapTrinhWebFlycams/src/main/webapp/image/avatar";
        File deployDir = new File(deploymentPath);
        if (!deployDir.exists())
            deployDir.mkdirs();

        File sourceDir = new File(sourcePath);
        if (!sourceDir.exists())
            sourceDir.mkdirs();

        String filePathDeploy = deploymentPath + File.separator + newFileName;
        String filePathSource = sourcePath + File.separator + newFileName;

        filePart.write(filePathDeploy);
        try {
            java.nio.file.Files.copy(Paths.get(filePathDeploy), Paths.get(filePathSource),
                    java.nio.file.StandardCopyOption.REPLACE_EXISTING);
            System.out.println("Avatar saved to source: " + filePathSource);
        } catch (Exception e) {
            System.err.println("Failed to save avatar to source directory: " + e.getMessage());
        }

        System.out.println("Avatar saved to deployment: " + filePathDeploy);

        boolean updated = authService.updateAvatar(user.getId(), newFileName);
        if (updated) {
            user.setAvatar(newFileName);
            session.setAttribute("user", user);
            System.out.println("User avatar updated in DB and session: " + newFileName);
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(newFileName);
        } else {
            System.out.println("Failed to update user avatar in DB for userId: " + user.getId());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
