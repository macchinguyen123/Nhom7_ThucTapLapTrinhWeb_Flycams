package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.MailProperties.EmailSender;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.PasswordUtil;
import java.sql.Date;

public class AuthService {
    private UserDAO userDAO = new UserDAO();
    //xử lý đăng nhập bằng email/số điện thoại
    public User login(String input, String password) {
        return userDAO.login(input, password);
    }
    //kiểm tra username đã tồn tại hay chưa
    public boolean isUsernameExists(String username) {
        return userDAO.isUsernameExists(username);
    }
    //kiểm tra email đã tồn tại hay chưa
    public boolean isEmailExists(String email) {
        return userDAO.isEmailExists(email);
    }
    //kiểm tra số điện thoại đã tồn tại hay chưa
    public boolean isPhoneNumberExists(String phone) {
        return userDAO.isPhoneNumberExists(phone);
    }
    //đăng ký
    public RegisterDTO prepareRegister(String fullName, String email, String username,
            String password, String phone, Date birthday) {
        //tạo User
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setUsername(username);
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setPhoneNumber(phone);
        user.setRoleId(2);
        user.setStatus(true);
        user.setBirthDate(birthday);
        //sinh OTP 4 số
        String otp = String.valueOf((int) (Math.random() * 9000) + 1000);
        long expireTime = System.currentTimeMillis() + 5 * 60 * 1000;
        //gửi email OTP
        EmailSender sender = new EmailSender();
        sender.sendVerificationEmail(email, "Xác thực đăng ký SKYDRONE", username, otp, "Mã OTP của bạn", "Cảm ơn bạn đã đăng ký");
        return new RegisterDTO(user, otp, expireTime);
    }
    //đổi mật khẩu có xác thực OTP
    public String changePassword(int userId, String email, String currentPass, String newPass, String confirmPass,
            String expectedOtp, String inputOtp) {
        if (expectedOtp == null || !expectedOtp.equals(inputOtp)) {
            return "Mã OTP không đúng hoặc chưa được gửi";
        }
        User checkLogin = userDAO.login(email, currentPass);
        if (checkLogin == null) {
            return "Mật khẩu hiện tại không đúng";
        }
        if (!vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.validate.Validator.isValidPassword(newPass)) {
            return "Mật khẩu mới phải ≥8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt";
        }
        if (newPass.equals(currentPass)) {
            return "Mật khẩu mới không được giống mật khẩu cũ";
        }
        if (!newPass.equals(confirmPass)) {
            return "Mật khẩu nhập lại không khớp";
        }
        String hashedNewPassword = PasswordUtil.hashPassword(newPass);
        boolean updated = userDAO.updatePassword(userId, hashedNewPassword);
        if (!updated) {
            return "Đổi mật khẩu thất bại. Vui lòng thử lại!";
        }
        return null;
    }
    //gửi OTP đặt lại mật khẩu qua email
    public String forgotPassword(String email) {
        User user = userDAO.getUserByEmail(email);
        if (user == null) {
            return null;
        }
        //sinh OTP 4 số
        String otp = String.valueOf((int) (Math.random() * 9000) + 1000);
        //gửi OTP qua email
        EmailSender emailSender = new EmailSender();
        String title = "Mã OTP đặt lại mật khẩu";
        String content = "Mã OTP của bạn là";
        String thanks = "Vui lòng nhập mã OTP bên dưới để tiếp tục";
        String otpHtml = "<h1 style='color:red;'>" + otp + "</h1>";
        emailSender.sendVerificationEmail(email, title, user.getUsername(), otpHtml, content, thanks);
        return otp;
    }
    // gửi lại OTP
    public String resendOtp(String email, String username, String title, String content, String thanks) {
        String otp = String.valueOf((int) (Math.random() * 9000) + 1000);
        EmailSender emailSender = new EmailSender();
        String otpHtml = "<h1 style='color:red;'>" + otp + "</h1>";
        emailSender.sendVerificationEmail(email, title, username, otpHtml, content, thanks);
        return otp;
    }
    //đặt lại mật khẩu sau khi xác thực OTP
    public boolean resetPassword(String email, String newPassword) {
        User user = userDAO.getUserByEmail(email);
        if (user == null) {
            return false;
        }
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        return userDAO.updatePassword(user.getId(), hashedPassword);
    }
    //cập nhật thông tin
    public User getUserByEmail(String email) {
        return userDAO.getUserByEmail(email);
    }
    public boolean updateAvatar(int userId, String fileName) {
        return userDAO.updateAvatar(userId, fileName);
    }
    public boolean updateProfile(User user) {
        return userDAO.updateProfile(user);
    }
    public boolean updateProfileAdmin(User user) {
        return userDAO.updateProfileAdmin(user);
    }
    //DTO dùng để truyền dữ liệu đăng ký
    public static class RegisterDTO {
        private final User user;
        private final String otp;
        private final long expireTime;
        public RegisterDTO(User user, String otp, long expireTime) {
            this.user = user;
            this.otp = otp;
            this.expireTime = expireTime;
        }
        public User getUser() {
            return user;
        }
        public String getOtp() {
            return otp;
        }
        public long getExpireTime() {
            return expireTime;
        }
    }
}
