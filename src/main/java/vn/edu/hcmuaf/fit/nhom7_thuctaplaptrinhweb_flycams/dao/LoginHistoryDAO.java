package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.LoginHistory;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LoginHistoryDAO {
    public boolean insert(LoginHistory history) {
        String sql = """
            INSERT INTO login_history (user_id, username, ip_address, location, status, user_agent)
            VALUES (?, ?, ?, ?, ?, ?)
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (history.getUserId() != null) {
                ps.setInt(1, history.getUserId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, history.getUsername());
            ps.setString(3, history.getIpAddress());   ps.setString(4, history.getLocation());
            ps.setString(5, history.getStatus());
            ps.setString(6, history.getUserAgent());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<LoginHistory> getLoginHistoryByUserId(int userId, int limit) {
        List<LoginHistory> list = new ArrayList<>();
        String sql = """
            SELECT * FROM login_history WHERE user_id = ? ORDER BY login_time DESC LIMIT ?
        """;
        try (Connection conn = DBConnection.getConnection();   PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LoginHistory lh = new LoginHistory();
                    lh.setId(rs.getInt("id"));
                    int uid = rs.getInt("user_id");
                    lh.setUserId(rs.wasNull() ? null : uid); lh.setUsername(rs.getString("username"));
                    lh.setLoginTime(rs.getTimestamp("login_time"));
                    lh.setIpAddress(rs.getString("ip_address"));     lh.setLocation(rs.getString("location"));
                    lh.setStatus(rs.getString("status"));    lh.setUserAgent(rs.getString("user_agent"));
                    list.add(lh);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}