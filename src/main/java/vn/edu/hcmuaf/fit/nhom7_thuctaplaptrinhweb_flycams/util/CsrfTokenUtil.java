package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.util.Base64;

public class CsrfTokenUtil {
    public static final String SESSION_ATTR = "CSRF_TOKEN";
    public static final String PARAM_NAME   = "_csrf";
    public static final String HEADER_NAME  = "X-CSRF-Token";
    private static final SecureRandom RANDOM = new SecureRandom();

    private CsrfTokenUtil() { }



    //lấy token của hiện tại, nếu mà chưa có thì tạo cái mới và lưu vào session
    public static String getOrCreate(HttpSession session) {
        String token = (String) session.getAttribute(SESSION_ATTR);
        if (token == null || token.isEmpty()) {
            token = generate();
            session.setAttribute(SESSION_ATTR, token);
        }
        return token;
    }
    //tạo chuỗi 32 ký tự ngầu nhiên cho getOrCreate bên trên tron trường hợp chưa có token
    private static String generate() {
        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    // tạo 1 token mới ghi đè lên token cũ để tăng bảo mật
    public static String regenerate(HttpSession session) {
        String token = generate();
        session.setAttribute(SESSION_ATTR, token);
        return token;
    }

    //hàm so sánh token của session và token client
    public static boolean isValid(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        String sessionToken = (String) session.getAttribute(SESSION_ATTR);
        if (sessionToken == null || sessionToken.isEmpty()) return false;

        String clientToken = request.getHeader(HEADER_NAME);
        if (clientToken == null || clientToken.isEmpty()) {
            clientToken = request.getParameter(PARAM_NAME);
        }

        return constantTimeEquals(sessionToken, clientToken);
    }


    //hàm này thay cho hàm equals. Dùng equals thì sẽ dễ bị hacker dùng thủ thuật timing attack
    //hàm này không dùng ngay khi sai mà chạy hết vòng lặp, thời gian gần như là cố định khiến việc timing attack khó hơn.
    private static boolean constantTimeEquals(String a, String b) {
        if (a == null || b == null) return false;
        if (a.length() != b.length()) return false;
        int result = 0;
        for (int i = 0; i < a.length(); i++) {
            result |= (a.charAt(i) ^ b.charAt(i));
        }
        return result == 0;
    }

}
