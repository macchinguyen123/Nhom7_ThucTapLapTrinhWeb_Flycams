<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trang Quản Trị - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/stylesheets/admin/profile-admin.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        .profile-page .avatar-wrapper {
            border-radius: 10px !important;
        }

        .profile-page .avatar-img {
            border-radius: 10px !important;
        }

        .avatar-camera {
            position: absolute;
            top: 50% !important;
            left: 50% !important;
            transform: translate(-50%, -50%) !important;
            bottom: unset !important;
            right: unset !important;
        }

        .avatar-camera i {
            display: none;
        }

        .avatar-camera::before {
            content: "\F4FE";
            font-family: bootstrap-icons !important;
            font-size: 24px;
        }

        .avatar-clear {
            position: absolute;
            top: 5px;
            right: 5px;
            background: rgba(220, 53, 69, 0.9);
            color: white;
            border-radius: 50%;
            width: 25px;
            height: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-weight: bold;
            z-index: 10;
        }
    </style>
</head>
<body>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<header class="main-header">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/image/logoo2.png" alt="Logo">
        <h2>SkyDrone Admin</h2>
    </div>
    <div class="header-right">
        <a href="${pageContext.request.contextPath}/admin/profile"
           class="text-decoration-none text-white">
            <div class="thong-tin-admin d-flex align-items-center gap-2">
                <i class="bi bi-person-circle fs-4"></i>
                <span class="fw-semibold">${sessionScope.user.fullName}</span>
            </div>
        </a>
        <button class="logout-btn" id="logoutBtn" title="Đăng xuất">
            <i class="bi bi-box-arrow-right"></i>
        </button>
    </div>
    <div class="logout-modal" id="logoutModal">
        <div class="logout-modal-content">
            <p>Bạn có chắc muốn đăng xuất không?</p>
            <div class="logout-actions">
                <a href="${pageContext.request.contextPath}/Logout">
                    <button id="confirmLogout" class="confirm">Có</button>
                </a>
                <button id="cancelLogout" class="cancel">Không</button>
            </div>
        </div>
    </div>
</header>
<div id="avatar-processing-notification" class="alert alert-info"
     style="display: none; position: fixed; top: 80px; left: 50%; transform: translateX(-50%); z-index: 9998; min-width: 450px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);">
    <div class="d-flex align-items-center">
        <div class="spinner-border spinner-border-sm me-3" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
        <span><strong>Đang xử lý và lưu ảnh đại diện...</strong> Vui lòng chờ trong giây lát.</span>
    </div>
