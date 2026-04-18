<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Trang Quản Trị - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/product-manage.css">
    <link rel="stylesheet" href="https://cdn.ckeditor.com/ckeditor5/47.2.0/ckeditor5.css" crossorigin>
    <link rel="stylesheet"
          href="https://cdn.ckeditor.com/ckeditor5-premium-features/47.2.0/ckeditor5-premium-features.css"
          crossorigin>
    <style>
        .ck-editor__editable {
            min-height: 250px;
        }

        .ck.ck-editor__main > .ck-editor__editable {
            background: #fff;
        }

        .ck.ck-balloon-panel {
            z-index: 10055 !important;
        }

        .ck.ck-modal__overlay {
            z-index: 10060 !important;
        }

        .ck-body-wrapper {
            z-index: 10065 !important;
        }

        .modal {
            --bs-modal-zindex: 1055;
        }

        .modal-backdrop {
            z-index: 1054;
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
                <li class="active"><i class="bi bi-box-seam"></i> Quản Lý Sản Phẩm</li>
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
            <h4 class="text-primary fw-bold"><i class="bi bi-box-seam"></i> Quản Lý Sản Phẩm</h4>
            <div class="d-flex align-items-center gap-2">
                <form class="d-flex" role="search" style="max-width: 300px;">
                    <div class="input-group">
                                        <span class="input-group-text bg-primary text-white">
                                            <i class="bi bi-search"></i>
                                        </span>
                        <input id="searchInput" type="search" class="form-control"
                               placeholder="Tìm kiếm sản phẩm..." aria-label="Tìm kiếm">
                    </div>
                </form>
                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalSanPham">
                    <i class="bi bi-plus-lg"></i> Thêm Sản Phẩm
                </button>
            </div>
        </div>
        <div class="d-flex justify-content-start align-items-center mb-2">
            <label class="me-2">Hiển thị</label>
            <select id="rowsPerPage" class="form-select d-inline-block" style="width:80px;">
                <option value="5">5</option>
                <option value="10" selected>10</option>
                <option value="20">20</option>
            </select>
            <label class="ms-2">sản phẩm</label>
        </div>
        <table id="tableSanPham" class="table table-striped table-bordered">
            <thead class="table-primary">
            <tr>
                <th>Mã SP</th>
                <th>Tên SP</th>
                <th>Danh Mục</th>
                <th>Ảnh</th>
                <th>Giá Gốc</th>
                <th>Giá KM</th>
                <th>Trạng Thái</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${products}">
                <tr>
                    <td>${p.id}</td>
                    <td>${p.productName}</td>
                    <td>${p.categoryName}</td>
                    <td>
                        <img src="${p.mainImage}" class="img-thumbnail"
                             style="width:60px;height:60px;object-fit:cover;" alt="${p.productName}">
                    </td>
                    <td>
                        <fmt:formatNumber value="${p.price}" pattern="#,##0 VNĐ"/>
                    </td>
                    <td>
                        <fmt:formatNumber value="${p.finalPrice}" pattern="#,##0 VNĐ"/>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${p.status == 'active'}">
                                <span class="badge bg-success">Đang KD</span>
                            </c:when>
                            <c:when test="${p.status == 'inactive'}">
                                <span class="badge bg-secondary">Ẩn</span>
                            </c:when>
                            <c:when test="${p.status == 'soldout'}">
                                <span class="badge bg-warning text-dark">Hết hàng</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-dark">Không xác định</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td style="width:160px; text-align:center;">
                        <button class="btn btn-warning btn-sm btn-edit" data-id="${p.id}">
                            <i class="bi bi-pencil"></i>
                        </button>
                        <button class="btn btn-danger btn-sm btn-delete" data-id="${p.id}">
                            <i class="bi bi-trash"></i>
                        </button>
                        <button class="btn btn-secondary btn-sm btn-toggle" data-id="${p.id}">
                            <i class="bi ${p.status == 'active' ? 'bi-eye-slash' : 'bi-eye'}"></i>
                        </button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty products}">
                <tr>
                    <td colspan="8" class="text-center text-muted">
                        Chưa có sản phẩm
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <div class="d-flex justify-content-end align-items-center mt-3">
            <div class="pagination-controls">
                <button id="prevPage" class="btn btn-outline-primary btn-sm">Trước</button>
                <span id="pageInfo" class="mx-2">1 / 1</span>
                <button id="nextPage" class="btn btn-outline-primary btn-sm">Sau</button>
            </div>
        </div>
    </main>
