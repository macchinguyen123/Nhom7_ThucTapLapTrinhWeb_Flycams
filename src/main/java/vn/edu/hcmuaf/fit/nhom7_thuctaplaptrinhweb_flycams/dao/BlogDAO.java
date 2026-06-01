package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao;


import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Post;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BlogDAO extends DBConnection {
    private static Boolean hasIsDeletedColumn;
    private static Boolean hasViewColumn;
    private static Boolean hasLikeCountColumn;

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

    private boolean hasIsDeletedColumn(Connection conn) throws SQLException {
        if (hasIsDeletedColumn == null) {
            hasIsDeletedColumn = hasColumn(conn, "posts", "is_deleted");
        }
        return hasIsDeletedColumn;
    }

    private boolean hasViewColumn(Connection conn) throws SQLException {
        if (hasViewColumn == null) {
            hasViewColumn = hasColumn(conn, "posts", "view");
        }
        return hasViewColumn;
    }

    private boolean hasLikeCountColumn(Connection conn) throws SQLException {
        if (hasLikeCountColumn == null) {
            hasLikeCountColumn = hasColumn(conn, "posts", "like_count");
        }
        return hasLikeCountColumn;
    }

    public List<Post> getAllPosts() {
        List<Post> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT id, title, content, image, createdAt, product_id");
        try (Connection conn = DBConnection.getConnection()) {
            boolean hasView = hasViewColumn(conn);
            boolean hasLikeCount = hasLikeCountColumn(conn);
            if (hasView) {
                sql.append(", COALESCE(view, 0) AS view");
            }
            if (hasLikeCount) {
                sql.append(", COALESCE(like_count, 0) AS likeCount");
            }
            sql.append(" FROM posts");
            if (hasIsDeletedColumn(conn)) {
                sql.append(" WHERE is_deleted = 0");
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
                            rs.getTimestamp("createdAt"),
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
            boolean hasLikeCount = hasLikeCountColumn(conn);
            if (hasView) {
                sql.append(", COALESCE(view, 0) AS view");
            }
            if (hasLikeCount) {
                sql.append(", COALESCE(like_count, 0) AS likeCount");
            }
            sql.append(" FROM posts WHERE is_deleted = 1 ORDER BY createdAt DESC");
            try (PreparedStatement ps = conn.prepareStatement(sql.toString());
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Post p = new Post(
                            rs.getInt("id"),
                            rs.getString("title"),
                            rs.getString("content"),
                            rs.getString("image"),
                            rs.getTimestamp("createdAt"),
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

    public Post getPostById(int id) {
        StringBuilder sql = new StringBuilder("SELECT id, title, content, image, createdAt, product_id");
        try (Connection conn = DBConnection.getConnection()) {
            boolean hasView = hasViewColumn(conn);
            boolean hasLikeCount = hasLikeCountColumn(conn);
            if (hasView) {
                sql.append(", COALESCE(view, 0) AS view");
            }
            if (hasLikeCount) {
                sql.append(", COALESCE(like_count, 0) AS likeCount");
            }
            sql.append(" FROM posts WHERE id = ?");
            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    return new Post(
                            rs.getInt("id"),
                            rs.getString("title"),
                            rs.getString("content"),
                            rs.getString("image"),
                            rs.getTimestamp("createdAt"),
                            rs.getInt("product_id"),
                            hasView ? rs.getInt("view") : 0
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean hasReviewed(int blogId, int userId) {
        String sql = "SELECT 1 FROM blog_reviews WHERE blog_id=? AND user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, blogId);
            ps.setInt(2, userId);
            return ps.executeQuery().next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void insert(int blogId, int userId, String content) {
        String sql = "INSERT INTO blog_reviews(blog_id,user_id,content) VALUES(?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, blogId);
            ps.setInt(2, userId);
            ps.setString(3, content);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Post> getMorePosts(int currentPostId) {
        List<Post> list = new ArrayList<>();
        String sql = """
                    SELECT id, title
                    FROM posts
                    WHERE id <> ?
                    ORDER BY createdAt DESC
                    LIMIT 5
                """;
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, currentPostId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Post p = new Post();
                p.setId(rs.getInt("id"));
                p.setTitle(rs.getString("title"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Post> getRelatedPosts(int currentPostId) {
        List<Post> list = new ArrayList<>();
        String sql = """
                    SELECT id, title, content, image, createdAt
                    FROM posts
                    WHERE id <> ?
                    ORDER BY createdAt DESC
                    LIMIT 6
                """;
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, currentPostId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Post p = new Post();
                p.setId(rs.getInt("id"));
                p.setTitle(rs.getString("title"));
                p.setContent(rs.getString("content"));
                p.setImage(rs.getString("image"));
                p.setCreatedAt(rs.getTimestamp("createdAt"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getReviewsByBlog(int blogId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
                    SELECT br.content, br.createdAt, u.fullname
                    FROM blog_reviews br
                    JOIN users u ON br.user_id = u.id
                    WHERE br.blog_id = ?
                    ORDER BY br.createdAt DESC
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, blogId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("content", rs.getString("content"));
                row.put("createdAt", rs.getTimestamp("createdAt"));
                row.put("username", rs.getString("fullname"));
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public void incrementView(int postId) {
        String sql = "UPDATE posts SET view = COALESCE(view, 0) + 1 WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
