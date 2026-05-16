package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.*;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.*;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.PriceFormatter;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", value = "/home")
public class HomeServlet extends HttpServlet {
    private final WishlistService wishlistService = new WishlistService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            ProductService productService = new ProductService();
            BannerService bannerService = new BannerService();
            ArticleService articleService = new ArticleService();
            CategoryService categoryService = new CategoryService();
            List<Banner> activeBanners = bannerService.getActiveBanners();
            request.setAttribute("banners", activeBanners);
            List<Product> bestSellerProducts = productService.getBestSellerProducts(5);
            if (bestSellerProducts.isEmpty()) {
                bestSellerProducts = productService.getTopViewedProducts(5);
            }
            if (bestSellerProducts.isEmpty()) {
                bestSellerProducts = productService.getRandomProducts(5);
            }
            request.setAttribute("bestSellerProducts", bestSellerProducts);
            List<Product> topViewedProducts = productService.getTopViewedProducts(10);
            if (topViewedProducts.isEmpty()) {
                topViewedProducts = productService.getRandomProducts(10);
            }
            request.setAttribute("topReviewedProducts", topViewedProducts);
            List<Product> recommendedProducts = productService.getRecommendedProducts(10);
            request.setAttribute("recommendedProducts", recommendedProducts);
            List<Categories> categories = categoryService.getCategoriesForHeader();
            request.setAttribute("headerCategories", categories);
            int catCount = 0;
            for (Categories cat : categories) {
                List<Product> prods = productService.getProductsByCategory(cat.getId(), 8);
                if (!prods.isEmpty()) {
                    catCount++;
                    if (catCount == 1) {
                        request.setAttribute("cat1Name", cat.getCategoryName());
                        request.setAttribute("cat1Id", cat.getId());
                        request.setAttribute("quayPhim", prods);
                    } else if (catCount == 2) {
                        request.setAttribute("cat2Name", cat.getCategoryName());
                        request.setAttribute("cat2Id", cat.getId());
                        request.setAttribute("mini", prods);
                        break;
                    }
                }
            }
            List<Post> latestPosts = articleService.getLatestPosts(8);
            request.setAttribute("latestPosts", latestPosts);
            request.setAttribute("formatter", new PriceFormatter());
            HttpSession session = request.getSession(false);
            User user = session != null ? (User) session.getAttribute("user") : null;
            if (user != null) {
                List<Integer> wishlistProductIds = wishlistService.getWishlistProductIds(user.getId());
                request.setAttribute("wishlistProductIds", wishlistProductIds);
            }
        } catch (Throwable t) {
            t.printStackTrace();
            request.setAttribute("error_trace", t.toString());
            request.setAttribute("error_obj", t);
        }
        request.getRequestDispatcher("/page/homepage.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}