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
        .drag-handle {
            cursor: grab;
            transition: color 0.2s, transform 0.2s;
        }
        .drag-handle:hover {
            color: #0d6efd !important;
            transform: scale(1.15);
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
    <jsp:include page="sidebar.jsp">
        <jsp:param name="activePage" value="category"/>
    </jsp:include>
    <main class="main-content container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="text-primary fw-bold"><i class="bi bi-tags"></i> Quản Lý Danh Mục</h4>
            <div class="d-flex align-items-center gap-2">
                <form class="d-flex" role="search" style="max-width: 300px;">
                    <input type="hidden" name="_csrf" value="${sessionScope.CSRF_TOKEN}">
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
        <table id="tableDanhMuc" class="table table-striped table-bordered align-middle">
            <thead class="table-primary text-center">
            <tr>
                <th style="width: 80px;">Di chuyển</th>
                <th style="width: 90px;">Mã DM</th>
                <th>Tên Danh Mục</th>
                <th>Sản phẩm hoạt động</th>
                <th style="width: 120px;">Ảnh Đại Diện</th>
                <th style="width: 130px;">Trạng Thái</th>
                <th style="width: 120px;">Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${categories}" var="c">
                <tr data-id="${c.id}">
                    <td class="text-center align-middle">
                        <i class="bi bi-grip-vertical drag-handle text-muted fs-4" style="cursor: grab;" title="Kéo thả để sắp xếp"></i>
                    </td>
                    <td class="text-center align-middle">${c.id}</td>
                    <td class="align-middle fw-semibold text-dark">${c.categoryName}</td>
                    <td class="text-center align-middle">
                        <span class="badge bg-info text-dark px-3 py-2 fs-7 rounded-pill">${c.productCount} sản phẩm</span>
                    </td>
                    <td class="text-center align-middle">
                        <img src="${pageContext.request.contextPath}/${c.image}" alt="Ảnh danh mục"
                             class="img-thumbnail" style="width: 60px; height: 60px; object-fit: cover;">
                        <input type="hidden" class="img-path" value="${c.image}">
                    </td>
                    <td class="text-center align-middle">
                        <div class="form-check form-switch d-inline-block">
                            <input class="form-check-input status-toggle" type="checkbox" role="switch"
                                   data-id="${c.id}" ${c.status == 'Hiện' ? 'checked' : ''} style="cursor: pointer; width: 2.5em; height: 1.25em;">
                        </div>
                    </td>
                    <td class="text-center align-middle">
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
                    <input type="hidden" name="_csrf" value="${sessionScope.CSRF_TOKEN}">
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
                            <img id="previewImg" src="" alt="Preview" class="img-thumbnail mt-2"
                                 style="width: 100px; height: 100px; object-fit: cover; display: none;">
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
    const CSRF_TOKEN = "${sessionScope.CSRF_TOKEN}";
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
            columnDefs: [
                { orderable: false, targets: [0, 4, 5, 6] }
            ],
            language: {
                zeroRecords: "Không tìm thấy kết quả"
            }
        });
        let sortable;

        function enableDragSort() {
            table.page.len(-1).draw();
            if (sortable) return;
            Swal.fire({
                icon: "info",
                title: "Chế độ kéo thả đã kích hoạt",
                text: "Hãy nhấp giữ biểu tượng tay nắm ✥ ở đầu mỗi hàng và di chuyển để sắp xếp danh mục.",
                timer: 3500,
                timerProgressBar: true,
                showConfirmButton: false,
                position: "top-end",
                toast: true
            });

            sortable = new Sortable(document.querySelector("#tableDanhMuc tbody"), {
                animation: 150,
                handle: ".drag-handle",
                ghostClass: "table-warning",
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
                        title: 'Đã lưu thứ tự hiển thị mới!'
                    });
                },
                error: function () {
                    Swal.fire("Lỗi", "Không thể lưu thứ tự sắp xếp", "error");
                }
            });
        }

        $("#sortSelect").change(function () {
            let value = $(this).val();
            disableDragSort();
            allowSaveOrder = true;
            switch (value) {
                case "name-asc":
                    table.order([2, 'asc']).draw();
                    break;
                case "name-desc":
                    table.order([2, 'desc']).draw();
                    break;
                case "id-asc":
                    table.order([1, 'asc']).draw();
                    break;
                case "id-desc":
                    table.order([1, 'desc']).draw();
                    break;
                case "custom":
                    table.order([]).draw();
                    enableDragSort();
                    break;
            }
        });
        $(document).on("change", ".status-toggle", function() {
            let checkbox = $(this);
            let id = checkbox.data("id");
            let status = checkbox.is(":checked") ? "Hiện" : "Ẩn";
            checkbox.prop("disabled", true);
            $.ajax({
                url: "${pageContext.request.contextPath}/admin/category-toggle-status",
                method: "POST",
                contentType: "application/json",
                headers: {
                    "X-CSRF-Token": CSRF_TOKEN
                },
                data: JSON.stringify({ id: id, status: status }),
                success: function(response) {
                    checkbox.prop("disabled", false);
                    if (response.success) {
                        const Toast = Swal.mixin({
                            toast: true,
                            position: 'top-end',
                            showConfirmButton: false,
                            timer: 2000,
                            timerProgressBar: true
                        });
                        Toast.fire({
                            icon: 'success',
                            title: 'Cập nhật trạng thái thành công!'
                        });
                    } else {
                        Swal.fire("Lỗi", response.message || "Cập nhật thất bại", "error");
                        checkbox.prop("checked", !checkbox.is(":checked"));
                    }
                },
                error: function() {
                    checkbox.prop("disabled", false);
                    Swal.fire("Lỗi", "Không thể kết nối đến máy chủ", "error");
                    checkbox.prop("checked", !checkbox.is(":checked"));
                }
            });
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
            $("#previewImg").attr("src", "").hide();
            $("#anhDM").attr("required", true);

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
            $("#previewImg")
                .attr("src", "${pageContext.request.contextPath}/" + encodeURI(img))
                    .show();
            $("#modalDanhMuc").modal("show");
        });

        $("#anhDM").on("change", function () {

            const file = this.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    $("#previewImg").attr("src", e.target.result).show();
                };
                reader.readAsDataURL(file);
            }
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
    (function () {
        const params = new URLSearchParams(window.location.search);
        const success = params.get("success");
        const error   = params.get("error");

        const messages = {
            added:   { icon: "success", title: "Thêm thành công!",     text: "Danh mục đã được thêm vào hệ thống." },
            updated: { icon: "success", title: "Cập nhật thành công!", text: "Thông tin danh mục đã được cập nhật." },
            deleted: { icon: "success", title: "Xóa thành công!",      text: "Danh mục đã được xóa khỏi hệ thống." },
        };

        let cfg = null;
        if (success && messages[success]) cfg = messages[success];
        else if (error) cfg = { icon: "error", title: "Có lỗi xảy ra!", text: error || "Vui lòng thử lại." };

        if (cfg) {
            Swal.fire({
                icon: cfg.icon,
                title: cfg.title,
                text: cfg.text,
                timer: 3000,
                timerProgressBar: true,
                showConfirmButton: false,
                position: "center"
            });

            const url = new URL(window.location.href);
            url.searchParams.delete("success");
            url.searchParams.delete("error");
            window.history.replaceState({}, "", url.toString());
        }
    })();
</script>
<script>

</script>
</body>
</html>