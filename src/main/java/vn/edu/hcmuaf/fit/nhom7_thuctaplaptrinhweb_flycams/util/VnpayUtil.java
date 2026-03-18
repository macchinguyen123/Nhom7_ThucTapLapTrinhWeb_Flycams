package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util;
import org.apache.commons.codec.binary.Hex;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;

public class VnpayUtil {
    public static String hmacSHA512(String key, String data) throws Exception {
        Mac hmac512 = Mac.getInstance("HmacSHA512");
        SecretKeySpec secretKey = new SecretKeySpec(
                key.getBytes(StandardCharsets.UTF_8), "HmacSHA512"
        );
        hmac512.init(secretKey);
        byte[] bytes = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));
        return Hex.encodeHexString(bytes);
    }
}