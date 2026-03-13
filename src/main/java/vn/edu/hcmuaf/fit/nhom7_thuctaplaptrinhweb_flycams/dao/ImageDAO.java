package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Image;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ImageDAO {
    public List<Image> getImagesByProduct(int productId) {
        List<Image> list = new ArrayList<>();
        String sql = "SELECT * FROM images WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Image img = new Image(
                        rs.getInt("id"),
                        rs.getInt("product_id"),
                        rs.getString("imageUrl"),
                        rs.getString("imageType")
                );
                list.add(img);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insertImage(int productId, String url, String type)
            throws SQLException {
        String sql = """
                    INSERT INTO images(product_id, imageUrl, imageType)
                    VALUES (?, ?, ?)
                """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setString(2, url);
            ps.setString(3, type);
            ps.executeUpdate();
        }
    }

    public void deleteImagesByProduct(int productId)
            throws SQLException {
        String sql = "DELETE FROM images WHERE product_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.executeUpdate();
        }
    }
}
