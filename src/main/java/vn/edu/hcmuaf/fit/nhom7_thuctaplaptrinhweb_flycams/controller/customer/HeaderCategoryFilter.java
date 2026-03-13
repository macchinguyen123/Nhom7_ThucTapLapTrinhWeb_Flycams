package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Categories;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.CategoryService;

import java.io.IOException;
import java.util.List;

@WebFilter(urlPatterns = "/*", dispatcherTypes = {DispatcherType.REQUEST, DispatcherType.FORWARD})
public class HeaderCategoryFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        try {
            CategoryService categoryService = new CategoryService();
            List<Categories> headerCategories = categoryService.getCategoriesForHeader();
            if (headerCategories != null) {
                req.setAttribute("headerCategories", headerCategories);
            }
        } catch (Throwable t) {
            t.printStackTrace();
        }
        chain.doFilter(request, response);
    }
}