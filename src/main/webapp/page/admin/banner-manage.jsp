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
    <script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
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
        .drag-handle {
            cursor: grab;
            transition: color 0.2s, transform 0.2s;
        }
        .drag-handle:hover {
            color: #0d6efd !important;
            transform: scale(1.2);
        }
        .drag-handle:active {
            cursor: grabbing;
        }
        tr.table-warning {
            background-color: rgba(255, 193, 7, 0.15) !important;
            border: 2px dashed #ffc107 !important;
        }
        .fs-7 {
            font-size: 0.85rem;
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
                <a href="${pageContext.request.contextPath}/home">
                    <button id="confirmLogout" class="confirm">Có</button>
                </a>
                <button id="cancelLogout" class="cancel">Không</button>
            </div>
        </div>
    </div>
</header>
<div class="layout">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="activePage" value="banner"/>
    </jsp:include>
    <main class="main-content container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="text-primary fw-bold"><i class="bi bi-images"></i> Quản Lý Banner</h4>
        </div>
        <div class="d-flex gap-2 mb-3">
            <a href="${pageContext.request.contextPath}/admin/banner-manage" class="btn ${not isTrash ? 'btn-primary' : 'btn-outline-primary'}">
                <i class="bi bi-list-task"></i> Danh sách hoạt động
            </a>
            <a href="${pageContext.request.contextPath}/admin/banner-manage?show=trash" class="btn ${isTrash ? 'btn-danger' : 'btn-outline-danger'} position-relative">
                <i class="bi bi-trash"></i> Thùng rác
                <c:if test="${trashCount > 0}">
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                        ${trashCount}
                    </span>
                </c:if> </a>
        </div>
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div class="input-group" style="max-width: 350px;">
                <span class="input-group-text bg-primary text-white">
                    <i class="bi bi-search"></i>
                </span>
                <input type="search" class="form-control" id="searchBannerInput"
                       placeholder="Tìm kiếm banner...">
            </div>
            <c:if test="${not isTrash}">
                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addBannerModal">
                    <i class="bi bi-plus-lg"></i> Thêm Banner
                </button>
            </c:if>
        </div>

        <div class="d-flex justify-content-start align-items-center mb-2 gap-2 flex-wrap">
            <label class="me-1">Hiển thị</label>
            <select id="rowsPerPage" class="form-select d-inline-block" style="width:80px;">
                <option value="5" selected>5</option>
                <option value="10">10</option>
                <option value="20">20</option>
            </select>
            <label>banner</label>

            <div class="ms-4 d-flex align-items-center gap-2">
                <label class="mb-0">Lọc loại:</label>
                <select id="filterType" class="form-select d-inline-block" style="width:140px;">
                    <option value="">Tất cả</option>
                    <option value="Hình Ảnh">Hình Ảnh</option>
                    <option value="Video">Video</option>
                </select>
            </div>

            <c:if test="${not isTrash}">
                <div class="ms-4 d-flex align-items-center gap-2">
                    <label class="mb-0">Trạng thái:</label>
                    <select id="filterStatus" class="form-select d-inline-block" style="width:150px;">
                        <option value="">Tất cả</option>
                        <option value="Hoạt động">Hoạt động</option>
                        <option value="Tạm ẩn">Tạm ẩn</option>
                    </select>
                </div>
            </c:if>
        </div>
        <div class="users-table mt-4">
            <section>
                <table class="table table-striped table-bordered align-middle text-center"
                       id="tableBanner">
                    <thead class="table-dark">
                    <tr>
                        <c:if test="${not isTrash}">
                            <th style="width: 80px;">Sắp xếp</th>
                        </c:if>
                        <th style="width: 70px;">ID</th>
                        <th>Loại</th>
                        <th>Preview</th>
                        <th>Lập lịch hiển thị</th>
                        <th style="width: 100px;">Thứ tự</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="banner" items="${banners}">
                        <tr data-id="${banner.id}">
                            <c:if test="${not isTrash}">
                                <td>
                                    <i class="bi bi-grip-vertical drag-handle text-muted fs-4" title="Kéo thả để sắp xếp"></i>
                                </td>
                            </c:if>
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
                            <td class="text-start fs-7">
                                <div><b>Bắt đầu:</b> 
                                    <c:choose>
                                        <c:when test="${not empty banner.startDate}">
                                            <fmt:formatDate value="${banner.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </c:when>
                                        <c:otherwise><span class="text-muted">Không giới hạn</span></c:otherwise>
                                    </c:choose>
                                </div>
                                <div><b>Kết thúc:</b> 
                                    <c:choose>
                                        <c:when test="${not empty banner.endDate}">
                                            <fmt:formatDate value="${banner.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </c:when>
                                        <c:otherwise><span class="text-muted">Không giới hạn</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                            <td>${banner.orderIndex}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${banner.isDeleted == 1}">
                                        <span class="badge bg-danger">Đã xóa tạm</span>
                                    </c:when>
                                    <c:when test="${banner.status == 'active'}">
                                        <span class="badge bg-success">Hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Tạm ẩn</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${isTrash}">
                                        <button type="button" class="btn btn-success btn-sm me-1"
                                                data-id="${banner.id}" onclick="confirmRestore(this)" title="Khôi phục banner">
                                            <i class="bi bi-arrow-counterclockwise"></i> Khôi phục
                                        </button>
                                        <button type="button" class="btn btn-danger btn-sm"
                                                data-id="${banner.id}" onclick="confirmHardDelete(this)" title="Xóa vĩnh viễn">
                                            <i class="bi bi-trash3-fill"></i> Xóa vĩnh viễn
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="btn btn-warning btn-sm me-1"
                                                data-id="${banner.id}" data-type="${banner.type}"
                                                data-image="${fn:escapeXml(banner.imageUrl)}"
                                                data-video="${fn:escapeXml(banner.videoUrl)}"
                                                data-link="${fn:escapeXml(banner.link)}"
                                                data-order="${banner.orderIndex}"
                                                data-status="${banner.status}"
                                                data-start="${not empty banner.startDate ? banner.startDate.toString().substring(0, 16).replace(' ', 'T') : ''}"
                                                data-end="${not empty banner.endDate ? banner.endDate.toString().substring(0, 16).replace(' ', 'T') : ''}"
                                                onclick="openEditModal(this)">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button type="button" class="btn btn-danger btn-sm me-1"
                                                data-id="${banner.id}" onclick="confirmDelete(this)" title="Xóa tạm vào Thùng rác">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                        <button type="button"
                                                class="btn btn-sm me-1 ${banner.status == 'active' ? 'btn-success' : 'btn-secondary'}"
                                                data-id="${banner.id}"
                                                data-status="${banner.status}"
                                                title="${banner.status == 'active' ? 'Đang hoạt động - nhấn để tắt' : 'Đang tạm ẩn - nhấn để bật'}"
                                                onclick="toggleStatus(this)">
                                            <i class="bi ${banner.status == 'active' ? 'bi-toggle-on' : 'bi-toggle-off'}"></i>
                                        </button>
                                        <button type="button" class="btn btn-info btn-sm"
                                                data-id="${banner.id}" data-type="${banner.type}"
                                                data-image="${fn:escapeXml(banner.imageUrl)}"
                                                data-video="${fn:escapeXml(banner.videoUrl)}"
                                                data-link="${fn:escapeXml(banner.link)}"
                                                data-order="${banner.orderIndex}"
                                                data-status="${banner.status}"
                                                data-start="${not empty banner.startDate ? banner.startDate.toString().substring(0, 16).replace(' ', 'T') : ''}"
                                                data-end="${not empty banner.endDate ? banner.endDate.toString().substring(0, 16).replace(' ', 'T') : ''}"
                                                onclick="openViewModal(this)">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </c:otherwise>
                                </c:choose>
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
            <form id="add-banner-form"
                  action="${pageContext.request.contextPath}/admin/banner-manage" method="post">
                <input type="hidden" name="_csrf" value="${sessionScope.CSRF_TOKEN}">
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
                        <div class="img-preview-wrap">
                            <img id="add-img-thumb" class="img-preview-thumb" alt="Preview">
                            <div id="add-img-err" class="img-preview-err">
                                <i class="bi bi-image-slash" style="font-size:20px;"></i>
                                <span>URL lỗi</span>
                            </div>
                            <input type="text" name="image" class="form-control"
                                   placeholder="https://..." id="add-image-input">
                        </div>
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
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Ngày/Giờ bắt đầu hiển thị</label>
                            <input type="datetime-local" name="startDate" class="form-control">
                            <small class="text-muted">Để trống nếu muốn hiển thị ngay lập tức.</small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ngày/Giờ kết thúc hiển thị</label>
                            <input type="datetime-local" name="endDate" class="form-control">
                            <small class="text-muted">Để trống nếu không muốn tự động ẩn.</small>
                        </div>
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
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy
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
                <input type="hidden" name="_csrf" value="${sessionScope.CSRF_TOKEN}">
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
                        <div class="img-preview-wrap">
                            <img id="edit-img-thumb" class="img-preview-thumb" alt="Preview">
                            <div id="edit-img-err" class="img-preview-err">
                                <i class="bi bi-image-slash" style="font-size:20px;"></i>
                                <span>URL lỗi</span>
                            </div>
                            <input type="text" name="image" id="edit-image" class="form-control">
                        </div>
                    </div>
                    <div class="mb-3 d-none" id="edit-video-group">
                        <label class="form-label">Link video</label>
                        <input type="text" name="video" id="edit-video" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Link điều hướng</label>
                        <input type="text" name="link" id="edit-link" class="form-control">
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Ngày/Giờ bắt đầu hiển thị</label>
                            <input type="datetime-local" name="startDate" id="edit-start-date" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ngày/Giờ kết thúc hiển thị</label>
                            <input type="datetime-local" name="endDate" id="edit-end-date" class="form-control">
                        </div>
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
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy
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
                        <th>Lập lịch hiển thị</th>
                        <td id="view-schedule"></td>
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
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng
                </button>
            </div>
        </div>
    </div>
</div>
<div class="hover-preview-popup" id="hoverPreview">
    <img id="hoverPreviewImg" src="" alt="Preview">
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
    const baseUrl = "${pageContext.request.contextPath}";
    const CSRF_TOKEN = "${sessionScope.CSRF_TOKEN}";
    const isTrash = ${isTrash};
    let bannerTable;
    let sortable;
    $(document).ready(function () {
        bannerTable = $('#tableBanner').DataTable({
            pageLength: 5,
            columnDefs: [{
                targets: isTrash ? [2] : [0, 3, 7], 
                orderable: false
            }],
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
        $('#rowsPerPage').on('change', function () {
            bannerTable.page.len(parseInt($(this).val())).draw();
            updatePageInfo();
        });
        $('#filterType').on('change', function () {
            bannerTable.column(isTrash ? 1 : 2).search(this.value).draw();
            updatePageInfo();
        });
        if (!isTrash) {
            $('#filterStatus').on('change', function () {
                bannerTable.column(6).search(this.value).draw();
                updatePageInfo();
            });
        }
        bannerTable.on('draw', updatePageInfo);
        updatePageInfo();
        if (!isTrash) {
            enableDragSort();
        }
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
                title: 'Đã xóa tạm!',
                text: 'Banner đã được chuyển vào Thùng rác.',
                timer: 2000,
                showConfirmButton: false
            });
        } else if (msg === 'restored') {
            Swal.fire({
                icon: 'success',
                title: 'Đã khôi phục!',
                text: 'Banner đã được khôi phục về danh sách hoạt động.',
                timer: 2000,
                showConfirmButton: false
            });
        } else if (msg === 'hard_deleted') {
            Swal.fire({
                icon: 'success',
                title: 'Đã xóa vĩnh viễn!',
                text: 'Banner đã bị xóa hoàn toàn khỏi cơ sở dữ liệu.',
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
        } else if (error === 'restore_failed') {
            Swal.fire({
                icon: 'error',
                title: 'Thất bại!',
                text: 'Không thể khôi phục banner. Vui lòng thử lại.',
            });
        }
    });

    function updatePageInfo() {
        const info = bannerTable.page.info();
        $('#pageInfo').text((info.page + 1) + ' / ' + info.pages);
    }

    function enableDragSort() {
        bannerTable.page.len(-1).draw();
        if (sortable) return;
        sortable = new Sortable(document.querySelector("#tableBanner tbody"), {
            animation: 150,
            handle: ".drag-handle",
            ghostClass: "table-warning",
            onEnd: function () {
                let order = [];
                $("#tableBanner tbody tr").each(function (index) {
                    order.push({
                        id: $(this).data("id"),
                        orderIndex: index + 1
                    });
                });
                saveSortOrder(order);
            }
        });
    }
    function saveSortOrder(order) {
        $.ajax({
            url: baseUrl + "/admin/banner-sort",
            method: "POST",
            contentType: "application/json",
            headers: {
                "X-CSRF-Token": CSRF_TOKEN
            },
            data: JSON.stringify(order),
            success: function () {
                const Toast = Swal.mixin({
                    toast: true,
                    position: 'top-end',
                    showConfirmButton: false,
                    timer: 1500,
                    timerProgressBar: true
                });
                Toast.fire({
                    icon: 'success',
                    title: 'Đã lưu thứ tự hiển thị banner mới!'
                });
            },
            error: function () {
                Swal.fire("Lỗi", "Không thể lưu thứ tự sắp xếp banner", "error");
            }
        });
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
        document.getElementById('edit-start-date').value = btn.dataset.start || '';
        document.getElementById('edit-end-date').value = btn.dataset.end || '';
        toggleMediaInput('edit');
        const editImg = document.getElementById('edit-image');
        if (editImg._triggerPreview) editImg._triggerPreview();
        new bootstrap.Modal(document.getElementById('editBannerModal')).show();
    }

    function confirmDelete(btn) {
        const id = btn.dataset.id;
        Swal.fire({
            title: 'Chuyển vào Thùng rác?',
            text: "Banner sẽ tạm ẩn khỏi giao diện khách hàng nhưng vẫn có thể khôi phục lại từ Thùng rác.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#ffc107',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Đồng ý, xóa tạm!',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                submitPostAction('delete', id);
            }
        })
    }
    function confirmRestore(btn) {
        const id = btn.dataset.id;
        Swal.fire({
            title: 'Khôi phục banner này?',
            text: "Banner sẽ được đưa trở lại danh sách hoạt động chính.",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#198754',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Khôi phục ngay!',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                submitPostAction('restore', id);
            }
        })
    }
    function confirmHardDelete(btn) {
        const id = btn.dataset.id;
        Swal.fire({
            title: 'Xóa vĩnh viễn?',
            text: "Hành động này sẽ xóa hoàn toàn banner khỏi CSDL và KHÔNG THỂ khôi phục lại!",
            icon: 'error',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Xóa vĩnh viễn!',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                submitPostAction('hard-delete', id);
            }
        })
    }
    function submitPostAction(action, id) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = baseUrl + '/admin/banner-manage';
        const csrfInput = document.createElement('input');
        csrfInput.type = 'hidden';
        csrfInput.name = '_csrf';
        csrfInput.value = CSRF_TOKEN;
        form.appendChild(csrfInput);
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = action;
        form.appendChild(actionInput);
        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'id';
        idInput.value = id;
        form.appendChild(idInput);
        document.body.appendChild(form);
        form.submit();
    }
    function openViewModal(btn) {
        document.getElementById('view-id').innerText = btn.dataset.id;
        document.getElementById('view-type').innerText = btn.dataset.type === 'image' ? 'Hình Ảnh' : 'Video';
        document.getElementById('view-link').innerText = btn.dataset.link || '---';
        document.getElementById('view-order').innerText = btn.dataset.order;
        document.getElementById('view-status').innerText = btn.dataset.status === 'active' ? 'Hoạt động' : 'Tạm ẩn';
        const start = btn.dataset.start ? btn.dataset.start.replace('T', ' ') : 'Không giới hạn';
        const end = btn.dataset.end ? btn.dataset.end.replace('T', ' ') : 'Không giới hạn';
        document.getElementById('view-schedule').innerHTML = '<div><b>Bắt đầu:</b> ' + start + '</div><div><b>Kết thúc:</b> ' + end + '</div>';
        const mediaContainer = document.getElementById('view-media-container');
        if (btn.dataset.type === 'image') {
            mediaContainer.innerHTML = '<img src="' + btn.dataset.image + '" style="max-width: 100%; border-radius: 6px;">';
        } else {
            mediaContainer.innerHTML = '<video src="' + btn.dataset.video + '" controls style="max-width: 100%; border-radius: 6px;"></video>';
        }
        let modal = new bootstrap.Modal(document.getElementById('viewBannerModal'));
        modal.show();
    }

    document.addEventListener("DOMContentLoaded", () => {
        const logoutBtn = document.getElementById("logoutBtn");
        const logoutModal = document.getElementById("logoutModal");
        const cancelLogout = document.getElementById("cancelLogout");
        if (logoutBtn && logoutModal && cancelLogout) {
            logoutBtn.addEventListener("click", () => logoutModal.style.display = "flex");
            cancelLogout.addEventListener("click", () => logoutModal.style.display = "none");
        }
        const addBannerForm = document.getElementById("add-banner-form");
        if (addBannerForm) {
            addBannerForm.addEventListener("submit", function (e) {
                const type = document.getElementById("add-type").value;
                const image = document.getElementById("add-image-input").value.trim();
                const video = document.getElementById("add-video-input").value.trim();
                const link = addBannerForm.querySelector("input[name='link']").value.trim();
                if (type === "image" && !image) {
                    e.preventDefault();
                    Swal.fire("Lỗi", "Vui lòng nhập link ảnh banner", "error");
                    return;
                }
                if (type === "video" && !video) {
                    e.preventDefault();
                    Swal.fire("Lỗi", "Vui lòng nhập link video banner", "error");
                    return;
                }
                if (!link) {
                    e.preventDefault();
                    Swal.fire("Lỗi", "Vui lòng nhập link điều hướng", "error");
                    return;
                }
            });
        }
    });

    setTimeout(() => {
        const alert = document.getElementById("alertMsg");
        if (alert) {
            alert.classList.add("fade");
            alert.style.opacity = "0";
            setTimeout(() => alert.remove(), 500);
        }
    }, 3000);

    function bindImgPreview(inputId, thumbId, errId) {
        const input = document.getElementById(inputId);
        const thumb = document.getElementById(thumbId);
        const errBox = document.getElementById(errId);
        if (!input || !thumb || !errBox) return;

        function update() {
            const url = input.value.trim();
            if (!url) {
                thumb.classList.remove('show');
                errBox.classList.remove('show');
                return;
            }
            thumb.onload = () => { thumb.classList.add('show'); errBox.classList.remove('show'); };
            thumb.onerror = () => { thumb.classList.remove('show'); errBox.classList.add('show'); };
            thumb.src = url;
        }

        input.addEventListener('input', update);
        input._triggerPreview = update;
    }

    bindImgPreview('add-image-input', 'add-img-thumb', 'add-img-err');
    bindImgPreview('edit-image', 'edit-img-thumb', 'edit-img-err');

    document.getElementById('addBannerModal').addEventListener('hidden.bs.modal', function () {
        const thumb = document.getElementById('add-img-thumb');
        const errBox = document.getElementById('add-img-err');
        document.getElementById('add-image-input').value = '';
        thumb.src = '';
        thumb.classList.remove('show');
        errBox.classList.remove('show');
    });
    function toggleStatus(btn) {
        const id = btn.dataset.id;
        const currentStatus = btn.dataset.status;

        fetch(baseUrl + '/admin/banner-manage', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-CSRF-Token': CSRF_TOKEN
            },
            body: 'action=toggle&id=' + id + '&status=' + currentStatus
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    const isActive = data.newStatus === 'active';

                    btn.dataset.status = data.newStatus;
                    btn.className = 'btn btn-sm me-1 ' + (isActive ? 'btn-success' : 'btn-secondary');
                    btn.querySelector('i').className = isActive ? 'bi bi-toggle-on' : 'bi bi-toggle-off';
                    btn.title = isActive ? 'Đang hoạt động - nhấn để tắt' : 'Đang tạm ẩn - nhấn để bật';

                    const statusCell = btn.closest('tr').querySelector('td:nth-child(7)'); // Cập nhật cột trạng thái (cột 7 do có cột Di chuyển)
                    statusCell.innerHTML = isActive
                        ? '<span class="badge bg-success">Hoạt động</span>'
                        : '<span class="badge bg-secondary">Tạm ẩn</span>';

                    Swal.fire({
                        icon: 'success',
                        title: isActive ? 'Đã bật!' : 'Đã tắt!',
                        text: isActive ? 'Banner đang hoạt động.' : 'Banner đã tạm ẩn.',
                        timer: 1500,
                        showConfirmButton: false
                    });
                } else {
                    Swal.fire('Lỗi!', 'Không thể cập nhật trạng thái.', 'error');
                }
            })
            .catch(() => {
                Swal.fire('Lỗi!', 'Mất kết nối đến server.', 'error');
            });
    }
</script>
</body>
</html>