<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Banner - SkyDrone Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/blog-manage.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        .banner-thumb,
        .banner-video {
            width: 150px;
            height: 80px;
            object-fit: cover;
            border-radius: 6px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
        }

        .modal-header {
            background: linear-gradient(180deg, #0051c6, #0073ff);
            color: white;
        }

        .modal-header .btn-close {
            filter: brightness(0) invert(1);
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
                <li><i class="bi bi-person-lines-fill"></i> Quản Lý Tài Khoản</li>
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
                <li class="active"><i class="bi bi-images"></i> Quản Lý Banner</li>
            </a>
        </ul>
    </aside>
    <main class="main-content container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="text-primary fw-bold"><i class="bi bi-images"></i> Quản Lý Banner</h4>
        </div>
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div class="input-group" style="max-width: 350px;">
                                        <span class="input-group-text bg-primary text-white">
                                            <i class="bi bi-search"></i>
                                        </span>
                <input type="search" class="form-control" id="searchBannerInput"
                       placeholder="Tìm kiếm banner...">
            </div>
            <button class="btn btn-success" data-bs-toggle="modal"
                    data-bs-target="#addBannerModal">
                <i class="bi bi-plus-lg"></i> Thêm Banner
            </button>
        </div>
        <div class="users-table mt-4">
            <section>
                <table class="table table-striped table-bordered align-middle text-center"
                       id="tableBanner">
                    <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Loại</th>
                        <th>Preview</th>
                        <th>Thứ tự</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="banner" items="${banners}">
                        <tr>
                            <td>${banner.id}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${banner.type == 'image'}">
                                        <span class="badge bg-primary">Hình Ảnh</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-info">Video</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${banner.type == 'image'}">
                                        <img src="${banner.imageUrl}" class="banner-thumb"
                                             alt="Banner">
                                    </c:when>
                                    <c:otherwise>
                                        <video src="${banner.videoUrl}" class="banner-video"
                                               muted></video>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${banner.orderIndex}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${banner.status == 'active'}">
                                        <span class="badge bg-success">Hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Tạm ẩn</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <button type="button" class="btn btn-warning btn-sm me-1"
                                        data-id="${banner.id}" data-type="${banner.type}"
                                        data-image="${fn:escapeXml(banner.imageUrl)}"
                                        data-video="${fn:escapeXml(banner.videoUrl)}"
                                        data-link="${fn:escapeXml(banner.link)}"
                                        data-order="${banner.orderIndex}"
                                        data-status="${banner.status}"
                                        onclick="openEditModal(this)">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button type="button" class="btn btn-danger btn-sm me-1"
                                        data-id="${banner.id}" onclick="confirmDelete(this)">
                                    <i class="bi bi-trash"></i>
                                </button>
                                <button type="button" class="btn btn-info btn-sm"
                                        data-id="${banner.id}" data-type="${banner.type}"
                                        data-image="${fn:escapeXml(banner.imageUrl)}"
                                        data-video="${fn:escapeXml(banner.videoUrl)}"
                                        data-link="${fn:escapeXml(banner.link)}"
                                        data-order="${banner.orderIndex}"
                                        data-status="${banner.status}"
                                        onclick="openViewModal(this)">
                                    <i class="bi bi-eye"></i>
                                </button>
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
            </section>
        </div>
    </main>
</div>
<div class="modal fade" id="addBannerModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/banner-manage" method="post">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="bi bi-plus-lg"></i> Thêm Banner</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="add">
                    <div class="mb-3">
                        <label class="form-label">Loại Banner</label>
                        <select name="type" class="form-select" id="add-type"
                                onchange="toggleMediaInput('add')" required>
                            <option value="image">Hình ảnh</option>
                            <option value="video">Video</option>
                        </select>
                    </div>
                    <div class="mb-3" id="add-image-group">
                        <label class="form-label">Link ảnh banner</label>
                        <input type="text" name="image" class="form-control"
                               placeholder="https://..." id="add-image-input">
                    </div>
                    <div class="mb-3 d-none" id="add-video-group">
                        <label class="form-label">Link video banner</label>
                        <input type="text" name="video" class="form-control"
                               placeholder="https://..." id="add-video-input">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Link điều hướng (URL)</label>
                        <input type="text" name="link" class="form-control"
                               placeholder="https://...">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Thứ tự hiển thị</label>
                        <input type="number" name="orderIndex" class="form-control" value="0"
                               min="0">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="active">Đang hoạt động</option>
                            <option value="inactive">Tạm ẩn</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary"
                            data-bs-dismiss="modal">Hủy
                    </button>
                    <button type="submit" class="btn btn-success">Lưu</button>
                </div>
            </form>
        </div>
    </div>
</div>
<div class="modal fade" id="editBannerModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/banner-manage" method="post">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="bi bi-pencil"></i> Sửa Banner</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="id" id="edit-id">
                    <div class="mb-3">
                        <label class="form-label">Loại Banner</label>
                        <select name="type" class="form-select" id="edit-type"
                                onchange="toggleMediaInput('edit')" required>
                            <option value="image">Hình ảnh</option>
                            <option value="video">Video</option>
                        </select>
                    </div>
                    <div class="mb-3" id="edit-image-group">
                        <label class="form-label">Link ảnh</label>
                        <input type="text" name="image" id="edit-image" class="form-control">
                    </div>
                    <div class="mb-3 d-none" id="edit-video-group">
                        <label class="form-label">Link video</label>
                        <input type="text" name="video" id="edit-video" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Link điều hướng</label>
                        <input type="text" name="link" id="edit-link" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Thứ tự hiển thị</label>
                        <input type="number" name="orderIndex" id="edit-order" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" id="edit-status" class="form-select">
                            <option value="active">Hoạt động</option>
                            <option value="inactive">Tạm ẩn</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary"
                            data-bs-dismiss="modal">Hủy
                    </button>
                    <button type="submit" class="btn btn-success">Lưu</button>
                </div>
            </form>
        </div>
    </div>
</div>
<div class="modal fade" id="viewBannerModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-eye"></i> Chi tiết Banner</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <table class="table table-bordered">
                    <tr>
                        <th style="width: 150px;">ID</th>
                        <td id="view-id"></td>
                    </tr>
                    <tr>
                        <th>Loại</th>
                        <td id="view-type"></td>
                    </tr>
                    <tr>
                        <th>Preview</th>
                        <td id="view-media-container"></td>
                    </tr>
                    <tr>
                        <th>Link điều hướng</th>
                        <td id="view-link"></td>
                    </tr>
                    <tr>
                        <th>Thứ tự</th>
                        <td id="view-order"></td>
                    </tr>
                    <tr>
                        <th>Trạng thái</th>
                        <td id="view-status"></td>
                    </tr>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary"
                        data-bs-dismiss="modal">Đóng
                </button>
            </div>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script>
    const baseUrl = "${pageContext.request.contextPath}";
    let bannerTable;

    $(document).ready(function () {
        bannerTable = $('#tableBanner').DataTable({
            pageLength: 5,
            columnDefs: [{targets: [2, 5], orderable: false}],
            language: {zeroRecords: "Không tìm thấy dữ liệu"}
        });
        $('#searchBannerInput').on('keyup', function () {
            bannerTable.search(this.value).draw();
        });
        $('#prevPage').click(() => {
            bannerTable.page('previous').draw('page');
            updatePageInfo();
        });
        $('#nextPage').click(() => {
            bannerTable.page('next').draw('page');
            updatePageInfo();
        });
        bannerTable.on('draw', updatePageInfo);
        updatePageInfo();
        const urlParams = new URLSearchParams(window.location.search);
        const msg = urlParams.get('msg');
        const error = urlParams.get('error');
        if (msg === 'added') {
            Swal.fire({
                icon: 'success',
                title: 'Thành công!',
                text: 'Đã thêm banner mới thành công.',
                timer: 2000,
                showConfirmButton: false
            });
        } else if (msg === 'updated') {
            Swal.fire({
                icon: 'success',
                title: 'Thành công!',
                text: 'Đã cập nhật banner thành công.',
                timer: 2000,
                showConfirmButton: false
            });
        } else if (msg === 'deleted') {
            Swal.fire({
                icon: 'success',
                title: 'Đã xóa!',
                text: 'Banner đã được xóa khỏi hệ thống.',
                timer: 2000,
                showConfirmButton: false
            });
        } else if (msg === 'add_failed') {
            Swal.fire({
                icon: 'error',
                title: 'Thất bại!',
                text: 'Không thể thêm banner. Vui lòng thử lại.',
            });
        } else if (msg === 'update_failed') {
            Swal.fire({
                icon: 'error',
                title: 'Thất bại!',
                text: 'Không thể cập nhật banner. Vui lòng thử lại.',
            });
        } else if (error === 'delete_failed') {
            Swal.fire({
                icon: 'error',
                title: 'Thất bại!',
                text: 'Không thể xóa banner. Vui lòng thử lại.',
            });
        }
    });

    function updatePageInfo() {
        const info = bannerTable.page.info();
        $('#pageInfo').text((info.page + 1) + ' / ' + info.pages);
    }

    function toggleMediaInput(prefix) {
        const type = document.getElementById(prefix + '-type').value;
        const imageGroup = document.getElementById(prefix + '-image-group');
        const videoGroup = document.getElementById(prefix + '-video-group');
        if (type === 'image') {
            imageGroup.classList.remove('d-none');
            videoGroup.classList.add('d-none');
        } else {
            imageGroup.classList.add('d-none');
            videoGroup.classList.remove('d-none');
        }
    }

    function openEditModal(btn) {
        document.getElementById('edit-id').value = btn.dataset.id;
        document.getElementById('edit-type').value = btn.dataset.type;
        document.getElementById('edit-image').value = btn.dataset.image;
        document.getElementById('edit-video').value = btn.dataset.video;
        document.getElementById('edit-link').value = btn.dataset.link;
        document.getElementById('edit-order').value = btn.dataset.order;
        document.getElementById('edit-status').value = btn.dataset.status;
        toggleMediaInput('edit');
        let modal = new bootstrap.Modal(document.getElementById('editBannerModal'));
        modal.show();
    }

    function openViewModal(btn) {
        document.getElementById('view-id').innerText = btn.dataset.id;
        document.getElementById('view-type').innerText = btn.dataset.type === 'image' ? 'Hình Ảnh' : 'Video';
        document.getElementById('view-link').innerText = btn.dataset.link || '---';
        document.getElementById('view-order').innerText = btn.dataset.order;
        document.getElementById('view-status').innerText = btn.dataset.status === 'active' ? 'Hoạt động' : 'Tạm ẩn';
        const mediaContainer = document.getElementById('view-media-container');
        if (btn.dataset.type === 'image') {
            mediaContainer.innerHTML = '<img src="' + btn.dataset.image + '" style="max-width: 100%; border-radius: 6px;">';
        } else {
            mediaContainer.innerHTML = '<video src="' + btn.dataset.video + '" controls style="max-width: 100%; border-radius: 6px;"></video>';
        }
        let modal = new bootstrap.Modal(document.getElementById('viewBannerModal'));
        modal.show();
    }

    function confirmDelete(btn) {
        const id = btn.dataset.id;
        Swal.fire({
            title: 'Bạn có chắc chắn?',
            text: "Bạn sẽ không thể khôi phục lại banner này!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Có, xóa nó!',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = baseUrl + '/admin/banner-manage';
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                form.appendChild(actionInput);
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = id;
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        })
    }

    document.addEventListener("DOMContentLoaded", () => {
        const logoutBtn = document.getElementById("logoutBtn");
        const logoutModal = document.getElementById("logoutModal");
        const cancelLogout = document.getElementById("cancelLogout");
        if (logoutBtn && logoutModal && cancelLogout) {
            logoutBtn.addEventListener("click", () => logoutModal.style.display = "flex");
            cancelLogout.addEventListener("click", () => logoutModal.style.display = "none");
        }
    });
    document.addEventListener("DOMContentLoaded", function () {
        const menuItems = document.querySelectorAll(".has-submenu .menu-item");
        menuItems.forEach(item => {
            item.addEventListener("click", function () {
                const parent = this.parentElement;
                parent.classList.toggle("open");
            });
        });
    });
    setTimeout(() => {
        const alert = document.getElementById("alertMsg");
        if (alert) {
            alert.classList.add("fade");
            alert.style.opacity = "0";
            setTimeout(() => alert.remove(), 500);
        }
    }, 3000);
</script>
</body>
</html>