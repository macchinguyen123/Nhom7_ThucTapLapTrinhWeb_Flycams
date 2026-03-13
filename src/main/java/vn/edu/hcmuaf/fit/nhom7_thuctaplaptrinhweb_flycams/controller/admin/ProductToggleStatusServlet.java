package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.ProductService;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ProductToggleStatusServlet", value = "/admin/product-toggle-status")
public class ProductToggleStatusServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
    private ProductService productService = new ProductService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> data = mapper.readValue(request.getInputStream(), Map.class);
        int productId = (int) data.get("id");
        String status = (String) data.get("status");
        Map<String, Object> resp = new HashMap<>();

        try {
            boolean success = productService.updateProductStatus(productId, status);
            resp.put("success", success);
            if (!success)
                resp.put("message", "Cập nhật trạng thái thất bại!");
        } catch (Exception e) {
            e.printStackTrace();
            resp.put("success", false);
            resp.put("message", e.getMessage());
        }

        response.getWriter().write(mapper.writeValueAsString(resp));
    }
}