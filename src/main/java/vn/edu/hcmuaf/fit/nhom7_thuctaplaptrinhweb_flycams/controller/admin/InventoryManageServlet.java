package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
@WebServlet("/admin/api/inventory-manage")
public class InventoryManageServlet extends HttpServlet {
    private final Gson gson = new Gson();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        setAccessControlHeaders(response);
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            String pageStr = request.getParameter("page");
            String limitStr = request.getParameter("limit");
            String search = request.getParameter("search");
            int page = (pageStr != null && !pageStr.isEmpty()) ? Integer.parseInt(pageStr) : 1;
            int limit = (limitStr != null && !limitStr.isEmpty()) ? Integer.parseInt(limitStr) : 10;
            if (page < 1) page = 1;
            if (limit < 1) limit = 10;
            int offset = (page - 1) * limit;
            if (search == null) {
                search = "";
            }
            vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.InventoryDAO inventoryDAO = new vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.InventoryDAO();
            int totalRecords = inventoryDAO.getTotalInventoryRecords(search);
            List<Map<String, Object>> inventoryList = inventoryDAO.getInventoryList(limit, offset, search);
            int totalPages = (int) Math.ceil((double) totalRecords / limit);
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("status", "success");
            responseData.put("data", inventoryList);
            responseData.put("pagination", Map.of(
                "currentPage", page,
                "limit", limit,
                "totalPages", totalPages,
                "totalRecords", totalRecords
            ));
            out.write(gson.toJson(responseData));

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.write(gson.toJson(Map.of("status", "error", "message", "Tham số phân trang không hợp lệ.")));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write(gson.toJson(Map.of("status", "error", "message", "Lỗi server: " + e.getMessage())));
        } finally {
            out.flush();
            out.close();
        }
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
