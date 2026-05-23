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
                           placeholder="Nhập mật khẩu" required autocomplete="new-password" oninput="validateForm(); updatePasswordStrength()">
                    <i class="bi bi-eye-slash password-toggle" id="togglePassword"></i>
                </div>
                <div class="strength-meter">
                    <div id="strength-bar" class="strength-meter-fill"></div>
                </div>
                <p id="strength-text" class="strength-text"></p>
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
    let isFormSubmitted = false;
    function updatePasswordStrength() {
        const password = document.getElementById('password').value;
        const bar = document.getElementById('strength-bar');
        const text = document.getElementById('strength-text');
        let strength = 0;
        if (password.length >= 8) strength++;
        if (/[A-Z]/.test(password)) strength++;
        if (/[a-z]/.test(password)) strength++;
        if (/\d/.test(password)) strength++;
        if (/[\W_]/.test(password)) strength++;
        bar.className = 'strength-meter-fill';
        text.className = 'strength-text';
        if (password.length === 0) {
            text.textContent = '';
            return;
        }
        if (strength <= 2) {
            bar.classList.add('strength-weak');
            text.textContent = 'Yếu';
            text.classList.add('text-weak');
        } else if (strength === 3) {
            bar.classList.add('strength-medium');
            text.textContent = 'Trung bình';
            text.classList.add('text-medium');
        } else if (strength === 4) {
            bar.classList.add('strength-fair');
            text.textContent = 'Khá';
            text.classList.add('text-fair');
        } else if (strength === 5) {
            bar.classList.add('strength-strong');
            text.textContent = 'Mạnh';
            text.classList.add('text-strong');
        }
    }
    function validateForm() {
        const usernameInput = document.getElementById('local');
        const username = usernameInput.value;
        const fullnameInput = document.getElementById('fullname');
        const fullname = fullnameInput.value;
        const birthdayInput = document.getElementById('birthday');
        const birthday = birthdayInput.value;
        const phoneInput = document.getElementById('phone');
        const phone = phoneInput.value;
        const emailInput = document.getElementById('email');
        const email = emailInput.value;
        const passwordInput = document.getElementById('password');
        const password = passwordInput.value;
        const confirmInput = document.getElementById('confirm');
        const confirm = confirmInput.value;
        let isValid = true;
        window.firstErrorInput = null;
        const setError = (inputEl, errorId, msg) => {
            document.getElementById(errorId).textContent = msg;
            if (inputEl) {
                inputEl.style.borderColor = '#dc3545';
                if (!window.firstErrorInput) {
                    window.firstErrorInput = inputEl;
                }
            }
            isValid = false;
        };
        const clearError = (inputEl, errorId) => {
            document.getElementById(errorId).textContent = "";
            if (inputEl) {
                inputEl.style.borderColor = '';
            }
        };
        if (username.length === 0) {
            if (window.isInitialLoadDone || isFormSubmitted) {
                setError(usernameInput, 'username_error', "Không được để trống");
            } else {
                clearError(usernameInput, 'username_error');
            }
        } else if (username.includes(" ")) {
            setError(usernameInput, 'username_error', "Tên đăng nhập không được chứa khoảng trắng");
        } else if (/[^a-zA-Z0-9]/.test(username)) {
            setError(usernameInput, 'username_error', "Không được có ký tự đặc biệt");
        } else if (username.length < 6 || username.length > 20) {
            setError(usernameInput, 'username_error', "Cần 6-20 ký tự");
        } else {
            clearError(usernameInput, 'username_error');
        }
        if (fullname.length > 0 || isFormSubmitted) {
            if (fullname.trim() === "") setError(fullnameInput, 'fullname_error', "Họ tên không được để trống");
            else clearError(fullnameInput, 'fullname_error');
        } else {
            clearError(fullnameInput, 'fullname_error');
        }
        if (birthday.length > 0 || isFormSubmitted) {
            if (!birthday || isNaN(new Date(birthday).getTime())) setError(birthdayInput, 'birthday_error', "Ngày sinh không hợp lệ");
            else clearError(birthdayInput, 'birthday_error');
        } else {
            clearError(birthdayInput, 'birthday_error');
        }
        const validPrefixes = ['032','033','034','035','036','037','038','039','086','096','097','098','070','076','077','078','079','089','090','093','056','058','092','059','099','081','082','083','084','085','088','091','094'];
        const phoneRegex = /^0\d{9}$/;
        if (phone.length > 0 || isFormSubmitted) {
            if (phone.length === 0) setError(phoneInput, 'phone_error', "Số điện thoại không được để trống");
            else if (phone[0] !== '0') setError(phoneInput, 'phone_error', "Số điện thoại phải bắt đầu bằng số 0");
            else if (phone.length < 10 || !phoneRegex.test(phone)) setError(phoneInput, 'phone_error', "SĐT phải đúng 10 chữ số");
            else if (!validPrefixes.some(prefix => phone.startsWith(prefix))) setError(phoneInput, 'phone_error', "Vui lòng sử dụng số điện thoại Việt Nam");
            else clearError(phoneInput, 'phone_error');
        } else {
            clearError(phoneInput, 'phone_error');
        }
        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        if (email.length > 0) {
            if (!emailRegex.test(email)) setError(emailInput, 'email_error', "Email không đúng định dạng");
            else clearError(emailInput, 'email_error');
        } else {
            clearError(emailInput, 'email_error');
        }
        if (password.length > 0 || isFormSubmitted) {
            if (password.length === 0) setError(passwordInput, 'password_error', "Mật khẩu không được để trống");
            else if (password.length < 8) setError(passwordInput, 'password_error', "Mật khẩu ít nhất 8 ký tự");
            else if (!/[A-Z]/.test(password)) setError(passwordInput, 'password_error', "Mật khẩu thiếu chữ hoa");
            else if (!/[a-z]/.test(password)) setError(passwordInput, 'password_error', "Mật khẩu thiếu chữ thường");
            else if (!/\d/.test(password)) setError(passwordInput, 'password_error', "Mật khẩu thiếu số");
            else if (!/[\W_]/.test(password)) setError(passwordInput, 'password_error', "Mật khẩu thiếu ký đặc biệt");
            else clearError(passwordInput, 'password_error');
        } else {
            clearError(passwordInput, 'password_error');
        }
        if (confirm.length > 0 || isFormSubmitted) {
            if (confirm.length === 0) setError(confirmInput, 'confirm_error', "Vui lòng nhập lại mật khẩu");
            else if (confirm !== password) setError(confirmInput, 'confirm_error', "Mật khẩu không khớp");
            else clearError(confirmInput, 'confirm_error');
        } else {
            clearError(confirmInput, 'confirm_error');
        }
        const promoCheckbox = document.getElementById('promo');
        const promoLabel = document.querySelector('label[for="promo"]');
        if (isFormSubmitted && promoCheckbox && !promoCheckbox.checked) {
             if (promoLabel) promoLabel.style.color = '#dc3545';
             isValid = false;
        } else if (promoLabel) {
             promoLabel.style.color = '';
        }
        return isValid;
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
        window.isInitialLoadDone = true;
        const form = document.querySelector('.register-form');
        if (form) {
            form.setAttribute('novalidate', '');
            form.addEventListener('submit', function(e) {
                isFormSubmitted = true;
                const isValid = validateForm();
                if (!isValid) {
                    e.preventDefault();
                    if (window.firstErrorInput) {
                        window.firstErrorInput.focus();
                    }
                }
            });
            const promoCheckbox = document.getElementById('promo');
            if (promoCheckbox) {
                promoCheckbox.addEventListener('change', validateForm);
            }
        }
    });
    function onlyNumber(input) {
        input.value = input.value.replace(/[^0-9]/g, '');
    }
</script>
</body>
</html>