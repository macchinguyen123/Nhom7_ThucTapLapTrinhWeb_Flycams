package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Banner;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.BannerService;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/banner-manage")
public class BannerManageServlet extends HttpServlet {
    private final BannerService bannerService = new BannerService();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        try {
            //lấy danh sách tất cả banner
            List<Banner> banners = bannerService.getAllBanners();
            //set attribute để hiển thị trong JSP
            request.setAttribute("banners", banners);
            //forward đến trang JSP (file nằm ở /webapp/page/admin/banner-manage.jsp)
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
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/banner-manage");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/banner-manage?error=system_error");
        }
    }
    //xử lý thêm banner
    private void handleAddBanner(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String type = request.getParameter("type");
            String imageUrl = request.getParameter("image");
            String videoUrl = request.getParameter("video");
            String link = request.getParameter("link");
            String orderIndexStr = request.getParameter("orderIndex");
            String status = request.getParameter("status");
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
            //tạo Banner mới
            Banner banner = new Banner();
            banner.setType(type);
            //set URL tương ứng với type
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
            //thêm vào database
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
    //xử lý sửa banner
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
            //validate input
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
            //lấy banner hiện tại
            Banner banner = bannerService.getBannerById(id);
            if (banner != null) {
                banner.setType(type);
                //set URL tương ứng với type
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
                //cập nhật database
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
    //xử lý xóa banner
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
}