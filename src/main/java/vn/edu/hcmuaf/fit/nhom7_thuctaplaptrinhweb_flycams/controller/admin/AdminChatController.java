package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.ChatDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.OrdersDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.UserDAO;
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
        User user = (User) req.getSession().getAttribute("user");
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
            chatDAO.markAsRead(convId, user.getId());
            resp.getWriter().write(gson.toJson(messages));
        } else if ("typing".equals(action)) {
            Map<String, Object> typingResult = new HashMap<>();
            typingResult.put("typing", false);
            resp.getWriter().write(gson.toJson(typingResult));
        } else if ("getCustomerInfo".equals(action)) {
            try {
                int userId = Integer.parseInt(req.getParameter("userId"));
                UserDAO userDAO = new UserDAO();
                OrdersDAO ordersDAO = new OrdersDAO();
                vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User customer = userDAO.findById(userId);
                List<vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Orders> orders = ordersDAO.getOrdersByUser(userId);

                double totalSpend = 0;
                JsonArray ordersArr = new JsonArray();

                if (orders != null) {
                    for (vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Orders o : orders) {
                        if ("Hoàn thành".equals(o.getStatus().toDB())) {
                            totalSpend += o.getTotalPrice();
                        }
                        if (ordersArr.size() < 5) {
                            JsonObject oJson = new JsonObject();
                            oJson.addProperty("id", o.getId());
                            oJson.addProperty("date", o.getCreatedAt().toString().substring(0, 10)); // Lấy yyyy-MM-dd
                            oJson.addProperty("status", o.getStatus().toDB());
                            oJson.addProperty("total", new java.text.DecimalFormat("#,###").format(o.getTotalPrice()));
                            ordersArr.add(oJson);
                        }
                    }
                }
                JsonObject responseData = new JsonObject();
                if (customer != null) {
                    responseData.addProperty("phone", customer.getPhoneNumber() != null ? customer.getPhoneNumber() : "N/A");
                    responseData.addProperty("address", (customer.getAddress() != null && !customer.getAddress().isEmpty())
                            ? customer.getAddress() : "Chưa cập nhật");
                } else {
                    responseData.addProperty("phone", "N/A");
                    responseData.addProperty("address", "N/A");
                }

                responseData.addProperty("totalSpend", totalSpend);
                responseData.add("orders", ordersArr);

                resp.getWriter().write(gson.toJson(responseData));

            } catch (Exception e) {
                e.printStackTrace();
                resp.sendError(500, "Lỗi lấy thông tin khách hàng");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        String action = req.getParameter("action");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        Map<String, Object> result = new HashMap<>();
        if ("send".equals(action)) {
            int convId = Integer.parseInt(req.getParameter("conversationId"));
            int participantId = Integer.parseInt(req.getParameter("participantId"));
            String content = req.getParameter("content");
            if (content != null && !content.trim().isEmpty()) {
                Message msg = new Message();
                msg.setConversationId(convId);
                msg.setSendUserId(user.getId());
                msg.setReceiveUserId(participantId);
                msg.setContent(content.trim());
                msg.setStatus("SENT");
                boolean success = chatDAO.saveMessage(msg);
                result.put("success", success);
            }
        }
         else if ("resolve".equals(action)) {
            int convId = Integer.parseInt(req.getParameter("conversationId"));
            int resolved = Integer.parseInt(req.getParameter("resolved"));
            boolean success = chatDAO.setResolved(convId, resolved == 1);
            result.put("success", success);
        }
        resp.getWriter().write(gson.toJson(result));
    }
}
