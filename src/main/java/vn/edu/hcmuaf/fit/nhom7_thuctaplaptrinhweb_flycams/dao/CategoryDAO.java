package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Categories;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    public List<Categories> getCategoriesForHeader() {
        List<Categories> list = new ArrayList<>();
        String sql = """
                    SELECT id, categoryName, image
                    FROM categories
                    WHERE status = 'Hiện'
                    ORDER BY sort_order ASC
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Categories c = new Categories();
                c.setId(rs.getInt("id"));
                c.setCategoryName(rs.getString("categoryName"));
                c.setImage(rs.getString("image"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateSortOrder(int id, int sortOrder) {
        String sql = "UPDATE categories SET sort_order = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sortOrder);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Categories getCategoryById(int id) {
        Categories c = null;
        String sql = "SELECT * FROM categories WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                c = new Categories(
                        rs.getInt("id"),
                        rs.getString("categoryName"),
                        rs.getString("image"),
                        rs.getString("status"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return c;
    }

    public String getCategoryNameById(int id) {
        String sql = "SELECT categoryName FROM categories WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getString("categoryName");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(Categories c) {
        String sqlGetMaxOrder = "SELECT COALESCE(MAX(sort_order), 0) + 1 FROM categories";
        String sqlInsert = "INSERT INTO categories (categoryName, image, status, sort_order) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection()) {
            int nextSortOrder = 1;
            try (PreparedStatement psMax = conn.prepareStatement(sqlGetMaxOrder);
                 ResultSet rs = psMax.executeQuery()) {
                if (rs.next()) {
                    nextSortOrder = rs.getInt(1);
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
                ps.setString(1, c.getCategoryName());
                ps.setString(2, c.getImage());
                ps.setString(3, c.getStatus());
                ps.setInt(4, nextSortOrder);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Categories c) {
        String sql = "UPDATE categories SET categoryName = ?, image = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getCategoryName());
            ps.setString(2, c.getImage());
            ps.setString(3, c.getStatus());
            ps.setInt(4, c.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM categories WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Categories> getAllCategoriesAdmin() {
        List<Categories> list = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY sort_order ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Categories c = new Categories(
                        rs.getInt("id"),
                        rs.getString("categoryName"),
                        rs.getString("image"),
                        rs.getString("status")
                );
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