</div>
<div class="layout">
    <aside class="sidebar">
        <div class="user-info">
            <c:choose>
                <c:when test="${not empty sessionScope.user.avatar}">
                    <img src="${pageContext.request.contextPath}/image/avatar/${sessionScope.user.avatar}?v=${sessionScope.user.updatedAt != null ? sessionScope.user.updatedAt.time : ''}"
                         alt="Avatar" id="sidebarAvatar"
                         style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover;">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/image/logoTCN.png" alt="Avatar"
                         id="sidebarAvatar">
                </c:otherwise>
            </c:choose>
            <h3>${sessionScope.user.fullName}</h3>
            <p>Chào mừng bạn trở lại 👋</p>
        </div>
        <ul class="menu">
            <a href="${pageContext.request.contextPath}/admin/dashboard">
                <li><i class="bi bi-speedometer2"></i> Tổng Quan</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/customer-manage">
                <li><i class="bi bi-person-lines-fill"></i> Quản Lý Tài Khoản</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/product-management">
                <li><i class="bi bi-box-seam"></i> Quản Lý Sản Phẩm</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/inventory-manage">
                <li><i class="bi bi-boxes"></i> Quản Lý Kho Hàng</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/category-manage">
                <li><i class="bi bi-tags"></i> Quản Lý Danh Mục</li>
            </a>
            <li class="has-submenu">
                <div class="menu-item">
                    <i class="bi bi-truck"></i>
                    <span>Quản Lý Đơn Hàng</span>
                    <i class="bi bi-chevron-right arrow"></i>
                </div>
                <ul class="submenu">
                    <a href="${pageContext.request.contextPath}/admin/unconfirmed-orders">
                        <li>Chưa Xác Nhận</li>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/order-manage">
                        <li>Đã Xác Nhận</li>
                    </a>
                </ul>
            </li>
            <a href="${pageContext.request.contextPath}/admin/blog-manage">
                <li><i class="bi bi-journal-text"></i> Quản Lý Blog</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/promotion-manage">
                <li><i class="bi bi-megaphone"></i> Quản Lý Khuyến Mãi</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/statistics">
                <li><i class="bi bi-bar-chart"></i> Báo Cáo & Thống Kê</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/chat-manage">
                <li><i class="bi bi-chat-left-text"></i> Hộp thoại</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/banner-manage">
                <li><i class="bi bi-images"></i> Quản Lý Banner</li>
            </a>
        </ul>
    </aside>
    <div class="profile-page">
        <div class="profile-left">
            <div class="avatar-box">
                <div class="avatar-wrapper">
                    <c:choose>
                        <c:when test="${not empty admin.avatar}">
                            <img src="${pageContext.request.contextPath}/image/avatar/${admin.avatar}"
                                 alt="Avatar" class="avatar-img" id="avatarPreview">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/image/logoTCN.png"
                                 alt="Avatar" class="avatar-img" id="avatarPreview">
                        </c:otherwise>
                    </c:choose>
                    <span class="avatar-camera">
                                            <i class="bi bi-camera-fill"></i>
                                        </span>
                    <span class="avatar-clear" id="avatarClearBtn" style="display: none;">×</span>
                </div>
            </div>
            <h3>${admin.fullName}</h3>
            <p class="text-muted small">${admin.email}</p>
        </div>
        <div class="profile-right">
            <h4><i class="bi bi-person-badge me-2"></i>Thông tin cơ bản</h4>
            <c:if test="${not empty sessionScope.infoMsg}">
                <div class="alert alert-dismissible fade show ${fn:contains(sessionScope.infoMsg, 'thành công') ? 'alert-success' : 'alert-danger'}"
                     role="alert">
                    <i class="bi ${fn:contains(sessionScope.infoMsg, 'thành công') ? 'bi-check-circle' : 'bi-exclamation-circle'} me-2"></i>
                        ${sessionScope.infoMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="infoMsg" scope="session"/>
            </c:if>
            <form id="profileForm"
                  action="${pageContext.request.contextPath}/admin/profile?action=update-info"
                  method="post" enctype="multipart/form-data">
                <input type="file" name="avatar" id="avatarInput" accept="image/*" hidden>
                <label>
                    <i class="bi bi-person me-1"> Họ tên</i>
                    <input name="fullName" value="${admin.fullName}" required
                           placeholder="Nhập họ tên đầy đủ">
                </label>
                <label>
                    <i class="bi bi-envelope me-1"> Email</i>
                    <input type="email" id="editEmail" name="email" value="${admin.email}" required
                           placeholder="example@email.com">
                    <div id="emailError" class="text-danger small mt-1" style="display:none;"></div>
                </label>
                <label>
                    <i class="bi bi-telephone me-1"> Số điện thoại</i>
                    <input id="editPhone" name="phone" value="${admin.phoneNumber}" required
                           placeholder="0123456789">
                    <div id="phoneError" class="text-danger small mt-1" style="display:none;"></div>
                </label>
                <div class="actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg me-1"></i> Lưu thay đổi
                    </button>
                </div>
            </form>
            <hr>
            <h4><i class="bi bi-shield-lock me-2"></i>Đổi mật khẩu</h4>
            <c:if test="${not empty sessionScope.passMsg}">
                <div class="alert alert-dismissible fade show ${fn:contains(sessionScope.passMsg, 'thành công') ? 'alert-success' : 'alert-danger'}"
                     role="alert">
                    <i class="bi ${fn:contains(sessionScope.passMsg, 'thành công') ? 'bi-check-circle' : 'bi-exclamation-circle'} me-2"></i>
                        ${sessionScope.passMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="passMsg" scope="session"/>
            </c:if>
            <form id="changePassForm"
                  action="${pageContext.request.contextPath}/admin/profile?action=change-password"
                  method="post">
                <small class="password-hint">
                    <i class="bi bi-info-circle me-1"></i>
                    Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc
                    biệt (@$!%*?&).
                </small>
                <label>
                    <i class="bi bi-key me-1"></i> Mật khẩu cũ
                    <div class="input-group">
                        <input type="password" name="oldPassword" id="oldPassword" required
                               placeholder="Nhập mật khẩu cũ">
                        <span class="input-group-text toggle-password" data-target="oldPassword"
                              style="cursor:pointer">
                                                <i class="bi bi-eye"></i>
                                            </span>
                    </div>
                </label>
                <label>
                    <i class="bi bi-key-fill me-1"></i> Mật khẩu mới
                    <div class="input-group">
                        <input type="password" name="newPassword" id="newPassword" required
                               placeholder="Nhập mật khẩu mới">
                        <span class="input-group-text toggle-password" data-target="newPassword"
                              style="cursor:pointer">
                                                <i class="bi bi-eye"></i>
                                            </span>
                    </div>
                    <div id="newPasswordError" class="text-danger small mt-1" style="display:none;"></div>
                </label>
                <label>
                    <i class="bi bi-shield-check me-1"></i> Xác nhận mật khẩu
                    <div class="input-group">
                        <input type="password" name="confirmPassword" id="confirmPassword" required
                               placeholder="Nhập lại mật khẩu mới">
                        <span class="input-group-text toggle-password" data-target="confirmPassword"
                              style="cursor:pointer">
                                                <i class="bi bi-eye"></i>
                                            </span>
                    </div>
                </label>
                <div class="actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-shield-lock me-1"></i> Đổi mật khẩu
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        document.querySelectorAll('.has-submenu .menu-item').forEach(item => {
            item.addEventListener('click', () => {
                const parent = item.parentElement;
                const arrow = item.querySelector('.arrow');
                const submenu = parent.querySelector('.submenu');
                parent.classList.toggle('open');
                parent.classList.toggle('active');
                if (parent.classList.contains('open')) {
                    if (arrow) {
                        arrow.classList.remove('bi-chevron-right');
                        arrow.classList.add('bi-chevron-down');
                    }
                    if (submenu) submenu.style.display = 'block';
                } else {
                    if (arrow) {
                        arrow.classList.remove('bi-chevron-down');
                        arrow.classList.add('bi-chevron-right');
                    }
                    if (submenu) submenu.style.display = 'none';
                }
            });
        });
        const avatarWrapper = document.querySelector(".avatar-wrapper");
        const avatarInput = document.getElementById("avatarInput");
        const avatarPreview = document.getElementById("avatarPreview");
        const processingNotification = document.getElementById("avatar-processing-notification");
        if (avatarWrapper && avatarInput) {
            avatarWrapper.addEventListener("click", () => avatarInput.click());
            avatarInput.addEventListener("change", function () {
                const file = this.files[0];
                if (!file) return;
                if (!file.type.startsWith('image/')) {
                    Swal.fire({icon: 'error', title: 'Lỗi', text: '⚠️ Vui lòng chọn file hình ảnh!'});
                    this.value = '';
                    return;
                }
                if (file.size > 5 * 1024 * 1024) {
                    Swal.fire({icon: 'error', title: 'Lỗi', text: '⚠️ File không được vượt quá 5MB!'});
                    this.value = '';
                    return;
                }
                const reader = new FileReader();
                reader.onload = e => {
                    avatarPreview.src = e.target.result;
                    const sidebarAvatar = document.getElementById("sidebarAvatar");
                    if (sidebarAvatar) sidebarAvatar.src = e.target.result;
                    const avatarClearBtn = document.getElementById("avatarClearBtn");
                    if (avatarClearBtn) avatarClearBtn.style.display = "flex";
                    if (processingNotification) {
                        processingNotification.style.display = "block";
                        uploadAvatar(file);
                    }
                };
                reader.readAsDataURL(file);
            });
        }

        function uploadAvatar(file) {
            const formData = new FormData();
            formData.append("avatar", file);
            formData.append("fullName", document.querySelector('input[name="fullName"]').value);
            formData.append("email", document.querySelector('input[name="email"]').value);
            formData.append("phone", document.querySelector('input[name="phone"]').value);
            fetch('${pageContext.request.contextPath}/admin/profile?action=update-info', {
                method: 'POST',
                body: formData
            }).then(response => {
                if (response.ok) {
                    if (processingNotification) processingNotification.style.display = "none";
                    Swal.fire({
                        icon: 'success',
                        title: 'Thành công',
                        text: 'Đã cập nhật ảnh đại diện!',
                        timer: 2000,
                        showConfirmButton: false
                    }).then(() => {
                        location.reload();
                    });
                } else {
                    throw new Error('Lỗi khi lưu ảnh');
                }
            }).catch(error => {
                console.error('Error:', error);
                if (processingNotification) processingNotification.style.display = "none";
                Swal.fire({
                    icon: 'error',
                    title: 'Thất bại!',
                    text: 'Có lỗi xảy ra khi lưu ảnh!',
                    confirmButtonText: 'Thử lại'
                });
            });
        }

        const bankView = document.getElementById("bankView");
        const bankEdit = document.getElementById("bankEdit");
        const btnEdit = document.getElementById("btn-edit-bank");
        const btnAdd = document.getElementById("btn-add-bank");
        const btnCancel = document.getElementById("btnCancelBank");
        const bankForm = document.getElementById("bankForm");
        const qrUpload = document.getElementById("qrUpload");
        const qrPreviewImg = document.getElementById("qrPreviewImg");
        const currentQR = document.getElementById("currentQR");
        const khungThemQR = document.getElementById("khungThemQR");
        if (btnEdit) {
            btnEdit.addEventListener("click", () => {
                bankView.classList.add("d-none");
                bankEdit.classList.remove("d-none");
                if (qrUpload) qrUpload.required = false;
            });
        }
        if (btnAdd) {
            btnAdd.addEventListener("click", () => {
                bankView.classList.add("d-none");
                bankEdit.classList.remove("d-none");
                if (qrUpload) qrUpload.required = true;
            });
        }
        if (btnCancel) {
            btnCancel.addEventListener("click", () => {
                bankEdit.classList.add("d-none");
                bankView.classList.remove("d-none");
                if (bankForm) bankForm.reset();
                if (qrPreviewImg) {
                    qrPreviewImg.classList.add("d-none");
                    qrPreviewImg.src = "";
                }
                if (currentQR) currentQR.classList.remove("d-none");
            });
        }
        if (khungThemQR && qrUpload && qrPreviewImg) {
            khungThemQR.addEventListener("click", () => qrUpload.click());
            qrUpload.addEventListener("change", () => {
                const file = qrUpload.files[0];
                if (!file) return;
                if (!file.type.startsWith('image/')) {
                    alert('Vui lòng chọn file hình ảnh!');
                    qrUpload.value = '';
                    return;
                }
                if (file.size > 5 * 1024 * 1024) {
                    alert('File không được vượt quá 5MB!');
                    qrUpload.value = '';
                    return;
                }
                const reader = new FileReader();
                reader.onload = e => {
                    qrPreviewImg.src = e.target.result;
                    qrPreviewImg.classList.remove("d-none");
                    if (currentQR) currentQR.classList.add("d-none");
                };
                reader.readAsDataURL(file);
            });
        }
        const toggleEye = document.getElementById("toggleEye");
        const accountNumber = document.getElementById("accountNumber");
        const eyeIcon = document.getElementById("eyeIcon");
        if (toggleEye && accountNumber) {
            toggleEye.addEventListener("click", () => {
                if (accountNumber.type === "password") {
                    accountNumber.type = "text";
                    eyeIcon.classList.replace("bi-eye", "bi-eye-slash");
                } else {
                    accountNumber.type = "password";
                    eyeIcon.classList.replace("bi-eye-slash", "bi-eye");
                }
            });
        }
        document.querySelectorAll('.toggle-password').forEach(toggle => {
            toggle.addEventListener('click', function () {
                const targetId = this.getAttribute('data-target');
                const input = document.getElementById(targetId);
                const icon = this.querySelector('i');
                if (input.type === 'password') {
                    input.type = 'text';
                    icon.classList.replace('bi-eye', 'bi-eye-slash');
                } else {
                    input.type = 'password';
                    icon.classList.replace('bi-eye-slash', 'bi-eye');
                }
            });
        });
        const changePassForm = document.getElementById("changePassForm");
        const newPasswordInput = document.getElementById("newPassword");
        const newPasswordError = document.getElementById("newPasswordError");
        if (newPasswordInput) {
            newPasswordInput.addEventListener("input", function () {
                let pwd = this.value;
                if (!pwd) {
                    newPasswordError.style.display = "none";
                    return;
                }
                newPasswordError.className = "text-danger small mt-1";
                if (pwd.length < 8) {
                    newPasswordError.textContent = "Mật khẩu ít nhất 8 ký tự";
                    newPasswordError.style.display = "block";
                    return;
                }
                if (!/[A-Z]/.test(pwd)) {
                    newPasswordError.textContent = "Mật khẩu thiếu chữ hoa";
                    newPasswordError.style.display = "block";
                    return;
                }
                if (!/[a-z]/.test(pwd)) {
                    newPasswordError.textContent = "Mật khẩu thiếu chữ thường";
                    newPasswordError.style.display = "block";
                    return;
                }
                if (!/[0-9]/.test(pwd)) {
                    newPasswordError.textContent = "Mật khẩu thiếu số";
                    newPasswordError.style.display = "block";
                    return;
                }
                if (!/[@$!%*?&]/.test(pwd)) {
                    newPasswordError.textContent = "Mật khẩu thiếu ký tự đặc biệt";
                    newPasswordError.style.display = "block";
                    return;
                }
                newPasswordError.textContent = "Mật khẩu hợp lệ";
                newPasswordError.className = "text-success small mt-1";
                newPasswordError.style.display = "block";
            });
        }
        const emailInput = document.getElementById("editEmail");
        const emailError = document.getElementById("emailError");
        const phoneInput = document.getElementById("editPhone");
        const phoneError = document.getElementById("phoneError");
        if (emailInput) {
            emailInput.addEventListener("input", function () {
                const val = this.value.trim();
                const pattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!val) {
                    emailError.style.display = "none";
                } else if (!pattern.test(val)) {
                    emailError.textContent = "Email chưa đúng định dạng.Vui lòng chỉnh sửa thêm!";
                    emailError.className = "text-danger small mt-1";
                    emailError.style.display = "block";
                } else {
                    emailError.textContent = "Email hợp lệ";
                    emailError.className = "text-success small mt-1";
                    emailError.style.display = "block";
                }
            });
        }
        if (phoneInput) {
            phoneInput.addEventListener("input", function () {
                const val = this.value.trim();
                phoneError.className = "text-danger small mt-1";
                if (!val) {
                    phoneError.style.display = "none";
                } else if (!val.startsWith("0")) {
                    phoneError.textContent = "Số điện thoại phải bắt đầu bằng số 0";
                    phoneError.style.display = "block";
                } else if (!/^[0-9]+$/.test(val)) {
                    phoneError.textContent = "Số điện thoại chỉ được chứa ký tự số";
                    phoneError.style.display = "block";
                } else if (val.length !== 10) {
                    phoneError.textContent = "Số điện thoại phải có đúng 10 chữ số";
                    phoneError.style.display = "block";
                } else {
                    phoneError.textContent = "Số điện thoại hợp lệ";
                    phoneError.className = "text-success small mt-1";
                    phoneError.style.display = "block";
                }
            });
        }
        if (changePassForm) {
            changePassForm.addEventListener("submit", function (e) {
                const newPassword = document.getElementById("newPassword").value;
                const confirmPassword = document.getElementById("confirmPassword").value;
                if (newPassword !== confirmPassword) {
                    e.preventDefault();
                    alert("Mật khẩu xác nhận không khớp!");
                    return false;
                }
                const strongPasswordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$/;
                if (!strongPasswordRegex.test(newPassword)) {
                    e.preventDefault();
                    document.getElementById("newPassword").focus();
                    return false;
                }
            });
        }
        const avatarClearBtn = document.getElementById("avatarClearBtn");
        if (avatarClearBtn) {
            avatarClearBtn.addEventListener("click", (e) => {
                e.stopPropagation();
                avatarPreview.src = "${pageContext.request.contextPath}/image/logoTCN.png";
                avatarInput.value = "";
                avatarClearBtn.style.display = "none";
                const sidebarAvatar = document.getElementById("sidebarAvatar");
                if (sidebarAvatar) sidebarAvatar.src = "${pageContext.request.contextPath}/image/logoTCN.png";
            });
        }
        if (window.$) {
            $("#logoutBtn").on("click", () => $("#logoutModal").css("display", "flex"));
            $("#cancelLogout").on("click", () => $("#logoutModal").hide());
        }
        setTimeout(() => {
            document.querySelectorAll('.alert').forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    });
</script>
</body>
</html>