package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util;

import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

public class FileStorageUtil {
    public static String saveFile(Part filePart, String deploymentPath, String subDir) throws IOException {
        String originalFileName = filePart.getSubmittedFileName();
        if (originalFileName == null || originalFileName.trim().isEmpty()) {
            throw new IOException("Tên file không hợp lệ");
        }
        String sanitizedFileName = originalFileName.replaceAll("[^a-zA-Z0-9\\\\. -]", "_").replace(" ", "_");
        String fileName = System.currentTimeMillis() + "_" + sanitizedFileName;
        File deployDir = new File(deploymentPath);
        if (!deployDir.exists()) {
            deployDir.mkdirs();
        }
        String deployFilePath = deploymentPath + File.separator + fileName;
        filePart.write(deployFilePath);
        String sourcePath = DBProperties.uploadPath;
        if (sourcePath == null || sourcePath.trim().isEmpty()) {
            String projectRoot = System.getProperty("user.dir");
            sourcePath = projectRoot + File.separator + "src" + File.separator + "main" + File.separator + "webapp" + File.separator + "image" + File.separator + subDir;
        } else {
            sourcePath = sourcePath + File.separator + "image" + File.separator + subDir;
        }
        File sourceDir = new File(sourcePath);
        if (!sourceDir.exists()) {
            sourceDir.mkdirs();
        }
        String sourceFilePath = sourcePath + File.separator + fileName;
        try {
            Files.copy(
                    new File(deployFilePath).toPath(),
                    new File(sourceFilePath).toPath(),
                    StandardCopyOption.REPLACE_EXISTING
            );
        } catch (IOException e) {
        }
        return fileName;
    }
}
