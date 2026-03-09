<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trang tạo mật khẩu mới</title>
    <style>
        .btn-cap-nhat {
            display: block;
            margin: 20px auto 0;
            padding: 12px 40px;
            border-radius: 12px;
            border: none;
            background: #0051c6;
            color: white;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: 0.2s;
        }

        .btn-cap-nhat:hover {
            background: #3b5be0;
        }

        .btn-cap-nhat:active {
            transform: scale(0.97);
        }
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/create-new-password.css">
</head>
<body>
<div class="khung">
    <img src="${pageContext.request.contextPath}/image/logoo.png" alt="SKYDRONE Logo" class="mascot">
    <h1 id="title">Tạo mật khẩu mới</h1>
    <form action="${pageContext.request.contextPath}/ResetPassword" method="post">
        <label for="password">Mật khẩu mới</label>
        <input type="password" id="password" name="password" required>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <c:if test="${not empty passwordError}">
            <div class="error">${passwordError}</div>
        </c:if>
        <label for="confirm">Nhập lại mật khẩu</label>
        <input type="password" id="confirm" name="confirm" required>
        <c:if test="${not empty confirmPasswordError}">
            <div class="error">${confirmPasswordError}</div>
        </c:if>
        <button type="submit" class="btn-cap-nhat">Cập nhật mật khẩu</button>
    </form>
</div>
</body>
</html>