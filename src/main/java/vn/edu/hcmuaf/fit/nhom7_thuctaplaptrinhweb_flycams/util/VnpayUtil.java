package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
public class VnpayUtil {
    public static String hmacSHA512(String key, String data) throws Exception {
        Mac hmac512 = Mac.getInstance("HmacSHA512");
        SecretKeySpec secretKey = new SecretKeySpec(
                key.getBytes(),"HmacSHA512"
        );
        hmac512.init(secretKey);
        byte[] bytes = hmac512.doFinal(data.getBytes());
        StringBuilder hash = new StringBuilder();
        for (byte b : bytes) {
            hash.append(String.format("%02x", b));
        }
        return hash.toString();
    }
}