</div>
<div class="modal fade" id="modalSanPham" tabindex="-1" data-bs-focus="false">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="bi bi-pencil-square"></i> Cập Nhật Thông Tin Sản Phẩm
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="formSanPham" class="row g-3">
                    <input type="hidden" id="productId">
                    <input type="hidden" id="formMode" value="add"> <!-- add | edit -->
                    <div class="col-md-6">
                        <label class="form-label">Mã sản phẩm</label>
                        <input type="text" class="form-control" id="maSP" placeholder="Mã tự động"
                               disabled>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Tên sản phẩm</label>
                        <input type="text" class="form-control" id="tenSP"
                               placeholder="Nhập tên sản phẩm">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Danh mục</label>
                        <select class="form-select" id="danhMuc">
                            <option value="1001">Drone quay phim chuyên nghiệp</option>
                            <option value="1006">Drone du lịch / vlog</option>
                            <option value="1003">Drone thể thao tốc độ cao</option>
                            <option value="1002">Drone nông nghiệp</option>
                            <option value="1005">Drone giám sát / an ninh</option>
                            <option value="1004">Drone mini / cỡ nhỏ</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Thương hiệu</label>
                        <input type="text" class="form-control" id="thuongHieu"
                               placeholder="VD: DJI, Autel, Xiaomi...">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Trạng thái</label>
                        <select class="form-select" id="trangThai">
                            <option>Đang Kinh Doanh</option>
                            <option>Ẩn</option>
                            <option>Hết Hàng</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Giá gốc</label>
                        <input type="number" class="form-control" id="giaGoc"
                               placeholder="Nhập giá gốc" min="1">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Giá khuyến mãi</label>
                        <input type="number" class="form-control" id="giaKM"
                               placeholder="Nhập giá khuyến mãi (nếu có)" min="1">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Số lượng</label>
                        <input type="number" class="form-control" id="soLuong"
                               placeholder="Nhập số lượng" min="1">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Đánh giá trung bình</label>
                        <input type="text" class="form-control" id="danhGia" value="Tự động tính"
                               disabled>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Bảo hành</label>
                        <input type="text" class="form-control" id="baoHanh"
                               placeholder="Nhập thời gian bảo hành, ví dụ: 12 tháng">
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-semibold">
                            Ảnh chính <small class="text-muted">(URL)</small>
                        </label>
                        <div class="d-flex align-items-center gap-3">
                            <div id="previewAnhChinh" style="
                                    width: 80px; height: 80px; min-width: 80px;
                                    border: 1px dashed #ccc; border-radius: 8px;
                                    display: flex; align-items: center; justify-content: center;
                                    overflow: hidden; background: #f8f9fa;">
                                <i class="bi bi-image text-muted fs-4"></i>
                            </div>
                            <div class="input-group flex-grow-1">
                                <span class="input-group-text"><i class="bi bi-image"></i></span>
                                <input type="url" class="form-control" id="anhChinh"
                                       placeholder="https://example.com/image-main.jpg">
                            </div>
                        </div>
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-semibold">
                            Ảnh phụ
                            <small class="text-muted">(có thể thêm nhiều)</small>
                        </label>
                        <div id="imageExtraContainer">
                            <div class="input-group mb-2 image-row">
                                                <span class="input-group-text">
                                                    <i class="bi bi-images"></i>
                                                </span>
                                <input type="url" class="form-control image-extra"
                                       placeholder="https://example.com/image-1.jpg">
                                <button type="button" class="btn btn-outline-success btn-add-image"
                                        title="Thêm ảnh">
                                    <i class="bi bi-plus-lg"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Mô tả chi tiết</label>
                        <textarea class="form-control" id="moTa" rows="3"
                                  placeholder="Giới thiệu, ưu điểm, công nghệ..."></textarea>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Thông số kỹ thuật</label>
                        <textarea class="form-control" id="thongSo" rows="3"
                                  placeholder="Nhập thông số kỹ thuật..."></textarea>
                    </div>
                    <div class="modal-footer col-12">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            Hủy
                        </button>
                        <button type="button" class="btn btn-primary" id="btnSaveProduct">
                            Lưu Thay Đổi
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    var table = $('#tableSanPham').DataTable({
        "paging": true,
        "lengthChange": false,
        "pageLength": 10,
        "ordering": true,
        "searching": true,
        "info": false,
        "dom": 't',
        "columnDefs": [
            {"orderable": false, "targets": [3, 7]}
        ], "language": {
            "zeroRecords": "Không tìm thấy dữ liệu"
        }
    });
    $('#searchInput').on('keyup', function () {
        table.search(this.value).draw();
    });
    $('#rowsPerPage').on('change', function () {
        table.page.len(parseInt($(this).val())).draw();
        updatePageInfo();
    });
    $("#logoutBtn").on("click", function () {
        $("#logoutModal").css("display", "flex");
    });
    $("#cancelLogout").on("click", function () {
        $("#logoutModal").hide();
    });
    $('#prevPage').on('click', function () {
        table.page('previous').draw('page');
        updatePageInfo();
    });
    $('#nextPage').on('click', function () {
        table.page('next').draw('page');
        updatePageInfo();
    });

    function updatePageInfo() {
        var info = table.page.info();
        $('#pageInfo').text((info.page + 1) + ' / ' + info.pages);
    }
    function showToast(message, type = 'success') {
        const toast = document.getElementById('toastNotify');
        const msg   = document.getElementById('toastMsg');

        toast.className = 'toast-notify ' + type;
        msg.textContent = message;

        const bar = toast.querySelector('.toast-bar');
        bar.style.animation = 'none';
        bar.offsetHeight;
        bar.style.animation = '';

        toast.classList.add('show');
        clearTimeout(toast._timer);
        toast._timer = setTimeout(() => {
            toast.classList.remove('show');
        }, 3000);
    }
    function validateProductForm() {
        const ten    = $('#tenSP').val().trim();
        const gia    = parseFloat($('#giaGoc').val());
        const giaKM  = $('#giaKM').val();
        const soLuong = $('#soLuong').val().trim();
        const thuongHieu = $('#thuongHieu').val().trim();
        const baoHanh = $('#baoHanh').val().trim();
        const anhChinh = $('#anhChinh').val().trim();
        const moTa   = window.descriptionEditor
            ? window.descriptionEditor.getData().trim()
            : $('#moTa').val().trim();
        const thongSo = window.parameterEditor
            ? window.parameterEditor.getData().trim()
            : $('#thongSo').val().trim();

        if (!ten) {
            showToast('Vui lòng nhập tên sản phẩm!', 'warning'); return false;
        }
        if (!thuongHieu) {
            showToast('Vui lòng nhập thương hiệu!', 'warning'); return false;
        }
        const soLuongNum = Number(soLuong);
        const giaNum = Number(gia);

        if (!Number.isInteger(soLuongNum) || soLuongNum <= 0) {
            showToast('Số lượng phải là số nguyên > 0!', 'warning');
            return false;
        }

        if (isNaN(giaNum) || giaNum <= 0) {
            showToast('Giá gốc phải > 0!', 'warning');
            return false;
        }
        if (giaKM !== '' && (isNaN(parseFloat(giaKM)) || parseFloat(giaKM) <= 0)) {
            showToast('Giá khuyến mãi phải lớn hơn 0!', 'warning');
            return false;
        }
        if (!baoHanh) {
            showToast('Vui lòng nhập thông tin bảo hành!', 'warning'); return false;
        }
        if (!anhChinh) {
            showToast('Vui lòng nhập URL ảnh chính!', 'warning'); return false;
        }
        return true;
    }

    updatePageInfo();
    $(document).on('click', '.btn-toggle', function () {
        const row = $(this).closest('tr');
        const statusCell = row.find('td:eq(6)');
        const productId = $(this).data('id');
        let newStatus;
        if (statusCell.text().trim() === "Đang KD") {
            newStatus = "inactive";
        } else {
            newStatus = "active";
        }
        fetch(contextPath + '/admin/product-toggle-status', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({id: productId, status: newStatus})
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    if (newStatus === "inactive") {
                        statusCell.html('<span class="badge bg-secondary">Ẩn</span>');
                        $(this).find('i').removeClass('bi-eye-slash').addClass('bi-eye');
                    } else {
                        statusCell.html('<span class="badge bg-success">Đang KD</span>');
                        $(this).find('i').removeClass('bi-eye').addClass('bi-eye-slash');
                    }
                } else {
                    Swal.fire({
                        title: "Lỗi!",
                        text: data.message,
                        icon: "error",
                        confirmButtonColor: "#0d6efd"
                    });
                }
            });
    });
    $(document).on('click', '.btn-delete', function (e) {
        e.preventDefault();
        let row = $(this).closest('tr');
        let productId = $(this).data('id');
        Swal.fire({
            title: "Bạn chắc chắn muốn xóa?",
            text: "Hành động này không thể hoàn tác!",
            icon: "warning",
            showCancelButton: true,
            confirmButtonText: "Xóa",
            cancelButtonText: "Hủy",
            confirmButtonColor: "#dc3545",
            cancelButtonColor: "#6c757d"
        }).then((result) => {
            if (result.isConfirmed) {
                fetch(contextPath + '/admin/product-delete?id=' + productId, {
                    method: 'POST'
                })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            table.row(row).remove().draw();
                            updatePageInfo();
                            Swal.fire({
                                title: "Đã xóa!",
                                text: "Sản phẩm đã được xóa.",
                                icon: "success",
                                confirmButtonColor: "#0d6efd"
                            });
                        } else {
                            Swal.fire({
                                title: "Lỗi!",
                                text: data.message,
                                icon: "error",
                                confirmButtonColor: "#0d6efd"
                            });
                        }
                    });
            }
        });
    });
    $(document).on('click', '.btn-edit', function () {
        const productId = $(this).data('id');
        $('#productId').val(productId);
        $('#formMode').val('edit');
        fetch(contextPath + '/admin/product-get?id=' + productId)
            .then(res => res.json())
            .then(product => {
                $('#tenSP').val(product.productName);
                $('#danhMuc').val(product.categoryId);
                $('#thuongHieu').val(product.brandName);
                $('#giaGoc').val(product.price);
                $('#giaKM').val(product.finalPrice);
                $('#soLuong').val(product.quantity);
                $('#trangThai').val(product.status === 'active' ? 'Đang Kinh Doanh' :
                    product.status === 'inactive' ? 'Ẩn' : 'Hết Hàng');
                $('#baoHanh').val(product.warranty);
                $('#moTa').val(product.description);
                $('#thongSo').val(product.parameter);
                $('#anhChinh').val(product.mainImage);
                const prevBox = document.getElementById('previewAnhChinh');
                if (product.mainImage) {
                    prevBox.innerHTML = `<img src="${product.mainImage}" style="width:100%;height:100%;object-fit:cover;border-radius:8px;">`;
                } else {
                    prevBox.innerHTML = `<i class="bi bi-image text-muted fs-4"></i>`;
                }
                $('#imageExtraContainer').empty();
                if (product.images && product.images.length > 0) {
                    product.images.forEach(img => {
                        $('#imageExtraContainer').append(createImageRow(img.imageUrl));
                    });
                } else {
                    $('#imageExtraContainer').append(createImageRow(''));
                }
                $('#modalSanPham .modal-title').html('<i class="bi bi-pencil"></i> Chỉnh sửa sản phẩm');
                if (window.descriptionEditor) {
                    window.descriptionEditor.setData(product.description || '');
                }
                if (window.parameterEditor) {
                    window.parameterEditor.setData(product.parameter || '');
                }
                const modalSanPham = new bootstrap.Modal(document.getElementById('modalSanPham'));
                modalSanPham.show();
            });
    });
