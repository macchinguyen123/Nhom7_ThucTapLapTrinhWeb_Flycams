package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Address;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.PasswordUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import static vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.DBConnection.getConnection;
public class UserDAO {
    public User login(String input, String password) {
        String sql = "SELECT * FROM users WHERE email = ? OR phoneNumber = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, input);
            ps.setString(2, input);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String hashedPw = rs.getString("password"); //mật khẩu trong DB
                boolean passOk = false;
                if (hashedPw != null) {
                    if (hashedPw.startsWith("$2a$")) { //là hash BCrypt
                        passOk = PasswordUtil.checkPassword(password, hashedPw);
                    } else { //plaintext
                        passOk = password.equals(hashedPw);
                    }
                }
                if (passOk) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setRoleId(rs.getInt("roleId"));
                    user.setFullName(rs.getString("fullName"));
                    user.setEmail(rs.getString("email"));
                    user.setUsername(rs.getString("username"));
                    user.setPhoneNumber(rs.getString("phoneNumber"));
                    user.setAvatar(rs.getString("avatar"));
                    user.setGender(rs.getString("gender"));
                    user.setBirthDate(rs.getDate("birthDate"));
                    user.setStatus(rs.getBoolean("status"));
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; //mật khẩu không đúng hoặc không tìm thấy user
    }
    public boolean insertUser(User user) {
        String sql = "INSERT INTO users (roleId, fullName, birthDate, gender, email, username, password, phoneNumber, avatar, status, createdAt, updatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user.getRoleId());
            ps.setString(2, user.getFullName());
            // birthDate
            if (user.getBirthDate() != null) {
                ps.setDate(3, new Date(user.getBirthDate().getTime()));
            } else {
                ps.setNull(3, Types.DATE);
            }
            //gender
            ps.setString(4, user.getGender() == null ? "OTHER" : user.getGender());
            ps.setString(5, user.getEmail());
            ps.setString(6, user.getUsername());
            ps.setString(7, user.getPassword());
            ps.setString(8, user.getPhoneNumber());
            //avatar
            ps.setString(9, user.getAvatar() == null ? "default.png" : user.getAvatar());
            ps.setBoolean(10, user.isStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean isUsernameExists(String username) {
        String sql = "SELECT id FROM users WHERE username = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next(); //nếu có -> username đã tồn tại
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean isEmailExists(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next(); // nếu có dòng -> email đã tồn tại
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean isPhoneNumberExists(String phoneNumber) {
        String sql = "SELECT id FROM users WHERE phoneNumber = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phoneNumber);
            ResultSet rs = ps.executeQuery();
            return rs.next(); //nếu có dòng -> sđt đã tồn tại
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public User findById(int id) {
        User u = null;
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    u = new User();
                    u.setId(rs.getInt("id"));
                    u.setRoleId(rs.getInt("roleId"));
                    u.setFullName(rs.getString("fullName"));
                    Date date = rs.getDate("birthDate");
                    if (date != null) {
                        u.setBirthDate(new java.util.Date(date.getTime()));
                    }
                    u.setGender(rs.getString("gender"));
                    u.setEmail(rs.getString("email"));
                    u.setUsername(rs.getString("username"));
                    u.setPhoneNumber(rs.getString("phoneNumber"));
                    u.setPassword(rs.getString("password"));
                    u.setAvatar(rs.getString("avatar"));
                    u.setStatus(rs.getBoolean("status"));
                    u.setCreatedAt(rs.getTimestamp("createdAt"));
                    u.setUpdatedAt(rs.getTimestamp("updatedAt"));
                    u.setAddress("");
                }
            }
            if (u != null) {
                String sqlAddr = "SELECT addressLine, district, province FROM addresses WHERE user_id = ? ORDER BY isDefault DESC LIMIT 1";
                try (PreparedStatement psAddr = conn.prepareStatement(sqlAddr)) {
                    psAddr.setInt(1, u.getId());
                    try (ResultSet rsAddr = psAddr.executeQuery()) {
                        if (rsAddr.next()) {
                            String addr = rsAddr.getString("addressLine");
                            if (addr != null) {
                                String dist = rsAddr.getString("district");
                                String prov = rsAddr.getString("province");
                                if (dist != null)
                                    addr += ", " + dist;
                                if (prov != null)
                                    addr += ", " + prov;
                                u.setAddress(addr);
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return u;
    }
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setRoleId(rs.getInt("roleId"));
                user.setFullName(rs.getString("fullName"));
                user.setBirthDate(rs.getDate("birthDate"));
                user.setGender(rs.getString("gender"));
                user.setEmail(rs.getString("email"));
                user.setUsername(rs.getString("username"));
                user.setPhoneNumber(rs.getString("phoneNumber"));
                user.setAvatar(rs.getString("avatar"));
                user.setStatus(rs.getBoolean("status"));
                user.setCreatedAt(rs.getTimestamp("createdAt"));
                user.setUpdatedAt(rs.getTimestamp("updatedAt"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public boolean updatePassword(int userId, String hashedPassword) {
        String sql = "UPDATE users SET password=?, updatedAt=NOW() WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public void update(Address addr) throws SQLException {
        String sql = "UPDATE addresses SET full_name=?, phone_number=?, address_line=?, province=?, district=?, is_default=? WHERE id=? AND user_id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, addr.getFullName());
            ps.setString(2, addr.getPhoneNumber());
            ps.setString(3, addr.getAddressLine());
            ps.setString(4, addr.getProvince());
            ps.setString(5, addr.getDistrict());
            ps.setBoolean(6, addr.isDefaultAddress());
            ps.setInt(7, addr.getId());
            ps.setInt(8, addr.getUserId());
            ps.executeUpdate();
        }
    }
    public boolean updateProfileAdmin(User user) {
        String sql = "UPDATE users SET fullName=?, email=?, phoneNumber=?, avatar=?, gender=?, birthDate=?, updatedAt=NOW() WHERE id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhoneNumber());
            //xử lý avatar
            if (user.getAvatar() != null && !user.getAvatar().trim().isEmpty()) {
                ps.setString(4, user.getAvatar());
            } else {
                ps.setString(4, user.getAvatar());
            }
            //xử lý gender
            ps.setString(5, user.getGender() != null ? user.getGender() : "OTHER");
            //xử lý birthDate - cho phép null
            if (user.getBirthDate() != null) {
                ps.setDate(6, new Date(user.getBirthDate().getTime()));
            } else {
                ps.setNull(6, Types.DATE);
            }
            ps.setInt(7, user.getId());
            int rowsAffected = ps.executeUpdate();
            System.out.println("Update rows affected: " + rowsAffected); // Debug
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error in updateProfileAdmin:");
            e.printStackTrace();
            return false;
        }
    }
    public boolean updateProfile(User user) {
        String sql = "UPDATE users SET fullName=?, username=?, email=?, phoneNumber=?, avatar=?, gender=?, birthDate=?, updatedAt=NOW() WHERE id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getUsername());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhoneNumber());
            ps.setString(5, user.getAvatar());
            ps.setString(6, user.getGender());
            if (user.getBirthDate() != null) {
                ps.setDate(7, new Date(user.getBirthDate().getTime()));
            } else {
                ps.setNull(7, Types.DATE);
            }
            ps.setInt(8, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public List<User> getAllCustomers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE roleId = 2";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setRoleId(rs.getInt("roleId"));
                    u.setFullName(rs.getString("fullName"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setPhoneNumber(rs.getString("phoneNumber"));
                    u.setAvatar(rs.getString("avatar"));
                    u.setGender(rs.getString("gender"));
                    u.setBirthDate(rs.getDate("birthDate"));
                    u.setStatus(rs.getBoolean("status"));
                    u.setPassword(rs.getString("password"));
                    u.setAddress("Chưa cập nhật");
                    list.add(u);
                }
            }
            String sqlAddr = "SELECT addressLine, district, province FROM addresses WHERE user_id = ? ORDER BY isDefault DESC LIMIT 1";
            try (PreparedStatement psAddr = conn.prepareStatement(sqlAddr)) {
                for (User u : list) {
                    psAddr.setInt(1, u.getId());
                    try (ResultSet rsAddr = psAddr.executeQuery()) {
                        if (rsAddr.next()) {
                            String addr = rsAddr.getString("addressLine");
                            if (addr != null) {
                                String dist = rsAddr.getString("district");
                                String prov = rsAddr.getString("province");
                                if (dist != null)
                                    addr += ", " + dist;
                                if (prov != null)
                                    addr += ", " + prov;
                                u.setAddress(addr);
                            }
                        }
                    } catch (Exception ex) {
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            //fetch users
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setRoleId(rs.getInt("roleId"));
                    u.setFullName(rs.getString("fullName"));
                    u.setUsername(rs.getString("username"));
                    u.setEmail(rs.getString("email"));
                    u.setPhoneNumber(rs.getString("phoneNumber"));
                    u.setAvatar(rs.getString("avatar"));
                    u.setGender(rs.getString("gender"));
                    u.setBirthDate(rs.getDate("birthDate"));
                    u.setStatus(rs.getBoolean("status"));
                    u.setPassword(rs.getString("password"));
                    u.setAddress("Chưa cập nhật");
                    list.add(u);
                }
            }
            //fetch addresses sequentially
            String sqlAddr = "SELECT addressLine, district, province FROM addresses WHERE user_id = ? ORDER BY isDefault DESC LIMIT 1";
            try (PreparedStatement psAddr = conn.prepareStatement(sqlAddr)) {
                for (User u : list) {
                    psAddr.setInt(1, u.getId());
                    try (ResultSet rsAddr = psAddr.executeQuery()) {
                        if (rsAddr.next()) {
                            String addr = rsAddr.getString("addressLine");
                            if (addr != null) {
                                String dist = rsAddr.getString("district");
                                String prov = rsAddr.getString("province");
                                if (dist != null)
                                    addr += ", " + dist;
                                if (prov != null)
                                    addr += ", " + prov;
                                u.setAddress(addr);
                            }
                        }
                    } catch (Exception ex) {
                        //ignore single error
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET roleId=?, fullName=?, birthDate=?, gender=?, email=?, username=?, password=?, phoneNumber=?, avatar=?, status=?, updatedAt=NOW() WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user.getRoleId());
            ps.setString(2, user.getFullName());
            if (user.getBirthDate() != null) {
                ps.setDate(3, new Date(user.getBirthDate().getTime()));
            } else {
                ps.setNull(3, Types.DATE);
            }
            ps.setString(4, user.getGender());
            ps.setString(5, user.getEmail());
            ps.setString(6, user.getUsername());
            ps.setString(7, user.getPassword());
            ps.setString(8, user.getPhoneNumber());
            ps.setString(9, user.getAvatar());
            ps.setBoolean(10, user.isStatus());
            ps.setInt(11, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean updateStatus(int userId, boolean status) {
        String sql = "UPDATE users SET status=? WHERE id=?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setRoleId(rs.getInt("roleId"));
                user.setFullName(rs.getString("fullName"));
                user.setBirthDate(rs.getDate("birthDate")); //java.sql.Date -> java.util.Date
                user.setGender(rs.getString("gender"));
                user.setEmail(rs.getString("email"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setPhoneNumber(rs.getString("phoneNumber"));
                user.setAvatar(rs.getString("avatar"));
                user.setStatus(rs.getInt("status") == 1); //DB kiểu int, model kiểu boolean
                user.setCreatedAt(rs.getTimestamp("createdAt"));
                user.setUpdatedAt(rs.getTimestamp("updatedAt"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setRoleId(rs.getInt("roleId"));
                user.setFullName(rs.getString("fullName"));
                user.setBirthDate(rs.getDate("birthDate"));
                user.setGender(rs.getString("gender"));
                user.setEmail(rs.getString("email"));
                user.setUsername(rs.getString("username"));
                user.setPhoneNumber(rs.getString("phoneNumber"));
                user.setAvatar(rs.getString("avatar"));
                user.setStatus(rs.getBoolean("status"));
                user.setCreatedAt(rs.getTimestamp("createdAt"));
                user.setUpdatedAt(rs.getTimestamp("updatedAt"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public void insertGoogleUser(User user) {
        String sql = """
                    INSERT INTO users(
                        email, fullName, roleId,
                        birthDate, username, password,
                        phoneNumber, createdAt, updatedAt
                    )
                    VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), NOW())
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getFullName());
            ps.setInt(3, user.getRoleId());
            //Google KHÔNG có ngày sinh → gán tạm
            ps.setDate(4, Date.valueOf("2000-01-01"));
            //username tự sinh từ email
            ps.setString(5, user.getEmail().split("@")[0]);
            //password giả (không dùng)
            ps.setString(6, "GOOGLE");
            //phoneNumber giả
            ps.setString(7, "0000000000");
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public boolean updateUserAddress(int userId, String address) {
        //check địa chỉ
        int addressId = -1;
        String sqlCheck = "SELECT id FROM addresses WHERE user_id = ? ORDER BY isDefault DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    addressId = rs.getInt("id");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (addressId != -1) {
            String sqlUpdate = "UPDATE addresses SET addressLine = ? WHERE id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                ps.setString(1, address);
                ps.setInt(2, addressId);
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            //thêm địa chỉ
            String sqlInsert = "INSERT INTO addresses (user_id, fullName, phoneNumber, addressLine, province, district, isDefault) "
                    +
                    "VALUES (?, ?, ?, ?, ?, ?, 1)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
                //safe defaults
                String uName = "Khách hàng";
                String uPhone = "";
                try {
                    User u = getUserById(userId);
                    if (u != null) {
                        if (u.getFullName() != null)
                            uName = u.getFullName();
                        if (u.getPhoneNumber() != null)
                            uPhone = u.getPhoneNumber();
                    }
                } catch (Exception ignore) {
                }
                ps.setInt(1, userId);
                ps.setString(2, uName);
                ps.setString(3, uPhone);
                ps.setString(4, address);
                ps.setString(5, "");
                ps.setString(6, "");
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }
    public boolean updateAvatar(int userId, String avatar) {
        String sql = "UPDATE users SET avatar = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, avatar);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
