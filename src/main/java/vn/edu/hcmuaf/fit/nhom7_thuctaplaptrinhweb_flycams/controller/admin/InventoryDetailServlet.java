package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.InventoryDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/api/inventory-detail")
public class InventoryDetailServlet extends HttpServlet {
    private final Gson gson = new Gson();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        setAccessControlHeaders(response);
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> responseData = new HashMap<>();
        String productIdParam = request.getParameter("productId");
        if (productIdParam == null || productIdParam.trim().isEmpty()) {
            sendErrorResponse(response, out, "Thiếu tham số productId.");
            return;
        }
        try {
            int productId = Integer.parseInt(productIdParam);
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductById(productId);
            if (product == null) {
                sendErrorResponse(response, out, "Không tìm thấy sản phẩm với ID: " + productId);
                return;
            }
            InventoryDAO inventoryDAO = new InventoryDAO();
            Map<String, Object> stats = inventoryDAO.getInventoryStats(productId);
            int totalImported = (Integer) stats.getOrDefault("totalImported", 0);
            int totalSold = (Integer) stats.getOrDefault("totalSold", 0);
            int currentStock = (Integer) stats.getOrDefault("inventory", 0);
            List<Map<String, Object>> importHistory = inventoryDAO.getImportHistory(productId, 30);
            List<Map<String, Object>> exportHistory = inventoryDAO.getExportHistory(productId, 30);
            responseData.put("status", "success");
            Map<String, Object> data = new HashMap<>();
            data.put("productId", product.getId());
            data.put("productName", product.getProductName());
            data.put("imageUrl", product.getMainImage());
            data.put("currentStock", currentStock);
            data.put("totalImported", totalImported);
            data.put("totalSold", totalSold);
            data.put("importHistory", importHistory);
            data.put("exportHistory", exportHistory);
            responseData.put("data", data);
            response.setStatus(HttpServletResponse.SC_OK);
            out.write(gson.toJson(responseData));
        } catch (NumberFormatException e) {
            sendErrorResponse(response, out, "Tham số productId phải là số nguyên hợp lệ.");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, Object> errorMap = new HashMap<>();
            errorMap.put("status", "error");
            errorMap.put("message", "Lỗi server: " + e.getMessage());
            out.write(gson.toJson(errorMap));
        } finally {
            out.flush();
            out.close();
        }
    }
    private void sendErrorResponse(HttpServletResponse response, PrintWriter out, String message) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        Map<String, Object> errorMap = new HashMap<>();
        errorMap.put("status", "error");
        errorMap.put("message", message);
        out.write(gson.toJson(errorMap));
    }
    @Override
    protected void doOptions(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        setAccessControlHeaders(resp);
        resp.setStatus(HttpServletResponse.SC_OK);
    }
    private void setAccessControlHeaders(HttpServletResponse resp) {
        resp.setHeader("Access-Control-Allow-Origin", "*");
        resp.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
        resp.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
    }
}