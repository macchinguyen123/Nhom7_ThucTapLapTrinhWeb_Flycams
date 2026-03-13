package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.ReviewsDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Reviews;

import java.util.List;

public class ReviewService {
    private ReviewsDAO reviewsDAO = new ReviewsDAO();

    //Kiểm tra người dùng đã đánh giá sản phẩm này hay chưa
    public boolean hasUserReviewedProduct(int userId, int productId) {
        return reviewsDAO.hasUserReviewedProduct(userId, productId);
    }

    //Lưu đánh giá mới của người dùng cho sản phẩm
    public void saveReview(int userId, int productId, int rating, String content) {
        reviewsDAO.saveReview(userId, productId, rating, content);
    }

    //Lấy điểm đánh giá trung bình của sản phẩm
    public double getAverageRating(int productId) {
        return reviewsDAO.getAverageRating(productId);
    }

    //Đếm tổng số lượt đánh giá của sản phẩm
    public int countReviews(int productId) {
        return reviewsDAO.countReviews(productId);
    }

    //Đếm số lượt đánh giá theo số sao cụ thể
    public int countByStar(int productId, int star) {
        return reviewsDAO.countByStar(productId, star);
    }

    //Đếm số đánh giá có nội dung nhận xét (không rỗng)
    public int countWithComment(int productId) {
        return reviewsDAO.countWithComment(productId);
    }

    //Lấy danh sách đánh giá của sản phẩm có phân trang
    public List<Reviews> getReviewsByProductPaging(int productId, int page, int pageSize) {
        return reviewsDAO.getReviewsByProductPaging(productId, page, pageSize);
    }
}
