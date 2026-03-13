package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "GoogleLoginServlet", value = "/google-login")
public class GoogleLoginServlet extends HttpServlet {
    private static final String CLIENT_ID = "75476416232-ge5966lp069m7494drdfhlh319d82t6l.apps.googleusercontent.com";
    private static final String REDIRECT_URI = "http://localhost:8080/Nhom12LapTrinhWebFlycams/google-callback";
    private static final String SCOPE = "openid email profile";
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String oauthURL = "https://accounts.google.com/o/oauth2/v2/auth" +
                "?client_id=" + CLIENT_ID +
                "&redirect_uri=" + REDIRECT_URI +
                "&response_type=code" +
                "&scope=" + SCOPE +
                "&access_type=offline" +
                "&prompt=consent";
        response.sendRedirect(oauthURL);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}