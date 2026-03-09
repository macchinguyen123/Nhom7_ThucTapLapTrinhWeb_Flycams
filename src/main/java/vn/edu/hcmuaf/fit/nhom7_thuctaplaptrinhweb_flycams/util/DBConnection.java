package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {
    private static HikariDataSource dataSource;

    static {
        try {
            Properties props = new Properties();
            InputStream is = DBConnection.class
                    .getClassLoader()
                    .getResourceAsStream("DB.properties");

            if (is == null) {
                throw new RuntimeException("Không tìm thấy file DB.properties");
            }
            props.load(is);
            String host = props.getProperty("db.host");
            String port = props.getProperty("db.port");
            String name = props.getProperty("db.name");
            String user = props.getProperty("db.user");
            String pass = props.getProperty("db.password");
            //khởi tạo cấu hình HikariCP
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl("jdbc:mysql://" + host + ":" + port + "/" + name +
                    "?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC");
            config.setUsername(user);
            config.setPassword(pass);
            config.setDriverClassName("com.mysql.cj.jdbc.Driver");
            //cấu hình Pool
            config.setMinimumIdle(5); //số lượng kết nối nhàn rỗi tối thiểu
            config.setMaximumPoolSize(20); //số lượng kết nối tối đa trong pool
            config.setConnectionTimeout(30000); //thời gian chờ kết nối (30 giây)
            config.setIdleTimeout(600000); //10 phut thời gian tối đa để 1 kết nối nhàn rỗi tồn tại
            //tùy chọn: Tối ưu hiệu năng
            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
            dataSource = new HikariDataSource(config);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error initializing HikariCP Connection Pool", e);
        }
    }

    public static Connection getConnection() {
        try {
            return dataSource.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    //tùy chọn dóng pool khi ứng dụng dừng
    public static void closePool() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}
