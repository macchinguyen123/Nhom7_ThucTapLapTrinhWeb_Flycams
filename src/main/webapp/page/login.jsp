<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập SKYDRONE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/login.css">

    <style>
        .password-wrapper {
            position: relative;
        }

        .password-toggle {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #6c757d;
            font-size: 18px;
            transition: color 0.2s;
            z-index: 10;
            padding: 5px;
        }

        .password-toggle:hover {
            color: #0051c6;
        }

        .password-wrapper input {
            padding-right: 45px !important;
        }
    </style>
</head>
<body>
<div class="page-container">
    <div class="login-wrapper">
        <div class="logo-section">
            <img src="${pageContext.request.contextPath}/image/logooo.png" alt="SKYDRONE Logo"
                 class="mascot">
        </div>
        <div class="login-container">
            <h2>Đăng nhập SKYDRONE</h2>
            <form action="${pageContext.request.contextPath}/Login" method="post">
                <div class="mb-3 text-start">
                    <label class="form-label">Số điện thoại / Email</label>
                    <input type="text" class="form-control" name="loginInput"
                           placeholder="Nhập số điện thoại hoặc email" required>
                </div>
                <div class="mb-3 text-start">
                    <label class="form-label">Mật khẩu</label>
                    <div class="password-wrapper">
                        <input type="password" class="form-control" name="password" id="loginPassword"
                               placeholder="Nhập mật khẩu" required autocomplete="new-password">
                        <i class="bi bi-eye-slash password-toggle" id="togglePassword"></i>
                    </div>
                </div>
                <button type="submit" class="btn btn-login w-100 mb-3">Đăng nhập
                </button>
                <div class="text-end">
                    <a href="${pageContext.request.contextPath}/page/forgot-password.jsp"
                       class="forgot-pass">Quên mật khẩu?
                    </a>
                </div>
                <div class="divider text-center my-3">Hoặc đăng nhập bằng</div>
                <div class="d-flex justify-content-center gap-3">
                    <a href="${pageContext.request.contextPath}/google-login"
                       class="btn btn-outline-secondary d-flex align-items-center justify-content-center"
                       style="width: 140px;">
                        <img src="https://www.svgrepo.com/show/355037/google.svg" width="20" class="me-2">Google
                    </a>
                    <a href="${pageContext.request.contextPath}/facebook-login"
                       class="btn btn-outline-primary d-flex align-items-center justify-content-center"
                       style="width: 140px;">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/b/b8/2021_Facebook_icon.svg"
                             width="20" class="me-2">Facebook
                    </a>
                </div>
                <p class="text-center mt-3">Bạn chưa có tài khoản?
                    <a href="${pageContext.request.contextPath}/Register">Đăng ký ngay</a>
                </p>
            </form>
        </div>
    </div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const togglePassword = document.getElementById('togglePassword');
        const passwordInput = document.getElementById('loginPassword');
        if (togglePassword && passwordInput) {
            togglePassword.addEventListener('click', function () {
                const type = passwordInput.type === 'password' ? 'text' : 'password';
                passwordInput.type = type;
                this.classList.toggle('bi-eye');
                this.classList.toggle('bi-eye-slash');
            });
        }
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<c:if test="${not empty error}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const Toast = Swal.mixin({
                toast: true,
                position: "top-end",
                showConfirmButton: false,
                timer: 4000,
                timerProgressBar: true,
                background: "#fff6f6",
                color: "#d00000",
                customClass: {popup: 'custom-toast'}
            });
            Toast.fire({
                icon: "error",
                html: `${error}`
            });
        });
    </script>
</c:if>
<c:if test="${param.resetSuccess eq '1'}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const Toast = Swal.mixin({
                toast: true,
                position: "top-end",
                showConfirmButton: false,
                timer: 4000,
                timerProgressBar: true,
                background: "#f0fdf4",
                color: "#15803d",
                customClass: {popup: 'custom-toast'}
            });
            Toast.fire({
                icon: "success",
                title: "Tạo mật khẩu mới thành công!",
                text: "Vui lòng đăng nhập lại."
            });
        });
    </script>
</c:if>
</body>
</html>