package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.DashboardService;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminDashboardServlet", value = "/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private final DashboardService dashboardService = new DashboardService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        //chưa login
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        User user = (User) session.getAttribute("user");
        //không phải vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin
        if (user.getRoleId() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        request.setAttribute("totalUsers", dashboardService.getTotalUsers());
        request.setAttribute("totalProducts", dashboardService.getTotalProducts());
        request.setAttribute("totalOrders", dashboardService.getTotalOrders());
        request.setAttribute("monthlyRevenue", dashboardService.getMonthlyRevenue());
        request.setAttribute("revenueMap", dashboardService.getRevenueLast30Days());
        request.setAttribute("userGrowthRate", dashboardService.getUserGrowthRate());
        request.setAttribute("totalCategories", dashboardService.getTotalCategories());
        request.setAttribute("processingOrders", dashboardService.getProcessingOrders());
        request.setAttribute("monthlyTarget", dashboardService.getMonthlyTarget());
        List<User> newUsers = dashboardService.getNewUsersLast7Days();
        request.setAttribute("newUsers", newUsers);
        request.setAttribute("recentOrders", dashboardService.getRecentOrders());
        Map<String, Double> revenue30Days = dashboardService.getRevenueLast30Days();
        request.setAttribute("revenueLabels", revenue30Days.keySet());
        request.setAttribute("revenueValues", revenue30Days.values());
        request.getRequestDispatcher("/page/vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin/dashboard.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}