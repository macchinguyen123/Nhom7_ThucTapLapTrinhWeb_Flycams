<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang Quản Lý Khách Hàng - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/stylesheets/admin/customer-manage.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
    <style>
        .edit-form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
        }

        .form-section {
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e0e0e0;
        }

        .form-section:last-child {
            border-bottom: none;
        }

        .section-title {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-save-custom {
            background: #28a745;
            color: white;
            padding: 10px 30px;
            border: none;
            border-radius: 5px;
            font-weight: 600;
        }

        .btn-save-custom:hover {
            background: #218838;
            color: white;
        }

        .status-toggle {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        #successAlert {
            display: none;
        }
    </style>
</head>
<body>
<header class="main-header">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/image/logoo2.png" alt="Logo">
        <h2>SkyDrone Admin</h2>
    </div>
    <div class="header-right">
        <a href="${pageContext.request.contextPath}/admin/profile"
           class="text-decoration-none text-while">
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
                <a href="${pageContext.request.contextPath}/home">
                    <button id="confirmLogout" class="confirm">Có</button>
                </a>
                <button id="cancelLogout" class="cancel">Không</button>
            </div>
        </div>
    </div>
</header>
<div class="layout">
    <aside class="sidebar">
        <div class="user-info">
            <c:choose>
                <c:when test="${not empty sessionScope.user.avatar}">
                    <img src="${pageContext.request.contextPath}/image/avatar/${sessionScope.user.avatar}?v=${sessionScope.user.updatedAt != null ? sessionScope.user.updatedAt.time : ''}"
                         alt="Avatar"
                         style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover;">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/image/logoTCN.png" alt="Avatar">
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
                <li class="active"><i class="bi bi-person-lines-fill"></i> Quản Lý Tài Khoản</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/product-management">
                <li><i class="bi bi-box-seam"></i> Quản Lý Sản Phẩm</li>
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
    <main class="main-content container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="text-primary fw-bold"><i class="bi bi-person-lines-fill"></i> Quản Lý Tài Khoản</h4>
            <div class="d-flex align-items-center gap-2">
                <a href="${pageContext.request.contextPath}/admin/complaints"
                   class="btn btn-warning shadow-sm fw-semibold">
                    <i class="bi bi-card-text"></i> Danh sách khiếu nại (${complaintCount != null ? complaintCount : 0})
                </a>
                <form action="${pageContext.request.contextPath}/admin/customer-manage" method="GET" class="d-flex"
                      role="search" style="max-width: 300px;">
                    <div class="input-group">
                        <button type="submit" class="btn input-group-text bg-primary text-white">
                            <i class="bi bi-search"></i>
                        </button>
                        <input id="search" name="keyword" value="${param.keyword}" type="search" class="form-control"
                               placeholder="Tìm kiếm bằng mã, họ tên, đăng nhập, email, sđt..." aria-label="Tìm kiếm">
                    </div>
                </form>
            </div>
        </div>
        <c:if test="${empty showDetail or showDetail == false}">
            <div class="users-table mt-4">
                <div class="d-flex justify-content-start align-items-center mb-2">
                    <label class="me-2">Hiển thị</label>
                    <select id="rowsPerPage" class="form-select d-inline-block" style="width:80px;">
                        <option value="5" selected>5</option>
                        <option value="10">10</option>
                        <option value="20">20</option>
                    </select>
                    <label class="ms-2">tài khoản</label>
                </div>
                <table id="tableKhachHang" class="table table-striped table-bordered">
                    <thead class="table-dark">
                    <tr>
                        <th>Mã</th>
                        <th>Họ tên</th>
                        <th>Tên đăng nhập</th>
                        <th>Email</th>
                        <th>Số điện thoại</th>
                        <th>Vai trò</th>
                        <th>Địa chỉ</th>
                        <th>Khóa</th>
                        <th>Sửa</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${users}" var="u">
                        <tr>
                            <td>${u.id}</td>
                            <td>${u.fullName}</td>
                            <td>${u.username}</td>
                            <td>${u.email}</td>
                            <td>${u.phoneNumber}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.roleId == 1}">
                                        <span class="badge bg-info text-dark">Admin</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">User</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${u.address}</td>
                            <td class="text-center">
                                <button
                                        class="btn btn-sm ${u.status ? 'btn-success' : 'btn-danger'}"
                                        onclick="toggleLock(this, ${u.id})"
                                        data-lock-reason="${u.lockReason}"
                                        title="${not empty u.lockReason ? u.lockReason : (u.status ? 'Đang hoạt động' : '')}">
                                    <i class="bi ${u.status ? 'bi-unlock-fill' : 'bi-lock-fill'}"></i>
                                </button>
                                <c:if test="${not empty u.lockReason and !u.status}">
        <span class="d-block mt-1"
              style="max-width:100px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; font-size:11px; color:#dc3545;"
              title="${u.lockReason}">
            <i class="bi bi-info-circle"></i> ${fn:substring(u.lockReason, 0, 15)}${fn:length(u.lockReason) > 15 ? '...' : ''}
        </span>
                                </c:if>
                            </td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/admin/customer-detail?id=${u.id}"
                                   class="btn btn-warning btn-sm">
                                    <i class="bi bi-pencil-square"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                <div class="d-flex justify-content-end align-items-center mt-3">
                    <button id="prevPage" class="btn btn-outline-primary btn-sm">Trước</button>
                    <span id="pageInfo" class="mx-2">1 / 1</span>
                    <button id="nextPage" class="btn btn-outline-primary btn-sm">Sau</button>
                </div>
            </div>
        </c:if>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const provinceSelect = document.getElementById("provinceSelect");
                const districtSelect = document.getElementById("districtSelect");
                const hiddenAddress = document.getElementById("editAddressHidden");
                if (provinceSelect && districtSelect) {
                    const GHN_API = "${pageContext.request.contextPath}/ghn";
                    const oldAddress = hiddenAddress.value || "";
                    const addressParts = oldAddress.split(",").map(x => x.trim());
                    let savedProvince = addressParts.length >= 2 ? addressParts[addressParts.length - 1] : "";
                    let savedDistrict = addressParts.length >= 2 ? addressParts[addressParts.length - 2] : "";

                    function matchOptionByText(select, text) {
                        if (!text) return null;
                        const t = text.toLowerCase().replace(/(tỉnh|thành phố|thị xã|quận|huyện|phường|xã|thị trấn)\s+/gi, "").trim();
                        for (let i = 0; i < select.options.length; i++) {
                            const optText = select.options[i].text.toLowerCase().replace(/(tỉnh|thành phố|thị xã|quận|huyện|phường|xã|thị trấn)\s+/gi, "").trim();
                            if (optText.includes(t) || t.includes(optText)) return select.options[i];
                        }
                        return null;
                    }

                    fetch(GHN_API + "/provinces")
                        .then(r => r.json())
                        .then(json => {
                            if (json.code !== 200) {
                                console.error("GHN API failed:", json);
                                return;
                            }
                            json.data.forEach(p => {
                                const option = document.createElement("option");
                                option.value = p.ProvinceName;
                                option.text = p.ProvinceName;
                                option.dataset.ghnId = p.ProvinceID;
                                provinceSelect.appendChild(option);
                            });
                            try {
                                if (savedProvince) {
                                    const matched = matchOptionByText(provinceSelect, savedProvince);
                                    if (matched) provinceSelect.value = matched.value;
                                }
                            } catch (e) {
                                console.error("Error pre-selecting province:", e);
                            }
                            provinceSelect.addEventListener("change", function () {
                                districtSelect.innerHTML = '<option value="">Chọn Quận/Huyện</option>';
                                districtSelect.disabled = true;
                                const selectedOpt = this.options[this.selectedIndex];
                                const ghnId = selectedOpt && selectedOpt.dataset ? selectedOpt.dataset.ghnId : null;
                                if (ghnId) {
                                    fetch(GHN_API + "/districts?provinceId=" + ghnId)
                                        .then(res => res.json())
                                        .then(dJson => {
                                            if (dJson.code !== 200) return;
                                            dJson.data.forEach(d => {
                                                const opt = document.createElement("option");
                                                opt.value = d.DistrictName;
                                                opt.text = d.DistrictName;
                                                opt.dataset.ghnId = d.DistrictID;
                                                districtSelect.appendChild(opt);
                                            });
                                            districtSelect.disabled = false;
                                            try {
                                                if (savedDistrict) {
                                                    const matchedDist = matchOptionByText(districtSelect, savedDistrict);
                                                    if (matchedDist) districtSelect.value = matchedDist.value;
                                                    savedDistrict = "";
                                                }
                                            } catch (e) {
                                                console.error("Error pre-selecting district:", e);
                                            }
                                            updateHiddenAddress();
                                        })
                                        .catch(err => console.error("GHN District error:", err));
                                } else {
                                    updateHiddenAddress();
                                }
                            });
                            try {
                                if (provinceSelect.value) {
                                    provinceSelect.dispatchEvent(new Event("change"));
                                }
                            } catch (e) {
                                console.error("Error dispatching change on province:", e);
                            }
                            districtSelect.addEventListener("change", updateHiddenAddress);

                            function updateHiddenAddress() {
                                if (provinceSelect.value && districtSelect.value) {
                                    hiddenAddress.value = districtSelect.value + ", " + provinceSelect.value;
                                }
                            }
                        })
                        .catch(err => console.error("Error fetching provinces:", err));
                }
            });
        </script>
        <c:if test="${showDetail}">
            <div class="order-card mt-4">
                <a href="${pageContext.request.contextPath}/admin/customer-manage"
                   class="btn btn-secondary mb-3"> <i class="bi bi-arrow-left"></i> Quay lại</a>
                <div class="edit-form-container">
                    <h5 class="mb-4"><i class="bi bi-pencil-square"></i> Chỉnh Sửa Thông Tin</h5>
                    <form id="editCustomerForm" method="POST" enctype="multipart/form-data"
                          action="${pageContext.request.contextPath}/admin/update-customer">
                        <input type="hidden" name="id" value="${detailUser.id}">
                        <div class="form-section">
                            <div class="section-title">
                                <i class="bi bi-person-badge"></i>
                                Thông Tin Cơ Bản
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Họ và Tên <span
                                            class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="fullName"
                                           value="${detailUser.fullName}" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Quyền Hạn (Role) <span
                                            class="text-danger">*</span></label>
                                    <select class="form-select" name="roleId" required>
                                        <option value="1" <c:if test="${detailUser.roleId == 1}">
                                            selected
                                        </c:if>>1 - Admin (Quản trị viên)
                                        </option>
                                        <option value="2" <c:if test="${detailUser.roleId == 2}">selected</c:if>>2 -
                                            User (Người dùng)
                                        </option>
                                    </select>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Tên đăng nhập <span
                                            class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="username"
                                           value="${detailUser.username}"
                                           required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">
                                        Mật khẩu (đã mã hóa)
                                    </label>
                                    <c:set var="pw" value="${detailUser.password}"/>
                                    <input type="text" class="form-control"
                                           value="${fn:substring(pw, 0, 20)}...${fn:substring(pw, fn:length(pw)-10, fn:length(pw))}"
                                           title="${pw}" readonly
                                           style="font-family: monospace; font-size: 13px; background:#f5f5f5;">
                                    <small class="text-muted">
                                        Mật khẩu đã được mã hóa an toàn.
                                    </small>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">
                                        Đổi mật khẩu mới
                                    </label>
                                    <input type="password" id="newPassword" class="form-control" name="newPassword"
                                           placeholder="Để trống nếu không đổi mật khẩu">
                                    <div id="passwordError" class="text-danger small mt-1" style="display:none;"></div>
                                    <small class="text-warning d-block mt-1">
                                        <i class="bi bi-info-circle"></i> Khi lưu, mật khẩu mới sẽ được mã hóa tự động
                                    </small>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <label class="form-label fw-semibold">Avatar</label>
                                    <div class="d-flex gap-3 align-items-center">
                                        <div class="avatar-current-box d-flex flex-column align-items-center justify-content-center border rounded position-relative p-2"
                                             style="width:100px; height:100px;">
                                            <c:choose>
                                                <c:when test="${not empty detailUser.avatar}">
                                                    <img src="${pageContext.request.contextPath}/image/avatar/${detailUser.avatar}"
                                                         style="width:100%;height:100%;object-fit:cover;border-radius:8px;">
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="bi bi-person-circle text-muted"
                                                       style="font-size:3rem;"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div id="newAvatarBox"
                                             class="avatar-new-box d-flex flex-column align-items-center justify-content-center border border-dashed rounded position-relative"
                                             style="width:100px; height:100px; border-style:dashed; cursor:pointer;">
                                            <input type="file" name="avatarFile" id="customerAvatarInput"
                                                   accept="image/*" hidden>
                                            <i class="bi bi-plus-lg text-primary fs-3" id="plusIcon"></i>
                                            <img src="" id="newAvatarPreview"
                                                 style="width:100%;height:100%;object-fit:cover;border-radius:8px; display:none;">
                                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger"
                                                  id="removeNewAvatarBtn" style="display:none; cursor:pointer;"
                                                  title="Bỏ ảnh">X</span>
                                        </div>
                                    </div>
                                    <input type="hidden" name="oldAvatar" value="${detailUser.avatar}">
                                </div>
                            </div>
                        </div>
                        <div class="form-section">
                            <div class="section-title">
                                <i class="bi bi-envelope"></i>
                                Thông Tin Liên Hệ
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Email <span
                                            class="text-danger">*</span></label>
                                    <input type="email" id="editEmail" class="form-control" name="email"
                                           value="${detailUser.email}"
                                           required>
                                    <div id="emailError" class="text-danger small mt-1" style="display:none;"></div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Số Điện Thoại <span
                                            class="text-danger">*</span></label>
                                    <input type="tel" id="editPhone" class="form-control" name="phoneNumber"
                                           value="${detailUser.phoneNumber}" required pattern="[0-9]{10,11}">
                                    <div id="phoneError" class="text-danger small mt-1" style="display:none;"></div>
                                </div>
                                <div class="col-md-12 mb-3">
                                    <label class="form-label fw-semibold">Địa chỉ</label>
                                    <div class="row">
                                        <div class="col-md-6 mb-2">
                                            <select id="provinceSelect" class="form-select">
                                                <option value="">Chọn Tỉnh/Thành phố</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6 mb-2">
                                            <select id="districtSelect" class="form-select" disabled>
                                                <option value="">Chọn Quận/Huyện</option>
                                            </select>
                                        </div>
                                    </div>
                                    <input type="hidden" id="editAddressHidden" name="address"
                                           value="${detailUser.address}">
                                    <small class="text-muted d-block mt-1">Địa chỉ hiện tại:
                                        <strong>${detailUser.address}</strong></small>
                                </div>
                            </div>
                        </div>
                        <div class="form-section">
                            <div class="section-title">
                                <i class="bi bi-calendar-heart"></i>
                                Thông Tin Cá Nhân
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Ngày Sinh</label>
                                    <fmt:formatDate value="${detailUser.birthDate}" pattern="yyyy-MM-dd"
                                                    var="birthDateFormatted"/>
                                    <input type="date" class="form-control" name="birthDate"
                                           value="${birthDateFormatted != null ? birthDateFormatted : ''}">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-semibold">Giới Tính</label>
                                    <select class="form-select" name="gender">
                                        <option value="">-- Chưa chọn --</option>
                                        <option value="Nam" <c:if test="${detailUser.gender eq 'Nam'}">
                                            selected
                                        </c:if>>Nam
                                        </option>
                                        <option value="Nữ" <c:if test="${detailUser.gender eq 'Nữ'}">selected</c:if>>Nữ
                                        </option>
                                        <option value="Khác"
                                                <c:if test="${detailUser.gender eq 'Khác'}">selected</c:if>
                                        >Khác
                                        </option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="form-section">
                            <div class="section-title">
                                <i class="bi bi-shield-check"></i>
                                Trạng Thái Tài Khoản
                            </div>
                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <label class="form-label fw-semibold">Trạng Thái</label>
                                    <div class="status-toggle">
                                        <div class="form-check form-switch">
                                            <input class="form-check-input" type="checkbox" id="statusSwitch"
                                                   name="status"
                                                   value="true" ${detailUser.status ? 'checked' : '' }>
                                            <label class="form-check-label" for="statusSwitch">
                                            <span id="statusText"
                                                  class="badge ${detailUser.status ? 'bg-success' : 'bg-danger'}">
                                                    ${detailUser.status ? 'Hoạt động' : 'Bị khóa'}
                                            </span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex justify-content-end gap-2 mt-4">
                            <a href="${pageContext.request.contextPath}/admin/customer-manage"
                               class="btn btn-secondary">
                                <i class="bi bi-x-circle"></i> Hủy
                            </a>
                            <button type="submit" class="btn btn-save-custom">
                                <i class="bi bi-check-circle"></i> Lưu Thay Đổi
                            </button>
                        </div>
                        <div style="height: 250px; width: 100%; display: block;"></div>
                    </form>
                </div>
            </div>
        </c:if>
    </main>
