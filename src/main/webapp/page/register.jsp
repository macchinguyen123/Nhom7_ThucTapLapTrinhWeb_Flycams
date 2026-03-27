<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký trở thành SMEMBER</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/register.css">
    <style>
        .error {
            color: red;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="field1">
    <h1 class="title">Đăng ký trở thành <span>SKYDroneMember</span></h1>
    <img src="${pageContext.request.contextPath}/image/looo.png" alt="Logo" class="mascot">
    <p class="or">Điền thông tin sau</p>
    </div>
    <form class="register-form" method="POST" action="${pageContext.request.contextPath}/Register">
        <div class="field">
            <h2>Tên đăng nhập</h2>
            <input type="text" id="local" name="username" placeholder="Nhập tên đăng nhập"
                   value="${username}" required oninput="validateForm()">
            <p class="error" id="username_error"></p>
            <c:if test="${not empty usernameError}">
                <p class="error"> ${usernameError}</p>
            </c:if>
        </div>
        <h2>Thông tin cá nhân</h2>
        <div class="grid">
            <div class="field">
                <label for="fullname">Họ và tên</label>
                <input type="text" id="fullname" name="fullName" placeholder="Nhập họ và tên"
                       value="${fullName}" required oninput="validateForm()">
                <p class="error" id="fullname_error"></p>
                <c:if test="${not empty fullNameError}">
                    <p class="error"> ${fullNameError}</p>
                </c:if>
            </div>
            <div class="field">
                <label for="birthday">Ngày sinh</label>
                <input type="date" id="birthday" name="birthday" value="${birthday}" required oninput="validateForm()">
                <p class="error" id="birthday_error"></p>
                <c:if test="${not empty birthdayError}">
                    <p class="error"> ${birthdayError}</p>
                </c:if>
            </div>
            <div class="field">
                <label for="phone">Số điện thoại</label>
                <input type="tel" id="phone" name="phoneNumber" placeholder="Nhập số điện thoại"
                       value="${phoneNumber}" required oninput="onlyNumber(this); validateForm()"
                       onkeypress="return event.charCode >= 48 && event.charCode <= 57">
                <p class="error" id="phone_error"></p>
                <c:if test="${not empty phoneError}">
                    <p class="error"> ${phoneError}</p>
                </c:if>
            </div>
            <div class="field">
                <label for="cccd">Số CCCD (12 số)</label>
                <input type="text" id="cccd" name="cccd" placeholder="Nhập 12 số CCCD"
                       value="${cccd}" required oninput="validateForm()">
                <p class="error" id="cccd_error"></p>
                <c:if test="${not empty cccdError}">
                    <p class="error"> ${cccdError}</p>
                </c:if>
            </div>
            <div class="field">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="Nhập email" value="${email}" oninput="validateForm()">
                <p class="hint">Hóa đơn VAT sẽ gửi qua email này</p>
                <p class="error" id="email_error"></p>
                <c:if test="${not empty emailError}">
                    <p class="error"> ${emailError}</p>
                </c:if>
            </div>
        </div>
        <h2>Tạo mật khẩu</h2>
        <div class="grid">
            <div class="field">
                <label for="password">Mật khẩu</label>
                <div class="password-wrapper">
                    <input type="password" id="password" name="password"
                           placeholder="Nhập mật khẩu" required autocomplete="new-password" oninput="validateForm()">
                    <i class="bi bi-eye-slash password-toggle" id="togglePassword"></i>
                </div>
                <p class="hint">Tối thiểu 8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt</p>
                <p class="error" id="password_error"></p>
                <c:if test="${not empty passwordError}">
                    <p class="error"> ${passwordError}</p>
                </c:if>
            </div>
            <div class="field">
                <label for="confirm">Nhập lại mật khẩu</label>
                <div class="password-wrapper">
                    <input type="password" id="confirm" name="confirm"
                           placeholder="Nhập lại mật khẩu" required autocomplete="new-password" oninput="validateForm()">
                    <i class="bi bi-eye-slash password-toggle" id="toggleConfirm"></i>
                </div>
                <p class="error" id="confirm_error"></p>
                <c:if test="${not empty confirmPasswordError}">
                    <p class="error"> ${confirmPasswordError}</p>
                </c:if>
            </div>
        </div>
        <div class="checkbox">
            <input type="checkbox" id="promo" name="promo" required>
            <label for="promo">Tôi đồng ý với điều khoản và chính sách của SKYDRONE</label>
        </div>
        <p class="terms">
            Bằng việc Đăng ký, bạn đã đồng ý với
            <a href="${pageContext.request.contextPath}/page/terms-of-use.jsp">Điều khoản sử dụng</a> và
            <a href="${pageContext.request.contextPath}/page/privacy-policy.jsp">Chính sách bảo mật</a>.
        </p>
        <div class="actions">
            <a href="${pageContext.request.contextPath}/Login" class="btn secondary">⟵ Quay lại đăng
                nhập</a>
            <button type="submit" id="submitBtn" class="btn primary">Hoàn tất đăng ký</button>
        </div>
    </form>
</div>
</body>
<script>
    function validateForm() {
        const username = document.getElementById('local').value;
        const fullname = document.getElementById('fullname').value;
        const birthday = document.getElementById('birthday').value;
        const phone = document.getElementById('phone').value;
        const cccd = document.getElementById('cccd').value;
        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;
        const confirm = document.getElementById('confirm').value;
        const submitBtn = document.getElementById('submitBtn');
        let isValid = true;
        const usernameSpecialCharRegex = /[^a-zA-Z0-9À-ỹ\s]/;
        const usernameLengthRegex = /^[a-zA-Z0-9À-ỹ\s]{6,20}$/;
        if (username.length > 0) {
            if (usernameSpecialCharRegex.test(username)) {
                document.getElementById('username_error').textContent = "Không được có ký tự đặc biệt";
                isValid = false;
            } else if (username.length < 6 || username.length > 20) {
                document.getElementById('username_error').textContent = "Cần 6-20 ký tự";
                isValid = false;
            } else {
                document.getElementById('username_error').textContent = "";
            }
        } else {
            document.getElementById('username_error').textContent = "";
        }
        if (fullname.length > 0) {
            if (fullname.trim() === "") {
                document.getElementById('fullname_error').textContent = "Họ tên không được để trống";
                isValid = false;
            } else {
                document.getElementById('fullname_error').textContent = "";
            }
        } else {
            document.getElementById('fullname_error').textContent = "";
        }
        if (birthday.length > 0) {
            if (isNaN(new Date(birthday).getTime())) {
                document.getElementById('birthday_error').textContent = "Ngày sinh không hợp lệ";
                isValid = false;
            } else {
                document.getElementById('birthday_error').textContent = "";
            }
        } else {
            document.getElementById('birthday_error').textContent = "";
        }
        const validPrefixes = [
            '032','033','034','035','036','037','038','039','086','096','097','098','070','076','077','078','079',
            '089','090','093','056','058','092','059','099','081','082','083','084','085','088','091','094',];
        const phoneRegex = /^0\d{9}$/;
        if (phone.length > 0) {
            if (phone[0] !== '0') {
                document.getElementById('phone_error').textContent = "Số điện thoại phải bắt đầu bằng số 0";
                isValid = false;
            } else if (phone.length < 10) {
                document.getElementById('phone_error').textContent = "SĐT phải đúng 10 chữ số";
                isValid = false;
            } else if (!phoneRegex.test(phone)) {
                document.getElementById('phone_error').textContent = "SĐT phải đúng 10 chữ số";
                isValid = false;
            } else if (!validPrefixes.some(prefix => phone.startsWith(prefix))) {
                document.getElementById('phone_error').textContent = "Vui lòng sử dụng số điện thoại Việt Nam";
                isValid = false;
            } else {
                document.getElementById('phone_error').textContent = "";
            }
        } else {
            document.getElementById('phone_error').textContent = "";
        }
        const cccdRegex = /^\d{12}$/;
        if (cccd.length > 0) {
            if (!cccdRegex.test(cccd)) {
                document.getElementById('cccd_error').textContent = "CCCD phải đúng 12 chữ số";
                isValid = false;
            } else {
                document.getElementById('cccd_error').textContent = "";
            }
        } else {
            document.getElementById('cccd_error').textContent = "";
        }
        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (email.length > 0) {
            if (!emailRegex.test(email)) {
                document.getElementById('email_error').textContent = "Email không đúng định dạng";
                isValid = false;
            } else {
                document.getElementById('email_error').textContent = "";
            }
        } else {
            document.getElementById('email_error').textContent = "";
        }
        const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;
        if (password.length > 0) {
            if (password.length < 8) {
                document.getElementById('password_error').textContent = "Mật khẩu phải có ít nhất 8 ký tự";
                isValid = false;
            } else if (!/[A-Z]/.test(password)) {
                document.getElementById('password_error').textContent = "Mật khẩu phải có ít nhất 1 chữ hoa";
                isValid = false;
            } else if (!/[a-z]/.test(password)) {
                document.getElementById('password_error').textContent = "Mật khẩu phải có ít nhất 1 chữ thường";
                isValid = false;
            } else if (!/\d/.test(password)) {
                document.getElementById('password_error').textContent = "Mật khẩu phải có ít nhất 1 chữ số";
                isValid = false;
            } else if (!/[\W_]/.test(password)) {
                document.getElementById('password_error').textContent = "Mật khẩu phải có ít nhất 1 ký tự đặc biệt";
                isValid = false;
            } else {
                document.getElementById('password_error').textContent = "";
            }
        } else {
            document.getElementById('password_error').textContent = "";
        }
        if (confirm.length > 0) {
            if (confirm !== password) {
                document.getElementById('confirm_error').textContent = "Mật khẩu không khớp";
                isValid = false;
            } else {
                document.getElementById('confirm_error').textContent = "";
            }
        } else {
            document.getElementById('confirm_error').textContent = "";
        }
        const usernameValid = !usernameSpecialCharRegex.test(username) && usernameLengthRegex.test(username);
        if (!usernameValid ||
            fullname.trim() === "" || 
            !birthday || 
            !phoneRegex.test(phone) || 
            !cccdRegex.test(cccd) || 
            !emailRegex.test(email) || 
            !passwordRegex.test(password) || 
            confirm !== password) {
            isValid = false;
        }
        submitBtn.disabled = !isValid;
    }
    document.addEventListener('DOMContentLoaded', function () {
        const togglePassword = document.getElementById('togglePassword');
        const passwordInput = document.getElementById('password');
        if (togglePassword && passwordInput) {
            togglePassword.addEventListener('click', function () {
                const type = passwordInput.type === 'password' ? 'text' : 'password';
                passwordInput.type = type;
                this.classList.toggle('bi-eye');
                this.classList.toggle('bi-eye-slash');
            });
        }
        const toggleConfirm = document.getElementById('toggleConfirm');
        const confirmInput = document.getElementById('confirm');
        if (toggleConfirm && confirmInput) {
            toggleConfirm.addEventListener('click', function () {
                const type = confirmInput.type === 'password' ? 'text' : 'password';
                confirmInput.type = type;
                this.classList.toggle('bi-eye');
                this.classList.toggle('bi-eye-slash');
            });
        }
        validateForm();
    });
    function onlyNumber(input) {
        input.value = input.value.replace(/[^0-9]/g, '');
    }
</script>
</body>
</html>