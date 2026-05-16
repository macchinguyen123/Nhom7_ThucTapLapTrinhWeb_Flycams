<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Đánh Giá Xấu - SkyDrone Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/blog-manage.css">
    <style>
        .dataTables_paginate, .dataTables_filter, .dataTables_length, .dataTables_info {
            display: none !important;
        }

        .bad-review {
            background-color: #fff3f3 !important;
        }

        .status-processed {
            color: #198754;
            font-weight: 600;
        }

        .status-pending {
            color: #dc3545;
            font-weight: 600;
        }

        .action-history-box {
            background: #f8f9fa;
            border-left: 4px solid #0d6efd;
            padding: 15px;
            margin-top: 20px;
            border-radius: 4px;
        }

        @keyframes pulse-red {
            0% {
                transform: scale(0.95);
                box-shadow: 0 0 0 0 rgba(220, 53, 69, 0.7);
            }
            70% {
                transform: scale(1);
                box-shadow: 0 0 0 10px rgba(220, 53, 69, 0);
            }
            100% {
                transform: scale(0.95);
                box-shadow: 0 0 0 0 rgba(220, 53, 69, 0);
            }
        }

        .pulse-bell-badge {
            animation: pulse-red 2s infinite;
        }
    </style>
</head>
<body>
<header class="main-header">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/image/logoo2.png" alt="Logo">
        <h2>SkyDrone Admin</h2>
    </div>
    <div class="header-right d-flex align-items-center gap-4">
        <div class="notification-bell text-white position-relative" onclick="showNewBadReviews()"
             style="cursor: pointer;">
            <i class="bi bi-bell-fill fs-4"></i>
            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger pulse-bell-badge"
                  id="badReviewCount">
                <c:out value="${fn:length(badReviewsPending)}" default="3"/>
            </span>
        </div>
        <a href="${pageContext.request.contextPath}/admin/profile" class="text-decoration-none text-white">
            <div class="thong-tin-admin d-flex align-items-center gap-2">
                <i class="bi bi-person-circle fs-4 text-white"></i>
                <span class="fw-semibold text-white">${sessionScope.user.fullName}</span>
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
                         alt="Avatar" style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover;">
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
            <a href="${pageContext.request.contextPath}/admin/review-manage">
                <li class="active"><i class="bi bi-shield-exclamation"></i> Quản Lý Đánh Giá Xấu</li>
            </a>
        </ul>
    </aside>
    <main class="main-content container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="text-danger fw-bold"><i class="bi bi-shield-exclamation"></i> Quản Lý Đánh Giá Tiêu Cực / Tin
                Nhắn Xấu</h4>
            <span class="text-muted">Trang theo dõi và xử lý các phản hồi vi phạm chính sách hoặc tiêu cực</span>
        </div>
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div class="input-group" style="max-width: 350px;">
                <span class="input-group-text bg-primary text-white"><i class="bi bi-search"></i></span>
                <input id="searchInput" type="search" class="form-control" placeholder="Tìm tên KH, nội dung...">
            </div>
            <div class="d-flex align-items-center gap-3">
                <select id="statusFilter" class="form-select">
                    <option value="">Tất cả trạng thái</option>
                    <option value="Chờ xử lý">Chờ xử lý</option>
                    <option value="Đã giữ lại">Đã giữ lại (An toàn)</option>
                    <option value="Đã xóa">Đã xóa (Vi phạm)</option>
                </select>

                <select id="rowsPerPage" class="form-select" style="width: 120px;">
                    <option value="5">5 dòng</option>
                    <option value="10" selected>10 dòng</option>
                    <option value="20">20 dòng</option>
                </select>
            </div>
        </div>
        <div class="users-table bg-white p-3 rounded shadow-sm border">
            <table id="tableReviews" class="table table-hover table-bordered align-middle text-center w-100">
                <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Khách hàng</th>
                    <th>Sản phẩm / Bài viết</th>
                    <th style="width: 35%;">Nội dung vi phạm/tiêu cực</th>
                    <th>Ngày tạo</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <tr class="bad-review">
                    <td>#RV102</td>
                    <td class="fw-bold">Nguyễn Văn A</td>
                    <td class="text-start">Flycam DJI Mini 3</td>
                    <td class="text-start text-danger fw-semibold">Sản phẩm như rác rưởi, lừa đảo, thái độ phục vụ
                        tồi!
                    </td>
                    <td>16/05/2026 08:30</td>
                    <td><span class="badge bg-danger">Chờ xử lý</span></td>
                    <td>
                        <div class="d-flex gap-1 justify-content-center">
                            <button class="btn btn-info btn-sm" title="Xem chi tiết"
                                    onclick="viewReviewDetail('#RV102', 'Nguyễn Văn A', 'Sản phẩm như rác rưởi, lừa đảo, thái độ phục vụ tồi!', 'PENDING', '')">
                                <i class="bi bi-eye text-white"></i>
                            </button>
                            <button class="btn btn-success btn-sm" title="Giữ nguyên (Không vi phạm)"
                                    onclick="keepReview('#RV102')">
                                <i class="bi bi-check-circle"></i>
                            </button>
                            <button class="btn btn-danger btn-sm" title="Xóa bỏ (Vi phạm)"
                                    onclick="deleteReview('#RV102')">
                                <i class="bi bi-trash"></i>
                            </button>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>#RV095</td>
                    <td class="fw-bold">Trần Thị B</td>
                    <td class="text-start">Mavic Air 2</td>
                    <td class="text-start text-muted text-decoration-line-through">Shop bán hàng giả, cẩn thận mọi
                        người.
                    </td>
                    <td>15/05/2026 14:20</td>
                    <td><span class="badge bg-secondary">Đã xóa</span></td>
                    <td>
                        <div class="d-flex gap-1 justify-content-center">
                            <button class="btn btn-info btn-sm" title="Xem chi tiết"
                                    onclick="viewReviewDetail('#RV095', 'Trần Thị B', 'Shop bán hàng giả, cẩn thận mọi người.', 'DELETED', 'Admin (Hệ thống) đã xóa lúc 15/05/2026 15:00 - Lý do: Vu khống không có bằng chứng.')">
                                <i class="bi bi-eye text-white"></i>
                            </button>
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
            <div class="d-flex justify-content-end align-items-center mt-3">
                <button id="prevPage" class="btn btn-outline-primary btn-sm">Trước</button>
                <span id="pageInfo" class="mx-2">Trang 1 / 1</span>
                <button id="nextPage" class="btn btn-outline-primary btn-sm">Sau</button>
            </div>
        </div>
        <div class="modal fade" id="reviewDetailModal" tabindex="-1" data-bs-backdrop="static">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content shadow-lg border-0">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title"><i class="bi bi-card-text"></i> Hồ Sơ Đánh Giá/Tin Nhắn Xấu</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <p class="mb-1 text-muted">Mã Phiếu</p>
                                <h6 class="fw-bold fs-5" id="detail-id"></h6>
                            </div>
                            <div class="col-md-6 text-end">
                                <p class="mb-1 text-muted">Trạng Thái</p>
                                <h6 id="detail-status"></h6>
                            </div>
                        </div>
                        <div class="card mb-3 border-danger">
                            <div class="card-header bg-danger text-white bg-opacity-10 text-danger fw-bold border-danger">
                                Thông tin người gửi: <span id="detail-customer" class="fw-normal"></span>
                            </div>
                            <div class="card-body">
                                <p class="mb-1 fw-bold">Nội dung bị báo cáo/cảnh báo:</p>
                                <div class="p-3 bg-light rounded text-danger fst-italic border" id="detail-content"
                                     style="white-space: pre-wrap; font-size: 1.1rem;"></div>
                            </div>
                        </div>
                        <div class="action-history-box" id="history-box" style="display: none;">
                            <h6 class="fw-bold text-primary mb-2"><i class="bi bi-clock-history"></i> Lịch sử quản trị
                            </h6>
                            <p id="detail-history" class="mb-0 text-dark"></p>
                        </div>
                    </div>
                    <div class="modal-footer bg-light" id="modal-actions"></div>
                </div>
            </div>
        </div>
    </main>
