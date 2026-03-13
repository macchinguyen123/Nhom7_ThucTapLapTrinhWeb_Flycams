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

@WebServlet(name = "CustomerManage", value = "/admin/customer-manage")
public class CustomerManage extends HttpServlet {
        private CustomerService customerService = new CustomerService();
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp)
                        throws ServletException, IOException {
                List<User> users = customerService.getAllUsers();
                req.setAttribute("users", users);
                req.setAttribute("showDetail", Boolean.FALSE); // ← Dùng Boolean.FALSE
                req.getRequestDispatcher("/page/admin/customer-manage.jsp")
                                .forward(req, resp);
        }
        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                        throws ServletException, IOException {
        }
}