package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.ProductService;

import java.io.IOException;

@WebServlet(name = "ProductGetServlet", value = "/admin/product-get")
public class ProductGetServlet extends HttpServlet {
    private ProductService productService = new ProductService();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Missing product ID\"}");
            return;
        }
        try {
            int productId = Integer.parseInt(idParam);
            Product product = productService.getProductDetailAdmin(productId);
            if (product != null) {
                // Chuyển sang JSON
                ObjectMapper mapper = new ObjectMapper();
                String json = mapper.writeValueAsString(product);
                response.getWriter().write(json);
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Sản phẩm không tồn tại\"}");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"ID không hợp lệ\"}");
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}