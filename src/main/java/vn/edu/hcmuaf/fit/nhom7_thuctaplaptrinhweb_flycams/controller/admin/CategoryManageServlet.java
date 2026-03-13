package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Categories;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.CategoryService;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;

@WebServlet(name = "CategoryManageServlet", value = "/admin/category-manage")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 100 // 100 MB
)
public class CategoryManageServlet extends HttpServlet {

    private CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            handleDelete(req, resp);
            return;
        }
        List<Categories> list = categoryService.getAllCategoriesAdmin();
        req.setAttribute("categories", list);
        req.getRequestDispatcher("/page/admin/category-manage.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action"); // add or update
        if ("add".equals(action)) {
            handleAdd(req, resp);
        } else if ("update".equals(action)) {
            handleUpdate(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/category-manage");
        }
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String name = req.getParameter("categoryName");
        String status = req.getParameter("status");
        String imagePath = "default.png";
        Part filePart = req.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String projectPath = System.getProperty("user.dir");
            Path uploadDir = Paths.get(projectPath,
                    "src", "main", "webapp",
                    "image", "logoCategory");
            Files.createDirectories(uploadDir);
            Path destination = uploadDir.resolve(fileName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, destination, StandardCopyOption.REPLACE_EXISTING);
            }
            imagePath = "image/logoCategory/" + fileName;
        }

        Categories c = new Categories();
        c.setCategoryName(name);
        c.setStatus(status);
        c.setImage(imagePath);
        categoryService.addCategory(c);
        resp.sendRedirect(req.getContextPath() + "/admin/category-manage");
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("categoryName");
        String status = req.getParameter("status");
        String oldImage = req.getParameter("oldImage");
        String imagePath = oldImage;
        Part filePart = req.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName())
                    .getFileName().toString();
            String projectPath = System.getProperty("user.dir");
            Path uploadDir = Paths.get(projectPath,
                    "src", "main", "webapp",
                    "image", "logoCategory");
            Files.createDirectories(uploadDir);
            Path destination = uploadDir.resolve(fileName);
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, destination, StandardCopyOption.REPLACE_EXISTING);
            }
            imagePath = "image/logoCategory/" + fileName;
            if (!oldImage.equals("default.png")) {
                Path oldPath = Paths.get(projectPath, "src", "main", "webapp", oldImage);
                Files.deleteIfExists(oldPath);
            }
        }
        Categories c = new Categories(id, name, imagePath, status);
        categoryService.updateCategory(c);
        resp.sendRedirect(req.getContextPath() + "/admin/category-manage");
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                categoryService.deleteCategory(id);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/category-manage");
    }
}
