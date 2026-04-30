package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.InventoryDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.InventoryImport;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/inventory-import-submit")
public class InventoryImportServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            BigDecimal importPrice = new BigDecimal(request.getParameter("importPrice"));
            String note = request.getParameter("note");
            User user = (User) request.getSession().getAttribute("user");
            Integer createdBy = (user != null) ? user.getId() : null;
            InventoryImport imp = new InventoryImport();
            imp.setProductId(productId);
            imp.setQuantity(quantity);
            imp.setImportPrice(importPrice);
            imp.setNote(note);
            imp.setCreatedBy(createdBy);
            InventoryDAO inventoryDAO = new InventoryDAO();
            boolean success = inventoryDAO.addInventoryImport(imp);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            if (success) {
                response.getWriter().write("{\"status\":\"success\"}");
            } else {
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Lỗi khi nhập kho.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
        }
    }
}