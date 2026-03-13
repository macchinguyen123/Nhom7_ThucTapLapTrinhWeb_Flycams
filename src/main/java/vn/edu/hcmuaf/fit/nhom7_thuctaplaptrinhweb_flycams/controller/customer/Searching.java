package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.ProductService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.WishlistService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.PriceFormatter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "Searching", value = "/Searching")
public class Searching extends HttpServlet {
    private final WishlistService wishlistService = new WishlistService();
    private final ProductService productService = new ProductService(); // New Service
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        String keyword = request.getParameter("keyword");
        if (keyword == null)
            keyword = "";
        String giaTuStr = request.getParameter("gia-tu");
        String giaDenStr = request.getParameter("gia-den");
        Double minPrice = null;
        Double maxPrice = null;
        try {
            if (giaTuStr != null && !giaTuStr.trim().isEmpty()) {
                String s = giaTuStr.trim().replaceAll("[^0-9]", "");
                if (!s.isEmpty())
                    minPrice = Double.parseDouble(s);
            }
        } catch (NumberFormatException x) {
            minPrice = null;
        }
        try {
            if (giaDenStr != null && !giaDenStr.trim().isEmpty()) {
                String s = giaDenStr.trim().replaceAll("[^0-9]", "");
                if (!s.isEmpty())
                    maxPrice = Double.parseDouble(s);
            }
        } catch (NumberFormatException x) {
            maxPrice = null;
        }
        String priceFilter = request.getParameter("chon-gia");
        if ((minPrice == null && maxPrice == null) && priceFilter != null) {
            switch (priceFilter) {
                case "duoi-5000000":
                    minPrice = null;
                    maxPrice = 5_000_000.0;
                    break;
                case "5-10":
                    minPrice = 5_000_000.0;
                    maxPrice = 10_000_000.0;
                    break;
                case "10-20":
                    minPrice = 10_000_000.0;
                    maxPrice = 20_000_000.0;
                    break;
                case "tren-20":
                    minPrice = 20_000_000.0;
                    maxPrice = null;
                    break;
                default:
                    break;
            }
        }
        String[] brandArr = request.getParameterValues("chon-thuong-hieu");
        List<String> brandList = (brandArr != null) ? Arrays.asList(brandArr) : null;
        String sortBy = request.getParameter("sort");
        List<Product> results = productService.searchProducts(
                keyword,
                priceFilter,
                minPrice,
                maxPrice,
                brandList,
                sortBy);
        if (user != null) {
            List<Integer> wishlistProductIds = wishlistService.getWishlistProductIds(user.getId());
            request.setAttribute("wishlistProductIds", wishlistProductIds);
        }
        request.setAttribute("formatter", new PriceFormatter());
        request.setAttribute("products", results);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("page/searching.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}