package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.cart.Carts;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.OrderService;

import java.io.IOException;
import java.util.List;

@WebServlet("/VnpayReturnServlet")
public class VnpayReturnServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String responseCode = request.getParameter("vnp_ResponseCode");
        HttpSession session = request.getSession();
        if ("00".equals(responseCode)) {
            try {
                User             user      = (User) session.getAttribute("user");
                List<OrderItems> items     = (List<OrderItems>) session.getAttribute("BUY_NOW_ITEM");
                Carts            cart      = (Carts) session.getAttribute("cart");
                Integer          addressId = (Integer) session.getAttribute("addressId");
                String           phone     = (String) session.getAttribute("phone");
                String           note      = (String) session.getAttribute("note");
                if (user != null && items != null && !items.isEmpty()) {
                    OrderService orderService = new OrderService();
                    orderService.placeOrder(user, addressId, phone, note, "VNPAY", items, cart);

                    if (cart != null) session.setAttribute("cart", cart);
                    session.removeAttribute("BUY_NOW_ITEM");
                    session.removeAttribute("note");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            request.setAttribute("message", "Thanh toán thành công!");
        } else {
            request.setAttribute("message", "Thanh toán thất bại! Mã lỗi: " + responseCode);
        }
        request.getRequestDispatcher("/page/paymentreturn.jsp").forward(request, response);
    }
}