</div>
<div class="modal fade" id="lockModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">
                    <i class="bi bi-lock-fill me-2"></i>Khóa Tài Khoản
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="d-flex align-items-center gap-3 mb-3 p-3 bg-danger bg-opacity-10 rounded-3">
                    <i class="bi bi-exclamation-triangle-fill text-danger fs-3"></i>
                    <div>
                        <div class="fw-semibold text-danger">Xác nhận khóa tài khoản</div>
                        <small class="text-muted">Người dùng sẽ không thể đăng nhập sau khi bị khóa.</small>
                    </div>
                </div>
                <label class="form-label fw-semibold">
                    Lý do khóa <span class="text-danger">*</span>
                </label>
                <div class="input-group">
                    <span class="input-group-text bg-danger text-white">
                        <i class="bi bi-chat-left-text"></i>
                    </span>
                    <textarea id="lockReasonInput" class="form-control" rows="3"
                              placeholder="Nhập lý do khóa tài khoản..."></textarea>
                </div>
                <div id="lockReasonError" class="text-danger small mt-1" style="display:none;">
                    <i class="bi bi-exclamation-circle"></i> Vui lòng nhập lý do khóa.
                </div>
                <div class="mt-3">
                    <small class="text-muted fw-semibold">Chọn nhanh:</small>
                    <div class="d-flex flex-wrap gap-2 mt-2">
                        <span class="badge bg-light text-dark border preset-reason" style="cursor:pointer;">
                            Vi phạm điều khoản
                        </span>
                        <span class="badge bg-light text-dark border preset-reason" style="cursor:pointer;">
                            Hành vi gian lận
                        </span>
                        <span class="badge bg-light text-dark border preset-reason" style="cursor:pointer;">
                            Spam hệ thống
                        </span>
                        <span class="badge bg-light text-dark border preset-reason" style="cursor:pointer;">
                            Yêu cầu từ người dùng
                        </span>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-0 pt-0">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x-circle me-1"></i>Hủy
                </button>
                <button type="button" class="btn btn-danger" id="confirmLockBtn">
                    <i class="bi bi-lock-fill me-1"></i>Xác nhận khóa
                </button>
            </div>
        </div>
    </div>
