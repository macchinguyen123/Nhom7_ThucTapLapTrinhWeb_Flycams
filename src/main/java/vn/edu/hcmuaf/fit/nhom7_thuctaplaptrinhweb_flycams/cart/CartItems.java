package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.cart;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;

import java.io.Serializable;

public class CartItems implements Serializable {
    private int productId;
    private Product product;
    private int quantity;
    private boolean selected;


    public CartItems(Product product, int quantity) {
        this.product = product;
        this.productId = product.getId();
        this.quantity = quantity;
        this.selected = true;
    }

    public Product getProduct() {
        return product;
    }

    public double getTotalPrice() {
        return product.getFinalPrice() * quantity;
    }

    public void updateQuantity(int quantity) {
        this.quantity += quantity;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void setSelected(boolean selected) {
        this.selected = selected;
    }

    public int getProductId() {
        return productId;
    }

    public double getPrice() {
        return product.getFinalPrice();
    }

    public int getQuantity() {
        return quantity;
    }

    public boolean isSelected() {
        return selected;
    }
}
