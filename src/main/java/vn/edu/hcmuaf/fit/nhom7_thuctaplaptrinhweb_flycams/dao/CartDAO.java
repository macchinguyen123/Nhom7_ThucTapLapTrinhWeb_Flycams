package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.cart.CartItems;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.cart.Carts;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Product;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;

import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

public class CartDAO {
    private ProductDAO productDAO = new ProductDAO();

    public Carts getCartByUserId(int userId) {
        String sqlCart = "SELECT id FROM carts WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlCart)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int cartId = rs.getInt("id");
                    Map<Integer, CartItems> items = getCartItems(cartId);
                    Carts cart = new Carts(items);
                    cart.setId(cartId);
                    cart.setUserId(userId);
                    return cart;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Map<Integer, CartItems> getCartItems(int cartId) {
        Map<Integer, CartItems> data = new LinkedHashMap<>();
        String sqlItems = "SELECT product_id, quantity, isSelected FROM cart_items WHERE cart_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlItems)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int productId = rs.getInt("product_id");
                    int quantity = rs.getInt("quantity");
                    boolean selected = rs.getBoolean("isSelected");
                    Product p = productDAO.getProductById(productId);
                    if (p != null) {
                        CartItems item = new CartItems(p, quantity);
                        item.setSelected(selected);
                        data.put(productId, item);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return data;
    }

    public int getOrCreateCartId(int userId) {
        String query = "SELECT id FROM carts WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    return id;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        String insert = "INSERT INTO carts (user_id) VALUES (?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(insert, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int id = rs.getInt(1);
                    return id;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void saveCartItem(int userId, int productId, int quantity, boolean selected) {
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                return;
            }
            int cartId = -1;
            String query = "SELECT id FROM carts WHERE user_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        cartId = rs.getInt("id");
                    }
                }
            }
            if (cartId == -1) {
                String insert = "INSERT INTO carts (user_id) VALUES (?)";
                try (PreparedStatement ps = conn.prepareStatement(insert, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, userId);
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            cartId = rs.getInt(1);
                        }
                    }
                }
            }
            if (cartId == -1) {
                return;
            }
            boolean exists = false;
            String checkQuery = "SELECT quantity FROM cart_items WHERE cart_id = ? AND product_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkQuery)) {
                ps.setInt(1, cartId);
                ps.setInt(2, productId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) exists = true;
                }
            }
            if (exists) {
                String update = "UPDATE cart_items SET quantity = ?, isSelected = ? WHERE cart_id = ? AND product_id = ?";
                try (PreparedStatement ps = conn.prepareStatement(update)) {
                    ps.setInt(1, quantity);
                    ps.setBoolean(2, selected);
                    ps.setInt(3, cartId);
                    ps.setInt(4, productId);
                    ps.setQueryTimeout(10);
                    ps.executeUpdate();
                }
            } else {
                String insert = "INSERT INTO cart_items (cart_id, product_id, quantity, isSelected) VALUES (?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insert)) {
                    ps.setInt(1, cartId);
                    ps.setInt(2, productId);
                    ps.setInt(3, quantity);
                    ps.setBoolean(4, selected);
                    ps.setQueryTimeout(10);
                    ps.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void removeCartItem(int userId, int productId) {
        int cartId = getOrCreateCartId(userId);
        if (cartId == -1) return;
        String delete = "DELETE FROM cart_items WHERE cart_id = ? AND product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(delete)) {
            ps.setInt(1, cartId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void clearCart(int userId) {
        int cartId = getOrCreateCartId(userId);
        if (cartId == -1) return;
        String delete = "DELETE FROM cart_items WHERE cart_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(delete)) {
            ps.setInt(1, cartId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void syncCart(int userId, Carts sessionCart) {
        int cartId = getOrCreateCartId(userId);
        if (cartId == -1) return;
        for (CartItems item : sessionCart.getItems()) {
            saveCartItem(userId, item.getProductId(), item.getQuantity(), item.isSelected());
        }
    }
}