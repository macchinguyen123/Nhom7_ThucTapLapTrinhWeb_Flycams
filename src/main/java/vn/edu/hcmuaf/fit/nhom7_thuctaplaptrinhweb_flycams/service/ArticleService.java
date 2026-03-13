package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.BlogDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.HomeDao;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.PostDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Post;

import java.util.List;
import java.util.Map;

public class ArticleService {
    private BlogDAO blogDAO = new BlogDAO();
    private HomeDao homeDao = new HomeDao();

    //Lấy thông tin bài viết theo ID
    public Post getPostById(int id) {
        return blogDAO.getPostById(id);
    }

    //Lấy danh sách bình luận của một bài viết
    public List<Map<String, Object>> getComments(int blogId) {
        return blogDAO.getReviewsByBlog(blogId);
    }

    //Kiểm tra người dùng đã bình luận bài viết hay chưa
    public boolean hasUserReviewed(int blogId, int userId) {
        return blogDAO.hasReviewed(blogId, userId);
    }

    //Lấy toàn bộ bài viết
    public List<Post> getAllPosts() {
        return blogDAO.getAllPosts();
    }

    //Lấy danh sách bài viết mới nhất
    public List<Post> getLatestPosts(int limit) {
        return homeDao.getLatestPosts(limit);
    }

    //Lấy thêm bài viết
    public List<Post> getMorePosts(int postId) {
        return blogDAO.getMorePosts(postId);
    }

    //Lấy danh sách bài viết liên quan
    public List<Post> getRelatedPosts(int postId) {
        return blogDAO.getRelatedPosts(postId);
    }

    public void addReview(int blogId, int userId, String content) {
        blogDAO.insert(blogId, userId, content);
    }

    // Admin
    private PostDAO postDAO = new PostDAO();

    public boolean addPost(Post post) {
        return postDAO.addPost(post);
    }

    public boolean updatePost(Post post) {
        return postDAO.updatePost(post);
    }

    public boolean deletePost(int postId) {
        return postDAO.deletePost(postId);
    }
}
