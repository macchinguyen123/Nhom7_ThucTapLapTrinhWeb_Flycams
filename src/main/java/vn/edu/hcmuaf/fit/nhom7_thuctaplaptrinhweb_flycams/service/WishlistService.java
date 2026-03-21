package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.WishlistDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;

import java.util.List;

public class WishlistService {
    private WishlistDAO wishlistDAO = new WishlistDAO();

    //Lấy danh sách sản phẩm trong wishlist của người dùng
    public List<Product> getWishlistProducts(int userId) {
        return wishlistDAO.getWishlistProductsByUser(userId);
    }

    //Lấy danh sách ID sản phẩm trong wishlist của người dùng
    public List<Integer> getWishlistProductIds(int userId) {
        return wishlistDAO.getWishlistProductIds(userId);
    }

    // Thêm một sản phẩm vào wishlist của người dùng
    public boolean add(int userId, int productId) {
        boolean result = wishlistDAO.addToWishlist(userId, productId);
        return result;
    }

    //Xóa một sản phẩm khỏi wishlist của người dùng
    public boolean remove(int userId, int productId) {
        boolean result = wishlistDAO.removeFromWishlist(userId, productId);
        return result;
    }

    //Nếu sản phẩm đã tồn tại trong wishlist, xóa
    //Nếu chưa tồn tại, thêm mới
    public boolean toggleWishlist(int userId, int productId) {
        boolean result;
        if (wishlistDAO.existsInWishlist(userId, productId)) {
            result = wishlistDAO.removeFromWishlist(userId, productId);
        } else {
            result = wishlistDAO.addToWishlist(userId, productId);
        }
        return result;
    }
}
