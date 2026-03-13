package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.CustomerService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CustomerDetail", value = "/admin/customer-detail")
public class CustomerDetail extends HttpServlet {
    private CustomerService customerService = new CustomerService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idRaw = req.getParameter("id");
        if (idRaw == null || idRaw.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/customer-manage");
            return;
        }

        try {
            int id = Integer.parseInt(idRaw);
            User user = customerService.getUserById(id);
            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/customer-manage");
                return;
            }
            List<User> users = customerService.getAllUsers();
            req.setAttribute("users", users);
            req.setAttribute("detailUser", user);
            req.setAttribute("showDetail", true); // Boolean true
            req.getRequestDispatcher("/page/admin/customer-manage.jsp")
                    .forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/customer-manage");
        }
    }
}