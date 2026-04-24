<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Kho Hàng - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/product-manage.css">
    <style>
        .modal {
            --bs-modal-zindex: 1055;
        }

        .modal-backdrop {
            z-index: 1054;
        }

        .low-stock {
            background-color: #fff3cd !important;
        }

        .out-of-stock {
            background-color: #f8d7da !important;
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
            <a href="${pageContext.request.contextPath}/admin/inventory-manage">
                <li class="active"><i class="bi bi-boxes"></i> Quản Lý Kho Hàng</li>
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
            <h4 class="text-primary fw-bold"><i class="bi bi-boxes"></i> Quản Lý Kho Hàng</h4>
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
                <a href="${pageContext.request.contextPath}/admin/inventory-import" class="btn btn-success">
                    <i class="bi bi-file-earmark-plus"></i> Tạo Phiếu Nhập
                </a>
            </div>
        </div>
        <div class="d-flex justify-content-start align-items-center mb-2">
            <label class="me-2">Hiển thị</label>
            <select id="rowsPerPage" class="form-select d-inline-block" style="width:80px;">
                <option value="5">5</option>
                <option value="10" selected>10</option>
                <option value="20">20</option>
                <option value="50">50</option>
            </select>
            <label class="ms-2">sản phẩm</label>
        </div>
        <table id="tableTonKho" class="table table-striped table-bordered">
            <thead class="table-primary">
            <tr>
                <th>Mã SP</th>
                <th>Tên SP</th>
                <th>Ảnh</th>
                <th>Danh Mục</th>
                <th>Số Lượng Tồn</th>
                <th>Trạng Thái</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty products}">
                    <c:forEach var="p" items="${products}">
                        <tr class="${p.quantity <= 0 ? 'out-of-stock' : (p.quantity <= 10 ? 'low-stock' : '')}">
                            <td>${p.id}</td>
                            <td>${p.productName}</td>
                            <td>
                                <img src="${p.mainImage}" class="img-thumbnail"
                                     style="width:60px;height:60px;object-fit:cover;" alt="${p.productName}">
                            </td>
                            <td>${p.categoryName}</td>
                            <td class="fw-bold text-center ${p.quantity <= 0 ? 'text-danger' : (p.quantity <= 10 ? 'text-warning' : 'text-success')}">
                                    ${p.quantity}
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.quantity > 10}">
                                        <span class="badge bg-success">Còn hàng</span>
                                    </c:when>
                                    <c:when test="${p.quantity > 0 && p.quantity <= 10}">
                                        <span class="badge bg-warning text-dark">Sắp hết</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger">Hết hàng</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align:center;">
                                <button class="btn btn-primary btn-sm btn-import"
                                        data-id="${p.id}"
                                        data-name="${p.productName}"
                                        data-img="${p.mainImage}">
                                    <i class="bi bi-box-arrow-in-down"></i> Nhập kho
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/inventory-detail?id=${p.id}" class="btn btn-info btn-sm text-white">
                                    <i class="bi bi-bar-chart-fill"></i> Thống kê
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td>1</td>
                        <td>Flycam DJI Mini 3 Pro</td>
                        <td>
                            <img src="https://example.com/dji.jpg" class="img-thumbnail"
                                 style="width:60px;height:60px;object-fit:cover;" alt="Flycam DJI Mini 3 Pro" onerror="this.src='${pageContext.request.contextPath}/image/default.jpg'">
                        </td>
                        <td>Drone mini</td>
                        <td class="fw-bold text-center text-success">45</td>
                        <td><span class="badge bg-success">Còn hàng</span></td>
                        <td style="text-align:center;">
                            <button class="btn btn-primary btn-sm btn-import" data-id="1" data-name="Flycam DJI Mini 3 Pro" data-img="https://example.com/dji.jpg">
                                <i class="bi bi-box-arrow-in-down"></i> Nhập kho
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/inventory-detail?id=1" class="btn btn-info btn-sm text-white"><i class="bi bi-bar-chart-fill"></i> Thống kê</a>
                        </td>
                    </tr>
                    <tr class="low-stock">
                        <td>2</td>
                        <td>Flycam Autel Evo Lite+</td>
                        <td>
                            <img src="https://example.com/autel.jpg" class="img-thumbnail"
                                 style="width:60px;height:60px;object-fit:cover;" alt="Flycam Autel Evo Lite+" onerror="this.src='${pageContext.request.contextPath}/image/default.jpg'">
                        </td>
                        <td>Drone quay phim chuyên nghiệp</td>
                        <td class="fw-bold text-center text-warning">5</td>
                        <td><span class="badge bg-warning text-dark">Sắp hết</span></td>
                        <td style="text-align:center;">
                            <button class="btn btn-primary btn-sm btn-import" data-id="2" data-name="Flycam Autel Evo Lite+" data-img="https://example.com/autel.jpg">
                                <i class="bi bi-box-arrow-in-down"></i> Nhập kho
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/inventory-detail?id=2" class="btn btn-info btn-sm text-white"><i class="bi bi-bar-chart-fill"></i> Thống kê</a>
                        </td>
                    </tr>
                    <tr class="out-of-stock">
                        <td>3</td>
                        <td>Flycam Xiaomi Fimi X8 SE</td>
                        <td>
                            <img src="https://example.com/xiaomi.jpg" class="img-thumbnail"
                                 style="width:60px;height:60px;object-fit:cover;" alt="Flycam Xiaomi Fimi X8 SE" onerror="this.src='${pageContext.request.contextPath}/image/default.jpg'">
                        </td>
                        <td>Drone du lịch / vlog</td>
                        <td class="fw-bold text-center text-danger">0</td>
                        <td><span class="badge bg-danger">Hết hàng</span></td>
                        <td style="text-align:center;">
                            <button class="btn btn-primary btn-sm btn-import" data-id="3" data-name="Flycam Xiaomi Fimi X8 SE" data-img="https://example.com/xiaomi.jpg">
                                <i class="bi bi-box-arrow-in-down"></i> Nhập kho
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/inventory-detail?id=3" class="btn btn-info btn-sm text-white"><i class="bi bi-bar-chart-fill"></i> Thống kê</a>
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
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
<div class="modal fade" id="modalNhapKho" tabindex="-1" data-bs-focus="false">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="bi bi-box-arrow-in-down"></i> Đề Xuất Thêm Mới - Nhập Kho Sản Phẩm
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row mb-3 align-items-center">
                    <div class="col-md-3 text-center">
                        <img id="importProductImg" src="" class="img-fluid rounded border" alt="Product Image" style="max-height: 150px; display: none;" onerror="this.src='${pageContext.request.contextPath}/image/default.jpg'">
                        <div id="importProductImgPlaceholder" style="width: 100%; height: 120px; background: #f8f9fa; display: flex; align-items: center; justify-content: center; border: 1px dashed #ccc; border-radius: 8px;">
                            <i class="bi bi-image text-muted fs-1"></i>
                        </div>
                    </div>
                    <div class="col-md-9">
                        <h5 id="importProductName" class="fw-bold text-primary mb-1">Tên sản phẩm</h5>
                        <p class="text-muted mb-0">Mã SP: <span id="importProductIdDisplay" class="fw-bold">...</span></p>
                    </div>
                </div>
                <hr>
                <form id="formNhapKho" class="row g-3">
                    <input type="hidden" id="importProductId" name="productId">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Số lượng nhập <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-123"></i></span>
                            <input type="number" class="form-control" id="importQuantity" name="quantity"
                                   placeholder="Nhập số lượng" min="1" required>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Giá nhập (VNĐ) <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text">₫</span>
                            <input type="number" class="form-control" id="importPrice" name="importPrice"
                                   placeholder="Nhập giá nhập" min="0" step="1000" required>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <label class="form-label fw-semibold">Ghi chú / Nguồn gốc</label>
                        <textarea class="form-control" id="importNote" name="note" rows="3"
                                  placeholder="Ví dụ: Nhập hàng từ nhà cung cấp DJI đợt 2, có kèm hóa đơn đỏ..."></textarea>
                    </div>
                    <div class="col-md-12 mt-4 text-muted small">
                        <i class="bi bi-info-circle"></i> Bản ghi nhập kho sẽ được lưu lại với thông tin người nhập là: <strong>${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'Admin'}</strong>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x-circle"></i> Hủy
                </button>
                <button type="button" class="btn btn-primary" id="btnSaveImport">
                    <i class="bi bi-check-circle"></i> Xác nhận nhập kho
                </button>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    const contextPath = '${pageContext.request.contextPath}';
    var table = $('#tableTonKho').DataTable({
        "paging": true,
        "lengthChange": false,
        "pageLength": 10,
        "ordering": true,
        "searching": true,
        "info": false,
        "dom": 't',
        "columnDefs": [
            {"orderable": false, "targets": [2, 6]}
        ],
        "language": {
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
    updatePageInfo();
    $(document).on('click', '.btn-import', function () {
        const productId = $(this).data('id');
        const productName = $(this).data('name');
        const productImg = $(this).data('img');
        $('#formNhapKho')[0].reset();
        $('#importProductId').val(productId);
        $('#importProductIdDisplay').text(productId);
        $('#importProductName').text(productName);
        if(productImg && productImg.trim() !== '') {
            $('#importProductImg').attr('src', productImg).show();
            $('#importProductImgPlaceholder').hide();
        } else {
            $('#importProductImg').hide();
            $('#importProductImgPlaceholder').show();
        }
        const modalNhapKho = new bootstrap.Modal(document.getElementById('modalNhapKho'));
        modalNhapKho.show();
    });
    $('#btnSaveImport').on('click', function () {
        const productId = $('#importProductId').val();
        const quantity = parseInt($('#importQuantity').val());
        const importPrice = parseFloat($('#importPrice').val());
        const note = $('#importNote').val().trim();
        if (isNaN(quantity) || quantity <= 0) {
            Swal.fire('Lỗi!', 'Vui lòng nhập số lượng lớn hơn 0', 'warning');
            return;
        }
        if (isNaN(importPrice) || importPrice < 0) {
            Swal.fire('Lỗi!', 'Vui lòng nhập giá nhập hợp lệ (>= 0)', 'warning');
            return;
        }
        const data = {
            productId: productId,
            quantity: quantity,
            importPrice: importPrice,
            note: note
        };
        Swal.fire({
            title: 'Đang xử lý...',
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });
        setTimeout(() => {
            Swal.fire({
                title: 'Thành công!',
                text: 'Đã nhập kho thành công.',
                icon: 'success',
                confirmButtonColor: '#0d6efd'
            }).then(() => {
                $('#modalNhapKho').modal('hide');
                location.reload();
            });
        }, 1000);
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
</body>
</html>