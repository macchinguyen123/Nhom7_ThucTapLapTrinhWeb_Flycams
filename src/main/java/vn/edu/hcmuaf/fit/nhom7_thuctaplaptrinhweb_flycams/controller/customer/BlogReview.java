package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.ArticleService;

import java.io.IOException;

@WebServlet(name = "BlogReview", value = "/BlogReview")
public class BlogReview extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");
        int blogId = Integer.parseInt(request.getParameter("blogId"));
        String content = request.getParameter("content");
        ArticleService articleService = new ArticleService();
        if (articleService.hasUserReviewed(blogId, user.getId())) {
            response.sendRedirect(request.getContextPath() + "/article?id=" + blogId);
            return;
        }
        articleService.addReview(blogId, user.getId(), content);
        response.sendRedirect(request.getContextPath() + "/article?id=" + blogId);

    }
}