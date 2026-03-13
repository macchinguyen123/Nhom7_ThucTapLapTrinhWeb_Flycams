package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Post;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.ArticleService;

import java.io.IOException;

@WebServlet(name = "Article", value = "/article-detail")
public class Article extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int blogId = Integer.parseInt(request.getParameter("id"));
        ArticleService articleService = new ArticleService();
        Post post = articleService.getPostById(blogId);
        User user = (User) request.getSession().getAttribute("user");
        boolean hasReviewed = user != null && articleService.hasUserReviewed(blogId, user.getId());
        request.setAttribute("post", post);
        request.setAttribute("comments", articleService.getComments(blogId));
        request.setAttribute("hasReviewed", hasReviewed);
        request.getRequestDispatcher("/page/article.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}