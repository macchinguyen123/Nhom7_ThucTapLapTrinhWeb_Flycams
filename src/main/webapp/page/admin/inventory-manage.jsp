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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="${pageContext.request.contextPath}/js/admin/inventory-manage.js?v=<%= System.currentTimeMillis() %>" defer></script>
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
            <a href="${pageContext.request.contextPath}/admin/review-manage">
                <li><i class="bi bi-shield-exclamation"></i> Quản Lý Đánh Giá Xấu</li>
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
                <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalMultiImport">
                    <i class="bi bi-file-earmark-plus"></i> Tạo Phiếu Nhập
                </button>
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
        <div id="loadingSpinner" class="text-center my-3" style="display: none;">
            <div class="spinner-border text-primary" role="status"></div>
            <span class="ms-2">Đang tải dữ liệu kho hàng...</span>
        </div>
        <table id="inventoryTable" class="table table-striped table-bordered">
            <thead class="table-primary">
            <tr>
                <th>STT</th>
                <th>Mã SP</th>
                <th>Ảnh</th>
                <th>Tên SP</th>
                <th>Tổng Nhập</th>
                <th>Tổng Xuất</th>
                <th>Tồn Kho</th>
                <th>Trạng Thái</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody id="tableBody">
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
                        <img id="importProductImg" src="" class="img-fluid rounded border" alt="Product Image" style="max-height: 150px; display: none;" onerror="this.style.display='none'; document.getElementById('importProductImgPlaceholder').style.display='flex';">
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
<div class="modal fade" id="modalMultiImport" tabindex="-1" data-bs-focus="false">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title"><i class="bi bi-file-earmark-plus"></i> Tạo Phiếu Nhập Kho</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body bg-light">
                <div class="row">
                    <div class="col-lg-4">
                        <div class="card shadow-sm mb-4">
                            <div class="card-header bg-white">
                                <h5 class="card-title fw-bold mb-0"><i class="bi bi-info-circle"></i> Thông Tin Chung</h5>
                            </div>
                            <div class="card-body">
                                <form id="infoForm">
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">Người lập phiếu</label>
                                        <input type="text" class="form-control" value="${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'Admin'}" disabled>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">Ngày nhập</label>
                                        <input type="datetime-local" class="form-control" id="importDate" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">Nhà cung cấp <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="supplier" placeholder="Nhập tên nhà cung cấp..." required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">Ghi chú</label>
                                        <textarea class="form-control" id="noteMulti" rows="3" placeholder="Lý do nhập hàng, đợt nhập..."></textarea>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-8">
                        <div class="card shadow-sm mb-4">
                            <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                <h5 class="card-title fw-bold mb-0"><i class="bi bi-list-check"></i> Chọn Sản Phẩm Nhập</h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0" id="importTable">
                                        <thead class="table-light">
                                            <tr>
                                                <th style="width: 5%">STT</th>
                                                <th style="width: 35%">Sản phẩm</th>
                                                <th style="width: 15%">Số lượng</th>
                                                <th style="width: 20%">Đơn giá nhập (VNĐ)</th>
                                                <th style="width: 20%">Thành tiền (VNĐ)</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr class="product-row">
                                                <td class="align-middle text-center row-stt">1</td>
                                                <td>
                                                    <select class="form-select product-select" required>
                                                        <option value="" disabled selected>-- Chọn sản phẩm --</option>
                                                        <c:forEach var="p" items="${products}">
                                                            <option value="${p.id}">${p.productName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </td>
                                                <td>
                                                    <input type="number" class="form-control quantity-input" min="1" value="1" required>
                                                </td>
                                                <td>
                                                    <input type="number" class="form-control price-input" min="0" step="1000" placeholder="0" required>
                                                </td>
                                                <td class="align-middle fw-bold text-primary total-cell">0</td>
                                            </tr>
                                        </tbody>
                                        <tfoot class="table-light">
                                            <tr>
                                                <td colspan="4" class="text-end fw-bold">Tổng cộng:</td>
                                                <td class="fw-bold text-success fs-5" id="grandTotal">0</td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary" id="btnSaveMultiReceipt"><i class="bi bi-save"></i> Hoàn Tất Phiếu Nhập</button>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    const contextPath = '${pageContext.request.contextPath}';
    function updatePageInfo() {
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
    // Removed btnSaveImport since it is handled by inventory-manage.js
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
    document.addEventListener("DOMContentLoaded", function() {
        const now = new Date();
        now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
        const importDateEl = document.getElementById('importDate');
        if(importDateEl) importDateEl.value = now.toISOString().slice(0, 16);
        updateRowNumbers();
        fetch(contextPath + '/admin/api/inventory-manage?page=1&limit=1000', {
            method: 'GET',
            credentials: 'same-origin',
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
            .then(response => {
                if (!response.ok) throw new Error("HTTP " + response.status);
                const contentType = response.headers.get("content-type");
                if (contentType && contentType.indexOf("application/json") !== -1) {
                    return response.json();
                } else {
                    throw new Error("API bị chặn, yêu cầu đăng nhập Admin!");
                }
            })
            .then(result => {
                if (result.status === 'success' && result.data && result.data.length > 0) {
                    let html = '<option value="" disabled selected>-- Chọn sản phẩm --</option>';
                    result.data.forEach(p => {
                        html += '<option value="' + p.id + '">#' + p.id + ' - ' + p.productName + '</option>';
                    });
                    document.querySelectorAll('.product-select').forEach(sel => {
                        sel.innerHTML = html;
                    });
                } else if (result.status === 'success' && (!result.data || result.data.length === 0)) {
                    document.querySelectorAll('.product-select').forEach(sel => {
                        sel.innerHTML = '<option disabled selected>-- Trống (Chưa có SP) --</option>';
                    });
                } else {
                    document.querySelectorAll('.product-select').forEach(sel => {
                        sel.innerHTML = '<option disabled selected>-- Lỗi API: ' + result.message + ' --</option>';
                    });
                }
            })
            .catch(error => {
                document.querySelectorAll('.product-select').forEach(sel => {
                    sel.innerHTML = '<option disabled selected>-- Lỗi tải: ' + error.message + ' --</option>';
                });
            });
        document.querySelectorAll('.product-row').forEach(row => {
            attachRowEvents(row);
        });
        const btnSaveMultiReceipt = document.getElementById('btnSaveMultiReceipt');
        if(btnSaveMultiReceipt) {
            btnSaveMultiReceipt.addEventListener('click', function() {
                const supplier = document.getElementById('supplier').value.trim();
                if(!supplier) {
                    Swal.fire('Lỗi', 'Vui lòng nhập tên nhà cung cấp!', 'warning');
                    return;
                }
                let isValid = true;
                let hasProducts = false;
                document.querySelectorAll('.product-row').forEach(row => {
                    hasProducts = true;
                    const product = row.querySelector('.product-select').value;
                    const price = row.querySelector('.price-input').value;
                    if(!product || !price) {
                        isValid = false;
                    }
                });
                if(!hasProducts) {
                    Swal.fire('Lỗi', 'Phiếu nhập phải có ít nhất 1 sản phẩm!', 'warning');
                    return;
                }
                if(!isValid) {
                    Swal.fire('Lỗi', 'Vui lòng chọn sản phẩm và nhập giá cho tất cả các dòng!', 'warning');
                    return;
                }
                Swal.fire({
                    title: 'Đang xử lý...',
                    allowOutsideClick: false,
                    didOpen: () => { Swal.showLoading(); }
                });
                const requests = [];
                const noteMulti = document.getElementById('noteMulti').value.trim() || supplier;
                document.querySelectorAll('.product-row').forEach(row => {
                    const productId = row.querySelector('.product-select').value;
                    const quantity = row.querySelector('.quantity-input').value;
                    const importPrice = row.querySelector('.price-input').value;
                    requests.push($.ajax({
                        url: contextPath + '/admin/api/inventory-import',
                        type: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({
                            productId: parseInt(productId),
                            quantity: parseInt(quantity),
                            importPrice: parseFloat(importPrice),
                            note: noteMulti
                        })
                    }));
                });
                Promise.all(requests).then(() => {
                    Swal.fire({
                        title: 'Thành công!',
                        text: 'Phiếu nhập kho đã được ghi nhận.',
                        icon: 'success',
                        confirmButtonColor: '#0d6efd'
                    }).then(() => {
                        $('#modalMultiImport').modal('hide');
                        location.reload();
                    });
                }).catch(() => {
                    Swal.fire('Lỗi', 'Có lỗi xảy ra trong quá trình nhập kho!', 'error');
                });
            });
        }
    });
    function attachRowEvents(row) {
        const qtyInput = row.querySelector('.quantity-input');
        const priceInput = row.querySelector('.price-input');
        qtyInput.addEventListener('input', calculateTotal);
        priceInput.addEventListener('input', calculateTotal);
    }
    function calculateTotal(e) {
        const row = e.target.closest('.product-row');
        const qty = parseFloat(row.querySelector('.quantity-input').value) || 0;
        const price = parseFloat(row.querySelector('.price-input').value) || 0;
        const total = qty * price;
        row.querySelector('.total-cell').textContent = new Intl.NumberFormat('vi-VN').format(total);
        calculateGrandTotal();
    }
    function calculateGrandTotal() {
        let grandTotal = 0;
        document.querySelectorAll('.product-row').forEach(row => {
            const qty = parseFloat(row.querySelector('.quantity-input').value) || 0;
            const price = parseFloat(row.querySelector('.price-input').value) || 0;
            grandTotal += (qty * price);
        });
        const gtEl = document.getElementById('grandTotal');
        if(gtEl) gtEl.textContent = new Intl.NumberFormat('vi-VN').format(grandTotal) + ' đ';
    }
    function updateRowNumbers() {
        document.querySelectorAll('.product-row').forEach((row, index) => {
            const stt = row.querySelector('.row-stt');
            if(stt) stt.textContent = index + 1;
        });
    }
</script>
</body>
</html>