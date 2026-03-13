package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.AddressService;

import java.io.IOException;

@WebServlet(name = "CheckoutServlet", value = "/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String savedAddressId = req.getParameter("savedAddress");
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String addressLine = req.getParameter("address");
        String province = req.getParameter("province");
        String ward = req.getParameter("ward");
        String note = req.getParameter("note");
        try {
            AddressService addressService = new AddressService();
            int addressId = addressService.processCheckoutAddress(user.getId(), savedAddressId, fullName, phone,
                    addressLine, province, ward);
            session.setAttribute("addressId", addressId);
            session.setAttribute("phone", phone);
            session.setAttribute("note", note);
            resp.sendRedirect(req.getContextPath() + "/page/payment.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Checkout failed");
        }
    }
}