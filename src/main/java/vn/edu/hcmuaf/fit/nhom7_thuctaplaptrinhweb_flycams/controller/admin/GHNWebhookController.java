package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.OrdersDAO;

import java.io.BufferedReader;
import java.io.IOException;

@WebServlet("/ghn-webhook")
public class GHNWebhookController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

//        String ghnToken = req.getHeader("Token");
//        String mySecret = "YOUR_GHN_WEBHOOK_TOKEN";
//
//        if (ghnToken == null || !ghnToken.equals(mySecret)) {
//            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
//            return;
//        }

        StringBuilder sb = new StringBuilder();
        String line;
        try (BufferedReader reader = req.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        try {
            JsonObject json = JsonParser.parseString(sb.toString()).getAsJsonObject();
            String ghnOrderCode = json.get("OrderCode").getAsString();
            String status = json.get("Status").getAsString();
            OrdersDAO ordersDAO = new OrdersDAO();
            boolean updated = updateStatusFromGHN(ghnOrderCode, status);

            if (updated) {
            }

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("Success");

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private boolean updateStatusFromGHN(String ghnCode, String ghnStatus) {
        String myStatus;
        switch (ghnStatus.toLowerCase()) {
            case "delivered":
                myStatus = "Hoàn thành";
                break;
            case "cancel":
                myStatus = "Hủy";
                break;
            case "delivering":
                myStatus = "Đang giao";
                break;
            case "returning":
                myStatus = "Yêu cầu trả hàng";
                break;
            default:
                return false;
        }
        OrdersDAO ordersDAO = new OrdersDAO();
        return ordersDAO.updateStatusByShippingCode(ghnCode, myStatus);
    }
}