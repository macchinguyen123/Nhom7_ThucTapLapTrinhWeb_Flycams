package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class ProductDAO {
    public List<Product> getProductsByPromotion(int promotionId) {
        List<Product> list = new ArrayList<>();
        String sql = """
                    SELECT
                        p.id,
                        p.productName,
                        p.price,
                        p.finalPrice,
                        i.imageUrl AS mainImage,
                        COALESCE(AVG(r.rating), 0) AS avgRating,
                        COUNT(r.id) AS reviewCount
                    FROM products p
                    JOIN promotion_target pt
                        ON (
                            pt.targetType = 'tất cả'
                            OR (pt.targetType = 'sản phẩm' AND p.id = pt.product_id)
                            OR (pt.targetType = 'danh mục' AND p.category_id = pt.category_id)
                        )
                    LEFT JOIN images i
                        ON p.id = i.product_id
                        AND i.imageType = 'Chính'
                    LEFT JOIN reviews r
                        ON p.id = r.product_id
                    WHERE pt.promotion_id = ?
                    GROUP BY
                        p.id, p.productName, p.price, p.finalPrice, i.imageUrl
                    ORDER BY p.productName ASC
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, promotionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setProductName(rs.getString("productName"));
                p.setPrice(rs.getDouble("price"));
                p.setFinalPrice(rs.getDouble("finalPrice"));
                p.setMainImage(rs.getString("mainImage"));
                p.setAvgRating(rs.getDouble("avgRating"));
                p.setReviewCount(rs.getInt("reviewCount"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> searchProducts(String keyword,
                                        String priceFilter, Double minPrice,
                                        Double maxPrice,
                                        List<String> brands,
                                        String sortBy) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
                    SELECT p.*,
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
                    WHERE p.productName LIKE ?
                """);
        if (minPrice != null && maxPrice != null) {
            sql.append(" AND p.finalPrice BETWEEN ? AND ? ");
        } else if (minPrice != null) {
            sql.append(" AND p.finalPrice >= ? ");
        } else if (maxPrice != null) {
            sql.append(" AND p.finalPrice <= ? ");
        }
        if (brands != null && !brands.isEmpty()) {
            sql.append(" AND p.brandName IN (");
            sql.append(brands.stream().map(b -> "?").collect(Collectors.joining(",")));
            sql.append(") ");
        }
        if ("low-high".equals(sortBy))
            sql.append(" ORDER BY p.finalPrice ASC ");
        else if ("high-low".equals(sortBy))
            sql.append(" ORDER BY p.finalPrice DESC ");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setString(idx++, "%" + (keyword == null ? "" : keyword) + "%");
            if (minPrice != null && maxPrice != null) {
                ps.setDouble(idx++, minPrice);
                ps.setDouble(idx++, maxPrice);
            } else if (minPrice != null) {
                ps.setDouble(idx++, minPrice);
            } else if (maxPrice != null) {
                ps.setDouble(idx++, maxPrice);
            }
            if (brands != null && !brands.isEmpty()) {
                for (String b : brands) {
                    ps.setString(idx++, b);
                }
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getString("brandName"),
                        rs.getString("productName"),
                        rs.getString("description"),
                        rs.getString("parameter"),
                        rs.getDouble("price"),
                        rs.getDouble("finalPrice"),
                        rs.getString("warranty"),
                        rs.getInt("quantity"),
                        rs.getString("status"));
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

    public List<Product> searchProductsInCategory(
            int categoryId,
            String keyword,
            Double minPrice,
            Double maxPrice,
            List<String> brands,
            String sortBy
    ) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
                    SELECT p.id,
                           p.productName,
                           p.price,
                           p.finalPrice,
                           p.brandName,
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
                """);
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND p.productName LIKE ?");
        }
        if (minPrice != null) {
            sql.append(" AND p.finalPrice >= ?");
        }
        if (maxPrice != null) {
            sql.append(" AND p.finalPrice <= ?");
        }
        if (brands != null && !brands.isEmpty()) {
            sql.append(" AND p.brand IN (");
            for (int i = 0; i < brands.size(); i++) {
                sql.append("?");
                if (i < brands.size() - 1)
                    sql.append(",");
            }
            sql.append(")");
        }
        if ("low-high".equals(sortBy)) {
            sql.append(" ORDER BY p.finalPrice ASC");
        } else if ("high-low".equals(sortBy)) {
            sql.append(" ORDER BY p.finalPrice DESC");
        } else {
            sql.append(" ORDER BY p.id DESC");
        }
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, categoryId);
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + keyword.trim() + "%");
            }
            if (minPrice != null) {
                ps.setDouble(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                ps.setDouble(paramIndex++, maxPrice);
            }
            if (brands != null && !brands.isEmpty()) {
                for (String brand : brands) {
                    ps.setString(paramIndex++, brand);
                }
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setProductName(rs.getString("productName"));
                p.setPrice(rs.getDouble("price"));
                p.setFinalPrice(rs.getDouble("finalPrice"));
                p.setBrandName(rs.getString("brandName"));
                p.setMainImage(rs.getString("imageUrl"));
                p.setAvgRating(rs.getDouble("avgRating")); // ← Thêm dòng này
                p.setReviewCount(rs.getInt("reviewCount")); // ← Thêm dòng này
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Product getProductById(int id) {
        ImageDAO imageDAO = new ImageDAO();
        String sql = "SELECT * FROM products WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    System.out.println("[ProductDAO] Found product name = " + rs.getString("productName"));
                    Product p = new Product(
                            rs.getInt("id"),
                            rs.getInt("category_id"),
                            rs.getString("brandName"),
                            rs.getString("productName"),
                            rs.getString("description"),
                            rs.getString("parameter"),
                            rs.getDouble("price"),
                            rs.getDouble("finalPrice"),
                            rs.getString("warranty"),
                            rs.getInt("quantity"),
                            rs.getString("status"));
                    p.setView(rs.getInt("view"));
                    p.setImages(imageDAO.getImagesByProduct(p.getId()));
                    return p;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Map<String, Object>> getProductSuggestions(String keyword) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                    SELECT id, productName
                    FROM products
                    WHERE LOWER(productName) LIKE LOWER(?)
                    LIMIT 8
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("id", rs.getInt("id"));
                m.put("name", rs.getString("productName"));
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getRelatedProducts(int categoryId, int excludeProductId, int limit) {
        List<Product> list = new ArrayList<>();
        System.out.println("===== [getRelatedProducts] START =====");
        System.out.println("categoryId = " + categoryId);
        System.out.println("excludeProductId = " + excludeProductId);
        System.out.println("limit = " + limit);
        String sql = """
                    SELECT p.*, i.imageUrl, COUNT(r.id) AS reviewCount,  IFNULL(AVG(r.rating), 0) AS avgRating
                    FROM products p
                    LEFT JOIN images i
                      ON p.id = i.product_id AND i.imageType = 'Chính'
                    LEFT JOIN reviews r
                      ON p.id = r.product_id
                    WHERE p.category_id = ?
                      AND p.id <> ?
                    GROUP BY p.id
                    ORDER BY RAND()
                    LIMIT ?
                """;
        System.out.println("SQL = \n" + sql);
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, excludeProductId);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            int count = 0;
            while (rs.next()) {
                count++;
                Product p = new Product(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getString("brandName"),
                        rs.getString("productName"),
                        rs.getString("description"),
                        rs.getString("parameter"),
                        rs.getDouble("price"),
                        rs.getDouble("finalPrice"),
                        rs.getString("warranty"),
                        rs.getInt("quantity"),
                        rs.getString("status"));
                String imageUrl = rs.getString("imageUrl");
                p.setMainImage(imageUrl);
                p.setAvgRating(rs.getDouble("avgRating"));
                p.setReviewCount(rs.getInt("reviewCount"));
                list.add(p);
            }
            System.out.println("→ Total related products found = " + count);
        } catch (Exception e) {
            System.out.println(" ERROR in getRelatedProducts");
            e.printStackTrace();
        }
        System.out.println("===== [getRelatedProducts] END =====");
        return list;
    }

    public List<Product> getAllProductsForAdmin() {
        List<Product> list = new ArrayList<>();
        String sql = """
                    SELECT p.id,
                           p.productName,
                           p.brandName,
                           c.categoryName AS categoryName,
                           p.price,
                           p.finalPrice,
                           p.quantity,
                           p.status,
                           i.imageUrl AS mainImage
                    FROM products p
                    JOIN categories c ON p.category_id = c.id
                    LEFT JOIN images i
                        ON p.id = i.product_id
                      AND i.imageType = 'Chính'
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setProductName(rs.getString("productName"));
                p.setBrandName(rs.getString("brandName"));
                p.setCategoryName(rs.getString("categoryName"));
                p.setPrice(rs.getDouble("price"));
                p.setFinalPrice(rs.getDouble("finalPrice"));
                p.setQuantity(rs.getInt("quantity"));
                p.setStatus(rs.getString("status"));
                p.setMainImage(rs.getString("mainImage"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean incrementViewCount(int productId) {
        String sql = "UPDATE products SET view = view + 1 WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("Error incrementing view count for product " + productId);
            e.printStackTrace();
            return false;
        }
    }
}