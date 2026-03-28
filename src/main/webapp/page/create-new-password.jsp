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
    <form action="${pageContext.request.contextPath}/ResetPassword" method="post" id="resetPasswordForm">
        <label for="password">Mật khẩu mới</label>
        <input type="password" id="password" name="password" required>
        <div id="passwordErrorJs" class="error" style="display: none; color: red;"></div>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <c:if test="${not empty passwordError}">
            <div class="error">${passwordError}</div>
        </c:if>
        <label for="confirm">Nhập lại mật khẩu</label>
        <input type="password" id="confirm" name="confirm" required>
        <div id="confirmErrorJs" class="error" style="display: none; color: red;"></div>
        <c:if test="${not empty confirmPasswordError}">
            <div class="error">${confirmPasswordError}</div>
        </c:if>
        <button type="submit" class="btn-cap-nhat">Cập nhật mật khẩu</button>
    </form>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const passwordInput = document.getElementById('password');
        const confirmInput = document.getElementById('confirm');
        const passwordErrorJs = document.getElementById('passwordErrorJs');
        const confirmErrorJs = document.getElementById('confirmErrorJs');
        const form = document.getElementById('resetPasswordForm');

        function validatePassword() {
            const pass = passwordInput.value;
            if (pass === '') {
                passwordErrorJs.style.display = 'none';
                return false;
            }

            if (pass.length < 8) {
                passwordErrorJs.textContent = "Mật khẩu ít nhất 8 ký tự";
                passwordErrorJs.style.display = 'block';
                return false;
            } else if (!/[A-Z]/.test(pass)) {
                passwordErrorJs.textContent = "Mật khẩu thiếu chữ hoa";
                passwordErrorJs.style.display = 'block';
                return false;
            } else if (!/[a-z]/.test(pass)) {
                passwordErrorJs.textContent = "Mật khẩu thiếu chữ thường";
                passwordErrorJs.style.display = 'block';
                return false;
            } else if (!/\d/.test(pass)) {
                passwordErrorJs.textContent = "Mật khẩu thiếu số";
                passwordErrorJs.style.display = 'block';
                return false;
            } else if (!/[\W_]/.test(pass)) {
                passwordErrorJs.textContent = "Mật khẩu thiếu ký đặc biệt";
                passwordErrorJs.style.display = 'block';
                return false;
            }
            
            passwordErrorJs.style.display = 'none';
            return true;
        }

        function validateConfirmPassword() {
            const confirmPass = confirmInput.value;
            const pass = passwordInput.value;

            if (confirmPass === '') {
                confirmErrorJs.style.display = 'none';
                return false;
            }

            if (confirmPass !== pass) {
                confirmErrorJs.textContent = "Mật khẩu nhập lại không khớp";
                confirmErrorJs.style.display = 'block';
                return false;
            }

            confirmErrorJs.style.display = 'none';
            return true;
        }

        if (passwordInput && confirmInput) {
            passwordInput.addEventListener('input', () => {
                validatePassword();
                if(confirmInput.value !== '') validateConfirmPassword();
            });
            passwordInput.addEventListener('blur', validatePassword);
            
            confirmInput.addEventListener('input', validateConfirmPassword);
            confirmInput.addEventListener('blur', validateConfirmPassword);
        }

        if (form) {
            form.addEventListener('submit', function(e) {
                const isPassValid = validatePassword();
                const isConfirmValid = validateConfirmPassword();
                
                if (!isPassValid || !isConfirmValid) {
                    e.preventDefault();
                }
            });
        }
    });
</script>
</body>
</html>