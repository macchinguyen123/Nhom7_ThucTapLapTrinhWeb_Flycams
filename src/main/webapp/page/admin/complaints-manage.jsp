<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Khiếu Nại - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/customer-manage.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>

</head>
<body>
<header class="main-header">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/image/logoo2.png" alt="Logo">
        <h2>SkyDrone Admin</h2>
    </div>
    <div class="header-right">
        <a href="${pageContext.request.contextPath}/admin/profile" class="text-decoration-none text-while">
            <div class="thong-tin-admin d-flex align-items-center gap-2">
                <i class="bi bi-person-circle fs-4"></i>
                <span class="fw-semibold">${sessionScope.user.fullName}</span>
            </div>
        </a>
    </div>
</header>
<div class="layout">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="activePage" value="complaints"/>
    </jsp:include>
    <main class="main-content container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="text-primary fw-bold"><i class="bi bi-card-text"></i> Danh Sách Khiếu Nại</h4>
        </div>
        <div class="complaint-card">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="d-flex align-items-center">
                    <label class="me-2 text-nowrap">Hiển thị</label>
                    <select id="statusFilter" class="form-select" style="width:140px;">
                        <option value="">Tất cả</option>
                        <option value="Chờ xử lý">Chờ xử lý</option>
                        <option value="Đã xử lý">Đã xử lý</option>
                    </select>
                    <select id="rowsPerPageCustom" class="form-select d-inline-block" style="width:80px;">
                        <option value="5" selected>5</option>
                        <option value="10">10</option>
                        <option value="20">20</option>
                    </select>
                    <label class="ms-2 text-nowrap">khiếu nại</label>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <input type="date" id="dateFrom" class="form-control" style="width:145px;" title="Từ ngày">
                    <span class="text-muted">–</span>
                    <input type="date" id="dateTo" class="form-control" style="width:145px;" title="Đến ngày">
                    <div class="input-group" style="max-width: 300px;">
                            <span class="input-group-text bg-primary text-white">
                                <i class="bi bi-search"></i>
                            </span>
                        <input id="searchCustom" type="search" class="form-control"
                               placeholder="Tìm kiếm khiếu nại..." aria-label="Tìm kiếm"
                               onkeypress="return event.keyCode != 13;">
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/customer-manage"
                       class="btn btn-secondary shadow-sm fw-semibold text-nowrap">
                        <i class="bi bi-arrow-left"></i> Quay lại
                    </a>
                </div>
            </div>
            <table id="complaintsTable" class="table table-striped table-bordered">
                <thead class="table-dark">
                <tr>
                    <th width="5%">ID</th>
                    <th width="15%">Khách hàng</th>
                    <th width="25%">Nội dung khiếu nại</th>
                    <th width="15%">Ngày gửi</th>
                    <th width="15%">Trạng thái</th>
                    <th width="15%">Ghi chú Admin</th>
                    <th width="10%">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${complaints}" var="c">
                    <tr data-date="<fmt:formatDate value='${c.createdAt}' pattern='yyyy-MM-dd'/>">
                        <td>${c.id}</td>
                        <td>
                            <strong>${c.userFullName}</strong><br>
                            <small class="text-muted">${c.userEmail}</small><br>
                            <small class="text-muted">${c.userPhone}</small>
                        </td>
                        <td>${c.content}</td>
                        <td><fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${c.status == 0}">
                                    <span class="badge bg-warning text-dark status-badge">Chờ xử lý</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-success status-badge">Đã xử lý</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${c.adminNote}</td>
                        <td class="text-center">
                            <button class="btn btn-sm btn-primary"
                                    onclick="openResolveModal(${c.id}, ${c.status}, '${c.adminNote != null ? c.adminNote : ''}')">
                                <i class="bi bi-pencil-square"></i> Cập nhật
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <div class="d-flex justify-content-end align-items-center mt-3">
                <button id="prevPageCustom" class="btn btn-outline-primary btn-sm">Trước</button>
                <span id="pageInfoCustom" class="mx-2">1 / 1</span>
                <button id="nextPageCustom" class="btn btn-outline-primary btn-sm">Sau</button>
            </div>
        </div>
    </main>
</div>
<div class="modal fade" id="resolveModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Cập nhật Trạng thái Khiếu nại</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/complaints" method="post">
                <input type="hidden" name="_csrf" value="${sessionScope.CSRF_TOKEN}">
                <div class="modal-body">
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="id" id="complaintId">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Trạng thái</label>
                        <select name="status" id="complaintStatus" class="form-select">
                            <option value="0">Chờ xử lý</option>
                            <option value="1">Đã xử lý</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Ghi chú của Admin</label>
                        <textarea name="adminNote" id="adminNote" class="form-control" rows="3"
                                  placeholder="Ví dụ: Đã mở khoá tài khoản..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-success">Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    const CSRF_TOKEN = "${sessionScope.CSRF_TOKEN}";
    $(document).ready(function () {
        var table = $('#complaintsTable').DataTable({
            "order": [],
            "paging": true,
            "lengthChange": false,
            "pageLength": 5,
            "searching": true,
            "info": false,
            "dom": 't',
            "language": {
                "emptyTable": "Không có dữ liệu khiếu nại",
                "zeroRecords": "Không tìm thấy dữ liệu phù hợp"
            }
        });

        <c:if test="${not empty sessionScope.message}">
        Swal.fire({
            toast: true, position: 'top-end', icon: 'success',
            title: '${sessionScope.message}',
            showConfirmButton: false, timer: 3000, timerProgressBar: true
        });
        </c:if>
        <c:remove var="message" scope="session"/>

        <c:if test="${not empty sessionScope.error}">
        Swal.fire({
            toast: true, position: 'top-end', icon: 'error',
            title: '${sessionScope.error}',
            showConfirmButton: false, timer: 3000, timerProgressBar: true
        });
        </c:if>
        <c:remove var="message" scope="session"/>

        $('#statusFilter').on('change', function () {
            table.column(4).search(this.value).draw();
        });

        $("#searchCustom").on("keyup search", function () {
            table.search(this.value).draw();
            updatePageInfo();
        });
        $("#rowsPerPageCustom").on("change", function () {
            table.page.len($(this).val()).draw();
            updatePageInfo();
        });
        $("#prevPageCustom").click(function () {
            table.page('previous').draw('page');
            updatePageInfo();
        });
        $("#nextPageCustom").click(function () {
            table.page('next').draw('page');
            updatePageInfo();
        });

        $('#dateFrom, #dateTo').on('change', function () {
            $.fn.dataTable.ext.search.push(function (settings, data, dataIndex) {
                if (settings.nTable.id !== 'complaintsTable') return true;
                let from = $('#dateFrom').val();
                let to   = $('#dateTo').val();
                if (!from && !to) return true;
                let rowDate = $(table.row(dataIndex).node()).attr('data-date');
                if (!rowDate) return true;
                if (from && rowDate < from) return false;
                if (to   && rowDate > to)   return false;
                return true;
            });
            table.draw();
            $.fn.dataTable.ext.search.pop();
        });

        function updatePageInfo() {
            var info = table.page.info();
            $('#pageInfoCustom').text((info.page + 1) + " / " + (info.pages === 0 ? 1 : info.pages));
        }

        table.on('draw', updatePageInfo);
        updatePageInfo();
    });

    function openResolveModal(id, currentStatus, adminNote) {
        document.getElementById('complaintId').value = id;
        document.getElementById('complaintStatus').value = currentStatus;
        document.getElementById('adminNote').value = adminNote;
        new bootstrap.Modal(document.getElementById('resolveModal')).show();
    }
</script>
</body>
</html>
