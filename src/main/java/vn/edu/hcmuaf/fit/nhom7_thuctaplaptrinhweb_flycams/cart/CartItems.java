package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.cart;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;

import java.io.Serializable;

public class CartItems implements Serializable {
    private int productId;
    private Product product;
    private String productName;
    private double price;
    private int quantity;
    private boolean selected;


    public CartItems(Product product, int quantity) {
        this.product = product;
        this.productId = product.getId();
        this.productName = product.getProductName();
        this.price = product.getFinalPrice();
        this.quantity = quantity;
        this.selected = true;
    }

    public Product getProduct() {
        return product;
    }

    public double getTotalPrice() {
        return price * quantity;
    }

    public void updateQuantity(int quantity) {
        this.quantity += quantity;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public void setPrice(double price) {
        this.price = price;
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

    public String getProductName() {
        return productName;
    }

    public double getPrice() {
        return price;
    }

    public int getQuantity() {
        return quantity;
    }

    public boolean isSelected() {
        return selected;
    }
}
