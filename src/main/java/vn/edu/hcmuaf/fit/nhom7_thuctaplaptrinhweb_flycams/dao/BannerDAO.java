package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Banner;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class BannerDAO extends DBConnection {
    public List<Banner> getAllBanners() {
        List<Banner> list = new ArrayList<>();
        String sql = "SELECT * FROM banner WHERE is_deleted = 0 ORDER BY order_index ASC, id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Banner b = new Banner(
                        rs.getInt("id"),    rs.getString("type"),
                        rs.getString("image_url"),
                        rs.getString("video_url"), rs.getString("link"),
                        rs.getInt("order_index"),
                        rs.getString("status"),  rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at")
                );
                b.setIsDeleted(rs.getInt("is_deleted"));
                b.setStartDate(rs.getTimestamp("start_date"));  b.setEndDate(rs.getTimestamp("end_date"));
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Banner> getDeletedBanners() {
        List<Banner> list = new ArrayList<>();
        String sql = "SELECT * FROM banner WHERE is_deleted = 1 ORDER BY order_index ASC, id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Banner b = new Banner(
                        rs.getInt("id"),
                        rs.getString("type"),
                        rs.getString("image_url"),
                        rs.getString("video_url"),
                        rs.getString("link"),
                        rs.getInt("order_index"),
                        rs.getString("status"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at")
                );
                b.setIsDeleted(rs.getInt("is_deleted"));
                b.setStartDate(rs.getTimestamp("start_date"));
                b.setEndDate(rs.getTimestamp("end_date"));
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    // Lấy banner theo trạng thái và chưa bị xóa
    public List<Banner> getBannersByStatus(String status) {
        List<Banner> list = new ArrayList<>();
        String sql = "SELECT * FROM banner WHERE status = ? AND is_deleted = 0 ORDER BY order_index ASC, id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Banner b = new Banner(
                        rs.getInt("id"),
                        rs.getString("type"),
                        rs.getString("image_url"),
                        rs.getString("video_url"),
                        rs.getString("link"),
                        rs.getInt("order_index"),
                        rs.getString("status"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at")
                );
                b.setIsDeleted(rs.getInt("is_deleted"));
                b.setStartDate(rs.getTimestamp("start_date"));
                b.setEndDate(rs.getTimestamp("end_date"));
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    // Lấy banner theo ID
    public Banner getBannerById(int id) {
        String sql = "SELECT * FROM banner WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Banner b = new Banner(
                        rs.getInt("id"),
                        rs.getString("type"),
                        rs.getString("image_url"),
                        rs.getString("video_url"),
                        rs.getString("link"),
                        rs.getInt("order_index"),
                        rs.getString("status"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at")
                );
                b.setIsDeleted(rs.getInt("is_deleted"));
                b.setStartDate(rs.getTimestamp("start_date"));
                b.setEndDate(rs.getTimestamp("end_date"));
                return b;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    // Thêm banner mới (bao gồm thông tin lập lịch hiển thị)
    public boolean addBanner(Banner banner) {
        String sql = "INSERT INTO banner (type, image_url, video_url, link, order_index, status, start_date, end_date) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, banner.getType());
            ps.setString(2, banner.getImageUrl());
            ps.setString(3, banner.getVideoUrl());
            ps.setString(4, banner.getLink());
            ps.setInt(5, banner.getOrderIndex());
            ps.setString(6, banner.getStatus());
            if (banner.getStartDate() != null) {
                ps.setTimestamp(7, banner.getStartDate());
            } else {
                ps.setNull(7, Types.TIMESTAMP);
            }
            if (banner.getEndDate() != null) {
                ps.setTimestamp(8, banner.getEndDate());
            } else {
                ps.setNull(8, Types.TIMESTAMP);
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean updateBanner(Banner banner) {
        String sql = "UPDATE banner SET type = ?, image_url = ?, video_url = ?, " +
                "link = ?, order_index = ?, status = ?, start_date = ?, end_date = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, banner.getType());
            ps.setString(2, banner.getImageUrl());
            ps.setString(3, banner.getVideoUrl());
            ps.setString(4, banner.getLink());
            ps.setInt(5, banner.getOrderIndex());
            ps.setString(6, banner.getStatus());
            if (banner.getStartDate() != null) {
                ps.setTimestamp(7, banner.getStartDate());
            } else {
                ps.setNull(7, Types.TIMESTAMP);
            }
            if (banner.getEndDate() != null) {
                ps.setTimestamp(8, banner.getEndDate());
            } else {
                ps.setNull(8, Types.TIMESTAMP);
            }
            ps.setInt(9, banner.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean deleteBanner(int id) {
        String sql = "UPDATE banner SET is_deleted = 1 WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean restoreBanner(int id) {
        String sql = "UPDATE banner SET is_deleted = 0 WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean hardDeleteBanner(int id) {
        String sql = "DELETE FROM banner WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateSortOrder(int id, int orderIndex) {
        String sql = "UPDATE banner SET order_index = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderIndex);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public List<Banner> getActiveBanners() {
        List<Banner> list = new ArrayList<>();
        String sql = """
SELECT * FROM banner 
WHERE status = 'active' AND is_deleted = 0 AND (start_date IS NULL OR start_date <= NOW())AND (end_date IS NULL OR end_date >= NOW())
ORDER BY order_index ASC, id ASC
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Banner b = new Banner(
                        rs.getInt("id"),rs.getString("type"),
                        rs.getString("image_url"), rs.getString("video_url"), rs.getString("link"),
                        rs.getInt("order_index"),rs.getString("status"),
                        rs.getTimestamp("created_at"), rs.getTimestamp("updated_at")
                );
                b.setIsDeleted(rs.getInt("is_deleted"));  b.setStartDate(rs.getTimestamp("start_date"));
                b.setEndDate(rs.getTimestamp("end_date"));  list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE banner SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}