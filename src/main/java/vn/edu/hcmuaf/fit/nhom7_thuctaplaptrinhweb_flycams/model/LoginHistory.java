package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class LoginHistory implements Serializable {
    private int id;
    private Integer userId;
    private String username;
    private Timestamp loginTime;
    private String ipAddress;
    private String location;
    private String status;
    private String userAgent;

    public LoginHistory() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public Timestamp getLoginTime() {
        return loginTime;
    }

    public void setLoginTime(Timestamp loginTime) {
        this.loginTime = loginTime;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getLocation() {
        return location;
    }
    public void setLocation(String location) {
        this.location = location;
    }
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
    public String getUserAgent() {
        return userAgent;
    }
    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }
    public static String parseUserAgent(String userAgent) {
        if (userAgent == null) return "Không xác định";
        String lower = userAgent.toLowerCase();
        String os = "Không xác định OS";
        String browser = "Không xác định trình duyệt";
        if (lower.contains("windows")) os = "Windows";
        else if (lower.contains("macintosh") || lower.contains("mac os")) os = "macOS";
        else if (lower.contains("iphone")) os = "iOS (iPhone)";
        else if (lower.contains("ipad")) os = "iOS (iPad)";
        else if (lower.contains("android")) os = "Android";
        else if (lower.contains("linux")) os = "Linux";
        if (lower.contains("chrome")) browser = "Chrome";
        else if (lower.contains("safari") && !lower.contains("chrome")) browser = "Safari";
        else if (lower.contains("firefox")) browser = "Firefox";
        else if (lower.contains("edge")) browser = "Edge";
        else if (lower.contains("opera")) browser = "Opera";
        return browser + " (" + os + ")";
    }
    public static String getIpLocation(String ip) {
        if (ip == null) return "Không xác định";
        if ("127.0.0.1".equals(ip) || "0:0:0:0:0:0:0:1".equals(ip)) {
            return "Localhost";
        }
        return "Việt Nam";
    }
}
