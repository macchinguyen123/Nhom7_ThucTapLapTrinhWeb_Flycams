package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.DashboardService;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "StatisticsServlet", value = "/admin/statistics")
public class StatisticsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DashboardService dashboardService = new DashboardService();
        String orderDate = request.getParameter("orderDate");
        List<Orders> todayOrders;
        if (orderDate != null && !orderDate.trim().isEmpty()) {
            todayOrders = dashboardService.getOrdersByDate(orderDate);
        } else {
            todayOrders = dashboardService.getTodayOrders();
            orderDate = java.time.LocalDate.now().toString();
        }
        Map<String, Double> revenue8Days = dashboardService.getRevenueLast8Days();
        Map<String, Double> revenueByMonth = dashboardService.getRevenueByMonth();
        request.setAttribute("revenueDays", revenue8Days.keySet());
        request.setAttribute("revenueValues", revenue8Days.values());
        request.setAttribute("revenueMonths", revenueByMonth.keySet());
        request.setAttribute("revenueMonthValues", revenueByMonth.values());
        request.setAttribute("revenueToday", dashboardService.getRevenueToday());
        request.setAttribute("revenueMonth", dashboardService.getRevenueThisMonth());
        request.setAttribute("ordersToday", dashboardService.getOrdersToday());
        request.setAttribute("bestProduct", dashboardService.getBestSellingProduct());
        request.setAttribute("todayOrders", todayOrders);
        request.setAttribute("selectedDate", orderDate);
        request.getRequestDispatcher("/page/admin/statistics.jsp")
                .forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