</div>
<div class="position-fixed bottom-0 end-0 p-3" style="z-index: 9999">
    <div id="actionToast" class="toast align-items-center border-0 text-white" role="alert">
        <div class="d-flex">
            <div class="toast-body fw-semibold" id="toastMessage"></div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
</div>
<script>
    document.querySelectorAll('.has-submenu .menu-item').forEach(item => {
        item.addEventListener('click', function (e) {
            e.preventDefault();
            const parent = this.parentElement;
            const submenu = parent.querySelector('.submenu');
            const arrow = this.querySelector('.arrow');
            parent.classList.toggle('active');
            parent.classList.toggle('open');
            if (parent.classList.contains('active') || parent.classList.contains('open')) {
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
    let _lockBtn = null;
    let _lockUserId = null;

    function toggleLock(btn, userId) {
        const isLocked = btn.classList.contains("btn-danger");
        if (isLocked) {
            const params = new URLSearchParams();
            params.append("id", userId);
            params.append("status", 1);
            params.append("lockReason", "");
            fetch("toggle-user-status", {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: params.toString()
            }).then(() => showActionToast("Đã mở khóa tài khoản thành công!", "success"));
            btn.classList.replace("btn-danger", "btn-success");
            btn.querySelector("i").classList.replace("bi-lock-fill", "bi-unlock-fill");
            btn.title = "Đang hoạt động";
            btn.dataset.lockReason = "";
            const reasonSpan = btn.parentElement.querySelector("span.d-block");
            if (reasonSpan) reasonSpan.remove();
        } else {
            _lockBtn = btn;
            _lockUserId = userId;
            document.getElementById("lockReasonInput").value = "";
            document.getElementById("lockReasonError").style.display = "none";
            new bootstrap.Modal(document.getElementById("lockModal")).show();
        }
    }

    document.addEventListener("DOMContentLoaded", function () {
        document.querySelectorAll(".preset-reason").forEach(badge => {
            badge.addEventListener("click", function () {
                document.getElementById("lockReasonInput").value = this.textContent.trim();
                document.getElementById("lockReasonError").style.display = "none";
            });
        });
        document.getElementById("confirmLockBtn").addEventListener("click", function () {
            let reason = document.getElementById("lockReasonInput").value.trim();
            if (!reason) {
                document.getElementById("lockReasonError").style.display = "block";
                return;
            }
            const params = new URLSearchParams();
            params.append("id", _lockUserId);
            params.append("status", 0);
            params.append("lockReason", reason);
            fetch("toggle-user-status", {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: params.toString()
            }).then(() => showActionToast("Đã khóa tài khoản thành công!", "danger"));
            _lockBtn.classList.replace("btn-success", "btn-danger");
            _lockBtn.querySelector("i").classList.replace("bi-unlock-fill", "bi-lock-fill");
            _lockBtn.title = reason;
            _lockBtn.dataset.lockReason = reason;
            const reasonSpan = _lockBtn.parentElement.querySelector("span.d-block");
            if (reasonSpan) {
                reasonSpan.textContent = reason.length > 15 ? reason.substring(0, 15) + "..." : reason;
                reasonSpan.title = reason;
            } else {
                const span = document.createElement("span");
                span.className = "d-block mt-1";
                span.style.cssText = "max-width:100px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-size:11px;color:#dc3545;";
                span.innerHTML = `<i class="bi bi-info-circle"></i> ` + (reason.length > 15 ? reason.substring(0, 15) + "..." : reason);
                span.title = reason;
                _lockBtn.parentElement.appendChild(span);
            }
            bootstrap.Modal.getInstance(document.getElementById("lockModal")).hide();
        });
    });

    function showActionToast(message, type) {
        const toast = document.getElementById("actionToast");
        const toastMsg = document.getElementById("toastMessage");
        toast.className = `toast align-items-center border-0 text-white bg-${type}`;
        toastMsg.textContent = message;
        new bootstrap.Toast(toast, {delay: 3000}).show();
    }

    document.addEventListener("DOMContentLoaded", function () {
        const logoutBtn = document.getElementById("logoutBtn");
        const logoutModal = document.getElementById("logoutModal");
        const cancelLogout = document.getElementById("cancelLogout");
        if (logoutBtn) {
            logoutBtn.addEventListener("click", function () {
                logoutModal.style.display = "flex";
            });
        }
        if (cancelLogout) {
            cancelLogout.addEventListener("click", function () {
                logoutModal.style.display = "none";
            });
        }
    });
    <c:if test="${empty showDetail or showDetail == false}">
    $(document).ready(function () {
        var table = $('#tableKhachHang').DataTable({
            "paging": true,
            "lengthChange": false,
            "pageLength": 5,
            "searching": true,
            "ordering": true,
            "order": [],
            "info": false,
            "dom": 't',
            "columnDefs": [
                {orderable: false, targets: [7, 8]}
            ],
            "language": {
                "emptyTable": "Không có dữ liệu",
                "zeroRecords": "Không tìm thấy dữ liệu phù hợp",
                "searchPlaceholder": "Tìm kiếm...",
                "paginate": {
                    "first": "Đầu",
                    "last": "Cuối",
                    "next": "Sau",
                    "previous": "Trước"
                }
            }
        });
        $("#search").on("keyup search", function () {
            if (this.value.trim() === "") {
                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('keyword')) {
                    window.location.href = '${pageContext.request.contextPath}/admin/customer-manage';
                    return;
                }
            }
            table.search(this.value).draw();
            updatePageInfo();
        });
        $("#rowsPerPage").on("change", function () {
            table.page.len($(this).val()).draw();
            updatePageInfo();
        });
        $("#prevPage").click(function () {
            table.page('previous').draw('page');
            updatePageInfo();
        });
        $("#nextPage").click(function () {
            table.page('next').draw('page');
            updatePageInfo();
        });

        function updatePageInfo() {
            var info = table.page.info();
            $('#pageInfo').text((info.page + 1) + " / " + info.pages);
        }

        table.on('draw', updatePageInfo);
        updatePageInfo();
    });
    </c:if>
    <c:if test="${showDetail}">
    document.getElementById('statusSwitch').addEventListener('change', function () {
        const statusText = document.getElementById('statusText');
        if (this.checked) {
            statusText.textContent = 'Hoạt động';
            statusText.className = 'badge bg-success';
        } else {
            statusText.textContent = 'Bị khóa';
            statusText.className = 'badge bg-danger';
        }
    });

    function showToast(message, type) {
        const existingToasts = document.querySelectorAll('.custom-toast-container');
        existingToasts.forEach(t => t.remove());
        const toastContainer = document.createElement('div');
        toastContainer.className = 'custom-toast-container position-fixed top-50 start-50 translate-middle p-3';
        toastContainer.style.zIndex = '1055';
        const toastHtml = `
            <div id="liveToast" class="toast align-items-center text-white bg-` + (type === 'success' ? 'success' : 'danger') + ` border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="bi ` + (type === 'success' ? 'bi-check-circle-fill' : 'bi-exclamation-triangle-fill') + ` me-2"></i>
                        ` + message + `
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
`;
        toastContainer.innerHTML = toastHtml;
        document.body.appendChild(toastContainer);
        const toastElement = document.getElementById('liveToast');
        const toast = new bootstrap.Toast(toastElement, {delay: 3000});
        toast.show();
    }

    document.addEventListener("DOMContentLoaded", function () {
        const form = document.getElementById('editCustomerForm');
        const newPasswordInput = document.getElementById('newPassword');
        const passwordError = document.getElementById('passwordError');

        function validatePassword() {
            if (!newPasswordInput) return true;
            const pwd = newPasswordInput.value;
            if (pwd === "") {
                if (passwordError) passwordError.style.display = "none";
                return true;
            }
            if (passwordError) passwordError.className = "text-danger small mt-1";
            if (pwd.length < 8) {
                if (passwordError) {
                    passwordError.textContent = "Mật khẩu ít nhất 8 ký tự";
                    passwordError.style.display = "block";
                }
                return false;
            }
            if (!/[A-Z]/.test(pwd)) {
                if (passwordError) {
                    passwordError.textContent = "Mật khẩu thiếu chữ hoa";
                    passwordError.style.display = "block";
                }
                return false;
            }
            if (!/[a-z]/.test(pwd)) {
                if (passwordError) {
                    passwordError.textContent = "Mật khẩu thiếu chữ thường";
                    passwordError.style.display = "block";
                }
                return false;
            }
            if (!/[0-9]/.test(pwd)) {
                if (passwordError) {
                    passwordError.textContent = "Mật khẩu thiếu số";
                    passwordError.style.display = "block";
                }
                return false;
            }
            if (!/[\W_]/.test(pwd)) {
                if (passwordError) {
                    passwordError.textContent = "Mật khẩu thiếu ký tự đặc biệt";
                    passwordError.style.display = "block";
                }
                return false;
            }
            if (passwordError) {
                passwordError.textContent = "Mật khẩu hợp lệ";
                passwordError.className = "text-success small mt-1";
                passwordError.style.display = "block";
            }
            return true;
        }

        if (newPasswordInput) {
            newPasswordInput.addEventListener('input', validatePassword);
        }
        const editEmailInput = document.getElementById('editEmail');
        const emailError = document.getElementById('emailError');
        const editPhoneInput = document.getElementById('editPhone');
        const phoneError = document.getElementById('phoneError');

        function validateEmail() {
            if (!editEmailInput) return true;
            const email = editEmailInput.value.trim();
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (emailError) emailError.className = "text-danger small mt-1";
            if (email === "") {
                if (emailError) emailError.style.display = "none";
                return true;
            }
            if (!emailPattern.test(email)) {
                if (emailError) {
                    emailError.textContent = "Email chưa đúng định dạng.Vui lòng chỉnh sửa thêm!";
                    emailError.style.display = "block";
                }
                return false;
            }
            if (emailError) {
                emailError.textContent = "Email hợp lệ";
                emailError.className = "text-success small mt-1";
                emailError.style.display = "block";
            }
            return true;
        }

        function validatePhone() {
            if (!editPhoneInput) return true;
            const phone = editPhoneInput.value.trim();
            if (phoneError) phoneError.className = "text-danger small mt-1";
            if (phone === "") {
                if (phoneError) phoneError.style.display = "none";
                return true;
            }
            if (!phone.startsWith("0")) {
                if (phoneError) {
                    phoneError.textContent = "Số điện thoại phải bắt đầu bằng số 0";
                    phoneError.style.display = "block";
                }
                return false;
            }
            if (!/^[0-9]+$/.test(phone)) {
                if (phoneError) {
                    phoneError.textContent = "Số điện thoại chỉ được chứa ký tự số";
                    phoneError.style.display = "block";
                }
                return false;
            }
            if (phone.length !== 10) {
                if (phoneError) {
                    phoneError.textContent = "Số điện thoại phải có đúng 10 chữ số";
                    phoneError.style.display = "block";
                }
                return false;
            }
            if (phoneError) {
                phoneError.textContent = "Số điện thoại hợp lệ";
                phoneError.className = "text-success small mt-1";
                phoneError.style.display = "block";
            }
            return true;
        }

        if (editEmailInput) editEmailInput.addEventListener('input', validateEmail);
        if (editPhoneInput) editPhoneInput.addEventListener('input', validatePhone);
        if (form) {
            form.addEventListener('submit', function (e) {
                e.preventDefault();
                let isValid = true;
                if (!validatePassword()) {
                    showToast("Vui lòng kiểm tra lại mật khẩu mới", "error");
                    isValid = false;
                }
                if (!validateEmail()) {
                    showToast("Vui lòng kiểm tra lại email", "error");
                    isValid = false;
                }
                if (!validatePhone()) {
                    showToast("Vui lòng kiểm tra lại số điện thoại", "error");
                    isValid = false;
                }
                if (!isValid) return;
                const formData = new FormData(this);
                fetch(this.action, {
                    method: 'POST',
                    body: formData
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            showToast('Thông tin đã được cập nhật thành công!', 'success');
                        } else {
                            showToast(data.msg || 'Cập nhật thất bại', 'error');
                        }
                    })
                    .catch(err => {
                        showToast('Có lỗi xảy ra khi cập nhật.', 'error');
                        console.error(err);
                    });
            });
        }
        const newAvatarBox = document.getElementById("newAvatarBox");
        const customerAvatarInput = document.getElementById("customerAvatarInput");
        const newAvatarPreview = document.getElementById("newAvatarPreview");
        const plusIcon = document.getElementById("plusIcon");
        const removeNewAvatarBtn = document.getElementById("removeNewAvatarBtn");
        if (newAvatarBox && customerAvatarInput) {
            newAvatarBox.addEventListener("click", function (e) {
                if (e.target !== removeNewAvatarBtn) {
                    customerAvatarInput.click();
                }
            });
            customerAvatarInput.addEventListener("change", function () {
                const file = this.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        newAvatarPreview.src = e.target.result;
                        newAvatarPreview.style.display = "block";
                        removeNewAvatarBtn.style.display = "block";
                        plusIcon.style.display = "none";
                    }
                    reader.readAsDataURL(file);
                }
            });
            removeNewAvatarBtn.addEventListener("click", function (e) {
                e.stopPropagation();
                customerAvatarInput.value = "";
                newAvatarPreview.src = "";
                newAvatarPreview.style.display = "none";
                removeNewAvatarBtn.style.display = "none";
                plusIcon.style.display = "block";
            });
        }
    });
    </c:if>
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>