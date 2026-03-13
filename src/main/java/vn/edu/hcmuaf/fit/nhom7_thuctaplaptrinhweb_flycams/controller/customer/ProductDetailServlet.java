package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.*;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.PriceFormatter;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductDetailServlet", value = "/product-detail")
public class ProductDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductService productService = new ProductService();
        CategoryService categoryService = new CategoryService();
        ReviewService reviewService = new ReviewService();
        OrderService orderService = new OrderService();
        WishlistService wishlistService = new WishlistService();
        String idRaw = request.getParameter("id");
        if (idRaw == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        int id;
        try {
            id = Integer.parseInt(idRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        Product product = productService.getProduct(id);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/404.jsp");
            return;
        }
        productService.incrementViewCount(id);

        String categoryName = categoryService.getCategoryNameById(product.getCategoryId());

        int discountPercent = calculateDiscountPercent(product.getPrice(), product.getFinalPrice());
        request.setAttribute("discountPercent", discountPercent);
        System.out.println("DEBUG: discountPercent = " + discountPercent); // ← THÊM DÒNG NÀY

        double avgRating = reviewService.getAverageRating(id);
        int reviewCount = reviewService.countReviews(id);

        int fullStars = (int) avgRating;
        boolean hasHalfStar = (avgRating - fullStars) >= 0.5;

        HttpSession session = request.getSession(false);
        boolean canReview = false;
        boolean isLoggedIn = false;
        boolean hasReviewed = false;

        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                isLoggedIn = true;
                boolean hasPurchased = orderService.hasUserPurchasedProduct(user.getId(), id);
                hasReviewed = reviewService.hasUserReviewedProduct(user.getId(), id);
                canReview = hasPurchased && !hasReviewed;
            }
        }

        request.setAttribute("avgRating", avgRating);
        request.setAttribute("reviewCount", reviewCount);
        request.setAttribute("fullStars", fullStars);
        request.setAttribute("hasHalfStar", hasHalfStar);
        request.setAttribute("canReview", canReview);
        request.setAttribute("isLoggedIn", isLoggedIn);
        request.setAttribute("hasReviewed", hasReviewed);

        request.setAttribute("formatter", new PriceFormatter());
        request.setAttribute("product", product);
        request.setAttribute("categoryName", categoryName);

        int page = 1;
        int pageSize = 5;

        String pageRaw = request.getParameter("page");
        if (pageRaw != null) {
            try {
                page = Integer.parseInt(pageRaw);
            } catch (NumberFormatException ignored) {
            }
        }

        int totalReviews = reviewService.countReviews(id);
        int totalPages = (int) Math.ceil((double) totalReviews / pageSize);

        request.setAttribute("reviews",
                reviewService.getReviewsByProductPaging(id, page, pageSize));

        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("star5", reviewService.countByStar(id, 5));
        request.setAttribute("star4", reviewService.countByStar(id, 4));
        request.setAttribute("star3", reviewService.countByStar(id, 3));
        request.setAttribute("star2", reviewService.countByStar(id, 2));
        request.setAttribute("star1", reviewService.countByStar(id, 1));
        request.setAttribute("commentCount", reviewService.countWithComment(id));

        List<Product> relatedProducts = productService.getRelatedProducts(
                product.getCategoryId(),
                product.getId(),
                20);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user != null) {
            List<Integer> wishlistProductIds = wishlistService.getWishlistProductIds(user.getId());
            request.setAttribute("wishlistProductIds", wishlistProductIds);
        }

        request.setAttribute("relatedProducts", relatedProducts);

        request.getRequestDispatcher("/page/product-details.jsp")
                .forward(request, response);
    }

    private int calculateDiscountPercent(double originalPrice, double finalPrice) {
        if (originalPrice <= 0 || finalPrice < 0) {
            return 0;
        }
        if (finalPrice >= originalPrice) {
            return 0;
        }
        double discount = ((originalPrice - finalPrice) / originalPrice) * 100;
        return (int) Math.round(discount);
    }
}