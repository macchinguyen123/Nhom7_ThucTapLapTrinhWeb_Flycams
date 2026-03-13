package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.CategoryDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Categories;

import java.util.List;

public class CategoryService {
    private CategoryDAO categoryDAO = new CategoryDAO();

    //Lấy thông tin danh mục theo ID
    public Categories getCategoryById(int id) {
        return categoryDAO.getCategoryById(id);
    }

    //Lấy danh sách danh mục để hiển thị trên header
    public List<Categories> getCategoriesForHeader() {
        return categoryDAO.getCategoriesForHeader();
    }

    //Lấy tên danh mục theo ID
    public String getCategoryNameById(int id) {
        return categoryDAO.getCategoryNameById(id);
    }

    // Admin
    //Lấy toàn bộ danh mục cho trang quản trị
    public List<Categories> getAllCategoriesAdmin() {
        return categoryDAO.getAllCategoriesAdmin();
    }

    //Thêm mới danh mục
    public boolean addCategory(Categories c) {
        return categoryDAO.insert(c);
    }

    //Cập nhật thông tin danh mục
    public boolean updateCategory(Categories c) {
        return categoryDAO.update(c);
    }

    //Xóa danh mục theo ID
    public boolean deleteCategory(int id) {
        return categoryDAO.delete(id);
    }

    //Cập nhật thứ tự hiển thị của danh mục
    public void updateCategorySort(int id, int sortOrder) {
        categoryDAO.updateSortOrder(id, sortOrder);
    }
}
