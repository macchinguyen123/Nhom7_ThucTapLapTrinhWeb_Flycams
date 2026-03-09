<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu</title>
    <style>
        .btn-tiep-tuc {
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

        .btn-tiep-tuc:hover {
            background: #3b5be0;
        }

        .btn-tiep-tuc:active {
            transform: scale(0.97);
        }
    </style>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/stylesheets/forgot-pasword.css">
</head>
<body>
<div class="khung">
    <img src="${pageContext.request.contextPath}/image/logoo.png" alt="SKYDRONE Logo" class="mascot">
    <h1>Quên mật khẩu</h1>
    <p class="huong_dan">Nhập email của bạn để khôi phục mật khẩu.</p>
    <form action="${pageContext.request.contextPath}/ForgotPassword" method="post">
        <label>Email:</label>
        <input type="email" name="email" required/>
        <button type="submit" class="btn-tiep-tuc">Tiếp tục</button>
    </form>
    <c:if test="${not empty message}">
        <div class="alert">${message}</div>
    </c:if>
</div>
</body>
</html>
