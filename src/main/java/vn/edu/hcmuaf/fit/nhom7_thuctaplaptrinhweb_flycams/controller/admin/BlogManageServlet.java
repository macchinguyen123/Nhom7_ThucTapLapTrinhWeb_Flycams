package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.BlogReview;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Post;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.ArticleService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.BlogReviewService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.CsrfTokenUtil;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "BlogManageServlet", value = "/admin/blog-manage")
public class BlogManageServlet extends HttpServlet {
    private ArticleService articleService;

    @Override
    public void init() {
        articleService = new ArticleService();
        blogReviewService = new BlogReviewService();
    }
    private BlogReviewService blogReviewService;


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        CsrfTokenUtil.getOrCreate(session);
        List<Post> posts = articleService.getAllPosts();
        List<BlogReview> reviews = blogReviewService.getAllReviews();
        req.setAttribute("posts", posts);
        req.setAttribute("reviews", reviews);
        req.getRequestDispatcher("/page/admin/blog-manage.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action != null ? action : "") {
            case "delete": {
                int postId = Integer.parseInt(request.getParameter("id"));
                boolean success = articleService.deletePost(postId);
                response.sendRedirect(request.getContextPath() + "/admin/blog-manage?msg="
                        + (success ? "deleted" : "delete_failed"));
                break;
            }
            case "delete_review": {
                int reviewId = Integer.parseInt(request.getParameter("id"));
                boolean success = blogReviewService.deleteReview(reviewId);
                response.sendRedirect(request.getContextPath() + "/admin/blog-manage?msg="
                        + (success ? "review_deleted" : "review_delete_failed"));
                break;
            }
            case "edit": {
                int id = Integer.parseInt(request.getParameter("id"));
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                String image = request.getParameter("image");
                int productId = Integer.parseInt(request.getParameter("productId"));
                Post post = new Post(id, title, content, image, null, productId, 0);
                boolean success = articleService.updatePost(post);
                response.sendRedirect(request.getContextPath() + "/admin/blog-manage?msg="
                        + (success ? "edited" : "edit_failed"));
                break;
            }
            case "add": {
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                String image = request.getParameter("image");
                String productIdStr = request.getParameter("productId");
                int productId = (productIdStr != null && !productIdStr.trim().isEmpty())
                        ? Integer.parseInt(productIdStr) : 0;

                if (title == null || title.trim().isEmpty()
                        || content == null || content.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/admin/blog-manage?error=add_failed");
                    return;
                }
                Post post = new Post(0, title, content, image, null, productId, 0);
                boolean success = articleService.addPost(post);
                response.sendRedirect(request.getContextPath() + "/admin/blog-manage?msg="
                        + (success ? "added" : "add_failed"));
                break;
            }
            default:
                response.sendRedirect(request.getContextPath() + "/admin/blog-manage");
        }
    }
}
