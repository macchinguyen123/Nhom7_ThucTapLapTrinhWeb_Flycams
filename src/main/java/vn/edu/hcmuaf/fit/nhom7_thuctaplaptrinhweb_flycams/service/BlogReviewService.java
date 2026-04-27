package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.BlogReviewDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.BlogReview;

import java.util.List;
public class BlogReviewService {

        private final BlogReviewDAO blogReviewDAO = new BlogReviewDAO();

        public List<BlogReview> getAllReviews() {
            return blogReviewDAO.getAllReviews();
        }

        public List<BlogReview> getReviewsByBlogId(int blogId) {
            return blogReviewDAO.getReviewsByBlogId(blogId);
        }

        public boolean deleteReview(int id) {
            return blogReviewDAO.deleteReview(id);
        }
}
