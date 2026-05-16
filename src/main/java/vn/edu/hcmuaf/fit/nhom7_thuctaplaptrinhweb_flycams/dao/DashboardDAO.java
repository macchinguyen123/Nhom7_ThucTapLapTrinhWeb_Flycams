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

    //lấy danh sách đơn hàng trong khoảng ngày
    public List<Orders> getOrdersInRange(String startDate, String endDate) {
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
                    WHERE DATE(o.createdAt) >= ? AND DATE(o.createdAt) <= ?
                    ORDER BY o.createdAt DESC
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
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

    public double getRevenueInRange(String startDate, String endDate) {
        String sql = "SELECT IFNULL(SUM(totalPrice),0) FROM orders WHERE status = 'Hoàn thành' AND DATE(createdAt) >= ? AND DATE(createdAt) <= ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getOrdersCountInRange(String startDate, String endDate) {
        String sql = "SELECT COUNT(*) FROM orders WHERE DATE(createdAt) >= ? AND DATE(createdAt) <= ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Map<String, Integer> getOrderStatusDistribution(String startDate, String endDate) {
        Map<String, Integer> result = new LinkedHashMap<>();
        String sql = """
                    SELECT status, COUNT(*) AS total
                    FROM orders
                    WHERE DATE(createdAt) >= ? AND DATE(createdAt) <= ?
                    GROUP BY status
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.put(rs.getString("status"), rs.getInt("total"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public Map<String, Double> getRevenueByCategory(String startDate, String endDate) {
        Map<String, Double> result = new LinkedHashMap<>();
        String sql = """
                    SELECT c.categoryName, SUM(oi.price * oi.quantity) AS revenue
                    FROM order_items oi
                    JOIN products p ON oi.product_id = p.id
                    JOIN categories c ON p.category_id = c.id
                    JOIN orders o ON oi.order_id = o.id
                    WHERE o.status = 'Hoàn thành' AND DATE(o.createdAt) >= ? AND DATE(o.createdAt) <= ?
                    GROUP BY c.id
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.put(rs.getString("categoryName"), rs.getDouble("revenue"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Map<String, Object>> getTopSellingProductsWithRevenue(String startDate, String endDate) {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = """
                    SELECT p.productName, SUM(oi.quantity) AS totalSold, SUM(oi.price * oi.quantity) AS totalRevenue
                    FROM order_items oi
                    JOIN products p ON oi.product_id = p.id
                    JOIN orders o ON oi.order_id = o.id
                    WHERE o.status = 'Hoàn thành' AND DATE(o.createdAt) >= ? AND DATE(o.createdAt) <= ?
                    GROUP BY p.id
                    ORDER BY totalSold DESC
                    LIMIT 5
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("productName", rs.getString("productName"));
                    map.put("totalSold", rs.getInt("totalSold"));
                    map.put("totalRevenue", rs.getDouble("totalRevenue"));
                    result.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Map<String, Object>> getLowPerformingProducts(String startDate, String endDate) {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = """
                    SELECT p.productName, IFNULL(SUM(oi.quantity), 0) AS totalSold
                    FROM products p
                    LEFT JOIN order_items oi ON p.id = oi.product_id
                    LEFT JOIN orders o ON oi.order_id = o.id AND o.status = 'Hoàn thành' AND DATE(o.createdAt) >= ? AND DATE(o.createdAt) <= ?
                    GROUP BY p.id
                    ORDER BY totalSold ASC
                    LIMIT 5
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("productName", rs.getString("productName"));
                    map.put("totalSold", rs.getInt("totalSold"));
                    result.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Map<String, Object>> getTopCustomersBySpending(String startDate, String endDate) {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = """
                    SELECT u.fullName, u.email, SUM(o.totalPrice) AS totalSpent, COUNT(o.id) AS totalOrders
                    FROM orders o
                    JOIN users u ON o.user_id = u.id
                    WHERE o.status = 'Hoàn thành' AND DATE(o.createdAt) >= ? AND DATE(o.createdAt) <= ?
                    GROUP BY u.id
                    ORDER BY totalSpent DESC
                    LIMIT 5
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("fullName", rs.getString("fullName"));
                    map.put("email", rs.getString("email"));
                    map.put("totalSpent", rs.getDouble("totalSpent"));
                    map.put("totalOrders", rs.getInt("totalOrders"));
                    result.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Map<String, Object>> getLowStockProducts() {
        List<Map<String, Object>> result = new ArrayList<>();
        String sqlWithMinStock = """
                    SELECT p.id, p.productName, p.quantity, p.min_stock, 
                           (SELECT imageUrl FROM images WHERE product_id = p.id 
                            ORDER BY (CASE WHEN imageType = 'Chính' THEN 1 WHEN imageType = 'Phụ' THEN 2 ELSE 3 END) ASC, id ASC LIMIT 1) as imageUrl
                    FROM products p
                    WHERE p.quantity <= p.min_stock
                    ORDER BY p.quantity ASC
                """;
        String sqlFallback = """
                    SELECT p.id, p.productName, p.quantity, 10 as min_stock, 
                           (SELECT imageUrl FROM images WHERE product_id = p.id 
                            ORDER BY (CASE WHEN imageType = 'Chính' THEN 1 WHEN imageType = 'Phụ' THEN 2 ELSE 3 END) ASC, id ASC LIMIT 1) as imageUrl
                    FROM products p
                    WHERE p.quantity <= 10
                    ORDER BY p.quantity ASC
                """;
        try (Connection con = DBConnection.getConnection()) {
            boolean hasMinStockColumn = false;
            try (ResultSet rs = con.getMetaData().getColumns(null, null, "products", "min_stock")) {
                if (rs.next()) hasMinStockColumn = true;
            }
            String sql = hasMinStockColumn ? sqlWithMinStock : sqlFallback;
            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", rs.getInt("id"));
                    map.put("productName", rs.getString("productName"));
                    map.put("quantity", rs.getInt("quantity"));
                    map.put("minStock", rs.getInt("min_stock"));
                    map.put("imageUrl", rs.getString("imageUrl"));
                    result.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
