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

    //Lấy doanh thu trong ngày hôm nay
    public double getRevenueToday() {
        return dashboardDAO.getRevenueToday();
    }

    //Lấy doanh thu trong tháng hiện tại
    public double getRevenueThisMonth() {
        return dashboardDAO.getRevenueThisMonth();
    }

    //Lấy số lượng đơn hàng phát sinh trong hôm nay
    public int getOrdersToday() {
        return dashboardDAO.getOrdersToday();
    }

    //Lấy sản phẩm bán chạy nhất
    public Map<String, Integer> getBestSellingProduct() {
        return dashboardDAO.getBestSellingProduct();
    }

    //Lấy danh sách đơn hàng trong ngày hôm nay
    public List<Orders> getTodayOrders() {
        return dashboardDAO.getTodayOrders();
    }
}
