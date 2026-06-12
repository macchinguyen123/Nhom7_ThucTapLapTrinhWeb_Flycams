package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util;

import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

public class SupabaseStorageUtil {
    private static final String SUPABASE_URL = DBProperties.supabaseUrl;
    private static final String SUPABASE_KEY = DBProperties.supabaseKey;
    private static final String SUPABASE_BUCKET = DBProperties.supabaseBucket;

    public static String uploadFile(Part filePart) throws IOException {
        return uploadFile(filePart, "avatar");
    }
    public static String uploadFile(Part filePart, String folder) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            throw new IOException("File không hợp lệ hoặc rỗng");
        }
        String originalFileName = filePart.getSubmittedFileName();
        if (originalFileName == null || originalFileName.trim().isEmpty()) {
            throw new IOException("Tên file không hợp lệ");
        }
        if (SUPABASE_URL == null || SUPABASE_URL.trim().isEmpty() ||
                SUPABASE_KEY == null || SUPABASE_KEY.trim().isEmpty() ||
                SUPABASE_BUCKET == null || SUPABASE_BUCKET.trim().isEmpty()) {
            return null;
        }
        String sanitizedFileName = originalFileName.replaceAll("[^a-zA-Z0-9._-]", "_").replace(" ", "_");
        String folderPrefix = (folder != null && !folder.trim().isEmpty()) ? folder.trim() + "/" : "";
        String fileName = folderPrefix + System.currentTimeMillis() + "_" + sanitizedFileName;
        String contentType = filePart.getContentType();
        if (contentType == null || contentType.trim().isEmpty()) {
            contentType = "image/jpeg";
        }
        String baseUrl = SUPABASE_URL.trim();
        while (baseUrl.endsWith("/")) {
            baseUrl = baseUrl.substring(0, baseUrl.length() - 1);
        }
        if (baseUrl.endsWith("/rest/v1")) {
            baseUrl = baseUrl.substring(0, baseUrl.length() - "/rest/v1".length());
        }
        while (baseUrl.endsWith("/")) {
            baseUrl = baseUrl.substring(0, baseUrl.length() - 1);
        }
        String uploadUrl = baseUrl + "/storage/v1/object/" + SUPABASE_BUCKET + "/" + fileName;
        System.out.println("[Supabase] Đang upload tới: " + uploadUrl);
        System.out.println("[Supabase] Bucket: " + SUPABASE_BUCKET + ", File size: " + filePart.getSize() + " bytes, Content-Type: " + contentType);
        try (InputStream inputStream = filePart.getInputStream()) {
            byte[] bytes = inputStream.readAllBytes();
            HttpClient client = HttpClient.newBuilder()
                    .connectTimeout(Duration.ofSeconds(15))
                    .build();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(uploadUrl))
                    .timeout(Duration.ofSeconds(30))
                    .header("Authorization", "Bearer " + SUPABASE_KEY)
                    .header("apikey", SUPABASE_KEY)
                    .header("Content-Type", contentType)
                    .header("x-upsert", "true")
                    .POST(HttpRequest.BodyPublishers.ofByteArray(bytes))
                    .build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
            int status = response.statusCode();
            System.out.println("[Supabase] HTTP Status: " + status);
            System.out.println("[Supabase] Response: " + response.body());
            if (status >= 200 && status < 300) {
                String publicUrl = baseUrl + "/storage/v1/object/public/" + SUPABASE_BUCKET + "/" + fileName;
                System.out.println("[Supabase] Upload thành công! URL: " + publicUrl);
                return publicUrl;
            } else if (status == 400 && response.body().contains("The resource already exists")) {
                throw new IOException("[Supabase] File đã tồn tại, HTTP " + status + ": " + response.body());
            } else if (status == 401 || status == 403) {
                throw new IOException("[Supabase] Lỗi xác thực/quyền (HTTP " + status + "). Kiểm tra:"
                        + "\n1. Bucket '" + SUPABASE_BUCKET + "' đã tồn tại chưa?"
                        + "\n2. Bucket có policy cho phép INSERT không?"
                        + "\n3. Key Supabase có đúng không?"
                        + "\nResponse: " + response.body());
            } else if (status == 404) {
                throw new IOException("[Supabase] Không tìm thấy bucket '" + SUPABASE_BUCKET + "' (HTTP 404). "
                        + "Hãy tạo bucket trong Supabase Dashboard > Storage."
                        + "\nResponse: " + response.body());
            } else {
                throw new IOException("[Supabase] Upload thất bại HTTP " + status + ": " + response.body());
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new IOException("[Supabase] Upload bị gián đoạn", e);
        }
    }
}