</script>
<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>
<script>
    function updatePreview(url, previewEl) {
        if (!url) {
            previewEl.innerHTML = `<i class="bi bi-image text-muted" style="font-size:18px;"></i>`;
            return;
        }
        previewEl.innerHTML = `<i class="bi bi-hourglass-split text-muted" style="font-size:18px;"></i>`;
        const img = new Image();
        const timeout = setTimeout(() => {
            previewEl.innerHTML = `<i class="bi bi-wifi-off text-warning" style="font-size:18px;"></i>`;
        }, 5000);
        img.onload = function () {
            clearTimeout(timeout);
            previewEl.innerHTML = '';
            img.style.cssText = 'width:100%;height:100%;object-fit:cover;border-radius:6px;';
            previewEl.appendChild(img);
        };
        img.onerror = function () {
            clearTimeout(timeout);
            previewEl.innerHTML = `<i class="bi bi-exclamation-triangle text-danger" style="font-size:18px;"></i>`;
        };
        img.src = url;
    }

    function createImageRow(url = '') {
        const row = document.createElement("div");
        row.className = "image-row mb-2";
        row.style.cssText = "display:flex; align-items:center; gap:8px;";
        row.innerHTML = `
        <div class="img-preview-small" style="
            width:55px; height:55px; min-width:55px;
            border:1px dashed #ccc; border-radius:6px;
            display:flex; align-items:center; justify-content:center;
            overflow:hidden; background:#f8f9fa;">
            <i class="bi bi-image text-muted" style="font-size:18px;"></i>
        </div>
       <div class="input-group flex-grow-1">
            <span class="input-group-text"><i class="bi bi-images"></i></span>
            <input type="url" class="form-control image-extra"
                   placeholder="https://example.com/image-x.jpg"
                   value="${url}">
            <button type="button" class="btn btn-outline-success btn-add-image" title="Thêm ảnh">
                <i class="bi bi-plus-lg"></i>
            </button>
            <button type="button" class="btn btn-outline-danger btn-remove-image" title="Xóa ảnh">
                <i class="bi bi-dash-lg"></i>
            </button>
        </div>
    `;
        const input = row.querySelector('.image-extra');
        const preview = row.querySelector('.img-preview-small');
        input.addEventListener('input', function () {
            updatePreview(this.value.trim(), preview);
        });
        if (url) updatePreview(url, preview);
        return row;
    }

    document.addEventListener("DOMContentLoaded", function () {
        const container = document.getElementById("imageExtraContainer");
        container.innerHTML = '';
        container.appendChild(createImageRow(''));

        document.addEventListener("click", function (e) {
            if (e.target.closest(".btn-add-image")) {
                document.getElementById("imageExtraContainer").appendChild(createImageRow(''));
            }
            if (e.target.closest(".btn-remove-image")) {
                e.target.closest(".image-row").remove();
            }
        });
    });
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
</script>
<script src="${pageContext.request.contextPath}/js/admin/product-management.js"></script>
<script src="https://cdn.ckeditor.com/ckeditor5/47.2.0/ckeditor5.umd.js" crossorigin></script>
<script
        src="https://cdn.ckeditor.com/ckeditor5-premium-features/47.2.0/ckeditor5-premium-features.umd.js"
        crossorigin></script>
