package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Post;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class PostDAO {
    private static String isDeletedColumnName;
    private static Boolean hasViewColumn;

    private boolean hasColumn(Connection conn, String tableName, String columnName) throws SQLException {
        if (columnName == null || columnName.trim().isEmpty()) {
            return false;
        }
        try (ResultSet rs = conn.getMetaData().getColumns(null, null, tableName, null)) {
            while (rs.next()) {
                if (columnName.equalsIgnoreCase(rs.getString("COLUMN_NAME"))) {
                    return true;
                }
            }
        }
        return false;
    }

    private String findIsDeletedColumn(Connection conn) throws SQLException {
        if (isDeletedColumnName != null) {
            return isDeletedColumnName;
        }
        String[] candidates = {"is_deleted", "isDeleted", "deleted", "deleted_flag"};
        for (String candidate : candidates) {
            if (hasColumn(conn, "posts", candidate)) {
                isDeletedColumnName = candidate;
                return isDeletedColumnName;
            }
        }
        return null;
    }

    private boolean hasIsDeletedColumn(Connection conn) throws SQLException {
        return findIsDeletedColumn(conn) != null;
    }

    private void ensureIsDeletedColumn(Connection conn) throws SQLException {
        if (findIsDeletedColumn(conn) == null) {
            try (Statement stmt = conn.createStatement()) {
                stmt.executeUpdate("ALTER TABLE posts ADD COLUMN is_deleted TINYINT(1) NOT NULL DEFAULT 0");
                isDeletedColumnName = "is_deleted";
            }
        }
    }

    private boolean hasViewColumn(Connection conn) throws SQLException {
        if (hasViewColumn == null) {
            hasViewColumn = hasColumn(conn, "posts", "view");
        }
        return hasViewColumn;
    }

    public List<Post> getAllPosts() {
        List<Post> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT id, title, content, image, createdAt, product_id");
        try (Connection conn = DBConnection.getConnection()) {
            boolean hasView = hasViewColumn(conn);
            if (hasView) {
                sql.append(", COALESCE(view, 0) AS view");
            }
            sql.append(" FROM posts");
            if (hasIsDeletedColumn(conn)) {
                sql.append(" WHERE " + isDeletedColumnName + " = 0");
            }
            sql.append(" ORDER BY createdAt DESC");
            try (PreparedStatement ps = conn.prepareStatement(sql.toString());
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Post p = new Post(
                            rs.getInt("id"),
                            rs.getString("title"),
                            rs.getString("content"),
                            rs.getString("image"),
                            rs.getTimestamp("createdAt") != null ? rs.getTimestamp("createdAt") : new java.sql.Timestamp(System.currentTimeMillis()),
                            rs.getInt("product_id"),
                            hasView ? rs.getInt("view") : 0
                    );
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Post> getDeletedPosts() {
        List<Post> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT id, title, content, image, createdAt, product_id");
        try (Connection conn = DBConnection.getConnection()) {
            if (!hasIsDeletedColumn(conn)) {
                return list;
            }
            boolean hasView = hasViewColumn(conn);
            if (hasView) {
                sql.append(", COALESCE(view, 0) AS view");
            }
            sql.append(" FROM posts WHERE " + isDeletedColumnName + " = 1 ORDER BY createdAt DESC");
            try (PreparedStatement ps = conn.prepareStatement(sql.toString());
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Post p = new Post(
                            rs.getInt("id"),
                            rs.getString("title"),
                            rs.getString("content"),
                            rs.getString("image"),
                            rs.getTimestamp("createdAt") != null ? rs.getTimestamp("createdAt") : new java.sql.Timestamp(System.currentTimeMillis()),
                            rs.getInt("product_id"),
                            hasView ? rs.getInt("view") : 0
                    );
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addPost(Post post) {
        try (Connection conn = DBConnection.getConnection()) {
            boolean hasIsDeleted = hasIsDeletedColumn(conn);
            boolean hasView = hasViewColumn(conn);
            String sql = "INSERT INTO posts (title, content, image, createdAt, product_id" +
                    (hasIsDeleted ? ", is_deleted" : "") +
                    (hasView ? ", view" : "") + ") VALUES (?, ?, ?, NOW(), ?" +
                    (hasIsDeleted ? ", ?" : "") +
                    (hasView ? ", ?" : "") + ")";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, post.getTitle());
                ps.setString(2, post.getContent());
                ps.setString(3, post.getImage());
                ps.setInt(4, post.getProductId());
                int paramIndex = 5;
                if (hasIsDeleted) {
                    ps.setInt(paramIndex++, 0);
                }
                if (hasView) {
                    ps.setInt(paramIndex++, 0);
                }
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deletePost(int postId) {
        try (Connection conn = DBConnection.getConnection()) {
            ensureIsDeletedColumn(conn);
            String sql = "UPDATE posts SET " + isDeletedColumnName + " = 1 WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, postId);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean restorePost(int postId) {
        try (Connection conn = DBConnection.getConnection()) {
            if (!hasIsDeletedColumn(conn)) {
                return false;
            }
            String sql = "UPDATE posts SET " + isDeletedColumnName + " = 0 WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, postId);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean updatePost(Post post) {
        String sql = "UPDATE posts SET title=?, content=?, image=?, product_id=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, post.getTitle());
            ps.setString(2, post.getContent());
            ps.setString(3, post.getImage());
            ps.setInt(4, post.getProductId());
            ps.setInt(5, post.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}