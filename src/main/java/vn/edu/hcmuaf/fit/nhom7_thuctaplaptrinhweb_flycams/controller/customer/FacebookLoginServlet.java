package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "FacebookLoginServlet", value = "/facebook-login")
public class FacebookLoginServlet extends HttpServlet {
    private static final String APP_ID = "1677006510324478";
    private static final String REDIRECT_URI = "http://localhost:8080/Nhom12LapTrinhWebFlycams/facebook-callback";
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String facebookLoginUrl = "https://www.facebook.com/v19.0/dialog/oauth" +
                "?client_id=" + APP_ID +
                "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, StandardCharsets.UTF_8) +
                "&scope=public_profile,email";
        response.sendRedirect(facebookLoginUrl);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}
