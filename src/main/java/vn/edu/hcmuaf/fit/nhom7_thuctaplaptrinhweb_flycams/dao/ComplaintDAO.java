package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Complaint;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    public boolean createComplaint(int userId, String content) {
        String sql = "INSERT INTO complaints(userId, content, status, createdAt, updatedAt) " +
                "VALUES (?, ?, 0, NOW(), NOW())";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, content);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Complaint> getAllComplaints() {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT c.*, u.email as userEmail, u.fullName as userFullName, u.phoneNumber as userPhone " +
                "FROM complaints c " +
                "JOIN users u ON c.userId = u.id " +
                "ORDER BY c.createdAt DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Complaint c = new Complaint();
                c.setId(rs.getInt("id"));
                c.setUserId(rs.getInt("userId"));
                c.setContent(rs.getString("content"));
                c.setStatus(rs.getInt("status"));
                c.setAdminNote(rs.getString("adminNote"));
                c.setCreatedAt(rs.getTimestamp("createdAt"));
                c.setUpdatedAt(rs.getTimestamp("updatedAt"));
                c.setUserEmail(rs.getString("userEmail"));
                c.setUserFullName(rs.getString("userFullName"));
                c.setUserPhone(rs.getString("userPhone"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateComplaintStatus(int complaintId, int status, String adminNote) {
        String sql = "UPDATE complaints SET status = ?, adminNote = ?, updatedAt = NOW() WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setString(2, adminNote);
            ps.setInt(3, complaintId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getPendingComplaintsCount() {
        String sql = "SELECT COUNT(id) FROM complaints WHERE status = 0";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
