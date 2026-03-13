<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác thực đặt lại mật khẩu</title>
    <style>
        .btn-xac-nhan {
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

        .btn-xac-nhan:hover {
            background: #3b5be0;
        }

        .btn-xac-nhan:active {
            transform: scale(0.97);
        }

        .error {
            color: red;
            text-align: center;
            margin-top: 10px;
        }

        .resend {
            text-align: center;
            margin-top: 15px;
        }

        .resend button {
            background: none;
            border: none;
            color: #0051c6;
            cursor: pointer;
            text-decoration: underline;
        }
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/otp.css">
</head>
<body>
<div class="khung">
    <img src="${pageContext.request.contextPath}/image/logoo.png" alt="SKYDRONE Logo" class="mascot">
    <h1>Xác thực quên mật khẩu</h1>
    <p class="huong_dan">
        Vui lòng nhập mã OTP vừa được gửi về email của bạn
    </p>
    <form action="${pageContext.request.contextPath}/VerifyOtp" method="post">
        <label for="otp">Nhập mã OTP</label>
        <input type="text" id="otp" name="otp" maxlength="4" required>
        <button type="submit" class="btn-xac-nhan">Xác nhận</button>
    </form>
    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>
    <div class="resend">
        <form action="${pageContext.request.contextPath}/ResendForgotPasswordOtp" method="post">
            <button type="submit">Gửi lại mã OTP</button>
        </form>
    </div>
</div>
</body>
</html>