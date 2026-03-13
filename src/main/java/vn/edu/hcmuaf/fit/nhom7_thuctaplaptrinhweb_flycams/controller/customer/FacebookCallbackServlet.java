package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;

@WebServlet(name = "FacebookCallbackServlet", value = "/facebook-callback")
public class FacebookCallbackServlet extends HttpServlet {
    private static final String APP_ID = "1677006510324478";
    private static final String APP_SECRET = "b29048650310a32f2a014a54e618347b";
    private static final String REDIRECT_URI = "http://localhost:8080/Nhom12LapTrinhWebFlycams/facebook-callback";
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        try (CloseableHttpClient client = HttpClients.createDefault()) {
            String tokenUrl = "https://graph.facebook.com/v19.0/oauth/access_token" +
                    "?client_id=" + APP_ID +
                    "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, StandardCharsets.UTF_8) +
                    "&client_secret=" + APP_SECRET +
                    "&code=" + code;
            HttpGet tokenGet = new HttpGet(tokenUrl);
            CloseableHttpResponse tokenResponse = client.execute(tokenGet);
            String tokenJson = EntityUtils.toString(tokenResponse.getEntity());
            ObjectMapper mapper = new ObjectMapper();
            Map<String, Object> tokenData = mapper.readValue(tokenJson, Map.class);
            String accessToken = (String) tokenData.get("access_token");
            if (accessToken == null) {
                request.getSession().setAttribute("error", "Không thể lấy access token từ Facebook");
                response.sendRedirect(request.getContextPath() + "/Login");
                return;
            }
            String userInfoUrl = "https://graph.facebook.com/me?fields=id,name,email&access_token=" + accessToken;
            HttpGet infoGet = new HttpGet(userInfoUrl);
            CloseableHttpResponse infoResponse = client.execute(infoGet);
            String userJson = EntityUtils.toString(infoResponse.getEntity());
            Map<String, Object> userInfo = mapper.readValue(userJson, Map.class);
            String email = (String) userInfo.get("email");
            if (email == null) {
                request.getSession().setAttribute("error",
                        "Không thể lấy email từ tài khoản Facebook này (Có thể tài khoản không có email hoặc chưa cấp quyền).");
                response.sendRedirect(request.getContextPath() + "/Login");
                return;
            }
            UserDAO userDAO = new UserDAO();
            User user = userDAO.findByEmail(email);
            if (user == null) {
                request.getSession().setAttribute("error", "Email Facebook này chưa được đăng ký trong hệ thống");
                response.sendRedirect(request.getContextPath() + "/Login");
                return;
            }
            request.getSession().setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/home");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Đã xảy ra lỗi khi đăng nhập bằng Facebook");
            response.sendRedirect(request.getContextPath() + "/Login");
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}
