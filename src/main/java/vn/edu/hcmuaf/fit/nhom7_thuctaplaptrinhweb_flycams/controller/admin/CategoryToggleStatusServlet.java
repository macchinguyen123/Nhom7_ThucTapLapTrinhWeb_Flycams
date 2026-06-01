package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.CategoryService;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "CategoryToggleStatusServlet", value = "/admin/category-toggle-status")
public class CategoryToggleStatusServlet extends HttpServlet {
    private CategoryService categoryService = new CategoryService();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        ObjectMapper mapper = new ObjectMapper();
        try {
            Map<String, Object> data = mapper.readValue(request.getInputStream(), Map.class);
            int categoryId = Integer.parseInt(data.get("id").toString());
            String status = (String) data.get("status");
            boolean success = categoryService.updateCategoryStatus(categoryId, status);
            Map<String, Object> resp = new HashMap<>();
            resp.put("success", success);
            if (!success) {
                resp.put("message", "Cập nhật trạng thái danh mục thất bại!");
            }
            response.getWriter().write(mapper.writeValueAsString(resp));
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> resp = new HashMap<>();
            resp.put("success", false);
            resp.put("message", e.getMessage());
            response.getWriter().write(mapper.writeValueAsString(resp));
        }
    }
}