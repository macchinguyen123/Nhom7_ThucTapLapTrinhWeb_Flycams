package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.filter;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class CsrfHelper {

    static final String[] BYPASS_PATHS = {
            "/login", "/register", "/forgot-password",
            "/reset-password", "/oauth", "/ghn"
    };

    static final String[] STATIC_EXTS = {
            ".css", ".js", ".png", ".jpg", ".jpeg",
            ".gif", ".ico", ".woff", ".woff2"
    };

    static final String[] STATIC_DIRS = {
            "/stylesheets/", "/javascript/", "/image/", "/fonts/"
    };

    static boolean isBypassed(String path) {
        for (String p : BYPASS_PATHS) {
            if (path.equals(p) || path.startsWith(p + "/")) return true;
        }
        return false;
    }

    static boolean isStaticResource(String path) {
        for (String dir : STATIC_DIRS) {
            if (path.startsWith(dir)) return true;
        }
        for (String ext : STATIC_EXTS) {
            if (path.endsWith(ext)) return true;
        }
        return false;
    }

    static void sendForbidden(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        resp.setStatus(HttpServletResponse.SC_FORBIDDEN);

        String ajaxHeader = req.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equalsIgnoreCase(ajaxHeader)) {
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write(
                    "{\"success\":false,\"msg\":\"Token không hợp lệ, vui lòng tải lại trang\"}"
            );
            return;
        }

        req.setAttribute("errorMessage",
                "Token bảo mật không hợp lệ hoặc đã hết hạn. Vui lòng tải lại trang.");
        try {
            req.getRequestDispatcher("/page/error/403.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.setContentType("text/html;charset=UTF-8");
            resp.getWriter().write("<h2>403 - Truy cập bị từ chối</h2>"
                    + "<a href='javascript:history.back()'>Quay lại</a>");
        }
    }
}