</div>
<script>
    let reviewTable;
    $(document).ready(function () {
        reviewTable = $('#tableReviews').DataTable({
            pageLength: 10,
            ordering: false,
            language: {
                zeroRecords: "Không có dữ liệu đánh giá nào",
                infoEmpty: "Không tìm thấy kết quả"
            }
        });
        $('#searchInput').on('keyup', function () {
            reviewTable.search(this.value).draw();
        });
        $('#statusFilter').on('change', function () {
            reviewTable.column(5).search(this.value).draw();
        });
        $('#rowsPerPage').change(function () {
            reviewTable.page.len($(this).val()).draw();
        });
        $('#prevPage').click(() => reviewTable.page('previous').draw('page'));
        $('#nextPage').click(() => reviewTable.page('next').draw('page'));
        $('#logoutBtn').click(function () {
            $('#logoutModal').addClass('show');
        });
        $('#cancelLogout').click(function () {
            $('#logoutModal').removeClass('show');
        });
        $('.has-submenu .menu-item').click(function () {
            $(this).parent().toggleClass('active');
        });
        setInterval(checkNewBadReviews, 60000);
    });

    function viewReviewDetail(id, customer, content, status, history) {
        $('#detail-id').text(id);
        $('#detail-customer').text(customer);
        $('#detail-content').text(content);
        let statusHtml = '';
        if (status === 'PENDING') statusHtml = '<span class="badge bg-danger fs-6">Chờ xử lý</span>';
        else if (status === 'KEPT') statusHtml = '<span class="badge bg-success fs-6">Đã duyệt hiển thị</span>';
        else statusHtml = '<span class="badge bg-secondary fs-6">Đã gỡ bỏ vĩnh viễn</span>';
        $('#detail-status').html(statusHtml);
        if (history && history.trim() !== '') {
            $('#history-box').fadeIn();
            $('#detail-history').html(history);
        } else {
            $('#history-box').hide();
        }
        let footerHtml = '<button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Đóng</button>';
        if (status === 'PENDING') {
            footerHtml = `
                <button class="btn btn-outline-secondary me-auto" data-bs-dismiss="modal">Đóng</button>
                <button class="btn btn-success px-4 shadow-sm" onclick="keepReview('\${id}')">
                    <i class="bi bi-check-circle"></i> Bỏ qua cảnh báo (Giữ nguyên)
                </button>
                <button class="btn btn-danger px-4 shadow-sm" onclick="deleteReview('\${id}')">
                    <i class="bi bi-trash"></i> Xóa bỏ hoàn toàn
                </button>
            `;
        }
        $('#modal-actions').html(footerHtml);

        let modal = new bootstrap.Modal(document.getElementById('reviewDetailModal'));
        modal.show();
    }

    function keepReview(id) {
        Swal.fire({
            title: 'Bỏ qua cảnh báo?',
            text: "Đánh giá này không vi phạm và sẽ được giữ lại trên hệ thống hiển thị bình thường.",
            icon: 'info',
            input: 'text',
            inputPlaceholder: 'Ghi chú thêm (không bắt buộc)...',
            showCancelButton: true,
            confirmButtonColor: '#198754',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Xác nhận giữ lại',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire('Thành công!', 'Hệ thống đã ghi nhận lịch sử xử lý (Giữ lại).', 'success')
                    .then(() => location.reload());
            }
        });
    }

    function deleteReview(id) {
        Swal.fire({
            title: 'Chắc chắn xóa vi phạm?',
            text: "Nội dung này vi phạm tiêu chuẩn và sẽ bị gỡ khỏi trang người dùng ngay lập tức!",
            icon: 'warning',
            input: 'text',
            inputPlaceholder: 'Nhập lý do xóa (Vd: Dùng từ ngữ thô tục, spam...)',
            inputValidator: (value) => {
                if (!value) return 'Bạn cần nhập lý do để lưu lịch sử hệ thống!'
            },
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Xóa ngay lập tức',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire('Đã xóa!', 'Nội dung đã bị xóa và lịch sử được ghi nhận.', 'success')
                    .then(() => location.reload());
            }
        });
    }

    function showNewBadReviews() {
        let count = $('#badReviewCount').text().trim();
        if (count > 0) {
            Swal.fire({
                toast: true,
                position: 'top-end',
                icon: 'warning',
                title: 'Có ' + count + ' đánh giá/tin nhắn tiêu cực mới cần xử lý!',
                showConfirmButton: false,
                timer: 4000,
                timerProgressBar: true,
            });
        } else {
            Swal.fire({
                toast: true,
                position: 'top-end',
                icon: 'success',
                title: 'Hệ thống sạch, không có nội dung xấu!',
                showConfirmButton: false,
                timer: 3000
            });
        }
    }

    function checkNewBadReviews() {
    }
</script>
</body>
</html>