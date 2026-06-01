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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/stylesheets/admin/uncomfirmed-order-manage.css">
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
                <a href="${pageContext.request.contextPath}/Logout">
                    <button id="confirmLogout" class="confirm">Có</button>
                </a>
                <button id="cancelLogout" class="cancel">Không</button>
            </div>
        </div>
    </div>
</header>
<div class="layout">
    <jsp:include page="sidebar.jsp">
        <jsp:param name="activePage" value="orders"/>
        <jsp:param name="activeSubPage" value="unconfirmed"/>
    </jsp:include>
    <main class="main-content container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="text-primary fw-bold mb-0">
                <i class="bi bi-receipt-cutoff"></i> Quản Lý Đơn Hàng
            </h4>
            <a href="${pageContext.request.contextPath}/admin/rejected-orders" class="btn btn-outline-danger shadow-sm">
                <i class="bi bi-shield-x"></i> Đơn hàng bị từ chối
            </a>
        </div>
        <div class="card border-0 shadow-sm mb-3" style="background: linear-gradient(135deg,#f8f9ff 0%,#eef2ff 100%);">
            <div class="card-body py-3">
                <div class="row g-3 align-items-end">
                    <div class="col-12 col-sm-auto">
                        <label class="form-label fw-semibold mb-1" style="color:#3a3a6a;"><i class="bi bi-calendar-range me-1 text-primary"></i>Khoảng thời gian</label>
                        <div class="d-flex align-items-center gap-2">
                            <input type="date" id="filterDateFrom" class="form-control form-control-sm" style="min-width:140px;" title="Từ ngày">
                            <span class="text-muted fw-bold">–</span>
                            <input type="date" id="filterDateTo" class="form-control form-control-sm" style="min-width:140px;" title="Đến ngày">
                        </div>
                    </div>
                    <div class="col-12 col-sm-auto">
                        <label class="form-label fw-semibold mb-1" style="color:#3a3a6a;"><i class="bi bi-credit-card me-1 text-primary"></i>Trạng thái thanh toán</label>
                        <select id="filterPayment" class="form-select form-select-sm" style="min-width:190px;">
                            <option value="all">Tất cả</option>
                            <option value="paid">Đã thanh toán (Online)</option>
                            <option value="cod">Chưa thanh toán (COD)</option>
                        </select>
                    </div>
                    <div class="col-12 col-sm-auto">
                        <label class="form-label fw-semibold mb-1" style="color:#3a3a6a;"><i class="bi bi-search me-1 text-primary"></i>Tìm kiếm</label>
                        <input id="searchInput" type="search" class="form-control form-control-sm" placeholder="Tìm theo mã, tên..." style="min-width:200px;">
                    </div>
                    <div class="col-12 col-sm-auto">
                        <button id="btnResetFilter" class="btn btn-outline-secondary btn-sm" title="Xoá bộ lọc">
                            <i class="bi bi-arrow-counterclockwise"></i> Đặt lại
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div class="d-flex justify-content-between align-items-center mb-2">
            <div class="d-flex align-items-center gap-2">
                <button id="batchConfirmBtn" class="btn btn-success btn-sm" disabled>
                    <i class="bi bi-check-all"></i> Xác nhận đã chọn
                </button>
                <button id="batchCancelBtn" class="btn btn-danger btn-sm" disabled>
                    <i class="bi bi-x-circle"></i> Từ chối đã chọn
                </button>
            </div>
            <div class="d-flex justify-content-end align-items-center">
                <label class="me-2">Hiển thị</label>
                <select id="rowsPerPage" class="form-select d-inline-block" style="width:80px;">
                    <option value="5">5</option>
                    <option value="10" selected>10</option>
                    <option value="20">20</option>
                </select>
                <label class="ms-2">đơn hàng</label>
            </div>
        </div>
        <table id="tableDonHang" class="table table-striped table-bordered align-middle">
            <thead class="table-primary">
            <tr>
                <th class="text-center" style="width: 40px;">
                    <input type="checkbox" class="form-check-input" id="selectAll">
                </th>
                <th>Mã Hóa Đơn</th>
                <th>Tên Khách Hàng</th>
                <th>Số Điện Thoại</th>
                <th>Ngày Lập Đơn</th>
                <th>Tổng Tiền</th>
                <th>Trạng Thái Thanh Toán</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${orders}" var="o">
                <tr data-date="<fmt:formatDate value="${o.createdAt}" pattern="yyyy-MM-dd"/>" data-payment="${o.paymentMethod}">
                    <td class="text-center">
                        <input type="checkbox" class="form-check-input order-checkbox" value="${o.id}">
                    </td>
                    <td>${o.id}</td>
                    <td>${o.customerName}</td>
                    <td>${o.phoneNumber}</td>
                    <td>
                        <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                    </td>
                    <fmt:setLocale value="vi_VN"/>
                    <td>
                        <fmt:formatNumber value="${o.totalPrice}" pattern="#,##0 VNĐ"/>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${o.paymentMethod eq 'COD' or empty o.paymentMethod}">
                                <span class="badge bg-warning text-dark"><i class="bi bi-cash-coin me-1"></i>COD - Chưa TT</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-success"><i class="bi bi-credit-card me-1"></i>Đã thanh toán</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <button class="btn btn-info btn-sm" data-id="${o.id}"
                                onclick="loadOrderDetail(${o.id})">
                            <i class="bi bi-eye"></i> Xem Chi Tiết
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
<div class="modal fade" id="modalChiTietDonHang">
    <div class="modal-dialog modal-xl">
        <div class="modal-content shadow-lg border-0 rounded-4 overflow-hidden">
            <div class="modal-header bg-gradient bg-primary text-white">
                <h5 class="modal-title d-flex align-items-center gap-2">
                    <i class="bi bi-file-earmark-text"></i> Chi Tiết Đơn Hàng
                </h5>
                <button type="button" class="btn-close btn-close-white"
                        data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm rounded-4">
                            <div class="card-body">
                                <h6 class="fw-bold text-primary mb-2">Thông tin hóa đơn</h6>
                                <table class="table table-sm table-borderless mb-3">
                                    <tbody>
                                    <tr>
                                        <th>Mã hóa đơn:</th>
                                        <td><span id="md_orderCode">---</span></td>
                                    </tr>
                                    <tr>
                                        <th>Tên khách hàng:</th>
                                        <td><span id="md_customerName">---</span></td>
                                    </tr>
                                    <tr>
                                        <th>Số điện thoại:</th>
                                        <td><span id="md_phone">---</span></td>
                                    </tr>
                                    <tr>
                                        <th>Email:</th>
                                        <td><span id="md_email">---</span></td>
                                    </tr>
                                    <tr>
                                        <th>Ngày lập đơn:</th>
                                        <td><span id="md_createdAt">---</span></td>
                                    </tr>
                                    <tr>
                                        <th>Tổng tiền:</th>
                                        <td>
                                                                <span id="md_totalPrice"
                                                                      class="fw-bold text-danger">---</span>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                                <h6 class="fw-bold text-primary mb-2">Thông tin giao hàng</h6>
                                <table class="table table-sm table-borderless">
                                    <tbody>
                                    <tr>
                                        <th>Địa chỉ giao:</th>
                                        <td><span id="md_address">---</span></td>
                                    </tr>
                                    <tr>
                                        <th>Mã vận đơn:</th>
                                        <td><span id="md_shippingCode">---</span></td>
                                    </tr>
                                    <tr>
                                        <th>Ngày giao/nhận:</th>
                                        <td><span id="md_completedAt">---</span></td>
                                    </tr>
                                    <tr>
                                        <th>Phí vận chuyển:</th>
                                        <td><span id="md_shippingFee">---</span></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card border-0 shadow-sm rounded-4">
                            <div class="card-body">
                                <h6 class="fw-bold text-primary mb-2">Sản phẩm trong đơn</h6>
                                <table class="table table-bordered align-middle text-center small">
                                    <thead class="table-light">
                                    <tr>
                                        <th>Tên sản phẩm</th>
                                        <th>SL</th>
                                        <th>Giá</th>
                                    </tr>
                                    </thead>
                                    <tbody id="md_productList">
                                    </tbody>
                                </table>
                                <h6 class="fw-bold text-primary mt-3 mb-2">Thanh toán & Trạng thái</h6>
                                <table class="table table-sm table-borderless">
                                    <tbody>
                                    <tr>
                                        <th>Hình thức TT:</th>
                                        <td><span id="md_paymentMethod">---</span></td>
                                    </tr>
                                    <tr>
                                        <th>Trạng thái TT:</th>
                                        <td><span id="md_paymentStatus">---</span></td>
                                    </tr>
                                    <tr>
                                        <th>Trạng thái VC:</th>
                                        <td><span id="md_orderStatus">---</span></td>
                                    </tr>
                                    <tr>
                                        <th>Ghi chú:</th>
                                        <td><span id="md_note">---</span></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer bg-light d-flex justify-content-between">
                <div class="text-muted small fst-italic">Kiểm tra kỹ trước khi xác nhận đơn hàng.</div>
                <div>
                    <button id="cancelBtn" class="btn btn-outline-danger">
                        <i class="bi bi-x-circle"></i> Từ Chối
                    </button>
                    <button id="confirmBtn" class="btn btn-success">
                        <i class="bi bi-check-circle"></i> Xác Nhận
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    const CSRF_TOKEN = "${sessionScope.CSRF_TOKEN}";
    let currentOrderId = null;

    function loadOrderDetail(orderId) {
        currentOrderId = orderId;
        fetch('${pageContext.request.contextPath}/admin/order-detail?id=' + orderId)
            .then(res => {
                if (!res.ok) throw new Error("HTTP " + res.status);
                return res.json();
            })
            .then(data => {
                if (!data || !data.items) {
                    alert("Không có dữ liệu đơn hàng");
                    return;
                }
                const o = data.order;
                document.getElementById("md_orderCode").innerText = o.id;
                document.getElementById("md_customerName").innerText = o.customerName;
                document.getElementById("md_phone").innerText = o.phoneNumber;
                document.getElementById("md_email").innerText = o.email || "---";
                document.getElementById("md_createdAt").innerText = formatDate(o.createdAt);
                document.getElementById("md_totalPrice").innerText =
                    Number(o.totalPrice).toLocaleString("vi-VN") + " VNĐ";
                document.getElementById("md_address").innerText = o.fullAddress || "---";
                document.getElementById("md_shippingCode").innerText =
                    o.shippingCode || "Chưa có";
                document.getElementById("md_completedAt").innerText =
                    o.completedAt ? formatDate(o.completedAt) : "Chưa giao";
                document.getElementById("md_shippingFee").innerText =
                    o.shippingFee ? Number(o.shippingFee).toLocaleString("vi-VN") + " VNĐ" : "0 VNĐ";
                const items = data.items;
                const tbody = document.getElementById("md_productList");
                tbody.innerHTML = "";
                items.forEach(item => {
                    const tr = document.createElement("tr");
                    const tdName = document.createElement("td");
                    const imgSrc = item.imageUrl
                        ? (item.imageUrl.startsWith('http') ? item.imageUrl : '${pageContext.request.contextPath}/' + item.imageUrl)
                        : '${pageContext.request.contextPath}/image/logoTCN.png';
                    tdName.innerHTML =
                        '<div class="d-flex align-items-center justify-content-start gap-2 text-start">' +
                        '<img src="' + imgSrc + '" style="width:40px;height:40px;object-fit:cover;border-radius:4px;border:1px solid #ddd;" />' +
                        '<span class="text-truncate" style="max-width: 250px;" title="' + (item.productName || '---') + '">' + (item.productName || '---') + '</span>' +
                        '</div>';
                    tr.appendChild(tdName);
                    const tdQty = document.createElement("td");
                    tdQty.textContent = item.quantity != null ? item.quantity : "0";
                    tr.appendChild(tdQty);
                    const tdPrice = document.createElement("td");
                    const priceNum = parseFloat(item.price) || 0;
                    tdPrice.textContent = priceNum.toLocaleString("vi-VN") + " VNĐ";
                    tr.appendChild(tdPrice);
                    tbody.appendChild(tr);
                });
                document.getElementById("md_paymentMethod").innerText =
                    o.paymentMethod || "COD";
                document.getElementById("md_paymentStatus").innerText =
                    o.paymentMethod ? "Đã thanh toán" : "Chưa thanh toán";
                document.getElementById("md_orderStatus").innerText = o.status;
                document.getElementById("md_note").innerText = o.note || "---";
                const modal = new bootstrap.Modal(
                    document.getElementById("modalChiTietDonHang")
                );
                modal.show();
            })
            .catch(err => {
                (function(){})(err);
                alert("Lỗi tải chi tiết đơn hàng");
            });
    }

    function formatDate(dateStr) {
        const d = new Date(dateStr);
        return d.toLocaleDateString("vi-VN");
    }

    function handleOrderAction(orderId, action, note) {
        const params = new URLSearchParams();
        params.append('id', orderId);
        params.append('action', action);
        if (note) params.append('note', note);
        Swal.fire({
            title: "Đang xử lý...",
            text: "Vui lòng chờ trong giây lát",
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });
        fetch('${pageContext.request.contextPath}/admin/order-action', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                "X-CSRF-Token": CSRF_TOKEN
            },
            body: params.toString()
        })
            .then(res => res.json())
            .then(data => {
                Swal.close();
                if (data.success) {
                    Swal.fire({
                        title: "Thành công!",
                        text: "Trạng thái đơn hàng đã được cập nhật",
                        icon: "success",
                        confirmButtonColor: "#0d6efd"
                    });
                    const table = $('#tableDonHang').DataTable();
                    table
                        .row($('#tableDonHang button[data-id="' + orderId + '"]').parents('tr'))
                        .remove()
                        .draw();
                    const modal = bootstrap.Modal.getInstance(
                        document.getElementById('modalChiTietDonHang')
                    );
                    if (modal) modal.hide();
                } else {
                    Swal.fire({
                        title: "Thất bại!",
                        text: "Không thể cập nhật đơn hàng",
                        icon: "error",
                        confirmButtonColor: "#dc3545"
                    });
                }
            })
            .catch(err => {
                Swal.close();
                (function(){})("Error:", err);
                Swal.fire({
                    title: "Lỗi kết nối!",
                    text: "Không thể kết nối đến server",
                    icon: "error",
                    confirmButtonColor: "#dc3545"
                });
            });
    }

    $(document).ready(function () {
        // Lọc theo ngày và thanh toán
        $.fn.dataTable.ext.search.push(function(settings, data, dataIndex) {
            if (settings.nTable.id !== 'tableDonHang') return true;
            const dateFrom = $("#filterDateFrom").val();
            const dateTo   = $("#filterDateTo").val();
            const payment  = $("#filterPayment").val();
            const row        = settings.aoData[dataIndex].nTr;
            const rowDate    = $(row).data('date') || '';
            const rowPayment = ($(row).data('payment') || '').toUpperCase();
            if (dateFrom && rowDate < dateFrom) return false;
            if (dateTo   && rowDate > dateTo)   return false;
            if (payment === 'cod'  && rowPayment !== 'COD' && rowPayment !== '') return false;
            if (payment === 'paid' && (rowPayment === 'COD' || rowPayment === '')) return false;
            return true;
        });
        var table = $('#tableDonHang').DataTable({
            paging: true,
            info: false,
            lengthChange: false,
            searching: true,
            pageLength: 10,
            order: [[1, "desc"]],
            columnDefs: [
                { orderable: false, targets: 0 }
            ],
            language: {
                zeroRecords: "Không tìm thấy kết quả",
                paginate: {previous: "Trước", next: "Sau"}
            },
            dom: 't',
        });
        $("#selectAll").on("change", function() {
            $(".order-checkbox").prop("checked", this.checked);
            updateBatchButtons();
        });
        $(document).on("change", ".order-checkbox", function() {
            let total = $(".order-checkbox").length;
            let checked = $(".order-checkbox:checked").length;
            $("#selectAll").prop("checked", total === checked && total > 0);
            updateBatchButtons();
        });
        function updateBatchButtons() {
            let checkedCount = $(".order-checkbox:checked").length;
            $("#batchConfirmBtn, #batchCancelBtn").prop("disabled", checkedCount === 0);
        }
        function handleBatchAction(action, note) {
            let ids = [];
            $(".order-checkbox:checked").each(function() {
                ids.push($(this).val());
            });
            if (ids.length === 0) return;
            const params = new URLSearchParams();
            params.append('ids', ids.join(','));
            params.append('action', action);
            if (note) params.append('note', note);
            Swal.fire({
                title: "Đang xử lý...",
                text: "Vui lòng chờ trong giây lát",
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
            fetch('${pageContext.request.contextPath}/admin/order-action', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    "X-CSRF-Token": CSRF_TOKEN
                },
                body: params.toString()
            })
            .then(res => res.json())
            .then(data => {
                Swal.close();
                if (data.success) {
                    Swal.fire({
                        title: "Thành công!",
                        text: "Đã xử lý các đơn hàng được chọn",
                        icon: "success",
                        confirmButtonColor: "#0d6efd"
                    }).then(() => {
                        location.reload();
                    });
                } else {
                    Swal.fire("Thất bại!", "Có lỗi xảy ra", "error");
                }
            })
            .catch(err => {
                Swal.close();
                Swal.fire("Lỗi kết nối!", "Không thể kết nối đến server", "error");
            });
        }
        $("#batchConfirmBtn").on("click", function() {
            Swal.fire({
                title: "Xác nhận hàng loạt?",
                text: "Bạn có chắc chắn muốn xác nhận các đơn hàng đã chọn?",
                icon: "question",
                showCancelButton: true,
                confirmButtonText: "Xác nhận",
                cancelButtonText: "Hủy",
                confirmButtonColor: "#198754",
                cancelButtonColor: "#6c757d"
            }).then((result) => {
                if (result.isConfirmed) {
                    handleBatchAction("batch-confirm");
                }
            });
        });
        $("#batchCancelBtn").on("click", function() {
            Swal.fire({
                title: "Từ chối hàng loạt?",
                text: "Vui lòng nhập lý do từ chối chung cho các đơn hàng này:",
                input: "textarea",
                icon: "warning",
                showCancelButton: true,
                confirmButtonText: "Từ chối",
                cancelButtonText: "Hủy",
                confirmButtonColor: "#dc3545",
                cancelButtonColor: "#6c757d",
                preConfirm: (noteValue) => {
                    if (!noteValue || noteValue.trim().length === 0) {
                        Swal.showValidationMessage('Bạn cần nhập lý do từ chối!');
                    }
                    return noteValue;
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    handleBatchAction("batch-cancel", result.value.trim());
                }
            });
        });

        function updatePageInfo() {
            var info = table.page.info();
            $("#pageInfo").text((info.page + 1) + " / " + info.pages);
        }

        updatePageInfo();
        $("#prevPage").click(function () {
            table.page('previous').draw('page');
            updatePageInfo();
        });
        $("#nextPage").click(function () {
            table.page('next').draw('page');
            updatePageInfo();
        });
        $("#searchInput").on("keyup", function () {
            let value = $(this).val();
            table.search(value).draw();
            updatePageInfo();
        });
        $("#rowsPerPage").change(function () {
            var value = $(this).val();
            table.page.len(value).draw();
            updatePageInfo();
        });
        // Lọc nâng cao: ngày và thanh toán
        $("#filterDateFrom, #filterDateTo, #filterPayment").on("change", function () {
            table.draw();
            updatePageInfo();
        });
        // Đặt lại bộ lọc
        $("#btnResetFilter").on("click", function () {
            $("#filterDateFrom").val('');
            $("#filterDateTo").val('');
            $("#filterPayment").val('all');
            $("#searchInput").val('');
            table.search('').draw();
            updatePageInfo();
        });
        table.on('draw', function () {
            updatePageInfo();
            $("#selectAll").prop("checked", false);
            updateBatchButtons();
        });
        $("#confirmBtn").on("click", function () {
            if (!currentOrderId) {
                Swal.fire({
                    icon: "error",
                    title: "Lỗi",
                    text: "Không xác định được đơn hàng",
                    confirmButtonColor: "#0d6efd"
                });
                return;
            }
            Swal.fire({
                title: "Xác nhận đơn hàng?",
                text: "Bạn có chắc chắn muốn xác nhận đơn hàng này?",
                icon: "question",
                showCancelButton: true,
                confirmButtonText: "Xác nhận",
                cancelButtonText: "Hủy",
                confirmButtonColor: "#198754",
                cancelButtonColor: "#6c757d"
            }).then((result) => {
                if (result.isConfirmed) {
                    handleOrderAction(currentOrderId, "confirm");
                }
            });
        });
        $("#cancelBtn").on("click", function () {
            if (!currentOrderId) {
                Swal.fire({
                    icon: "error",
                    title: "Lỗi",
                    text: "Không xác định được đơn hàng",
                    confirmButtonColor: "#0d6efd"
                });
                return;
            }
            const modalEl = document.getElementById('modalChiTietDonHang');
            const bsModal = bootstrap.Modal.getInstance(modalEl);
            if (bsModal) {
                bsModal.hide();
            }
            setTimeout(() => {
                Swal.fire({
                    title: "Từ chối đơn hàng?",
                    text: "Vui lòng nhập lý do từ chối đơn hàng này (sẽ gửi cho khách hàng):",
                    input: "textarea",
                    inputPlaceholder: "Ví dụ: Hết hàng, không liên lạc được, v.v.",
                    inputAttributes: {
                        "aria-label": "Nhập lý do từ chối"
                    },
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonText: "Xác Nhận Từ Chối",
                    cancelButtonText: "Hủy",
                    confirmButtonColor: "#dc3545",
                    cancelButtonColor: "#6c757d",
                    preConfirm: (noteValue) => {
                        if (!noteValue || noteValue.trim().length === 0) {
                            Swal.showValidationMessage('Bạn cần nhập lý do từ chối!');
                        }
                        return noteValue;
                    }
                }).then((result) => {
                    if (result.isConfirmed) {
                        handleOrderAction(currentOrderId, "cancel", result.value.trim());
                    }
                });
            }, 300);
        });
        $("#logoutBtn").on("click", function () {
            $("#logoutModal").css("display", "flex");
        });
        $("#cancelLogout").on("click", function () {
            $("#logoutModal").hide();
        });
    });
</script>
</body>

</html>