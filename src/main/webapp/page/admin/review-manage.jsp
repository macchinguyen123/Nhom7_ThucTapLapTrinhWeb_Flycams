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
    <jsp:include page="sidebar.jsp">
        <jsp:param name="activePage" value="review"/>
    </jsp:include>
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
                <input type="date" id="dateFrom" class="form-control form-control-sm" style="width:140px;">
                <span>–</span>
                <input type="date" id="dateTo" class="form-control form-control-sm" style="width:140px;">

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
                <c:forEach var="r" items="${badReviews}">
                    <tr class="${r.status == null || r.status == 'PENDING' ? 'bad-review' : ''}"
                        data-date="<fmt:formatDate value='${r.createdAt}' pattern='yyyy-MM-dd'/>">
                        <td>#RV${r.id}</td>
                        <td class="fw-bold"><c:out value="${r.username}"/></td>
                        <td class="text-start"><c:out value="${r.productName}"/></td>
                        <td class="text-start ${r.status == 'DELETED' ? 'text-muted text-decoration-line-through' : 'text-danger fw-semibold'}">
                            <c:out value="${r.content}"/>
                        </td>
                        <td>
                            <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${r.status == 'KEPT'}">
                                    <span class="badge bg-success">Đã giữ lại</span>
                                </c:when>
                                <c:when test="${r.status == 'DELETED'}">
                                    <span class="badge bg-secondary">Đã xóa</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">Chờ xử lý</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="d-flex gap-1 justify-content-center">
                                <button class="btn btn-info btn-sm" title="Xem chi tiết"
                                        onclick="viewReviewDetail('${r.id}', '<c:out value="${fn:escapeXml(r.username)}"/>', '<c:out value="${fn:escapeXml(r.content)}"/>', '${r.status == null ? 'PENDING' : r.status}', '<c:out value="${fn:escapeXml(r.adminNote)}"/>')">
                                    <i class="bi bi-eye text-white"></i>
                                </button>
                                <c:if test="${r.status == null || r.status == 'PENDING'}">
                                    <button class="btn btn-success btn-sm" title="Giữ nguyên (Không vi phạm)"
                                            onclick="keepReview('${r.id}')">
                                        <i class="bi bi-check-circle"></i>
                                    </button>
                                    <button class="btn btn-danger btn-sm" title="Xóa bỏ (Vi phạm)"
                                            onclick="deleteReview('${r.id}')">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
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
    const CSRF_TOKEN = "${sessionScope.CSRF_TOKEN}";
    let detailModalInstance = null;
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
        detailModalInstance = new bootstrap.Modal(document.getElementById('reviewDetailModal'));
        reviewTable.on('draw', function () {
            let pageInfo = reviewTable.page.info();
            if (pageInfo.pages > 0) {
                $('#pageInfo').text('Trang ' + (pageInfo.page + 1) + ' / ' + pageInfo.pages);
            } else {
                $('#pageInfo').text('Trang 1 / 1');
            }
        });
        let initPageInfo = reviewTable.page.info();
        if (initPageInfo.pages > 0) {
            $('#pageInfo').text('Trang ' + (initPageInfo.page + 1) + ' / ' + initPageInfo.pages);
        }
        $('#searchInput').on('keyup', function () {
            reviewTable.search(this.value).draw();
        });
        $('#statusFilter').on('change', function () {
            reviewTable.column(5).search(this.value).draw();
        });
        $('#rowsPerPage').change(function () {
            reviewTable.page.len($(this).val()).draw();
        });
        $('#dateFrom, #dateTo').on('change', function () {
            $.fn.dataTable.ext.search.push(function (settings, data, dataIndex) {
                if (settings.nTable.id !== 'tableReviews') return true;
                let from = $('#dateFrom').val();
                let to   = $('#dateTo').val();
                if (!from && !to) return true;
                let rowDate = $(reviewTable.row(dataIndex).node()).attr('data-date');
                if (!rowDate) return true;
                if (from && rowDate < from) return false;
                if (to   && rowDate > to)   return false;
                return true;
            });
            reviewTable.draw();
            $.fn.dataTable.ext.search.pop();
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
        setInterval(checkNewBadReviews, 30000);
    });

    function viewReviewDetail(id, customer, content, status, history) {
        $('#detail-id').text('#RV' + id);
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
                <button class="btn btn-success px-4 shadow-sm" onclick="keepFromModal('${id}')">
                    <i class="bi bi-check-circle"></i> Bỏ qua cảnh báo (Giữ nguyên)
                </button>
                <button class="btn btn-danger px-4 shadow-sm" onclick="deleteFromModal('${id}')">
                    <i class="bi bi-trash"></i> Xóa bỏ hoàn toàn
                </button>
            `;
        }
        $('#modal-actions').html(footerHtml);
        detailModalInstance.show();
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
                let note = result.value || '';
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/review-manage',
                    type: 'POST',
                    data: {
                        action: 'keep',
                        id: id,
                        adminNote: note,
                        _csrf: CSRF_TOKEN
                    },
                    success: function (res) {
                        Swal.fire('Thành công!', 'Đã phê duyệt giữ lại đánh giá.', 'success')
                            .then(() => location.reload());
                    },
                    error: function (xhr) {
                        let errMsg = xhr.responseJSON ? xhr.responseJSON.message : 'Có lỗi xảy ra!';
                        Swal.fire('Lỗi!', errMsg, 'error');
                    }
                });
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
                let reason = result.value;
                $.ajax({
                    url: '${pageContext.request.contextPath}/admin/review-manage',
                    type: 'POST',
                    data: {
                        action: 'delete',
                        id: id,
                        adminNote: reason,
                        _csrf: CSRF_TOKEN
                    },
                    success: function (res) {
                        Swal.fire('Đã xóa!', 'Đánh giá đã bị ẩn khỏi trang bán hàng thành công.', 'success')
                            .then(() => location.reload());
                    },
                    error: function (xhr) {
                        let errMsg = xhr.responseJSON ? xhr.responseJSON.message : 'Có lỗi xảy ra!';
                        Swal.fire('Lỗi!', errMsg, 'error');
                    }
                });
            }
        });
    }

    function showNewBadReviews() {
        let count = parseInt($('#badReviewCount').text().trim()) || 0;
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
        $.ajax({
            url: '${pageContext.request.contextPath}/admin/review-manage',
            type: 'GET',
            data: { action: 'countPending' },
            dataType: 'json',
            success: function (res) {
                if (res && typeof res.count !== 'undefined') {
                    let badge = $('#badReviewCount');
                    let oldCount = parseInt(badge.text().trim()) || 0;
                    let newCount = res.count;
                    badge.text(newCount);
                    if (newCount > 0) {
                        badge.removeClass('d-none').show();
                        if (newCount > oldCount) {
                            Swal.fire({
                                toast: true,
                                position: 'top-end',
                                icon: 'warning',
                                title: 'Có thêm ' + (newCount - oldCount) + ' đánh giá tiêu cực mới cần xử lý!',
                                showConfirmButton: false,
                                timer: 5000,
                                timerProgressBar: true
                            });
                        }
                    } else {
                        badge.hide();
                    }
                }
            }
        });
    }
    function keepFromModal(id) {
        detailModalInstance.hide();
        $('#reviewDetailModal').one('hidden.bs.modal', function () {
            keepReview(id);
        });
    }

    function deleteFromModal(id) {
        detailModalInstance.hide();
        $('#reviewDetailModal').one('hidden.bs.modal', function () {
            deleteReview(id);
        });
    }
</script>
</body>
</html>