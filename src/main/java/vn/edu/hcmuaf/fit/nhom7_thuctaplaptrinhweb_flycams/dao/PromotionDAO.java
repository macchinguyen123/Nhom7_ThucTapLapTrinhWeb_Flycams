package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Categories;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Promotion;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PromotionDAO {

    public List<Promotion> getAllPromotions() {
        List<Promotion> list = new ArrayList<>();
        String sql = "SELECT id, name, discountValue, discountType, startDate, endDate FROM promotion ORDER BY startDate DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Promotion p = new Promotion();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setDiscountValue(rs.getDouble("discountValue"));
                p.setDiscountType(rs.getString("discountType"));
                p.setStartDate(rs.getTimestamp("startDate"));
                p.setEndDate(rs.getTimestamp("endDate"));
                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insertPromotion(Promotion p, String scope,
            List<String> productIds, List<String> categoryIds) {

        String sqlPromotion = "INSERT INTO promotion (name, discountValue, discountType, startDate, endDate) VALUES (?, ?, ?, ?, ?)";
        String sqlTarget = "INSERT INTO promotion_target (promotion_id, targetType, product_id, category_id) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            PreparedStatement ps = conn.prepareStatement(sqlPromotion, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, p.getName());
            ps.setDouble(2, p.getDiscountValue());
            ps.setString(3, p.getDiscountType());
            ps.setTimestamp(4, new Timestamp(p.getStartDate().getTime()));
            ps.setTimestamp(5, new Timestamp(p.getEndDate().getTime()));
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            rs.next();
            int promotionId = rs.getInt(1);
            p.setId(promotionId);

            PreparedStatement psTarget = conn.prepareStatement(sqlTarget);
            if ("ALL".equals(scope)) {
                psTarget.setInt(1, promotionId);
                psTarget.setString(2, "tất cả");
                psTarget.setNull(3, Types.INTEGER);
                psTarget.setNull(4, Types.INTEGER);
                psTarget.executeUpdate();

            } else if ("PRODUCT".equals(scope)) {
                for (String id : productIds) {
                    psTarget.setInt(1, promotionId);
                    psTarget.setString(2, "sản phẩm");
                    psTarget.setInt(3, Integer.parseInt(id.trim()));
                    psTarget.setNull(4, Types.INTEGER);
                    psTarget.executeUpdate();
                }

            } else if ("CATEGORY".equals(scope)) {
                for (String id : categoryIds) {
                    psTarget.setInt(1, promotionId);
                    psTarget.setString(2, "danh mục");
                    psTarget.setNull(3, Types.INTEGER);
                    psTarget.setInt(4, Integer.parseInt(id.trim()));
                    psTarget.executeUpdate();
                }
            }

            conn.commit();

            applyPromotionToProducts(p, scope, productIds, categoryIds);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Promotion> getActivePromotions() {
        List<Promotion> list = new ArrayList<>();

        String sql = """
                    SELECT id, name, discountValue, discountType, startDate, endDate
                    FROM promotion
                    WHERE NOW() BETWEEN startDate AND endDate
                    ORDER BY startDate DESC
                """;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Promotion p = new Promotion();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setDiscountValue(rs.getDouble("discountValue"));
                p.setDiscountType(rs.getString("discountType"));
                p.setStartDate(rs.getDate("startDate"));
                p.setEndDate(rs.getDate("endDate"));
                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void updatePromotionWithScope(Promotion p, String scope,
            List<String> productIds, List<String> categoryIds) {

        String sqlUpdate = "UPDATE promotion SET name=?, discountValue=?, discountType=?, startDate=?, endDate=? WHERE id=?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                ps.setString(1, p.getName());
                ps.setDouble(2, p.getDiscountValue());
                ps.setString(3, p.getDiscountType());
                ps.setTimestamp(4, new Timestamp(p.getStartDate().getTime()));
                ps.setTimestamp(5, new Timestamp(p.getEndDate().getTime()));
                ps.setInt(6, p.getId());
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM promotion_target WHERE promotion_id=?")) {
                ps.setInt(1, p.getId());
                ps.executeUpdate();
            }

            String sqlTarget = "INSERT INTO promotion_target (promotion_id, targetType, product_id, category_id) VALUES (?, ?, ?, ?)";
            PreparedStatement psTarget = conn.prepareStatement(sqlTarget);

            if ("ALL".equals(scope)) {
                psTarget.setInt(1, p.getId());
                psTarget.setString(2, "tất cả");
                psTarget.setNull(3, Types.INTEGER);
                psTarget.setNull(4, Types.INTEGER);
                psTarget.executeUpdate();

            } else if ("PRODUCT".equals(scope)) {
                for (String id : productIds) {
                    psTarget.setInt(1, p.getId());
                    psTarget.setString(2, "sản phẩm");
                    psTarget.setInt(3, Integer.parseInt(id.trim()));
                    psTarget.setNull(4, Types.INTEGER);
                    psTarget.executeUpdate();
                }

            } else if ("CATEGORY".equals(scope)) {
                for (String id : categoryIds) {
                    psTarget.setInt(1, p.getId());
                    psTarget.setString(2, "danh mục");
                    psTarget.setNull(3, Types.INTEGER);
                    psTarget.setInt(4, Integer.parseInt(id.trim()));
                    psTarget.executeUpdate();
                }
            }

            conn.commit();

            // Apply promotion
            applyPromotionToProducts(p, scope, productIds, categoryIds);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void applyPromotionToProducts(Promotion p, String scope,
            List<String> productIds, List<String> categoryIds) {

        if (p == null)
            return;

        try (Connection conn = DBConnection.getConnection()) {

            if ("ALL".equals(scope)) {
                // RESET tất cả về price gốc trước
                String resetSql = "UPDATE products SET finalPrice = price";
                try (PreparedStatement psReset = conn.prepareStatement(resetSql)) {
                    psReset.executeUpdate();
                }

                String sql = "UPDATE products SET finalPrice = CASE WHEN ? = '%' THEN price * (1 - ? / 100) ELSE price - ? END WHERE finalPrice - ? >= 0";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, p.getDiscountType());
                    ps.setDouble(2, p.getDiscountValue());
                    ps.setDouble(3, p.getDiscountValue());
                    ps.setDouble(4, p.getDiscountValue());
                    int rowsUpdated = ps.executeUpdate();
                    System.out.println(" Updated " + rowsUpdated + " products (ALL)");
                }

            } else if ("PRODUCT".equals(scope) && !productIds.isEmpty()) {
                String placeholders = String.join(",", productIds);
                String resetSql = "UPDATE products SET finalPrice = price WHERE id IN (" + placeholders + ")";
                try (PreparedStatement psReset = conn.prepareStatement(resetSql)) {
                    psReset.executeUpdate();
                }

                String sql = "UPDATE products SET finalPrice = CASE WHEN ? = '%' THEN price * (1 - ? / 100) ELSE GREATEST(price - ?, 0) END WHERE id IN ("
                        + placeholders + ")";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, p.getDiscountType());
                    ps.setDouble(2, p.getDiscountValue());
                    ps.setDouble(3, p.getDiscountValue());
                    int rowsUpdated = ps.executeUpdate();
                    System.out.println(" Updated " + rowsUpdated + " products (PRODUCT)");
                }

            } else if ("CATEGORY".equals(scope) && !categoryIds.isEmpty()) {
                String placeholders = String.join(",", categoryIds);
                String resetSql = "UPDATE products SET finalPrice = price WHERE category_id IN (" + placeholders + ")";
                try (PreparedStatement psReset = conn.prepareStatement(resetSql)) {
                    psReset.executeUpdate();
                }

                String sql = "UPDATE products SET finalPrice = CASE WHEN ? = '%' THEN price * (1 - ? / 100) ELSE GREATEST(price - ?, 0) END WHERE category_id IN ("
                        + placeholders + ")";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, p.getDiscountType());
                    ps.setDouble(2, p.getDiscountValue());
                    ps.setDouble(3, p.getDiscountValue());
                    int rowsUpdated = ps.executeUpdate();
                    System.out.println(" Updated " + rowsUpdated + " products in category");
                }
            }

        } catch (Exception e) {
            System.out.println(" Error applying promotion:");
            e.printStackTrace();
        }
    }

    public void deleteById(int promotionId) {
        resetFinalPrice(promotionId);
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement("DELETE FROM promotion_target WHERE promotion_id=?");
                    PreparedStatement ps2 = conn.prepareStatement("DELETE FROM promotion WHERE id=?")) {
                ps1.setInt(1, promotionId);
                ps1.executeUpdate();
                ps2.setInt(1, promotionId);
                ps2.executeUpdate();
                conn.commit();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void resetFinalPrice(int promotionId) {
        String sql = """
                    UPDATE products
                    SET finalPrice = price
                    WHERE id IN (
                        SELECT product_id
                        FROM promotion_target
                        WHERE promotion_id = ?
                          AND product_id IS NOT NULL
                    )
                    OR category_id IN (
                        SELECT category_id
                        FROM promotion_target
                        WHERE promotion_id = ?
                          AND category_id IS NOT NULL
                    )
                """;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, promotionId);
            ps.setInt(2, promotionId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getPromotionScope(int promotionId) {
        String sql = "SELECT DISTINCT targetType FROM promotion_target WHERE promotion_id = ?";
        List<String> types = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, promotionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                types.add(rs.getString("targetType"));
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (types.contains("tất cả"))
            return "Toàn bộ sản phẩm";
        if (types.size() >= 2)
            return "Sản phẩm + Danh mục";
        if (types.contains("sản phẩm"))
            return "Sản phẩm";
        if (types.contains("danh mục"))
            return "Danh mục";
        return "—";
    }

    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();

        String sql = """
                    SELECT
                        p.id,
                        p.productName,
                        p.price,
                        p.finalPrice,
                        i.imageUrl AS mainImage
                    FROM products p
                    LEFT JOIN images i
                        ON p.id = i.product_id
                        AND i.imageType = 'Chính'
                    ORDER BY p.productName ASC
                """;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product product = new Product();

                product.setId(rs.getInt("id"));
                product.setProductName(rs.getString("productName"));
                product.setPrice(rs.getDouble("price"));
                product.setFinalPrice(rs.getDouble("finalPrice"));

                product.setMainImage(rs.getString("mainImage"));

                list.add(product);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Integer> getProductIdsForPromotion(int promotionId) {
        List<Integer> productIds = new ArrayList<>();
        String sql = "SELECT product_id FROM promotion_target WHERE promotion_id = ? AND product_id IS NOT NULL";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, promotionId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                productIds.add(rs.getInt("product_id"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return productIds;
    }

    public List<Categories> getAllCategories() {
        List<Categories> list = new ArrayList<>();
        String sql = "SELECT id, categoryName, image, status FROM categories ORDER BY categoryName ASC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Categories category = new Categories();
                category.setId(rs.getInt("id"));
                category.setCategoryName(rs.getString("categoryName"));
                category.setImage(rs.getString("image"));
                category.setStatus(rs.getString("status"));
                list.add(category);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Integer> getCategoryIdsForPromotion(int promotionId) {
        List<Integer> categoryIds = new ArrayList<>();
        String sql = "SELECT category_id FROM promotion_target WHERE promotion_id = ? AND category_id IS NOT NULL";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, promotionId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                categoryIds.add(rs.getInt("category_id"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return categoryIds;
    }

}
