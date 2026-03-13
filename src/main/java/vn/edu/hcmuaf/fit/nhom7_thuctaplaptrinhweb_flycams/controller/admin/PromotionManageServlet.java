package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Categories;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Promotion;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.PromotionService;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/promotion-manage")
public class PromotionManageServlet extends HttpServlet {

    private PromotionService promotionService;

    @Override
    public void init() {
        promotionService = new PromotionService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Promotion> promotions = promotionService.getAllPromotions();
        Map<Integer, String> scopeMap = new HashMap<>();
        for (Promotion p : promotions) {
            scopeMap.put(p.getId(),
                    promotionService.getPromotionScope(p.getId()));
        }

        List<Product> allProducts = promotionService.getAllProducts();
        List<Categories> allCategories = promotionService.getAllCategories();

        Map<Integer, List<Integer>> promotionProductsMap = new HashMap<>();
        for (Promotion p : promotions) {
            List<Integer> productIds = promotionService.getProductIdsForPromotion(p.getId());
            promotionProductsMap.put(p.getId(), productIds);
        }

        Map<Integer, List<Integer>> promotionCategoriesMap = new HashMap<>();
        for (Promotion p : promotions) {
            List<Integer> categoryIds = promotionService.getCategoryIdsForPromotion(p.getId());
            promotionCategoriesMap.put(p.getId(), categoryIds);
        }

        req.setAttribute("promotions", promotions);
        req.setAttribute("scopeMap", scopeMap);
        req.setAttribute("allProducts", allProducts);
        req.setAttribute("allCategories", allCategories);
        req.setAttribute("promotionProductsMap", promotionProductsMap);
        req.setAttribute("promotionCategoriesMap", promotionCategoriesMap);
        req.getRequestDispatcher("/page/admin/promotion-manage.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        if ("add".equals(action) || "edit".equals(action)) {
            Promotion p = new Promotion();
            if ("edit".equals(action)) {
                p.setId(Integer.parseInt(req.getParameter("id")));
            }
            p.setName(req.getParameter("name"));
            p.setDiscountValue(Double.parseDouble(req.getParameter("discountValue")));
            p.setDiscountType(req.getParameter("discountType"));
            p.setStartDate(Date.valueOf(req.getParameter("startDate")));
            p.setEndDate(Date.valueOf(req.getParameter("endDate")));

            String scope = req.getParameter("scope");
            List<String> productIdsList = new ArrayList<>();
            String productIdsParam = req.getParameter("productIds");
            if (productIdsParam != null && !productIdsParam.isEmpty()) {
                for (String id : productIdsParam.split(",")) {
                    String trimmedId = id.trim();
                    if (!trimmedId.isEmpty()) {
                        productIdsList.add(trimmedId);
                    }
                }
            }
            List<String> categoryIdsList = new ArrayList<>();
            String categoryIdsParam = req.getParameter("categoryIds");
            if (categoryIdsParam != null && !categoryIdsParam.isEmpty()) {
                for (String id : categoryIdsParam.split(",")) {
                    String trimmedId = id.trim();
                    if (!trimmedId.isEmpty()) {
                        categoryIdsList.add(trimmedId);
                    }
                }
            }
            HttpSession session = req.getSession();
            if ("add".equals(action)) {
                promotionService.addPromotion(p, scope, productIdsList, categoryIdsList);
                session.setAttribute("infoMsg", "Thêm khuyến mãi thành công!");
            } else {
                promotionService.updatePromotion(p, scope, productIdsList, categoryIdsList);
                session.setAttribute("infoMsg", "Cập nhật khuyến mãi thành công!");
            }
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            promotionService.deletePromotion(id);
            req.getSession().setAttribute("infoMsg", "Xóa khuyến mãi thành công!");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/promotion-manage");
    }
}