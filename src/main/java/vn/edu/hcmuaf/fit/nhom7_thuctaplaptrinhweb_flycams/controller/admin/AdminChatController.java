package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

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

@WebServlet(name = "AdminChatController", value = {"/admin/chat-manage", "/admin/chat"})
public class AdminChatController extends HttpServlet {
    private ChatDAO chatDAO = new ChatDAO();
    private Gson gson = new GsonBuilder()
            .registerTypeAdapter(Timestamp.class, (com.google.gson.JsonSerializer<Timestamp>) (src, typeOfSrc, context) ->
                    new com.google.gson.JsonPrimitive(src.getTime()))
            .create();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/admin/chat-manage".equals(path)) {
            req.getRequestDispatcher("/page/admin/chat-manage.jsp").forward(req, resp);
            return;
        }
        String action = req.getParameter("action");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        if ("list".equals(action)) {
            List<Conversation> list = chatDAO.getAdminConversations();
            resp.getWriter().write(gson.toJson(list));
        } else if ("messages".equals(action)) {
            int convId = Integer.parseInt(req.getParameter("conversationId"));
            List<Message> messages = chatDAO.getMessages(convId);
            HttpSession session = req.getSession();
            User admin = (User) session.getAttribute("user");
            int adminId = (admin != null) ? admin.getId() : 1;
            chatDAO.markAsRead(convId, adminId);
            resp.getWriter().write(gson.toJson(messages));
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();
        if ("send".equals(action)) {
            HttpSession session = req.getSession();
            User admin = (User) session.getAttribute("user");
            int convId = Integer.parseInt(req.getParameter("conversationId"));
            int participantId = Integer.parseInt(req.getParameter("participantId"));
            String content = req.getParameter("content");
            if (content != null && !content.trim().isEmpty()) {
                Message msg = new Message();
                msg.setConversationId(convId);
                msg.setSendUserId(admin != null ? admin.getId() : 1);
                msg.setReceiveUserId(participantId);
                msg.setContent(content.trim());
                msg.setStatus("SENT");
                boolean success = chatDAO.saveMessage(msg);
                result.put("success", success);
            }
        }
        resp.getWriter().write(gson.toJson(result));
    }
}
