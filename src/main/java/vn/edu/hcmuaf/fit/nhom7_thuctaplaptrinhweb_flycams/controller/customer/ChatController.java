package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
public class ChatController extends HttpServlet {
    private ChatDAO chatDAO = new ChatDAO();
    private Gson gson = new GsonBuilder()
            .registerTypeAdapter(Timestamp.class, (com.google.gson.JsonSerializer<Timestamp>) (src, typeOfSrc, context) ->
                    new com.google.gson.JsonPrimitive(src.getTime()))
            .create();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
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
                    msg.setReceiveUserId(1);
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
