package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model;

import java.io.Serializable;

public class Image implements Serializable {
    private int id;
    private int productId;
    private String imageUrl;
    private String imageType;

    public Image(int id, int productId, String imageUrl, String imageType) {
        this.id = id;
        this.productId = productId;
        this.imageUrl = imageUrl;
        this.imageType = imageType;
    }

    public Image() {
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

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getImageType() {
        return imageType;
    }

    public void setImageType(String imageType) {
        this.imageType = imageType;
    }
}
