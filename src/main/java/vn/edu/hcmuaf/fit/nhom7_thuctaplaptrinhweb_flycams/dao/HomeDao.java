package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Post;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class HomeDao {
    public List<Product> getBestSellerProducts(int limit) {
        List<Product> list = new ArrayList<>();
        String sql = """
                SELECT p.id,
                       p.productName,
                       p.price,
                       p.finalPrice,
                       i.imageUrl,
                       COALESCE(rv.avgRating, 0) AS avgRating,
                       COALESCE(rv.reviewCount, 0) AS reviewCount
                FROM (
                    SELECT product_id, COUNT(*) AS totalAppear
                    FROM order_items
                    GROUP BY product_id
                ) oi
                JOIN products p ON oi.product_id = p.id
                LEFT JOIN images i
                    ON p.id = i.product_id AND i.imageType = 'Chính'
                LEFT JOIN (
                    SELECT product_id,
                           AVG(rating) AS avgRating,
                           COUNT(*) AS reviewCount
                    FROM reviews
                    GROUP BY product_id
                ) rv ON p.id = rv.product_id
                WHERE p.status = 'active'
                ORDER BY oi.totalAppear DESC
                LIMIT ?
                """;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setProductName(rs.getString("productName"));
                p.setPrice(rs.getDouble("price"));
                p.setFinalPrice(rs.getDouble("finalPrice"));
                p.setMainImage(rs.getString("imageUrl"));
                p.setAvgRating(rs.getDouble("avgRating"));
                p.setReviewCount(rs.getInt("reviewCount"));
                list.add(p);
                System.out.println("Thành công");
                System.out.println(
                        "[HomeDao] id=" + p.getId() +
                                ", rating=" + p.getAvgRating() +
                                ", reviews=" + p.getReviewCount());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Product> getTopReviewedProducts(int limit) {
        List<Product> list = new ArrayList<>();
        String sql = """
                    SELECT p.id,
                           p.productName,
                           p.price,
                           p.finalPrice,
                           i.imageUrl,
                           COALESCE(rv.avgRating, 0) AS avgRating,
                           COALESCE(rv.reviewCount, 0) AS reviewCount
                    FROM products p
                    LEFT JOIN images i
                        ON p.id = i.product_id AND i.imageType = 'Chính'
                    LEFT JOIN (
                        SELECT product_id,
                               AVG(rating) AS avgRating,
                               COUNT(*) AS reviewCount
                        FROM reviews
                        GROUP BY product_id
                    ) rv ON p.id = rv.product_id
                    WHERE p.status = 'active'
                    ORDER BY rv.reviewCount DESC
                    LIMIT ?
                """;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setProductName(rs.getString("productName"));
                p.setPrice(rs.getDouble("price"));
                p.setFinalPrice(rs.getDouble("finalPrice"));
                p.setMainImage(rs.getString("imageUrl"));
                p.setAvgRating(rs.getDouble("avgRating"));
                p.setReviewCount(rs.getInt("reviewCount"));
                list.add(p);
                System.out.println(
                        "[TopReview] id=" + p.getId() +
                                ", reviews=" + p.getReviewCount());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Product> getProductsByCategory(int categoryId, int limit) {
        List<Product> list = new ArrayList<>();
        String sql = """
                    SELECT p.id,
                           p.productName,
                           p.price,
                           p.finalPrice,
                           i.imageUrl,
                           COALESCE(rv.avgRating, 0) AS avgRating,
                           COALESCE(rv.reviewCount, 0) AS reviewCount
                    FROM products p
                    LEFT JOIN images i
                        ON p.id = i.product_id AND i.imageType = 'Chính'
                    LEFT JOIN (
                        SELECT product_id,
                               AVG(rating) AS avgRating,
                               COUNT(*) AS reviewCount
                        FROM reviews
                        GROUP BY product_id
                    ) rv ON p.id = rv.product_id
                    WHERE p.status = 'active'
                      AND p.category_id = ?
                    ORDER BY p.id DESC
                    LIMIT ?
                """;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setProductName(rs.getString("productName"));
                p.setPrice(rs.getDouble("price"));
                p.setFinalPrice(rs.getDouble("finalPrice"));
                p.setMainImage(rs.getString("imageUrl"));
                p.setAvgRating(rs.getDouble("avgRating"));
                p.setReviewCount(rs.getInt("reviewCount"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    // Lấy 8 bài viết mới nhất
    public List<Post> getLatestPosts(int limit) {
        List<Post> list = new ArrayList<>();
        String sql = """
                    SELECT id,
                           title,
                           content,
                           image,
                           createdAt,
                           product_id
                    FROM posts
                    ORDER BY createdAt DESC
                    LIMIT ?
                """;
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Post p = new Post(
                            rs.getInt("id"),
                            rs.getString("title"),
                            rs.getString("content"),
                            rs.getString("image"),
                            rs.getTimestamp("createdAt"),
                            rs.getInt("product_id"));
                    list.add(p);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Lấy danh sách sản phẩm có lượt xem cao nhất
     * 
     * @param limit Số lượng sản phẩm cần lấy
     * @return Danh sách sản phẩm được sắp xếp theo lượt xem giảm dần
     */
    public List<Product> getTopViewedProducts(int limit) {
        List<Product> list = new ArrayList<>();

        String sql = """
                    SELECT p.id,
                           p.productName,
                           p.price,
                           p.finalPrice,
                           p.view,
                           i.imageUrl,
                           COALESCE(rv.avgRating, 0) AS avgRating,
                           COALESCE(rv.reviewCount, 0) AS reviewCount
                    FROM products p
                    LEFT JOIN images i
                        ON p.id = i.product_id AND i.imageType = 'Chính'
                    LEFT JOIN (
                        SELECT product_id,
                               AVG(rating) AS avgRating,
                               COUNT(*) AS reviewCount
                        FROM reviews
                        GROUP BY product_id
                    ) rv ON p.id = rv.product_id
                    WHERE p.status = 'active'
                    ORDER BY p.view DESC
                    LIMIT ?
                """;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setProductName(rs.getString("productName"));
                p.setPrice(rs.getDouble("price"));
                p.setFinalPrice(rs.getDouble("finalPrice"));
                p.setView(rs.getInt("view"));
                p.setMainImage(rs.getString("imageUrl"));
                p.setAvgRating(rs.getDouble("avgRating"));
                p.setReviewCount(rs.getInt("reviewCount"));

                list.add(p);

                System.out.println(
                        "[TopViewed] id=" + p.getId() +
                                ", views=" + p.getView() +
                                ", reviews=" + p.getReviewCount());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}
