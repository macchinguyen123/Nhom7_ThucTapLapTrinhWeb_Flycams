package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class InventoryImport implements Serializable {
    private int id;
    private int productId;
    private int quantity;
    private BigDecimal importPrice;
    private Timestamp createdAt;
    private Integer createdBy;
    private String note;
    private String productName;
    private String mainImage;

    public InventoryImport() {
    }

    public InventoryImport(int id, int productId, int quantity, BigDecimal importPrice, Timestamp createdAt, Integer createdBy, String note) {
        this.id = id;
        this.productId = productId;
        this.quantity = quantity;
        this.importPrice = importPrice;
        this.createdAt = createdAt;
        this.createdBy = createdBy;
        this.note = note;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getImportPrice() {
        return importPrice;
    }

    public void setImportPrice(BigDecimal importPrice) {
        this.importPrice = importPrice;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getMainImage() {
        return mainImage;
    }

    public void setMainImage(String mainImage) {
        this.mainImage = mainImage;
    }
}
