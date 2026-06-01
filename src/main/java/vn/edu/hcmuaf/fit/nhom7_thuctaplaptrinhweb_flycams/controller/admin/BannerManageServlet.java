package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Banner;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.BannerService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.CsrfTokenUtil;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/banner-manage")
public class BannerManageServlet extends HttpServlet {
    private final BannerService bannerService = new BannerService();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        CsrfTokenUtil.getOrCreate(session);
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        try {
            String show = request.getParameter("show");
            List<Banner> banners;
            boolean isTrash = "trash".equals(show);
            if (isTrash) {
                banners = bannerService.getDeletedBanners();
            } else {
                banners = bannerService.getAllBanners();
            }
            List<Banner> trashBanners = bannerService.getDeletedBanners();
            int trashCount = trashBanners != null ? trashBanners.size() : 0;
            request.setAttribute("banners", banners);
            request.setAttribute("isTrash", isTrash);
            request.setAttribute("trashCount", trashCount);
            request.getRequestDispatcher("/page/admin/banner-manage.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=system_error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        try {
            switch (action) {
                case "add":
                    handleAddBanner(request, response);
                    break;
                case "edit":
                    handleEditBanner(request, response);
                    break;
                case "delete":
                    handleDeleteBanner(request, response);
                    break;
                case "restore":
                    handleRestoreBanner(request, response);
                    break;
                case "hard-delete":
                    handleHardDeleteBanner(request, response);
                    break;
                case "toggle":
                    handleToggleStatus(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/banner-manage");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/banner-manage?error=system_error");
        }
    }
    private java.sql.Timestamp parseTimestamp(String datetimeLocalStr) {
        if (datetimeLocalStr == null || datetimeLocalStr.trim().isEmpty()) {
            return null;
        }
        try {
            String formatted = datetimeLocalStr.replace("T", " ");
            if (formatted.length() == 16) {
                formatted += ":00";
            }
            return java.sql.Timestamp.valueOf(formatted);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    private void handleAddBanner(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String type = request.getParameter("type");
            String imageUrl = request.getParameter("image");
            String videoUrl = request.getParameter("video");
            String link = request.getParameter("link");
            String orderIndexStr = request.getParameter("orderIndex");
            String status = request.getParameter("status");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            if (type == null || type.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/banner-manage?msg=add_failed");
                return;
            }
            int orderIndex = 0;
            try {
                orderIndex = Integer.parseInt(orderIndexStr);
            } catch (NumberFormatException e) {
                orderIndex = 0;
            }
            
            Banner banner = new Banner();
            banner.setType(type);
            if ("image".equals(type)) {
                banner.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
                banner.setVideoUrl(null);
            } else {
                banner.setImageUrl(null);
                banner.setVideoUrl(videoUrl != null ? videoUrl.trim() : "");
            }
            banner.setLink(link != null ? link.trim() : "");
            banner.setOrderIndex(orderIndex);
            banner.setStatus(status != null ? status : "active");
            banner.setStartDate(parseTimestamp(startDateStr));
            banner.setEndDate(parseTimestamp(endDateStr));
            boolean success = bannerService.addBanner(banner);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/banner-manage?msg=added");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/banner-manage?msg=add_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/banner-manage?msg=add_failed");
        }
    }
    private void handleEditBanner(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String idStr = request.getParameter("id");
            String type = request.getParameter("type");
            String imageUrl = request.getParameter("image");
            String videoUrl = request.getParameter("video");
            String link = request.getParameter("link");
            String orderIndexStr = request.getParameter("orderIndex");
            String status = request.getParameter("status");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            if (idStr == null || type == null || type.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/banner-manage?msg=update_failed");
                return;
            }
            int id = Integer.parseInt(idStr);
            int orderIndex = 0;
            try {
                orderIndex = Integer.parseInt(orderIndexStr);
            } catch (NumberFormatException e) {
                orderIndex = 0;
            }
            Banner banner = bannerService.getBannerById(id);
            if (banner != null) {
                banner.setType(type);
                if ("image".equals(type)) {
                    banner.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
                    banner.setVideoUrl(null);
                } else {
                    banner.setImageUrl(null);
                    banner.setVideoUrl(videoUrl != null ? videoUrl.trim() : "");
                }
                banner.setLink(link != null ? link.trim() : "");
                banner.setOrderIndex(orderIndex);
                banner.setStatus(status != null ? status : "active");
                banner.setStartDate(parseTimestamp(startDateStr));
                banner.setEndDate(parseTimestamp(endDateStr));
                boolean success = bannerService.updateBanner(banner);
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/banner-manage?msg=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/banner-manage?msg=update_failed");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/banner-manage?msg=not_found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/banner-manage?msg=update_failed");
        }
    }
    private void handleDeleteBanner(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/banner-manage?error=delete_failed");
                return;
            }
            int id = Integer.parseInt(idStr);
            boolean success = bannerService.deleteBanner(id);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/banner-manage?msg=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/banner-manage?error=delete_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/banner-manage?error=delete_failed");
        }
    }
    private void handleRestoreBanner(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/banner-manage?error=restore_failed");
                return;
            }
            int id = Integer.parseInt(idStr);
            boolean success = bannerService.restoreBanner(id);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/banner-manage?msg=restored");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/banner-manage?error=restore_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/banner-manage?error=restore_failed");
        }
    }
    private void handleHardDeleteBanner(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/banner-manage?error=delete_failed");
                return;
            }
            int id = Integer.parseInt(idStr);
            boolean success = bannerService.hardDeleteBanner(id);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/banner-manage?msg=hard_deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/banner-manage?error=delete_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/banner-manage?error=delete_failed");
        }
    }
    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String currentStatus = request.getParameter("status");
            String newStatus = "active".equals(currentStatus) ? "inactive" : "active";
            boolean success = bannerService.updateStatus(id, newStatus);
            if (success) {
                response.getWriter().write("{\"success\":true,\"newStatus\":\"" + newStatus + "\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"Cập nhật thất bại\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\":false,\"message\":\"Lỗi hệ thống\"}");
        }
    }
}