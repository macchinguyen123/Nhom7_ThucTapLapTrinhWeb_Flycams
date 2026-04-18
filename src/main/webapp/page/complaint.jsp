<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khiếu nại tài khoản - SKYDRONE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            background-image: url("${pageContext.request.contextPath}/image/img1.png");
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
        }
        .complaint-card {
            background: #fff;
            border-radius: 10px;
            border: 1px solid #e5e7eb;
            width: 100%;
            max-width: 500px;
            padding: 25px;
        }

        .card-header-styled {
            text-align: center;
            margin-bottom: 20px;
        }

        .card-header-styled i {
            font-size: 32px;
            color: #dc2626;
        }

        .card-title-main {
            font-size: 20px;
            font-weight: 600;
            margin-top: 10px;
        }

        .card-subtitle {
            font-size: 13px;
            color: #6b7280;
        }

        .form-label {
            font-weight: 500;
            font-size: 14px;
        }

        .complaint-textarea {
            width: 100%;
            border-radius: 6px;
            border: 1px solid #d1d5db;
            padding: 10px;
            font-size: 14px;
        }

        .complaint-textarea:focus {
            outline: none;
            border-color: #2563eb;
        }

        .btn-submit {
            width: 100%;
            background-color: #2563eb;
            color: #fff;
            border: none;
            padding: 10px;
            border-radius: 6px;
            font-weight: 500;
        }

        .btn-submit:hover {
            background-color: #1d4ed8;
            color: #fff;
        }

        .btn-back {
            display: block;
            width: 100%;
            margin-top: 12px;
            padding: 9px;
            border-radius: 6px;
            border: 2px solid #6b7280;
            background-color: transparent;
            color: #6b7280;
            font-size: 14px;
            font-weight: 500;
            text-align: center;
            text-decoration: none;
            transition: all 0.2s ease-in-out;
        }

        .btn-back:hover {
            background-color: #6b7280;
            color: #fff;
        }

        .custom-alert {
            border-radius: 6px;
            font-size: 14px;
            padding: 10px;
        }
    </style>
</head>
<body>
<div class="complaint-card">
    <div class="card-header-styled">
        <div class="header-icon">
            <i class="bi bi-shield-lock"></i>
        </div>
        <h2 class="card-title-main">Yêu cầu xem xét tài khoản</h2>
        <p class="card-subtitle">Vui lòng cung cấp chi tiết lý do và minh chứng nếu có</p>
    </div>
    <div class="card-body-styled">
        <c:if test="${not empty message}">
            <div class="custom-alert ${messageType eq 'success' ? 'custom-alert-success' : 'custom-alert-danger'} mb-4">
                <i class="bi ${messageType eq 'success' ? 'bi-check-circle-fill' : 'bi-exclamation-triangle-fill'} fs-5"></i>
                <div>${message}</div>
            </div>
            <c:if test="${messageType eq 'success'}">
                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/Login" class="btn-submit text-decoration-none">
                        Quay lại trang Đăng nhập
                    </a>
                </div>
            </c:if>
        </c:if>
        <c:if test="${empty message or messageType ne 'success'}">
            <form action="${pageContext.request.contextPath}/submit-complaint" method="post">
                <input type="hidden" name="userId" value="${userId != null ? userId : param.userId}">
                <div class="mb-4 text-start">
                    <label class="form-label">
                        Chi tiết khiếu nại <span class="text-danger">*</span>
                    </label>
                    <textarea
                            class="complaint-textarea"
                            name="content"
                            rows="6"
                            placeholder="Hãy cho chúng tôi biết tại sao bạn cho rằng tài khoản bị khoá nhầm, hoặc lời giải thích của bạn về sự việc đã xảy ra..."
                            required
                    ></textarea>
                </div>
                <div class="mb-4 text-start">
                    <label class="form-label">
                        Link minh chứng (nếu có)
                    </label>
                    <input type="url" class="form-control" name="evidence"
                           placeholder="Nhập đường dẫn hình ảnh/tài liệu (Google Drive, Imgur,...)">
                </div>
                <button type="submit" class="btn-submit">
                    Gửi yêu cầu <i class="bi bi-send-fill ms-1"></i>
                </button>
            </form>
            <a href="${pageContext.request.contextPath}/Login" class="btn-back">
                <i class="bi bi-arrow-left me-1"></i> Quay lại đăng nhập
            </a>
        </c:if>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>