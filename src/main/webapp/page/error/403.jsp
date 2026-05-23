<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>403 - Truy cập bị từ chối</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f8f9fa; }
        .error-card {
            max-width: 480px;
            border-radius: 16px;
            box-shadow: 0 8px 30px rgba(0,0,0,.10);
        }
        .icon-circle {
            width: 90px; height: 90px;
            border-radius: 50%;
            background: #fff3f3;
            display: flex; align-items: center; justify-content: center;
            font-size: 2.8rem; color: #dc3545;
            margin: 0 auto 1.5rem;
        }
    </style>
</head>
    <body class="d-flex align-items-center justify-content-center min-vh-100">
        <div class="error-card bg-white p-5 text-center">
            <div class="icon-circle">
                <i class="bi bi-shield-exclamation"></i>
            </div>
            <h2 class="fw-bold text-danger mb-2">403 – Truy cập bị từ chối</h2>
            <p class="text-muted">
                ${not empty errorMessage ? errorMessage :
                        'Token bảo mật không hợp lệ hoặc đã hết hạn. Vui lòng tải lại trang và thử lại.'}
            </p>
            <div class="d-flex gap-2 justify-content-center mt-4">
                <a href="javascript:history.back()" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> Quay lại
                </a>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                    <i class="bi bi-house"></i> Về trang chủ
                </a>
            </div>
        </div>
    </body>
</html>

