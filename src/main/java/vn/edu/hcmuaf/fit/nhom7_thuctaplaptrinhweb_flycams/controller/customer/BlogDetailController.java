package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Post;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.ArticleService;

import java.io.IOException;

@WebServlet(name = "BlogDetailController", value = "/article")
public class BlogDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int postId = Integer.parseInt(request.getParameter("id"));
        ArticleService articleService = new ArticleService();
        Post post = articleService.getPostById(postId);
        request.setAttribute("post", post);
        request.setAttribute("morePosts", articleService.getMorePosts(postId));
        request.setAttribute("relatedPosts", articleService.getRelatedPosts(postId));
        request.setAttribute("comments", articleService.getComments(postId));
        boolean hasReviewed = false;
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            hasReviewed = articleService.hasUserReviewed(postId, user.getId());
        }
        request.setAttribute("hasReviewed", hasReviewed);
        request.getRequestDispatcher("/page/article.jsp")
                .forward(request, response);
    }

}