<div id="toastNotify" class="toast-notify">
    <span class="toast-icon" id="toastIcon"></span>
    <span id="toastMsg"></span>
    <div class="toast-bar"></div>
</div>
<script>
    const {
        ClassicEditor,
        Essentials,
        Paragraph,
        Alignment,
        AutoImage,
        Autoformat,
        AutoLink,
        ImageBlock,
        BlockQuote,
        Bold,
        Code,
        CodeBlock,
        FontBackgroundColor,
        FontColor,
        FontFamily,
        FontSize,
        Heading,
        Highlight,
        HorizontalLine,
        ImageCaption,
        ImageInsert,
        ImageInsertViaUrl,
        ImageResize,
        ImageStyle,
        ImageTextAlternative,
        ImageToolbar,
        ImageUpload,
        Indent,
        IndentBlock,
        Italic,
        Link,
        LinkImage,
        List,
        ListProperties,
        MediaEmbed,
        RemoveFormat,
        SpecialCharacters,
        SpecialCharactersArrows,
        SpecialCharactersCurrency,
        SpecialCharactersEssentials,
        SpecialCharactersLatin,
        SpecialCharactersMathematical,
        SpecialCharactersText,
        Strikethrough,
        Subscript,
        Superscript,
        Table,
        TableCaption,
        TableCellProperties,
        TableColumnResize,
        TableProperties,
        TableToolbar,
        Underline,
        Base64UploadAdapter
    } = window.CKEDITOR;
    const LICENSE_KEY = 'eyJhbGciOiJFUzI1NiJ9.eyJleHAiOjE3Nzc3NjYzOTksImp0aSI6IjZjNDQyM2I1LWE5MTYtNDcyOC05NjAyLWRkMTkwM2RhZjQ4MSIsInVzYWdlRW5kcG9pbnQiOiJodHRwczovL3Byb3h5LWV2ZW50LmNrZWRpdG9yLmNvbSIsImRpc3RyaWJ1dGlvbkNoYW5uZWwiOlsiY2xvdWQiLCJkcnVwYWwiLCJzaCJdLCJ3aGl0ZUxhYmVsIjp0cnVlLCJsaWNlbnNlVHlwZSI6InRyaWFsIiwiZmVhdHVyZXMiOlsiKiJdLCJ2YyI6IjVlNzljMTExIn0.QeBKswpbgvJ6NHs0Ng3FO3qFW2P-ZUM6qUOwk52x2JjriNGnpV5YhiekUWCDN2GPtT3Ws0oOdOo0i9NeHMhYAw';
    const editorConfig = {
        licenseKey: LICENSE_KEY,
        toolbar: {
            items: [
                'undo', 'redo',
                '|',
                'heading',
                '|',
                'fontSize', 'fontFamily', 'fontColor', 'fontBackgroundColor',
                '|',
                'bold', 'italic', 'underline', 'strikethrough', 'subscript', 'superscript', 'code', 'removeFormat',
                '|',
                'specialCharacters', 'horizontalLine', 'link', 'insertImage', 'insertImageViaUrl', 'mediaEmbed', 'insertTable',
                'highlight', 'blockQuote', 'codeBlock',
                '|',
                'alignment',
                '|',
                'bulletedList', 'numberedList', 'outdent', 'indent'
            ],
            shouldNotGroupWhenFull: true
        },
        plugins: [
            Alignment,
            Autoformat,
            AutoImage,
            AutoLink,
            Base64UploadAdapter,
            BlockQuote,
            Bold,
            Code,
            CodeBlock,
            Essentials,
            FontBackgroundColor,
            FontColor,
            FontFamily,
            FontSize,
            Heading,
            Highlight,
            HorizontalLine,
            ImageBlock,
            ImageCaption,
            ImageInsert,
            ImageInsertViaUrl,
            ImageResize,
            ImageStyle,
            ImageTextAlternative,
            ImageToolbar,
            ImageUpload,
            Indent,
            IndentBlock,
            Italic,
            Link,
            LinkImage,
            List,
            ListProperties,
            MediaEmbed,
            Paragraph,
            RemoveFormat,
            SpecialCharacters,
            SpecialCharactersArrows,
            SpecialCharactersCurrency,
            SpecialCharactersEssentials,
            SpecialCharactersLatin,
            SpecialCharactersMathematical,
            SpecialCharactersText,
            Strikethrough,
            Subscript,
            Superscript,
            Table,
            TableCaption,
            TableCellProperties,
            TableColumnResize,
            TableProperties,
            TableToolbar,
            Underline
        ],

        image: {
            toolbar: [
                'imageTextAlternative',
                'imageStyle:inline',
                'imageStyle:block',
                'imageStyle:side',
                'linkImage'
            ]
        },
        table: {
            contentToolbar: [
                'tableColumn',
                'tableRow',
                'mergeTableCells',
                'tableCellProperties',
                'tableProperties'
            ]
        },
        placeholder: 'Nhập nội dung...'
    };
    var descriptionEditor = null;
    var parameterEditor = null;
    var editorsReady = false;

    document.addEventListener('focusin', function (e) {
        if (e.target.closest(
            '.ck-body-wrapper, .ck-balloon-panel, .ck-link-form, .ck-input,' +
            '.ck-editor__editable, .ck-toolbar, .ck-dropdown__panel,' +
            '.ck-list, .ck-button, .ck-color-grid'
        )) {
            e.stopImmediatePropagation();
        }
    }, true);
    $('#modalSanPham').on('shown.bs.modal', function () {
        if (!editorsReady) {
            ClassicEditor.create(document.querySelector('#moTa'), editorConfig)
                .then(editor => {
                    descriptionEditor = editor;
                    window.descriptionEditor = editor;
                })
                .catch(err => console.error('moTa editor error:', err));

            ClassicEditor.create(document.querySelector('#thongSo'), editorConfig)
                .then(editor => {
                    parameterEditor = editor;
                    window.parameterEditor = editor;
                })
                .catch(err => console.error('thongSo editor error:', err));

            editorsReady = true;
        }
    });
    $('#modalSanPham').on('hidden.bs.modal', function () {
        document.getElementById('previewAnhChinh').innerHTML = `<i class="bi bi-image text-muted fs-4"></i>`;
        if (descriptionEditor) descriptionEditor.setData('');
        if (parameterEditor)   parameterEditor.setData('');
    });

    document.getElementById('anhChinh').addEventListener('input', function () {
        const url = this.value.trim();
        const preview = document.getElementById('previewAnhChinh');

        preview.innerHTML = `<i class="bi bi-hourglass-split text-muted fs-4"></i>`;

        if (!url) {
            preview.innerHTML = `<i class="bi bi-image text-muted fs-4"></i>`;
            return;
        }

        const img = new Image();

        const timeout = setTimeout(() => {
            preview.innerHTML = `<i class="bi bi-wifi-off text-warning fs-4" title="Ảnh không tải được"></i>`;
        }, 5000);

        img.onload = function () {
            clearTimeout(timeout);
            preview.innerHTML = '';
            img.style.cssText = 'width:100%;height:100%;object-fit:cover;border-radius:8px;';
            preview.appendChild(img);
        };

        img.onerror = function () {
            clearTimeout(timeout);
            preview.innerHTML = `
            <div style="text-align:center;">
                <i class="bi bi-exclamation-triangle text-danger fs-5"></i>
                <div style="font-size:10px;color:#dc3545;margin-top:2px;">Lỗi URL</div>
            </div>`;
        };

        img.src = url;
    });
</script>

</body>

</html>