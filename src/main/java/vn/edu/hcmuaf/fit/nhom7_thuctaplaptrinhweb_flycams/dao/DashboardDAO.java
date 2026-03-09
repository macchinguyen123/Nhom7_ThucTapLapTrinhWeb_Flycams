package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.*;

public class DashboardDAO {
    //tổng khách hàng
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    //tổng sản phẩm
    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) FROM products";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    //tổng đơn hàng
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    //doanh thu tháng hiện tại
    public double getMonthlyRevenue() {
        String sql = """ 
                SELECT IFNULL(SUM(totalPrice),0)
                FROM orders
                WHERE MONTH(createdAt) = MONTH(CURRENT_DATE())
                AND YEAR(createdAt) = YEAR(CURRENT_DATE())
                AND status = 'Hoàn thành'
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Map<String, Double> getRevenueLast30Days() {
        Map<String, Double> data = new LinkedHashMap<>();
        String sql = """
                    SELECT DATE(createdAt) AS day,
                    SUM(totalPrice) AS revenue
                    FROM orders
                    WHERE status = 'Hoàn thành'
                    AND createdAt >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
                    GROUP BY DATE(createdAt)
                    ORDER BY day
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.put(
                        rs.getString("day"),
                        rs.getDouble("revenue"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }

    public int getUsersThisWeek() {
        String sql = """
                    SELECT COUNT(*)
                    FROM users
                    WHERE createdAt >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getUsersLastWeek() {
        String sql = """
                    SELECT COUNT(*)
                    FROM users
                    WHERE createdAt >= DATE_SUB(CURDATE(), INTERVAL 14 DAY)
                    AND createdAt < DATE_SUB(CURDATE(), INTERVAL 7 DAY)
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getUserGrowthRate() {
        int thisWeek = getUsersThisWeek();
        int lastWeek = getUsersLastWeek();
        if (lastWeek == 0)
            return 100; // tránh chia cho 0
        return ((double) (thisWeek - lastWeek) / lastWeek) * 100;
    }

    public int getTotalCategories() {
        String sql = "SELECT COUNT(*) FROM categories";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getProcessingOrders() {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = 'Đang xử lý'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getMonthlyTarget() {
        return 500_000_000;
    }

    public List<User> getNewUsersLast7Days() {
        List<User> list = new ArrayList<>();
        String sql = """
                    SELECT fullName, phoneNumber, createdAt
                    FROM users
                    WHERE createdAt >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
                    ORDER BY createdAt DESC
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setFullName(rs.getString("fullName"));
                u.setPhoneNumber(rs.getString("phoneNumber"));
                u.setCreatedAt(rs.getTimestamp("createdAt"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Orders> getRecentOrders() {
        List<Orders> list = new ArrayList<>();

        String sql = """
                    SELECT o.shippingCode,
                    u.fullName AS customerName,
                    o.status,
                    o.totalPrice
                    FROM orders o
                    JOIN users u ON o.user_id = u.id
                    ORDER BY o.createdAt DESC
                    LIMIT 10
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Orders o = new Orders();
                o.setShippingCode(rs.getString("shippingCode"));
                o.setCustomerName(rs.getString("customerName"));
                o.setTotalPrice(rs.getDouble("totalPrice"));
                String status = rs.getString("status");
                //map 1 LẦN DUY NHẤT
                switch (status) {
                    case "Xác nhận" -> {
                        o.setStatusLabel("Xác nhận");
                        o.setStatusClass("bg-pending");
                    }
                    case "Đang xử lý" -> {
                        o.setStatusLabel("Đang xử lý");
                        o.setStatusClass("bg-processing");
                    }
                    case "Đang giao" -> {
                        o.setStatusLabel("Đang giao");
                        o.setStatusClass("bg-shipped");
                    }
                    case "Hoàn thành" -> {
                        o.setStatusLabel("Hoàn thành");
                        o.setStatusClass("bg-complete");
                    }
                    default -> {
                        o.setStatusLabel("Hủy");
                        o.setStatusClass("bg-cancel");
                    }
                }
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    //lấy danh sách đơn hàng trong ngày hiện tại
    public List<Orders> getTodayOrders() {
        List<Orders> list = new ArrayList<>();
        String sql = """
                    SELECT o.id,
                    o.shippingCode,
                    u.fullName AS customerName,
                    o.createdAt,
                    o.totalPrice,
                    o.status
                    FROM orders o
                    JOIN users u ON o.user_id = u.id
                    WHERE o.createdAt BETWEEN ? AND ?
                    ORDER BY o.createdAt DESC
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setTimestamp(1, startOfToday());
            ps.setTimestamp(2, endOfToday());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Orders o = new Orders();
                o.setId(rs.getInt("id"));
                o.setShippingCode(rs.getString("shippingCode"));
                o.setCustomerName(rs.getString("customerName"));
                o.setCreatedAt(rs.getTimestamp("createdAt"));
                o.setTotalPrice(rs.getDouble("totalPrice"));
                String status = rs.getString("status");
                switch (status) {
                    case "Xác nhận" -> {
                        o.setStatusLabel("Chờ xác nhận");
                        o.setStatusClass("bg-warning text-dark");
                    }
                    case "Đang xử lý" -> {
                        o.setStatusLabel("Đang xử lý");
                        o.setStatusClass("bg-info");
                    }
                    case "Đang giao" -> {
                        o.setStatusLabel("Đang giao");
                        o.setStatusClass("bg-primary");
                    }
                    case "Hoàn thành" -> {
                        o.setStatusLabel("Đã giao");
                        o.setStatusClass("bg-success");
                    }
                    default -> {
                        o.setStatusLabel("Hủy");
                        o.setStatusClass("bg-danger");
                    }
                }
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    //doanh thu hôm nay
    public double getRevenueToday() {
        String sql = "SELECT IFNULL(SUM(totalPrice),0) FROM orders WHERE status = 'Hoàn thành' AND DATE(createdAt) = CURDATE()";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    //DOANH THU THÁNG NÀY
    public double getRevenueThisMonth() {
        String sql = """
                    SELECT IFNULL(SUM(totalPrice),0)
                    FROM orders
                    WHERE MONTH(createdAt) = MONTH(CURDATE())
                    AND YEAR(createdAt) = YEAR(CURDATE())
                    AND status = 'Hoàn thành'
                """;
        return getDouble(sql);
    }

    //SỐ ĐƠN TRONG NGÀY
    public int getOrdersToday() {
        String sql = """
                    SELECT COUNT(*)
                    FROM orders
                    WHERE DATE(createdAt) = CURDATE()
                """;
        return getInt(sql);
    }

    public Map<String, Integer> getBestSellingProduct() {
        Map<String, Integer> result = new HashMap<>();
        String sql = """
                    SELECT p.productName, SUM(oi.quantity) totalSold
                    FROM order_items oi
                    JOIN products p ON oi.product_id = p.id
                    JOIN orders o ON oi.order_id = o.id
                    WHERE o.status = 'Hoàn thành'
                    GROUP BY p.id
                    ORDER BY totalSold DESC
                    LIMIT 1
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                result.put(
                        rs.getString("productName"),
                        rs.getInt("totalSold")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    //HÀM TIỆN ÍCH
    private double getDouble(String sql) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private int getInt(String sql) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Timestamp startOfToday() {
        return Timestamp.valueOf(
                LocalDate.now(ZoneId.of("Asia/Ho_Chi_Minh")).atStartOfDay()
        );
    }

    private Timestamp endOfToday() {
        return Timestamp.valueOf(
                LocalDate.now(ZoneId.of("Asia/Ho_Chi_Minh")).atTime(23, 59, 59)
        );
    }


    public Map<String, Double> getRevenueLast8Days() {
        Map<String, Double> dbData = new HashMap<>();
        Map<String, Double> result = new LinkedHashMap<>();
        String sql = """
                    SELECT DATE(createdAt) AS day,
                    SUM(totalPrice) AS revenue
                    FROM orders
                    WHERE status = 'Hoàn thành'
                    AND createdAt >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
                    GROUP BY DATE(createdAt)
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                dbData.put(
                        rs.getString("day"),
                        rs.getDouble("revenue")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        //ĐẢM BẢO ĐỦ 8 NGÀY
        LocalDate today = LocalDate.now(ZoneId.of("Asia/Ho_Chi_Minh"));
        for (int i = 7; i >= 0; i--) {
            LocalDate day = today.minusDays(i);
            String key = day.toString(); // yyyy-MM-dd
            result.put(key, dbData.getOrDefault(key, 0.0));
        }
        return result;
    }

    //dashboardDAO.java
    public Map<String, Double> getRevenueByMonth() {
        Map<String, Double> data = new LinkedHashMap<>();
        String sql = """
                    SELECT MONTH(createdAt) AS month, IFNULL(SUM(totalPrice),0) AS revenue
                    FROM orders
                    WHERE status = 'Hoàn thành'
                    AND YEAR(createdAt) = YEAR(CURDATE())
                    GROUP BY MONTH(createdAt)
                    ORDER BY month
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            //khởi tạo 12 tháng = 0
            for (int m = 1; m <= 12; m++) {
                data.put(String.valueOf(m), 0.0);
            }
            while (rs.next()) {
                data.put(rs.getString("month"), rs.getDouble("revenue"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }
}
