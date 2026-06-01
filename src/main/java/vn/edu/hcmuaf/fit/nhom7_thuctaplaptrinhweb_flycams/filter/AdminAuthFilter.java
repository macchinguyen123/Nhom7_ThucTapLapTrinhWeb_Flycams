package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;

import java.io.IOException;

@WebFilter(filterName = "AdminAuthFilter", urlPatterns = {"/admin/*"})
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    private static final java.util.Set<Integer> ALLOWED_ADMIN_ROLES = java.util.Set.of(1, 3, 4, 5);
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String requestURI = httpRequest.getRequestURI();
        if (requestURI.contains("/ghn-webhook")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            String xRequestedWith = httpRequest.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(xRequestedWith)) {
                httpResponse.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Login required");
            } else {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/Login");
            }
            return;
        }
        int roleId = user.getRoleId();
        if (!ALLOWED_ADMIN_ROLES.contains(roleId)) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Unprivileged role.");
            return;
        }
        if (roleId == 1) {
            chain.doFilter(request, response);
            return;
        }
        if (requestURI.contains("/dashboard") || requestURI.contains("/profile")) {
            chain.doFilter(request, response);
            return;
        }
        if (roleId == 3 && isOrderURI(requestURI)) {
            chain.doFilter(request, response);
            return;
        }
        if (roleId == 4 && isProductInventoryURI(requestURI)) {
            chain.doFilter(request, response);
            return;
        }
        if (roleId == 5 && isSupportURI(requestURI)) {
            chain.doFilter(request, response);
            return;
        }
        httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You do not have permission to access this resource.");
    }
    private boolean isOrderURI(String uri) {
        return uri.contains("/unconfirmed-orders") || uri.contains("/order-manage")  || uri.contains("/order-detail")
                || uri.contains("/order-action") || uri.contains("/update-order") || uri.contains("/rejected-orders");
    }

    private boolean isProductInventoryURI(String uri) {
        return uri.contains("/product-management") || uri.contains("/product-manage")  || uri.contains("/product-save")
                || uri.contains("/product-delete") || uri.contains("/product-get") || uri.contains("/product-toggle-status")
                || uri.contains("/inventory-manage") || uri.contains("/inventory-detail")  || uri.contains("/inventory-import") || uri.contains("/category-manage")  || uri.contains("/category-sort")  || uri.contains("/banner-manage")
                || uri.contains("/api/inventory-");
    }

    private boolean isSupportURI(String uri) {
        return uri.contains("/chat-manage")
                || uri.contains("/chat") || uri.contains("/complaints")
                || uri.contains("/manage-complaint") || uri.contains("/review-manage");
    }

    @Override
    public void destroy() {
    }
}
