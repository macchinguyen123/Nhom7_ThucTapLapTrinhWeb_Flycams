package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.cart;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;

import java.io.Serializable;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;


public class Carts implements Serializable {
    private int id;
    private int userId;
    Map<Integer, CartItems> data;
    private User user;

    public Carts() {
        this.data = new LinkedHashMap<>();
    }

    public Carts(Map<Integer, CartItems> data) {
        this.data = data != null ? new LinkedHashMap<>(data) : new LinkedHashMap<>();
    }


    public void addItem(Product product, int quantity) {
        if (quantity <= 0) quantity = 1;
        CartItems item = data.get(product.getId());
        if (item != null) {
            //thêm trùng , cộng số lượng
            item.updateQuantity(quantity);
        } else {
            data.put(product.getId(), new CartItems(product, quantity));
        }
    }


    public boolean updateItem(int productId, int quantity) {
        if (!data.containsKey(productId)) return false;
        if (quantity <= 0) {
            data.remove(productId);
        } else {
            data.get(productId).setQuantity(quantity);
        }
        return true;
    }

    public void clear() {
        data.clear();
    }


    public CartItems removeItem(int productId) {
        if (get(productId) == null) return null;
        return data.remove(productId);
    }


    public List<CartItems> removeAllItem() {
        ArrayList<CartItems> cartItems = new ArrayList<>();
        data.clear();
        return cartItems;
    }

    public List<CartItems> getItems() {
        List<CartItems> items = new ArrayList<>(data.values());
        Collections.reverse(items); // đảo ngược: mới nhất lên đầu
        return items;
    }

    private CartItems get(int id) {
        return data.get(id);
    }

    public int totalQuantity() {
        AtomicInteger total = new AtomicInteger();
        getItems().forEach(item -> {
            total.addAndGet(item.getQuantity());
        });
        return total.get();
    }

    public double total() {
        double total = 0;
        for (CartItems item : data.values()) {
            if (item.isSelected()) {
                total += item.getTotalPrice();
            }
        }
        return total;
    }

    public void updateCustomer(User user) {
        this.user = user;
    }
}
