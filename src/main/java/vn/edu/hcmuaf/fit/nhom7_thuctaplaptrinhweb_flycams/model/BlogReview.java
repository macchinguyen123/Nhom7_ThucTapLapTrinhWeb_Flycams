package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model;

import java.io.Serializable;
import java.util.Date;

public class BlogReview implements Serializable {
    private int id;
    private int blogId;
    private int userId;
    private String content;
    private Date createdAt;
    private String username;
    private String blogTitle;

    public int getId() {
        return id;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public String getContent() {
        return content;
    }

    public int getUserId() {
        return userId;
    }

    public int getBlogId() {
        return blogId;
    }

    public String getUsername() { return username; }

    public String getBlogTitle() { return blogTitle; }

    public void setId(int id) {
        this.id = id;
    }

    public void setBlogId(int blogId) {
        this.blogId = blogId;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public void setUsername(String username) { this.username = username; }

    public void setBlogTitle(String blogTitle) { this.blogTitle = blogTitle; }
}
