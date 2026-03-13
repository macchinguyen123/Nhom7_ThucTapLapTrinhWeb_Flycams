package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.HomeDao;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.ImageDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.ProductManagement;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Image;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;

import java.util.List;
import java.util.Map;

public class ProductService {
    private ProductDAO productDAO = new ProductDAO();
    ImageDAO imageDAO = new ImageDAO();
    private HomeDao homeDao = new HomeDao();

    //Lấy thông tin chi tiết sản phẩm theo ID
    public Product getProduct(int productId) {
        Product product = productDAO.getProductById(productId);
        if (product != null) {
            product.setImages(imageDAO.getImagesByProduct(product.getId()));
        }
        return product;
    }

    //Tìm kiếm sản phẩm trong một danh mục cụ thể, lọc giá, thương hiệu và sắp xếp
    public List<Product> searchProductsInCategory(int categoryId, String keyword, Double minPrice,
                                                  Double maxPrice, List<String> brandList, String sortBy) {
        List<Product> products = productDAO.searchProductsInCategory(categoryId, keyword, minPrice, maxPrice,
                brandList, sortBy);
        return products;
    }

    //Lấy danh sách sản phẩm bán chạy nhất (HomePage)
    public List<Product> getBestSellerProducts(int limit) {
        return homeDao.getBestSellerProducts(limit);
    }

    //Lấy danh sách sản phẩm được xem nhiều nhất
    public List<Product> getTopViewedProducts(int limit) {
        return homeDao.getTopViewedProducts(limit);
    }

    //Lấy danh sách sản phẩm theo danh mục
    public List<Product> getProductsByCategory(int categoryId, int limit) {
        return homeDao.getProductsByCategory(categoryId, limit);
    }

    //Tăng số lượt xem sản phẩm
    public void incrementViewCount(int productId) {
        productDAO.incrementViewCount(productId);
    }

    //Lấy danh sách sản phẩm liên quan , cùng danh mục
    public List<Product> getRelatedProducts(int categoryId, int productId, int limit) {
        return productDAO.getRelatedProducts(categoryId, productId, limit);
    }

    //Tìm kiếm sản phẩm toàn hệ thống
    public List<Product> searchProducts(String keyword, String priceFilter, Double minPrice,
                                        Double maxPrice, List<String> brandList, String sortBy) {
        return productDAO.searchProducts(keyword, priceFilter, minPrice, maxPrice, brandList, sortBy);
    }

    //Gợi ý sản phẩm khi người dùng nhập từ khóa
    public List<Map<String, Object>> getProductSuggestions(String keyword) {
        return productDAO.getProductSuggestions(keyword);
    }

    // Admin Methods
    private ProductManagement productManagement = new ProductManagement();

    //Lấy toàn bộ sản phẩm cho trang quản lý
    public List<Product> getAllProductsForAdmin() {
        return productDAO.getAllProductsForAdmin();
    }

    //Xóa sản phẩm theo ID
    public boolean deleteProduct(int productId) {
        return productManagement.deleteProduct(productId);
    }

    //Lấy chi tiết sản phẩm cho trang chỉnh sửa Admin
    public Product getProductDetailAdmin(int productId) {
        Product product = productDAO.getProductById(productId);
        if (product != null) {
            List<Image> allImages = imageDAO
                    .getImagesByProduct(productId);
            allImages.stream()
                    .filter(img -> "Chính".equals(img.getImageType()))
                    .findFirst()
                    .ifPresent(img -> product.setMainImage(img.getImageUrl()));
            List<Image> extraImages = allImages.stream()
                    .filter(img -> !"Chính".equals(img.getImageType()))
                    .collect(java.util.stream.Collectors.toList());
            product.setImages(extraImages);
        }
        return product;
    }

    //Thêm mới hoặc cập nhật sản phẩm
    public int saveProduct(Product product) throws Exception {
        boolean isAdd = product.getId() == 0;
        int productId;
        if (isAdd) {
            productId = productManagement.insertProduct(product);
        } else {
            productManagement.updateProduct(product);
            productId = product.getId();
        }
        if (productId <= 0) {
            throw new Exception("Save product failed");
        }
        imageDAO.deleteImagesByProduct(productId);
        if (product.getMainImage() != null && !product.getMainImage().isEmpty()) {
            imageDAO.insertImage(productId, product.getMainImage(), "Chính");
        }
        if (product.getImages() != null) {
            for (Image img : product.getImages()) {
                if (img.getImageUrl() != null && !img.getImageUrl().isEmpty()
                        && !img.getImageUrl().equals(product.getMainImage())) {
                    imageDAO.insertImage(productId, img.getImageUrl(), "Phụ");
                }
            }
        }
        return productId;
    }

    //Cập nhật trạng thái sản phẩm
    public boolean updateProductStatus(int id, String status) throws Exception {
        return productManagement.updateProductStatus(id, status);
    }
}
