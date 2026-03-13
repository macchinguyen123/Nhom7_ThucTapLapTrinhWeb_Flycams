package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model;

import java.io.Serializable;
import java.util.Date;

public class BlogReview implements Serializable {
    private int id;
    private int blogId;
    private int userId;
    private String content;
    private Date createdAt;

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


}
