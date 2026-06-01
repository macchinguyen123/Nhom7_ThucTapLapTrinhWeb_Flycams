package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.DashboardDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;

import java.util.List;
import java.util.Map;

public class DashboardService {
    private DashboardDAO dashboardDAO = new DashboardDAO();

    //Lấy tổng số người dùng trong hệ thống
    public int getTotalUsers() {
        return dashboardDAO.getTotalUsers();
    }

    //Lấy tổng số sản phẩm
    public int getTotalProducts() {
        return dashboardDAO.getTotalProducts();
    }

    //Lấy tổng số đơn hàng
    public int getTotalOrders() {
        return dashboardDAO.getTotalOrders();
    }

    //Lấy tổng doanh thu trong tháng hiện tại
    public double getMonthlyRevenue() {
        return dashboardDAO.getMonthlyRevenue();
    }

    public double getRevenueGrowthRate() {
        return dashboardDAO.getRevenueGrowthRate();
    }
    //Lấy doanh thu 30 ngày gần nhất
    public Map<String, Double> getRevenueLast30Days() {
        return dashboardDAO.getRevenueLast30Days();
    }

    //Tính tỉ lệ tăng trưởng người dùng
    public double getUserGrowthRate() {
        return dashboardDAO.getUserGrowthRate();
    }

    //Lấy tổng số danh mục sản phẩm
    public int getTotalCategories() {
        return dashboardDAO.getTotalCategories();
    }

    //Lấy số đơn hàng đang xử lý
    public int getProcessingOrders() {
        return dashboardDAO.getProcessingOrders();
    }

    //Lấy mục tiêu doanh thu trong tháng
    public double getMonthlyTarget() {
        return dashboardDAO.getMonthlyTarget();
    }

    //Lấy danh sách người dùng mới đăng ký trong 7 ngày gần nhất
    public List<User> getNewUsersLast7Days() {
        return dashboardDAO.getNewUsersLast7Days();
    }

    //Lấy danh sách các đơn hàng gần đây
    public List<Orders> getRecentOrders() {
        return dashboardDAO.getRecentOrders();
    }

    //Lấy doanh thu 8 ngày gần nhất
    public Map<String, Double> getRevenueLast8Days() {
        return dashboardDAO.getRevenueLast8Days();
    }

    //Lấy doanh thu theo từng tháng trong năm
    public Map<String, Double> getRevenueByMonth() {
        return dashboardDAO.getRevenueByMonth();
    }


    public List<Orders> getOrdersInRange(String startDate, String endDate) {
        return dashboardDAO.getOrdersInRange(startDate, endDate);
    }

    public double getRevenueInRange(String startDate, String endDate) {
        return dashboardDAO.getRevenueInRange(startDate, endDate);
    }

    public int getOrdersCountInRange(String startDate, String endDate) {
        return dashboardDAO.getOrdersCountInRange(startDate, endDate);
    }

    public Map<String, Integer> getOrderStatusDistribution(String startDate, String endDate) {
        return dashboardDAO.getOrderStatusDistribution(startDate, endDate);
    }

    public Map<String, Double> getRevenueByCategory(String startDate, String endDate) {
        return dashboardDAO.getRevenueByCategory(startDate, endDate);
    }

    public List<Map<String, Object>> getTopSellingProductsWithRevenue(String startDate, String endDate) {
        return dashboardDAO.getTopSellingProductsWithRevenue(startDate, endDate);
    }

    public List<Map<String, Object>> getLowPerformingProducts(String startDate, String endDate) {
        return dashboardDAO.getLowPerformingProducts(startDate, endDate);
    }

    public List<Map<String, Object>> getTopCustomersBySpending(String startDate, String endDate) {
        return dashboardDAO.getTopCustomersBySpending(startDate, endDate);
    }

    public List<Map<String, Object>> getLowStockProducts() {
        return dashboardDAO.getLowStockProducts();
    }

    public double getRevenueToday() {
        return dashboardDAO.getRevenueToday();
    }

    public int getOrdersCountToday() {
        return dashboardDAO.getOrdersCountToday();
    }

    public String getBestSellerToday() {
        return dashboardDAO.getBestSellerToday();
    }
}
