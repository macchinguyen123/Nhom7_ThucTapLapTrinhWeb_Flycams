package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.InventoryImport;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
public class InventoryDAO {
    public boolean addInventoryImport(InventoryImport imp) {
        String sql = "INSERT INTO inventory_import (product_id, quantity, import_price, created_at, created_by, note) VALUES (?, ?, ?, NOW(), ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, imp.getProductId());
            ps.setInt(2, imp.getQuantity());
            ps.setBigDecimal(3, imp.getImportPrice());
            if (imp.getCreatedBy() != null) {
                ps.setInt(4, imp.getCreatedBy());
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            ps.setString(5, imp.getNote());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                updateProductQuantity(conn, imp.getProductId());
                return true;
            }
        } catch (Exception e) {
            String altSql = "INSERT INTO inventory_import (productId, quantity, importPrice, createdAt, createdBy, note) VALUES (?, ?, ?, NOW(), ?, ?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(altSql)) {
                ps.setInt(1, imp.getProductId());
                ps.setInt(2, imp.getQuantity());
                ps.setBigDecimal(3, imp.getImportPrice());
                if (imp.getCreatedBy() != null) {
                    ps.setInt(4, imp.getCreatedBy());
                } else {
                    ps.setNull(4, java.sql.Types.INTEGER);
                }
                ps.setString(5, imp.getNote());
                
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    updateProductQuantity(conn, imp.getProductId());
                    return true;
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return false;
    }
    private void updateProductQuantity(Connection conn, int productId) throws SQLException {
        int totalImported = getTotalImported(conn, productId);
        int totalSold = getTotalSold(conn, productId);
        int inventory = totalImported - totalSold;
        String sql = "UPDATE products SET quantity = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inventory);
            ps.setInt(2, productId);
            ps.executeUpdate();
        }
    }
    public int getTotalImported(Connection conn, int productId) throws SQLException {
        String sql = "SELECT SUM(quantity) FROM inventory_import WHERE product_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            String altSql = "SELECT SUM(quantity) FROM inventory_import WHERE productId = ?";
            try (PreparedStatement ps = conn.prepareStatement(altSql)) {
                ps.setInt(1, productId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        }
        return 0;
    }
    public int getTotalSold(Connection conn, int productId) throws SQLException {
        String sql = "SELECT SUM(oi.quantity) FROM order_items oi JOIN orders o ON oi.order_id = o.id WHERE oi.product_id = ? AND o.status != 'Hủy' AND o.status != 'Yêu cầu trả hàng' AND o.status != 'Đã trả hàng'";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    public Map<String, Object> getInventoryStats(int productId) {
        Map<String, Object> stats = new HashMap<>();
        try (Connection conn = DBConnection.getConnection()) {
            int totalImported = getTotalImported(conn, productId);
            int totalSold = getTotalSold(conn, productId);
            int inventory = totalImported - totalSold;
            double salesRatio = 0;
            if (totalImported > 0) {
                salesRatio = (double) totalSold / totalImported * 100;
            }
            stats.put("totalImported", totalImported);
            stats.put("totalSold", totalSold);
            stats.put("inventory", inventory);
            stats.put("salesRatio", salesRatio);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }
    public int getTotalInventoryRecords(String search) {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM products p LEFT JOIN categories c ON p.category_id = c.id WHERE p.productName LIKE ? OR CAST(p.id AS CHAR) LIKE ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchPattern = "%" + (search != null ? search : "") + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }
    public List<Map<String, Object>> getInventoryList(int limit, int offset, String search) {
        List<Map<String, Object>> list = new java.util.ArrayList<>();
        String sql = "SELECT p.id, p.productName as productName, c.categoryName as categoryName, " +
                     "(SELECT imageUrl FROM images WHERE product_id = p.id ORDER BY (CASE WHEN imageType = 'Chính' THEN 1 WHEN imageType = 'Phụ' THEN 2 ELSE 3 END) ASC, id ASC LIMIT 1) as imageUrl, " +
                     "(SELECT COALESCE(SUM(quantity), 0) FROM inventory_import WHERE product_id = p.id) as totalImported, " + 
                     "(SELECT COALESCE(SUM(oi.quantity), 0) FROM order_items oi JOIN orders o ON oi.order_id = o.id WHERE oi.product_id = p.id AND o.status NOT IN ('Hủy', 'Yêu cầu trả hàng', 'Đã trả hàng')) as totalSold, " + 
                     "p.quantity as currentStock, p.status " +
                     "FROM products p " + 
                     "LEFT JOIN categories c ON p.category_id = c.id " +
                     "WHERE p.productName LIKE ? OR CAST(p.id AS CHAR) LIKE ? " +
                     "ORDER BY p.id DESC LIMIT ? OFFSET ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchPattern = "%" + (search != null ? search : "") + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setInt(3, limit);
            ps.setInt(4, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> record = new HashMap<>();
                    int id = rs.getInt("id");
                    int totalImported = rs.getInt("totalImported");
                    int totalSold = rs.getInt("totalSold");
                    int currentStock = totalImported - totalSold;
                    record.put("id", id);
                    record.put("productName", rs.getString("productName"));
                    record.put("categoryName", rs.getString("categoryName"));
                    record.put("imageUrl", rs.getString("imageUrl"));
                    record.put("totalImported", totalImported);
                    record.put("totalSold", totalSold);
                    record.put("currentStock", currentStock);
                    String status = rs.getString("status");
                    if (currentStock <= 0) {
                        status = "Hết hàng";
                    } else if (currentStock < 10) {
                        status = "Sắp hết hàng";
                    }
                    record.put("status", status);
                    list.add(record);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Map<String, Object>> getImportHistory(int productId, int days) {
        List<Map<String, Object>> list = new java.util.ArrayList<>();
        String sql = "SELECT quantity, import_price as price, created_at as date, note " + "FROM inventory_import " +
    "WHERE product_id = ? AND created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " + "ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, days);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> record = new HashMap<>();
                    record.put("quantity", rs.getInt("quantity"));
                    record.put("price", rs.getBigDecimal("price"));
                    record.put("date", rs.getTimestamp("date") != null ? rs.getTimestamp("date").toString() : null);
                    record.put("note", rs.getString("note"));
                    record.put("type", "IMPORT");
                    list.add(record);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Map<String, Object>> getExportHistory(int productId, int days) {
        List<Map<String, Object>> list = new java.util.ArrayList<>();
        String sql = "SELECT oi.quantity, oi.price, o.order_date as date, o.id as orderId " + "FROM order_items oi " +
    "JOIN orders o ON oi.order_id = o.id " + "WHERE oi.product_id = ? AND o.status NOT IN ('Hủy', 'Yêu cầu trả hàng', 'Đã trả hàng') " +
    "AND o.order_date >= DATE_SUB(NOW(), INTERVAL ? DAY) " + "ORDER BY o.order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, days);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> record = new HashMap<>();
                    record.put("quantity", rs.getInt("quantity"));
                    record.put("price", rs.getBigDecimal("price"));
                    record.put("date", rs.getTimestamp("date") != null ? rs.getTimestamp("date").toString() : null);
                    record.put("orderId", rs.getInt("orderId"));
                    record.put("type", "EXPORT");
                    list.add(record);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}