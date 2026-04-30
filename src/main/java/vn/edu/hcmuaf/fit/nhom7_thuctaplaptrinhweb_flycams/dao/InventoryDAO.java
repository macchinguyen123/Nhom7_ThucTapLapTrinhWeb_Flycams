package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.InventoryImport;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
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
}