package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.BlogReview;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BlogReviewDAO extends DBConnection {

    public List<BlogReview> getAllReviews() {
        List<BlogReview> list = new ArrayList<>();
        String sql = """
            SELECT br.id, br.blog_id, br.user_id, br.content, br.createdAt,
                   u.fullName AS display_name,
                   p.title AS blog_title
            FROM blog_reviews br
            LEFT JOIN users u ON br.user_id = u.id
            LEFT JOIN posts p ON br.blog_id = p.id
            ORDER BY br.createdAt DESC
            """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                BlogReview r = new BlogReview();
                r.setId(rs.getInt("id"));
                r.setBlogId(rs.getInt("blog_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setContent(rs.getString("content"));
                r.setCreatedAt(rs.getTimestamp("createdAt"));
                r.setUsername(rs.getString("display_name"));
                r.setBlogTitle(rs.getString("blog_title"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<BlogReview> getReviewsByBlogId(int blogId) {
        List<BlogReview> list = new ArrayList<>();
        String sql = "SELECT * FROM blog_reviews WHERE blog_id = ? ORDER BY createdAt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, blogId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BlogReview r = new BlogReview();
                r.setId(rs.getInt("id"));
                r.setBlogId(rs.getInt("blog_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setContent(rs.getString("content"));
                r.setCreatedAt(rs.getTimestamp("createdAt"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteReview(int id) {
        String sql = "DELETE FROM blog_reviews WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}