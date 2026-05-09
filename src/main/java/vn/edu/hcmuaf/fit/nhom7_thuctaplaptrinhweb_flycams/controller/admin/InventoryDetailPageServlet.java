package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.InventoryDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;

import java.io.IOException;
import java.util.Map;
import java.util.List;

@WebServlet("/admin/inventory-detail")
public class InventoryDetailPageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productIdParam = request.getParameter("id");
        if (productIdParam == null || productIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/inventory-manage");
            return;
        }
        try {
            int productId = Integer.parseInt(productIdParam);
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductById(productId);
            
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/admin/inventory-manage");
                return;
            }
            InventoryDAO inventoryDAO = new InventoryDAO();
            Map<String, Object> stats = inventoryDAO.getInventoryStats(productId);
            List<Map<String, Object>> importHistory = inventoryDAO.getImportHistory(productId, 5);
            List<Map<String, Object>> exportHistory = inventoryDAO.getExportHistory(productId, 5);
            request.setAttribute("product", product);
            request.setAttribute("stats", stats);
            request.setAttribute("importHistory", importHistory);
            request.setAttribute("exportHistory", exportHistory);
            request.getRequestDispatcher("/page/admin/inventory-detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/inventory-manage");
        }
    }
}