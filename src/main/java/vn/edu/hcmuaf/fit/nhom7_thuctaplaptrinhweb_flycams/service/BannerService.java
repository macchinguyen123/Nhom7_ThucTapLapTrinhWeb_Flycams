package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.BannerDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Banner;

import java.util.List;

public class BannerService {
    private BannerDAO bannerDAO = new BannerDAO();
    //lấy danh sách banner đang hoạt động
    public List<Banner> getActiveBanners() {
        return bannerDAO.getActiveBanners();
    }
    //lấy toàn bộ banner
    public List<Banner> getAllBanners() {
        return bannerDAO.getAllBanners();
    }
    //lấy thông tin chi tiết banner theo ID
    public Banner getBannerById(int id) {
        return bannerDAO.getBannerById(id);
    }
    //thêm banner
    public boolean addBanner(Banner banner) {
        return bannerDAO.addBanner(banner);
    }
    public boolean updateBanner(Banner banner) {
        return bannerDAO.updateBanner(banner);
    }
    public boolean deleteBanner(int id) {
        return bannerDAO.deleteBanner(id);
    }
}
