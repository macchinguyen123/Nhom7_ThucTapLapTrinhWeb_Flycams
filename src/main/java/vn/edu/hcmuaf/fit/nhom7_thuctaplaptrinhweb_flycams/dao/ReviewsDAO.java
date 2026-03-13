package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Reviews;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReviewsDAO {

    public boolean hasUserReviewedProduct(int userId, int productId) {
        String sql = "SELECT COUNT(*) > 0 FROM reviews WHERE user_id = ? AND product_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBoolean(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void saveReview(int userId, int productId, int rating, String content) {
        String sql = """
                    INSERT INTO reviews (user_id, product_id, rating, content)
                    VALUES (?, ?, ?, ?)
                    ON DUPLICATE KEY UPDATE rating=?, content=?, createdAt=NOW()
                """;


        System.out.println("=== [DAO] saveReview ===");
        System.out.println("userId    = " + userId);
        System.out.println("productId = " + productId);
        System.out.println("rating    = " + rating);
        System.out.println("content   = " + content);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setInt(3, rating);
            ps.setString(4, content);
            ps.setInt(5, rating);
            ps.setString(6, content);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public double getAverageRating(int productId) {
        String sql = "SELECT AVG(rating) FROM reviews WHERE product_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countReviews(int productId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE product_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countByStar(int productId, int star) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE product_id=? AND rating=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ps.setInt(2, star);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countWithComment(int productId) {
        String sql = """
                    SELECT COUNT(*) 
                    FROM reviews 
                    WHERE product_id=? 
                      AND content IS NOT NULL 
                      AND TRIM(content) <> ''
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    public List<Reviews> getReviewsByProductPaging(int productId, int page, int pageSize) {
        List<Reviews> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String sql = """
                SELECT r.*, u.username, u.avatar
                FROM reviews r
                JOIN users u ON r.user_id = u.id
                WHERE r.product_id = ?
                ORDER BY r.createdAt DESC
                LIMIT ? OFFSET ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ps.setInt(2, pageSize);
            ps.setInt(3, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Reviews r = new Reviews();
                r.setId(rs.getInt("id"));
                r.setProductId(rs.getInt("product_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setRating(rs.getInt("rating"));
                r.setContent(rs.getString("content"));
                r.setCreatedAt(rs.getTimestamp("createdAt"));
                // ====== USER INFO ======
                r.setUsername(rs.getString("username"));
                r.setAvatar(rs.getString("avatar"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


}
