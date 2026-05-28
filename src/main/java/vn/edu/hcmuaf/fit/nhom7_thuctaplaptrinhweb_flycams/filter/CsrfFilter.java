package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.CsrfTokenUtil;

import java.io.IOException;

@WebFilter(urlPatterns = "/*")
public class CsrfFilter implements Filter {

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) servletRequest;
        HttpServletResponse resp = (HttpServletResponse) servletResponse;

        String method = req.getMethod().toUpperCase();
        String contextPath = req.getContextPath();
        String fullPath = req.getRequestURI();
        String path = fullPath.startsWith(contextPath)
                ? fullPath.substring(contextPath.length())
                : fullPath;

        //get thì tạo token nếu sesion đang tồn tại
        if (method.equals("GET")) {
            HttpSession session = req.getSession(true);
            CsrfTokenUtil.getOrCreate(session);
            chain.doFilter(req, resp);
            return;
        }

        //post put delete mới kiểm tra
        if (method.equals("POST") || method.equals("PUT") || method.equals("DELETE")) {

            //bỏ qua file tĩnh và path đã liệt kê trong helper
            if (CsrfHelper.isStaticResource(path) || CsrfHelper.isBypassed(path)) {
                chain.doFilter(req, resp);
                return;
            }
            //kiểm tra token nếu sai thì chặn
            if (!CsrfTokenUtil.isValid(req)) {
                CsrfHelper.sendForbidden(req, resp);
                return;
            }
        }
        chain.doFilter(req, resp);
    }
}