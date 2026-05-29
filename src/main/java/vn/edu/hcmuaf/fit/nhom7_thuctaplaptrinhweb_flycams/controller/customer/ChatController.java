package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.annotation.MultipartConfig;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.ChatDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Conversation;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Message;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ChatController", value = "/chat")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
public class ChatController extends HttpServlet {
    private ChatDAO chatDAO = new ChatDAO();
    private Gson gson = new GsonBuilder()
            .registerTypeAdapter(Timestamp.class, (com.google.gson.JsonSerializer<Timestamp>) (src, typeOfSrc, context) ->
                    new com.google.gson.JsonPrimitive(src.getTime()))
            .create();
    private int getAdminId() {
        String sql = "SELECT id FROM users WHERE roleId = 1 LIMIT 1";
        try (java.sql.Connection conn = vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            java.sql.ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("id");
            }
            try (java.sql.PreparedStatement psFallback = conn.prepareStatement("SELECT id FROM users ORDER BY id ASC LIMIT 1");
                 java.sql.ResultSet rsFallback = psFallback.executeQuery()) {
                if (rsFallback.next()) return rsFallback.getInt("id");
            }
        } catch (Exception e) {
        }
        return 1;
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
        Map<String, Object> result = new HashMap<>();
        if ("history".equals(action)) {
            if (user == null) {
                result.put("success", false);
                result.put("msg", "NOT_LOGGED_IN");
            } else {
                Conversation conv = chatDAO.getOrCreateConversation(user.getId());
                if (conv != null) {
                    List<Message> messages = chatDAO.getMessages(conv.getId());
                    result.put("success", true);
                    result.put("messages", messages);
                    boolean adminTyping = false;
                    Long lastTyping = vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin.AdminChatController.adminTypingMap.get(conv.getId());
                    if (lastTyping != null && (System.currentTimeMillis() - lastTyping) < 5000) {
                        adminTyping = true;
                    }
                    result.put("adminTyping", adminTyping);
                    chatDAO.markAsRead(conv.getId(), user.getId());
                } else {
                    result.put("success", false);
                }
            }
        } else if ("unread-count".equals(action)) {
            if (user != null) {
                int count = chatDAO.getUnreadCountForUser(user.getId());
                result.put("success", true);
                result.put("count", count);
            } else {
                result.put("success", false);
            }
        } else if ("productInfo".equals(action)) {
            String productId = req.getParameter("id");
            if (productId != null) {
                vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.ProductDAO pDao = new vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.ProductDAO();
                vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product p = pDao.getProductById(Integer.parseInt(productId));
                if (p != null) {
                    result.put("success", true);
                    result.put("id", p.getId());
                    result.put("name", p.getProductName());
                    result.put("price", p.getFinalPrice());
                    result.put("image", p.getMainImage());
                } else {
                    result.put("success", false);
                }
            } else {
                result.put("success", false);
            }
        }
        resp.getWriter().write(gson.toJson(result));
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();
        if ("send".equals(action)) {
            if (user == null) {
                result.put("success", false);
            } else {
                String content = req.getParameter("content");
                Conversation conv = chatDAO.getOrCreateConversation(user.getId());
                if (conv != null && content != null && !content.trim().isEmpty()) {
                    Message msg = new Message();
                    msg.setConversationId(conv.getId());
                    msg.setSendUserId(user.getId());
                    msg.setReceiveUserId(getAdminId());
                    msg.setContent(content.trim());
                    msg.setStatus("SENT");
                    boolean success = chatDAO.saveMessage(msg);
                    result.put("success", success);
                } else {
                    result.put("success", false);
                }
            }
        }
        resp.getWriter().write(gson.toJson(result));
    }
}
