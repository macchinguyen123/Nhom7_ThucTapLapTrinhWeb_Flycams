<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trang Quản Lý Danh Mục - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/category-manage.css">
    <style>
        .dataTables_paginate,
        .dataTables_filter,
        .dataTables_length,
        .dataTables_info {
            display: none !important;
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
            <li>
                <a href="${pageContext.request.contextPath}/admin/dashboard"><i
                        class="bi bi-speedometer2"></i> Tổng Quan</a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/customer-manage"><i
                        class="bi bi-person-lines-fill"></i> Quản Lý Tài Khoản</a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/product-management"><i
                        class="bi bi-box-seam"></i> Quản Lý Sản Phẩm</a>
            </li>
            <li class="active">
                <a href="${pageContext.request.contextPath}/admin/category-manage"><i
                        class="bi bi-tags"></i> Quản Lý Danh Mục</a>
            </li>
            <li class="has-submenu">
                <div class="menu-item">
                    <i class="bi bi-truck"></i>
                    <span>Quản Lý Đơn Hàng</span>
                    <i class="bi bi-chevron-right arrow"></i>
                </div>
                <ul class="submenu">
                    <li><a href="${pageContext.request.contextPath}/admin/unconfirmed-orders">Chưa Xác
                        Nhận</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/order-manage">Đã Xác Nhận</a></li>
                </ul>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/blog-manage"><i
                        class="bi bi-journal-text"></i> Quản Lý Blog</a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/promotion-manage"><i
                        class="bi bi-megaphone"></i> Quản Lý Khuyến Mãi</a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/admin/statistics"><i
                        class="bi bi-bar-chart"></i> Báo Cáo & Thống Kê</a>
            </li>
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
            <h4 class="text-primary fw-bold"><i class="bi bi-tags"></i> Quản Lý Danh Mục</h4>
            <div class="d-flex align-items-center gap-2">
                <form class="d-flex" role="search" style="max-width: 300px;">
                    <div class="input-group">
                                    <span class="input-group-text bg-primary text-white">
                                        <i class="bi bi-search"></i>
                                    </span>
                        <input id="searchInput" type="search" class="form-control"
                               placeholder="Tìm kiếm danh mục..." aria-label="Tìm kiếm">
                    </div>
                </form>
                <button class="btn btn-success btn-them" data-bs-toggle="modal"
                        data-bs-target="#modalDanhMuc">
                    <i class="bi bi-plus-lg"></i> Thêm Danh Mục
                </button>
            </div>
        </div>
        <div class="d-flex justify-content-start align-items-center mb-2 gap-3 flex-wrap">
            <div class="d-flex align-items-center">
                <label class="me-2">Hiển thị</label>
                <select id="rowsPerPage" class="form-select d-inline-block" style="width:80px;">
                    <option value="5">5</option>
                    <option value="10" selected>10</option>
                    <option value="20">20</option>
                </select>
                <label class="ms-2">danh mục</label>
            </div>
            <div class="d-flex align-items-center">
                <label class="me-2">Sắp xếp</label>
                <select id="sortSelect" class="form-select" style="width:220px;">
                    <option value="">-- Tùy chọn --</option>
                    <option value="name-asc">Tên A → Z</option>
                    <option value="name-desc">Tên Z → A</option>
                    <option value="id-asc">Mã DM ↑ (Thấp → Cao)</option>
                    <option value="id-desc">Mã DM ↓ (Cao → Thấp)</option>
                    <option value="custom">Theo ý admin</option>
                </select>
            </div>
        </div>
        <table id="tableDanhMuc" class="table table-striped table-bordered">
            <thead class="table-primary">
            <tr>
                <th>Mã DM</th>
                <th>Tên Danh Mục</th>
                <th>Ảnh Đại Diện</th>
                <th>Trạng Thái</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${categories}" var="c">
                <tr data-id="${c.id}">
                    <td>${c.id}</td>
                    <td>${c.categoryName}</td>
                    <td>
                        <img src="${pageContext.request.contextPath}/${c.image}" alt="Ảnh danh mục"
                             class="img-thumbnail" style="width: 60px; height: 60px; object-fit: cover;">
                        <input type="hidden" class="img-path" value="${c.image}">
                    </td>
                    <td>
                                        <span
                                                class="badge ${c.status == 'Hiện' ? 'bg-success' : 'bg-secondary'}">${c.status}</span>
                    </td>
                    <td>
                        <button class="btn btn-warning btn-sm btn-sua" data-id="${c.id}"
                                data-name="${c.categoryName}" data-status="${c.status}"
                                data-img="${c.image}">
                            <i class="bi bi-pencil"></i>
                        </button>
                        <button class="btn btn-danger btn-sm btn-xoa" onclick="confirmDelete(${c.id})">
                            <i class="bi bi-trash"></i>
                        </button>
                    </td>
                </tr>
            </c:forEach>
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
<div class="modal fade" id="modalDanhMuc" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="modalTitle"><i class="bi bi-pencil-square"></i> Cập Nhật Danh Mục
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="formDanhMuc" method="POST" enctype="multipart/form-data"
                      action="${pageContext.request.contextPath}/admin/category-manage">
                    <input type="hidden" name="action" id="formAction" value="add">
                    <input type="hidden" name="id" id="catId">
                    <input type="hidden" name="oldImage" id="oldImage">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Tên danh mục</label>
                            <input type="text" class="form-control" name="categoryName" id="tenDM"
                                   placeholder="Nhập tên danh mục" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ảnh đại diện</label>
                            <input type="file" class="form-control" name="image" id="anhDM"
                                   accept="image/*">
                            <small class="text-muted" id="currentImgText"></small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Trạng thái</label>
                            <select class="form-select" name="status" id="trangThaiDM">
                                <option value="Hiện">Hiện</option>
                                <option value="Ẩn">Ẩn</option>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button type="submit" form="formDanhMuc" class="btn btn-primary">Lưu Thay Đổi</button>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    let allowSaveOrder = false;
    $(document).ready(function () {
        var table = $('#tableDanhMuc').DataTable({
            paging: true,
            info: false,
            lengthChange: false,
            searching: true,
            pageLength: 10,
            ordering: true,
            order: [],
            language: {
                zeroRecords: "Không tìm thấy kết quả"
            }
        });
        let sortable;

        function enableDragSort() {
            table.page.len(-1).draw();
            if (sortable) return;
            sortable = new Sortable(document.querySelector("#tableDanhMuc tbody"), {
                animation: 150,
                ghostClass: "bg-warning",
                onEnd: function () {
                    let order = [];
                    $("#tableDanhMuc tbody tr").each(function (index) {
                        order.push({
                            id: $(this).data("id"),
                            sortOrder: index + 1
                        });
                    });
                    saveSortOrder(order);
                }
            });
        }

        function disableDragSort() {
            if (sortable) {
                sortable.destroy();
                sortable = null;
            }
        }

        function saveSortOrder(order) {
            $.ajax({
                url: "${pageContext.request.contextPath}/admin/category-sort",
                method: "POST",
                contentType: "application/json",
                data: JSON.stringify(order),
                success: function () {
                    Swal.fire({
                        icon: "success",
                        title: "Đã lưu thứ tự",
                        timer: 1200,
                        showConfirmButton: false
                    });
                },
                error: function () {
                    Swal.fire("Lỗi", "Không thể lưu thứ tự", "error");
                }
            });
        }

        $("#sortSelect").change(function () {
            let value = $(this).val();
            disableDragSort();
            allowSaveOrder = true;
            switch (value) {
                case "name-asc":
                    table.order([1, 'asc']).draw();
                    break;
                case "name-desc":
                    table.order([1, 'desc']).draw();
                    break;
                case "id-asc":
                    table.order([0, 'asc']).draw();
                    break;
                case "id-desc":
                    table.order([0, 'desc']).draw();
                    break;
                case "custom":
                    table.order([]).draw();
                    enableDragSort();
                    break;
            }
        });
        table.on('draw', function () {
            if (!allowSaveOrder) return;
            let order = collectFullOrder();
            if (order.length === 0) return;
            saveSortOrder(order);
            allowSaveOrder = false;
        });

        function collectFullOrder() {
            let order = [];
            let data = table.rows({order: 'applied'}).nodes();
            $(data).each(function (index) {
                order.push({
                    id: $(this).data("id"),
                    sortOrder: index + 1
                });
            });
            return order;
        }

        function updatePageInfo() {
            var info = table.page.info();
            $("#pageInfo").text((info.page + 1) + " / " + info.pages);
        }

        table.on('draw', updatePageInfo);
        updatePageInfo();
        $("#prevPage").click(function () {
            table.page('previous').draw('page');
        });
        $("#nextPage").click(function () {
            table.page('next').draw('page');
        });
        $("#searchInput").on("keyup search", function () {
            table.search($(this).val()).draw();
        });
        $("#rowsPerPage").change(function () {
            table.page.len($(this).val()).draw();
        });
        $("#logoutBtn").click(() => $("#logoutModal").css("display", "flex"));
        $("#cancelLogout").click(() => $("#logoutModal").hide());
        $(".btn-them").click(function () {
            $("#modalTitle").html('<i class="bi bi-plus-circle"></i> Thêm Danh Mục');
            $("#formAction").val("add");
            $("#catId").val("");
            $("#tenDM").val("");
            $("#trangThaiDM").val("Hiện");
            $("#anhDM").val("");
            $("#currentImgText").text("");
        });
        $(document).on("click", ".btn-sua", function () {
            let id = $(this).data("id");
            let name = $(this).data("name");
            let status = $(this).data("status");
            let img = $(this).data("img");
            $("#modalTitle").html('<i class="bi bi-pencil-square"></i> Cập Nhật Danh Mục');
            $("#formAction").val("update");
            $("#catId").val(id);
            $("#tenDM").val(name);
            $("#trangThaiDM").val(status);
            $("#oldImage").val(img);
            $("#currentImgText").text("Ảnh hiện tại: " + img);
            $("#modalDanhMuc").modal("show");
        });
    });

    function confirmDelete(id) {
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
                window.location.href = "${pageContext.request.contextPath}/admin/category-manage?action=delete&id=" + id;
            }
        });
    }
</script>
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
</script>
</body>
</html>