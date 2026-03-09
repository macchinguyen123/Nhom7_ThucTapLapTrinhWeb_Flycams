package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    //mã hóa mật khẩu
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
    }

    // kiểm tra mật khẩu khi đăng nhập
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}
