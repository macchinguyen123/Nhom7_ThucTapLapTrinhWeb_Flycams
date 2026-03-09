package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Banner implements Serializable {
    private int id;
    private String type; // "image" hoặc "video"
    private String imageUrl;
    private String videoUrl;
    private String link;
    private int orderIndex;
    private String status; // "active" hoặc "inactive"
    private Timestamp createdAt;
    private Timestamp updatedAt;
    // Constructor mặc định
    public Banner() {
    }
    public Banner(int id, String type, String imageUrl, String videoUrl,
                  String link, int orderIndex, String status,
                  Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.type = type;
        this.imageUrl = imageUrl;
        this.videoUrl = videoUrl;
        this.link = link;
        this.orderIndex = orderIndex;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    //constructor dùng khi tạo mới
    public Banner(String type, String imageUrl, String videoUrl,
                  String link, int orderIndex, String status) {
        this.type = type;
        this.imageUrl = imageUrl;
        this.videoUrl = videoUrl;
        this.link = link;
        this.orderIndex = orderIndex;
        this.status = status;
    }
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public String getType() {
        return type;
    }
    public void setType(String type) {
        this.type = type;
    }
    public String getImageUrl() {
        return imageUrl;
    }
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    public String getVideoUrl() {
        return videoUrl;
    }
    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }
    public String getLink() {
        return link;
    }
    public void setLink(String link) {
        this.link = link;
    }
    public int getOrderIndex() {
        return orderIndex;
    }
    public void setOrderIndex(int orderIndex) {
        this.orderIndex = orderIndex;
    }
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    //method tiện ích để lấy media URL (ảnh hoặc video)
    public String getMediaUrl() {
        if ("image".equals(type)) {
            return imageUrl;
        } else if ("video".equals(type)) {
            return videoUrl;
        }
        return null;
    }
    @Override
    public String toString() {
        return "Banner{" +
                "id=" + id +
                ", type='" + type + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                ", videoUrl='" + videoUrl + '\'' +
                ", link='" + link + '\'' +
                ", orderIndex=" + orderIndex +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}