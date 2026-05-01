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
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        java.time.LocalDate today = java.time.LocalDate.now();
        if (startDateStr == null || startDateStr.trim().isEmpty()) {
            startDateStr = today.withDayOfMonth(1).toString();
        }
        if (endDateStr == null || endDateStr.trim().isEmpty()) {
            endDateStr = today.toString();
        }
        List<Orders> ordersInRange = dashboardService.getOrdersInRange(startDateStr, endDateStr);
        double revenueInRange = dashboardService.getRevenueInRange(startDateStr, endDateStr);
        int ordersCountInRange = dashboardService.getOrdersCountInRange(startDateStr, endDateStr);
        Map<String, Integer> orderStatusDistribution = dashboardService.getOrderStatusDistribution(startDateStr, endDateStr);
        Map<String, Double> revenueByCategory = dashboardService.getRevenueByCategory(startDateStr, endDateStr);
        List<Map<String, Object>> topSellingProducts = dashboardService.getTopSellingProductsWithRevenue(startDateStr, endDateStr);
        List<Map<String, Object>> lowPerformingProducts = dashboardService.getLowPerformingProducts(startDateStr, endDateStr);
        List<Map<String, Object>> topCustomers = dashboardService.getTopCustomersBySpending(startDateStr, endDateStr);
        Map<String, Double> revenue8Days = dashboardService.getRevenueLast8Days();
        Map<String, Double> revenueByMonth = dashboardService.getRevenueByMonth();
        request.setAttribute("startDate", startDateStr);
        request.setAttribute("endDate", endDateStr);
        request.setAttribute("ordersInRange", ordersInRange);
        request.setAttribute("revenueInRange", revenueInRange);
        request.setAttribute("ordersCountInRange", ordersCountInRange);
        request.setAttribute("orderStatusDistribution", orderStatusDistribution);
        request.setAttribute("revenueByCategory", revenueByCategory);
        request.setAttribute("topSellingProducts", topSellingProducts);
        request.setAttribute("lowPerformingProducts", lowPerformingProducts);
        request.setAttribute("topCustomers", topCustomers);
        request.setAttribute("revenueDays", revenue8Days.keySet());
        request.setAttribute("revenueValues", revenue8Days.values());
        request.setAttribute("revenueMonths", revenueByMonth.keySet());
        request.setAttribute("revenueMonthValues", revenueByMonth.values());
        request.getRequestDispatcher("/page/admin/statistics.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
