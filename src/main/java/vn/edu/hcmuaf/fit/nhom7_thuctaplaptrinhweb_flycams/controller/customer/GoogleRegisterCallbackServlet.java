package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name = "GoogleRegisterCallbackServlet", value = "/google-register-callback")
public class GoogleRegisterCallbackServlet extends HttpServlet {
    private static final String CLIENT_ID = "75476416232-a03cpg0memv6kegoupj3sndro4bi9ek8.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "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";
    private static final String REDIRECT_URI = "http://localhost:8080/Nhom12LapTrinhWebFlycams/google-register-callback";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String code = request.getParameter("code");
        if (code == null) {
            response.sendRedirect(request.getContextPath() + "/Register");
            return;
        }
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            HttpPost post = new HttpPost("https://oauth2.googleapis.com/token");
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("code", code));
            params.add(new BasicNameValuePair("client_id", CLIENT_ID));
            params.add(new BasicNameValuePair("client_secret", CLIENT_SECRET));
            params.add(new BasicNameValuePair("redirect_uri", REDIRECT_URI));
            params.add(new BasicNameValuePair("grant_type", "authorization_code"));
            post.setEntity(new UrlEncodedFormEntity(params));
            String tokenJson = EntityUtils.toString(
                    client.execute(post).getEntity());
            ObjectMapper mapper = new ObjectMapper();
            Map<String, Object> token = mapper.readValue(tokenJson, Map.class);
            String accessToken = (String) token.get("access_token");
            HttpGet get = new HttpGet("https://www.googleapis.com/oauth2/v2/userinfo");
            get.setHeader("Authorization", "Bearer " + accessToken);
            String userJson = EntityUtils.toString(
                    client.execute(get).getEntity());
            Map<String, Object> info = mapper.readValue(userJson, Map.class);
            String email = (String) info.get("email");
            String name = (String) info.get("name");
            UserDAO userDAO = new UserDAO();
            if (userDAO.findByEmail(email) != null) {
                request.getSession().setAttribute("error",
                        "Email Google này đã được đăng ký");
                response.sendRedirect(request.getContextPath() + "/Login");
                return;
            }
            User user = new User();
            user.setEmail(email);
            user.setFullName(name);
            user.setRoleId(2);
            userDAO.insertGoogleUser(user);
            request.getSession().setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/home");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Register");
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}