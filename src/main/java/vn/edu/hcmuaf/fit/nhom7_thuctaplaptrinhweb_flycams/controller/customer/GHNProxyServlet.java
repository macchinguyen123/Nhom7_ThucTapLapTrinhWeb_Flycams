package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "GHNProxyServlet", value = "/ghn/*")
public class GHNProxyServlet extends HttpServlet {
    private static final String GHN_TOKEN = "64eae663-1e9c-11f1-a973-aee5264794df";
    private static final int GHN_SHOP_ID = 	199571;
    private static final int FROM_DISTRICT = 3695;
    private static final String GHN_BASE = "https://online-gateway.ghn.vn/shiip/public-api";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Access-Control-Allow-Origin", "*");
        String pathInfo = req.getPathInfo();
        if (pathInfo == null) pathInfo = "/";
        try {
            switch (pathInfo) {
                case "/provinces":
                    handleProvinces(resp);
                    break;
                case "/districts":
                    handleDistricts(req, resp);
                    break;
                case "/wards":
                    handleWards(req, resp);
                    break;
                case "/fee":
                    handleFee(req, resp);
                    break;
                default:
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    resp.getWriter().write("{\"error\":\"Unknown GHN endpoint: " + pathInfo + "\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private void handleProvinces(HttpServletResponse resp) throws IOException {
        String url = GHN_BASE + "/master-data/province";
        String body = callGHN_GET(url, 0);
        resp.getWriter().write(body);
    }

    private void handleDistricts(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String provinceId = req.getParameter("provinceId");
        if (provinceId == null || provinceId.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing provinceId\"}");
            return;
        }
        String url = GHN_BASE + "/master-data/district?province_id=" + provinceId;
        String body = callGHN_GET(url, 0);
        resp.getWriter().write(body);
    }

    private void handleWards(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String districtId = req.getParameter("districtId");
        if (districtId == null || districtId.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing districtId\"}");
            return;
        }
        String url = GHN_BASE + "/master-data/ward?district_id=" + districtId;
        String body = callGHN_GET(url, 0);
        resp.getWriter().write(body);
    }

    private void handleFee(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String districtId = req.getParameter("districtId");
        String wardCode = req.getParameter("wardCode");
        if (districtId == null || districtId.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Missing districtId\"}");
            return;
        }
        String safeWardCode = (wardCode != null && !wardCode.isEmpty()) ? wardCode : "";
        String url = GHN_BASE + "/v2/shipping-order/fee";
        String jsonPayload = "{"
                + "\"service_type_id\":2,"
                + "\"from_district_id\":" + FROM_DISTRICT + ","
                + "\"to_district_id\":" + districtId + ","
                + (safeWardCode.isEmpty() ? "" : "\"to_ward_code\":\"" + safeWardCode + "\",")
                + "\"weight\":500,"
                + "\"length\":20,"
                + "\"width\":15,"
                + "\"height\":10,"
                + "\"insurance_value\":0,"
                + "\"coupon\":\"\""
                + "}";
        String body = callGHN_POST(url, jsonPayload);
        resp.getWriter().write(body);
    }

    private String callGHN_GET(String urlStr, int shopId) throws IOException {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(15000);
        conn.setReadTimeout(15000);
        conn.setRequestProperty("Token", GHN_TOKEN);
        conn.setRequestProperty("Content-Type", "application/json");
        if (shopId > 0) {
            conn.setRequestProperty("ShopId", String.valueOf(shopId));
        }
        return readResponse(conn);
    }

    private String callGHN_POST(String urlStr, String jsonBody) throws IOException {
        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setConnectTimeout(15000);
        conn.setReadTimeout(15000);
        conn.setRequestProperty("Token", GHN_TOKEN);
        conn.setRequestProperty("ShopId", String.valueOf(GHN_SHOP_ID));
        conn.setRequestProperty("Content-Type", "application/json");
        try (OutputStream os = conn.getOutputStream()) {
            os.write(jsonBody.getBytes(StandardCharsets.UTF_8));
        }
        return readResponse(conn);
    }

    private String readResponse(HttpURLConnection conn) throws IOException {
        int code = conn.getResponseCode();
        InputStream is = (code >= 200 && code < 300) ? conn.getInputStream() : conn.getErrorStream();
        if (is == null) return "{\"error\":\"No response body\"}";
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
            return sb.toString();
        } finally {
            conn.disconnect();
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}