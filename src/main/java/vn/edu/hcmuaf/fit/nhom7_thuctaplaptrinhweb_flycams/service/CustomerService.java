package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;

import java.util.List;

public class CustomerService {
    private UserDAO userDAO = new UserDAO();

    //Lấy danh sách tất cả người dùng trong hệ thống
    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    //Lấy danh sách khách hàng
    public List<User> getAllCustomers() {
        return userDAO.getAllCustomers();
    }

    //Tìm kiếm tài khoản người dùng
    public List<User> searchUsers(String keyword) {
        return userDAO.searchUsers(keyword);
    }

    //Lấy thông tin người dùng theo ID
    public User getUserById(int id) {
        return userDAO.findById(id);
    }

    //Cập nhật trạng thái người dùng
    public boolean updateStatus(int userId, boolean status) {
        return userDAO.updateStatus(userId, status);
    }
    
    //Cập nhật trạng thái người dùng kèm lý do khóa
    public boolean updateStatusWithReason(int userId, boolean status, String lockReason) {
        return userDAO.updateStatusWithReason(userId, status, lockReason);
    }

    //Cập nhật thông tin người dùng
    public boolean updateUser(User user) {
        return userDAO.updateUser(user);
    }

    //Cập nhật địa chỉ của người dùng
    public boolean updateUserAddress(int userId, String address) {
        return userDAO.updateUserAddress(userId, address);
    }
}
