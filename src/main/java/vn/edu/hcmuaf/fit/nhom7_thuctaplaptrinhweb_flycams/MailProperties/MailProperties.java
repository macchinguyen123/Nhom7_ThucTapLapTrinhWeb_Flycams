package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.MailProperties;
import java.io.IOException;
import java.util.Properties;

public class MailProperties {
    private static final Properties properties = new Properties();
    static {
        try {
            properties.load(
                    MailProperties.class
                            .getClassLoader()
                            .getResourceAsStream("Mail.properties")
            );
        } catch (IOException e) {
            throw new RuntimeException("Không load được Mail.properties", e);
        }
    }
    public static final String HOST = properties.getProperty("mail.smtp.host");
    public static final String PORT = properties.getProperty("mail.smtp.port");
    public static final String USER = properties.getProperty("mail.user");
    public static final String PASSWORD = properties.getProperty("mail.password");
    public static final boolean AUTH =
            "true".equals(properties.getProperty("mail.smtp.auth"));
    public static final boolean STARTTLS =
            "true".equals(properties.getProperty("mail.smtp.starttls.enable"));
}
