<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
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
    <style>
        .complaint-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            padding: 20px;
        }

        .status-badge {
            font-size: 13px;
            padding: 5px 10px;
        }

        #complaintsTable thead th {
            background-color: #0051c6 !important;
            color: white !important;
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
        <a href="${pageContext.request.contextPath}/admin/profile" class="text-decoration-none text-while">
            <div class="thong-tin-admin d-flex align-items-center gap-2">
                <i class="bi bi-person-circle fs-4"></i>
                <span class="fw-semibold">${sessionScope.user.fullName}</span>
            </div>
        </a>
    </div>
</header>
<div class="layout">
    <main class="main-content container-fluid p-4" style="margin-left: 0; width: 100%;">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="text-primary fw-bold"><i class="bi bi-card-text"></i> Danh Sách Khiếu Nại</h4>
            <a href="${pageContext.request.contextPath}/admin/customer-manage" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Quay lại
            </a>
        </div>
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${sessionScope.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% request.getSession().removeAttribute("message"); %>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${sessionScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% request.getSession().removeAttribute("error"); %>
        </c:if>
        <div class="complaint-card">
            <table id="complaintsTable" class="table table-striped table-bordered">
                <thead>
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
                    <tr>
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
<script>
    $(document).ready(function () {
        $('#complaintsTable').DataTable({
            "order": [[3, "desc"]],
            "language": {
                "emptyTable": "Không có dữ liệu khiếu nại",
                "search": "Tìm kiếm:",
                "lengthMenu": "Hiển thị _MENU_ dòng",
                "info": "Hiển thị từ _START_ đến _END_ của _TOTAL_ dòng",
                "infoEmpty": "Hiển thị 0 dòng",
                "paginate": {
                    "first": "Đầu",
                    "last": "Cuối",
                    "next": "Sau",
                    "previous": "Trước"
                }
            }
        });
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
