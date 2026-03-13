package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model;

import java.io.Serializable;

public class PromotionTarget implements Serializable {
    private int id;
    private int promotionId;
    private String targetType; // "sản phẩm" | "danh mục" | "tất cả"
    private Integer productId;
    private Integer categoryId;

    public PromotionTarget() {
    }

    public PromotionTarget(int promotionId, String targetType, Integer productId, Integer categoryId) {
        this.promotionId = promotionId;
        this.targetType = targetType;
        this.productId = productId;
        this.categoryId = categoryId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPromotionId() {
        return promotionId;
    }

    public void setPromotionId(int promotionId) {
        this.promotionId = promotionId;
    }

    public String getTargetType() {
        return targetType;
    }

    public void setTargetType(String targetType) {
        this.targetType = targetType;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }
}
