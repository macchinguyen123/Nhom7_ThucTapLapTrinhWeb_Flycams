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
        } else if (user.getRoleId() != 1) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin role required.");
        } else {
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
    }
}
