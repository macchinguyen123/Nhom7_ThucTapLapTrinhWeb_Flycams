package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.InventoryDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.InventoryImport;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/api/inventory-import")
public class InventoryImportServlet extends HttpServlet {
    private final Gson gson = new Gson();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        setAccessControlHeaders(response);
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> responseData = new HashMap<>();
        try {
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            JsonObject jsonObject = gson.fromJson(sb.toString(), JsonObject.class);
            if (jsonObject == null) {
                sendErrorResponse(response, out, "Dữ liệu JSON không hợp lệ hoặc bị rỗng.");
                return;
            }
            if (!jsonObject.has("productId") || !jsonObject.has("quantity") || !jsonObject.has("importPrice")) {
                sendErrorResponse(response, out, "Thiếu các trường dữ liệu bắt buộc (productId, quantity, importPrice).");
                return;
            }
            int productId = jsonObject.get("productId").getAsInt();
            int quantity = jsonObject.get("quantity").getAsInt();
            BigDecimal importPrice = jsonObject.get("importPrice").getAsBigDecimal();
            String note = jsonObject.has("note") ? jsonObject.get("note").getAsString() : "";
            if (quantity <= 0) {
                sendErrorResponse(response, out, "Số lượng nhập kho phải lớn hơn 0.");
                return;
            }
            if (importPrice.compareTo(BigDecimal.ZERO) < 0) {
                sendErrorResponse(response, out, "Giá nhập kho không được nhỏ hơn 0.");
                return;
            }
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductById(productId);
            if (product == null) {
                sendErrorResponse(response, out, "Sản phẩm không tồn tại trong hệ thống (ID: " + productId + ").");
                return;
            }
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
            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                responseData.put("status", "success");
                responseData.put("message", "Nhập kho thành công cho sản phẩm " + product.getProductName() + ".");
                Map<String, Object> stats = inventoryDAO.getInventoryStats(productId);
                responseData.put("updatedStock", stats.get("inventory"));
                out.write(gson.toJson(responseData));
            } else {
                sendErrorResponse(response, out, "Có lỗi xảy ra trong quá trình lưu phiếu nhập kho. Vui lòng thử lại.");
            }

        } catch (JsonSyntaxException | NumberFormatException e) {
            sendErrorResponse(response, out, "Định dạng dữ liệu không hợp lệ. Vui lòng kiểm tra lại kiểu dữ liệu của các trường.");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            responseData.put("status", "error");
            responseData.put("message", "Lỗi server: " + e.getMessage());
            out.write(gson.toJson(responseData));
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
        resp.setHeader("Access-Control-Allow-Methods", "POST, OPTIONS");
        resp.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
    }
}