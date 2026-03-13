package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.PromotionDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Categories;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Promotion;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class PromotionService {
    private PromotionDAO promotionDAO = new PromotionDAO();
    private ProductDAO productDAO = new ProductDAO();

    // lấy danh sách khuyến mãi và sản phẩm.
    public Map<Promotion, List<Product>> getActivePromotionsWithProducts() {
        List<Promotion> promotions = promotionDAO.getActivePromotions();

        // Map: Promotion -> List<Product> (Ban đầu chứa tất cả user chưa lọc)
        Map<Promotion, List<Product>> rawMap = new LinkedHashMap<>();

        // Map: ProductID -> Best Promotion Info (Để tìm promotion tốt nhất cho từng sản
        // phẩm)
        Map<Integer, Promotion> bestPromoForProduct = new java.util.HashMap<>();
        Map<Integer, Double> maxDiscountAmount = new java.util.HashMap<>();

        // 1. Thu thập dữ liệu và tìm Best Promotion cho mỗi sản phẩm
        for (Promotion promo : promotions) {
            List<Product> products = productDAO.getProductsByPromotion(promo.getId());
            if (!products.isEmpty()) {
                rawMap.put(promo, products);

                for (Product p : products) {
                    double currentDiscountAmount = calculateDiscount(p.getPrice(), promo);

                    if (!maxDiscountAmount.containsKey(p.getId())
                            || currentDiscountAmount > maxDiscountAmount.get(p.getId())) {
                        maxDiscountAmount.put(p.getId(), currentDiscountAmount);
                        bestPromoForProduct.put(p.getId(), promo);
                    }
                }
            }
        }

        // 2. Lọc lại map chính: Chỉ thêm sản phẩm vào promotion nếu đó là promotion tốt
        // nhất của nó
        Map<Promotion, List<Product>> resultMap = new LinkedHashMap<>();

        for (Map.Entry<Promotion, List<Product>> entry : rawMap.entrySet()) {
            Promotion promo = entry.getKey();
            List<Product> allProducts = entry.getValue();
            List<Product> filteredProducts = new java.util.ArrayList<>();

            for (Product p : allProducts) {
                Promotion bestPromo = bestPromoForProduct.get(p.getId());
                // So sánh theo ID để đảm bảo chính xác (Object equals có thể chưa override)
                if (bestPromo != null && bestPromo.getId() == promo.getId()) {
                    filteredProducts.add(p);
                }
            }

            if (!filteredProducts.isEmpty()) {
                resultMap.put(promo, filteredProducts);
            }
        }

        return resultMap;
    }

    private double calculateDiscount(double originalPrice, Promotion p) {
        if ("%".equals(p.getDiscountType())) {
            return originalPrice * (p.getDiscountValue() / 100.0);
        } else {
            // Giảm tiền mặt
            return p.getDiscountValue();
        }
    }

    // Admin Lấy toàn bộ danh sách khuyến mãi (không phân biệt trạng thái)
    public List<Promotion> getAllPromotions() {
        return promotionDAO.getAllPromotions();
    }

    // Lấy phạm vi áp dụng của khuyến mãi
    public String getPromotionScope(int promotionId) {
        return promotionDAO.getPromotionScope(promotionId);
    }

    // Lấy danh sách toàn bộ sản phẩm để admin thêm chọn sản phẩm thêm khuyến mãi
    public List<Product> getAllProducts() {
        return promotionDAO.getAllProducts();
    }

    // Lấy danh sách toàn bộ danh mục sản phẩm
    public List<Categories> getAllCategories() {
        return promotionDAO.getAllCategories();
    }

    // Lấy danh sách ID sản phẩm được áp dụng cho một khuyến mãi
    public List<Integer> getProductIdsForPromotion(int promotionId) {
        return promotionDAO.getProductIdsForPromotion(promotionId);
    }

    // Lấy danh sách ID danh mục được áp dụng cho một khuyến mãi
    public List<Integer> getCategoryIdsForPromotion(int promotionId) {
        return promotionDAO.getCategoryIdsForPromotion(promotionId);
    }

    // Thêm khuyến mãi mới (Admin)
    public void addPromotion(Promotion p, String scope, List<String> productIds, List<String> categoryIds) {
        promotionDAO.insertPromotion(p, scope, productIds, categoryIds);
    }

    // Cập nhật khuyến mãi (Admin)
    public void updatePromotion(Promotion p, String scope, List<String> productIds, List<String> categoryIds) {
        promotionDAO.updatePromotionWithScope(p, scope, productIds, categoryIds);
    }

    // Xóa khuyến mãi theo ID (Admin)
    public void deletePromotion(int id) {
        promotionDAO.deleteById(id);
    }
}
