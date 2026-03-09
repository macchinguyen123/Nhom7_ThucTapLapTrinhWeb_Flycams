package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.MailProperties;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.InputStream;
import java.util.Properties;

public class EmailSender {
    private static Properties loadMailProperties() {
        try (InputStream input = EmailSender.class
                .getClassLoader()
                .getResourceAsStream("Mail.properties")) {
            if (input == null) {
                throw new RuntimeException("Không tìm thấy Mail.properties");
            }
            Properties props = new Properties();
            props.load(input);
            return props;
        } catch (Exception e) {
            throw new RuntimeException("Lỗi load Mail.properties", e);
        }
    }
    public void sendVerificationEmail(
            String toEmail,
            String title,
            String username,
            String otp,
            String content,
            String thanks) {
        Properties props = loadMailProperties();
        String fromEmail = props.getProperty("mail.from");
        String password = props.getProperty("mail.password");
        //bắt buộc
        props.put("mail.debug", "false");
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(toEmail));
            message.setSubject(title);
            String htmlContent = "<h2>Xin chào " + username + ",</h2>" +
                    "<p>" + thanks + "</p>" +
                    "<p>" + content + ":</p>" +
                    "<h1 style='color:#0051c6;text-align:center'>" + otp + "</h1>" +
                    "<p>Mã có hiệu lực trong 5 phút.</p>";

            message.setContent(htmlContent, "text/html; charset=UTF-8");
            //sử dụng Transport.send để tự động xử lý kết nối và giao thức
            Transport.send(message);
            System.out.println(" Gửi email thành công: " + toEmail);
        } catch (MessagingException e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi gửi email", e);
        }
    }
}
