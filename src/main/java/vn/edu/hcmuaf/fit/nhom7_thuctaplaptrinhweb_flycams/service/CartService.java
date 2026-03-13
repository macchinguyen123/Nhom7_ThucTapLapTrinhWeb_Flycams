package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.cart.Carts;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.OrdersDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;

import java.util.ArrayList;
import java.util.List;

public class CartService {
    private ProductService productService = new ProductService();
    private OrdersDAO ordersDAO = new OrdersDAO();

    public List<OrderItems> prepareBuyNowFromOrder(
            int orderId, int userId) {
        List<OrderItems> buyNowItems = new ArrayList<>();

        Orders oldOrder = ordersDAO.getOrderById(orderId, userId);
        if (oldOrder == null)
            return buyNowItems;

        List<OrderItems> oldItems = ordersDAO
                .getOrderItems(orderId);
        for (OrderItems oldItem : oldItems) {
            Product product = productService.getProduct(oldItem.getProductId());
            if (product == null)
                continue;

            OrderItems item = new OrderItems();
            item.setProductId(product.getId());
            item.setQuantity(oldItem.getQuantity());
            item.setPrice(product.getFinalPrice());
            item.setProduct(product);
            buyNowItems.add(item);
        }
        return buyNowItems;
    }

    //chọn nhiều sản phẩm và bấm "Mua ngay"
    public List<OrderItems> prepareBuyNowFromSelection(
            String[] productIds, String[] quantities) {
        List<OrderItems> buyNowItems = new ArrayList<>();

        if (productIds == null || quantities == null)
            return buyNowItems;

        try {
            for (int i = 0; i < productIds.length; i++) {
                int productId = Integer.parseInt(productIds[i]);
                int quantity = Integer.parseInt(quantities[i]);

                Product product = productService.getProduct(productId);
                if (product == null)
                    continue;

                OrderItems item = new OrderItems();
                item.setProductId(productId);
                item.setQuantity(quantity);
                item.setPrice(product.getFinalPrice());
                item.setProduct(product);
                buyNowItems.add(item);
            }
        } catch (NumberFormatException e) {

        }
        return buyNowItems;
    }

    //bấm "Mua ngay" tại trang chi tiết sản phẩm
    public List<OrderItems> prepareBuyNowSingle(
            int productId, int quantity) {
        List<OrderItems> items = new ArrayList<>();

        Product product = productService.getProduct(productId);
        if (product != null) {
            OrderItems item = new OrderItems();
            item.setProductId(productId);
            item.setQuantity(quantity);
            item.setPrice(product.getFinalPrice());
            item.setProduct(product);
            items.add(item);
        }
        return items;
    }

    //Thêm sản phẩm vào giỏ hàng
    public boolean addToCart(Carts cart, int productId, int quantity) {
        Product product = productService.getProduct(productId);
        if (product != null) {
            cart.addItem(product, quantity);
            return true;
        }
        return false;
    }

    //Xóa một sản phẩm khỏi giỏ hàng
    public void removeFromCart(Carts cart, int productId) {
        if (cart != null) {
            cart.removeItem(productId);
        }
    }

    //Xóa nhiều sản phẩm khỏi giỏ hàng
    public void removeMultiFromCart(Carts cart, String[] productIds) {
        if (cart != null && productIds != null) {
            for (String id : productIds) {
                try {
                    cart.removeItem(Integer.parseInt(id));
                } catch (NumberFormatException e) {
                    // Bỏ qua ID không hợp lệ
                }
            }
        }
    }
    //Cập nhật số lượng sản phẩm trong giỏ hàng
    public boolean updateCartItem(Carts cart, int productId, int quantity) {
        if (cart != null) {
            return cart.updateItem(productId, quantity);
        }
        return false;
    }
}
