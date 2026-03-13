package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderDaoAdmin {
    public List<Orders> getPendingOrders() {
        List<Orders> list = new ArrayList<>();

        String sql = """
                    SELECT o.id,
                           o.shippingCode,
                           o.totalPrice,
                           o.status,
                           o.phoneNumber,
                           o.createdAt,
                           o.paymentMethod,
                           u.fullName
                    FROM orders o
                    JOIN users u ON o.user_id = u.id
                    WHERE o.status = 'Xác nhận'
                    ORDER BY o.createdAt DESC
                """;

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Orders o = new Orders();
                o.setId(rs.getInt("id"));
                o.setShippingCode(rs.getString("shippingCode"));
                o.setTotalPrice(rs.getDouble("totalPrice"));
                o.setPhoneNumber(rs.getString("phoneNumber"));
                o.setCreatedAt(rs.getTimestamp("createdAt"));
                o.setPaymentMethod(rs.getString("paymentMethod"));
                o.setCustomerName(rs.getString("fullName"));

                Orders.Status status = Orders.Status.fromDB(rs.getString("status"));
                o.setStatus(status);

                o.setStatusLabel("Chưa xác nhận");
                o.setStatusClass("bg-warning text-dark");

                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Object> getOrderDetail(int orderId) {
        Map<String, Object> map = new HashMap<>();
        String sql = """
                    SELECT
                        o.id,
                        o.totalPrice,
                        o.phoneNumber,
                        o.createdAt,
                        o.shippingCode,
                        o.paymentMethod,
                        o.note,
                        o.status,
                        o.user_id,
                        u.fullName,
                        u.email,
                        o.completedAt,
                        a.addressLine,
                        CONCAT(
                            a.addressLine, ', ',
                            a.district, ', ',
                            a.province
                        ) AS fullAddress

                    FROM orders o
                    JOIN users u ON o.user_id = u.id
                    LEFT JOIN addresses a ON o.address_id = a.id
                    WHERE o.id = ?
                """;
        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                map.put("id", rs.getInt("id"));
                map.put("customerName", rs.getString("fullName"));
                map.put("email", rs.getString("email"));
                map.put("phoneNumber", rs.getString("phoneNumber"));
                map.put("totalPrice", rs.getDouble("totalPrice"));
                map.put("createdAt", rs.getTimestamp("createdAt"));
                map.put("shippingCode", rs.getString("shippingCode"));
                map.put("paymentMethod", rs.getString("paymentMethod"));
                map.put("note", rs.getString("note"));
                map.put("status", rs.getString("status"));
                map.put("address", rs.getString("addressLine"));
                map.put("user_id", rs.getInt("user_id"));
                map.put("fullAddress", rs.getString("fullAddress"));
                map.put("completedAt", rs.getTimestamp("completedAt")); // <-- dòng này
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public List<Map<String, Object>> getOrderItems(int orderId) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
                    SELECT
                        p.productName,
                        oi.quantity,
                        oi.price
                    FROM order_items oi
                    JOIN products p ON oi.product_id = p.id
                    WHERE oi.order_id = ?
                """;

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            int count = 0;
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("productName", rs.getString("productName"));
                map.put("quantity", rs.getInt("quantity"));
                map.put("price", rs.getDouble("price"));
                list.add(map);
                count++;

                String productName = rs.getString("productName");
                int quantity = rs.getInt("quantity");
                double price = rs.getDouble("price");
                System.out.println("Item " + count + ": "
                        + productName + " | "
                        + quantity + " | "
                        + price);
                System.out.println("Thành công");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateOrderStatusAndShippingCode(int orderId, String status, String shippingCode) {
        String sql = "UPDATE orders SET `status` = ?, `shippingCode` = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("Update orderId=" + orderId + ", status=" + status + ", shippingCode=" + shippingCode);

            ps.setString(1, status);
            ps.setString(2, shippingCode);
            ps.setInt(3, orderId);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET `status` = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("Update orderId=" + orderId + ", status=" + status);

            ps.setString(1, status);
            ps.setInt(2, orderId);

            int rows = ps.executeUpdate();
            System.out.println("Rows affected = " + rows);

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Orders> getOrdersForAdmin() {
        List<Orders> list = new ArrayList<>();

        String sql = """
                    SELECT
                        o.id,
                        o.user_id,
                        o.shippingCode,
                        o.status,
                        o.createdAt,
                        o.completedAt,
                        CONCAT_WS(', ',
                                            a.addressLine,
                                            a.district,
                                            a.province
                                        ) AS fullAddress
                    FROM orders o
                    LEFT JOIN addresses a ON o.address_id = a.id
                    WHERE o.status <> 'Xác nhận'
                    ORDER BY o.createdAt DESC
                """;

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Orders o = new Orders();

                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setShippingCode(rs.getString("shippingCode"));

                Orders.Status status = Orders.Status.fromDB(rs.getString("status"));
                o.setStatus(status);

                o.setCreatedAt(rs.getTimestamp("createdAt"));

                // Thêm completedAt
                Timestamp completedTs = rs.getTimestamp("completedAt");
                o.setCompletedAt(completedTs != null ? completedTs : null);

                o.setFullAddress(rs.getString("fullAddress"));

                // set label + class cho view
                setStatusView(o);

                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private void setStatusView(Orders o) {
        switch (o.getStatus()) {
            case PROCESSING -> {
                o.setStatusLabel("Đang xử lý");
                o.setStatusClass("bg-warning text-dark");
            }
            case OUT_FOR_DELIVERY -> {
                o.setStatusLabel("Đang giao hàng");
                o.setStatusClass("bg-primary");
            }
            case DELIVERED -> {
                o.setStatusLabel("Giao thành công");
                o.setStatusClass("bg-success");
            }
            case CANCELLED -> {
                o.setStatusLabel("Đã hủy");
                o.setStatusClass("bg-danger");
            }
            default -> {
                o.setStatusLabel("Xác nhận");
                o.setStatusClass("bg-secondary");
            }
        }
    }

    public boolean updateOrderFull(
            int orderId,
            int userId,
            String fullName,
            String email,
            String phoneNumber,
            String addressLine,
            String province,
            String district,
            String paymentMethod,
            String status,
            String note,
            LocalDate completedAt) {

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String sqlUser = """
                        UPDATE users
                        SET fullName = ?, email = ?
                        WHERE id = ?
                    """;
            try (PreparedStatement ps = con.prepareStatement(sqlUser)) {
                ps.setString(1, fullName);
                ps.setString(2, email);
                ps.setInt(3, userId);
                ps.executeUpdate();
            }

            String sqlOrder = """
                        UPDATE orders
                        SET phoneNumber = ?,
                            paymentMethod = ?,
                            status = ?,
                            note = ?,
                            completedAt = ?
                        WHERE id = ?
                    """;
            try (PreparedStatement ps = con.prepareStatement(sqlOrder)) {
                ps.setString(1, phoneNumber);
                ps.setString(2, paymentMethod);
                ps.setString(3, status);
                ps.setString(4, note);

                if (completedAt != null)
                    ps.setTimestamp(5, Timestamp.valueOf(completedAt.atStartOfDay()));
                else
                    ps.setNull(5, Types.TIMESTAMP);

                ps.setInt(6, orderId);
                ps.executeUpdate();
            }

            String sqlAddress = """
                        UPDATE addresses a
                        JOIN orders o ON o.address_id = a.id
                        SET a.addressLine = ?, a.province = ?, a.district = ?
                        WHERE o.id = ?
                    """;
            try (PreparedStatement ps = con.prepareStatement(sqlAddress)) {
                ps.setString(1, addressLine); // vd: "123 Nguyễn Trãi"
                ps.setString(2, province); // vd: "TP.HCM"
                ps.setString(3, district); // vd: "Quận 1"
                ps.setInt(4, orderId); // WHERE o.id = ?
                ps.executeUpdate();
            }

            con.commit();
            return true;

        } catch (Exception e) {
            try {
                if (con != null)
                    con.rollback();
            } catch (Exception ignored) {
            }
            e.printStackTrace();
        } finally {
            try {
                if (con != null)
                    con.setAutoCommit(true);
            } catch (Exception ignored) {
            }
        }

        return false;
    }

}
