<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Trang Thống Kê - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/statistics.css?v=1.5">
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .main-content {
            width: 100%;
            max-width: 100%;
            min-width: 0 !important;
        }

        .chart-box-fix {
            position: relative;
            width: 100%;
            min-height: 250px;
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
           class="text-decoration-none text-white">
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
        <jsp:param name="activePage" value="statistics"/>
    </jsp:include>
    <main class="main-content flex-fill container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap">
            <h4 class="m-0 mb-2 text-primary fw-bold"><i class="bi bi-clipboard2-data"></i> Khởi Tạo Báo Cáo</h4>
            <a href="${pageContext.request.contextPath}/admin/statistics/export?startDate=${startDate}&endDate=${endDate}"
               class="btn btn-success fw-semibold shadow-sm mb-2">
                <i class="bi bi-file-earmark-excel"></i> Xuất Báo Cáo Excel
            </a>
        </div>
        <div class="card shadow-sm mb-4 border-0">
            <div class="card-body">
                <h5 class="card-title fw-bold text-secondary mb-3"><i class="bi bi-funnel-fill"></i> Bộ Lọc Dữ Liệu</h5>
                <form action="${pageContext.request.contextPath}/admin/statistics" method="GET"
                      class="row gx-3 gy-2 align-items-center m-0">
                    <input type="hidden" name="_csrf" value="${sessionScope.CSRF_TOKEN}">
                    <div class="col-sm-auto">
                        <label class="fw-semibold text-secondary">Từ ngày:</label>
                        <input type="date" name="startDate" class="form-control mt-1" value="${startDate}" required>
                    </div>
                    <div class="col-sm-auto">
                        <label class="fw-semibold text-secondary">Đến ngày:</label>
                        <input type="date" name="endDate" class="form-control mt-1" value="${endDate}" required>
                    </div>
                    <div class="col-sm-auto ms-auto d-flex align-items-end pt-4">
                        <button type="submit" class="btn btn-primary px-4"><i class="bi bi-filter"></i> Áp Dụng Lọc
                        </button>
                    </div>
                </form>
            </div>
        </div>
        <section class="mb-5">
            <h5 class="text-primary fw-bold mb-3"><i class="bi bi-wallet2"></i> Tổng Quan Doanh Thu Khoảng Lọc</h5>
            <div class="row g-4">
                <div class="col-md-6 col-lg-4">
                    <div class="card border-0 shadow-sm h-100 p-3 text-center"
                         style="background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);">
                        <div class="mb-2"><i class="bi bi-calendar-day fs-1 text-warning"></i></div>
                        <h6 class="text-warning fw-bold">DOANH THU HÔM NAY</h6>
                        <h3 class="fw-bolder text-warning mb-0">
                            <fmt:formatNumber value="${revenueToday}" pattern="#,##0 VNĐ"/>
                        </h3>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="card border-0 shadow-sm h-100 p-3 text-center"
                         style="background: linear-gradient(135deg, #ede9fe 0%, #ddd6fe 100%);">
                        <div class="mb-2"><i class="bi bi-calendar-month fs-1" style="color:#7c3aed"></i></div>
                        <h6 class="fw-bold" style="color:#7c3aed">DOANH THU THÁNG NÀY</h6>
                        <h3 class="fw-bolder mb-0" style="color:#7c3aed">
                            <fmt:formatNumber value="${revenueThisMonth}" pattern="#,##0 VNĐ"/>
                        </h3>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="card border-0 shadow-sm h-100 p-3 text-center"
                         style="background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);">
                        <div class="mb-2"><i class="bi bi-bag-check fs-1 text-danger"></i></div>
                        <h6 class="text-danger fw-bold">ĐƠN HÔM NAY</h6>
                        <h3 class="fw-bolder text-danger mb-0">${ordersToday} Đơn</h3>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="card border-0 shadow-sm h-100 p-3 text-center"
                         style="background: linear-gradient(135deg, #d1fae5 0%, #6ee7b7 100%);">
                        <div class="mb-2"><i class="bi bi-star-fill fs-1 text-success"></i></div>
                        <h6 class="text-success fw-bold">SẢN PHẨM BÁN CHẠY HÔM NAY</h6>
                        <h5 class="fw-bolder text-success mb-0">${bestSellerToday}</h5>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="card border-0 shadow-sm h-100 p-3 text-center"
                         style="background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);">
                        <div class="mb-2"><i class="bi bi-cash-coin fs-1 text-success"></i></div>
                        <h6 class="text-success fw-bold">TỔNG DOANH THU</h6>
                        <h3 class="fw-bolder text-success mb-0"><fmt:formatNumber value="${revenueInRange}"
                                                                                  pattern="#,##0 VNĐ"/></h3>
                    </div>
                </div>
                <div class="col-md-6 col-lg-4">
                    <div class="card border-0 shadow-sm h-100 p-3 text-center"
                         style="background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);">
                        <div class="mb-2"><i class="bi bi-box-seam fs-1 text-primary"></i></div>
                        <h6 class="text-primary fw-bold">TỔNG ĐƠN HÀNG THÀNH CÔNG</h6>
                        <h3 class="fw-bolder text-primary mb-0">${ordersCountInRange} Đơn</h3>
                    </div>
                </div>
            </div>
        </section>
        <section class="mb-5">
            <h5 class="text-primary fw-bold mb-3"><i class="bi bi-cart-check"></i> Đơn Hàng Giao Dịch Trong Khoảng</h5>
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="d-flex align-items-center gap-2">
                    <label class="fw-semibold text-secondary">Hiển thị:</label>
                    <select id="rowsPerPage" class="form-select d-inline-block" style="width:auto;">
                        <option value="5">5</option>
                        <option value="10" selected>10</option>
                        <option value="20">20</option>
                        <option value="50">50</option>
                    </select>
                </div>
                <div class="input-group" style="max-width: 300px;">
                    <span class="input-group-text bg-white border-end-0"><i class="bi bi-search text-muted"></i></span>
                    <input id="searchBox" type="text" class="form-control border-start-0 ps-0"
                           placeholder="Tìm kiếm đơn hàng...">
                </div>
            </div>
            <div class="card shadow-sm border-0">
                <div class="table-responsive">
                    <table id="tableDonTrongNgay" class="table table-hover align-middle text-center mb-0"
                           style="min-width: 800px;">
                        <thead class="table-light text-secondary">
                        <tr>
                            <th class="py-3">Mã Đơn</th>
                            <th class="py-3">Khách Hàng</th>
                            <th class="py-3">Ngày Đặt</th>
                            <th class="py-3">Tổng Tiền</th>
                            <th class="py-3">Trạng Thái</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="o" items="${ordersInRange}">
                            <tr>
                                <td class="fw-bold">#${o.id}</td>
                                <td>${o.customerName}</td>
                                <td><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td class="fw-bold text-danger"><fmt:formatNumber value="${o.totalPrice}"
                                                                                  pattern="#,##0 VNĐ"/></td>
                                <td><span class="badge ${o.statusClass} px-3 py-2 rounded-pill">${o.statusLabel}</span>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
        <div class="row g-4 mb-5">
            <div class="col-xl-6">
                <h5 class="text-primary fw-bold mb-3"><i class="bi bi-trophy"></i> Top Sản Phẩm Bán Chạy Nhất</h5>
                <div class="card shadow-sm h-100 border-0">
                    <c:choose>
                        <c:when test="${empty topSellingProducts}">
                            <div class="card-body text-center py-5 text-muted">
                                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                                <span>Chưa có dữ liệu sản phẩm</span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0" style="min-width: 500px;">
                                    <thead class="table-light">
                                    <tr>
                                        <th class="text-center" style="width:80px;">Hạng</th>
                                        <th>Tên Sản Phẩm</th>
                                        <th class="text-center">Đã Bán</th>
                                        <th class="text-end pe-4">Doanh Thu</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="p" items="${topSellingProducts}" varStatus="st">
                                        <tr>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${st.index == 0}"><span
                                                            class="badge bg-warning text-dark px-2 py-1 fs-6 rounded-circle">1</span></c:when>
                                                    <c:when test="${st.index == 1}"><span
                                                            class="badge bg-secondary px-2 py-1 fs-6 rounded-circle">2</span></c:when>
                                                    <c:when test="${st.index == 2}"><span
                                                            class="badge px-2 py-1 fs-6 rounded-circle"
                                                            style="background:#cd7f32;">3</span></c:when>
                                                    <c:otherwise><span
                                                            class="badge bg-light text-secondary px-2 py-1 fs-6 rounded-circle border">${st.index + 1}</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="fw-semibold">${p.productName}</td>
                                            <td class="text-center fw-bold text-primary">${p.totalSold}</td>
                                            <td class="text-end fw-bold text-success pe-4"><fmt:formatNumber
                                                    value="${p.totalRevenue}" pattern="#,##0 đ"/></td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="col-xl-6">
                <h5 class="text-primary fw-bold mb-3"><i class="bi bi-exclamation-triangle"></i> Sản Phẩm Không Bán Chạy
                </h5>
                <div class="card shadow-sm h-100 border-0">
                    <c:choose>
                        <c:when test="${empty lowPerformingProducts}">
                            <div class="card-body text-center py-5 text-muted">
                                <i class="bi bi-check-circle fs-1 d-block mb-3 text-success"></i>
                                <span>Tất cả sản phẩm đều bán tốt</span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0" style="min-width: 400px;">
                                    <thead class="table-light">
                                    <tr>
                                        <th>Tên Sản Phẩm</th>
                                        <th class="text-center">Số Lượng Tiêu Thụ</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="p" items="${lowPerformingProducts}">
                                        <tr>
                                            <td class="fw-semibold">${p.productName}</td>
                                            <td class="text-center fw-bold text-danger">${p.totalSold}</td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <section class="mb-5">
            <h5 class="text-primary fw-bold mb-3"><i class="bi bi-star-fill text-warning"></i> Khách Hàng Tiêu Biểu Bậc
                Nhất</h5>
            <div class="card shadow-sm border-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle text-center mb-0" style="min-width: 700px;">
                        <thead class="table-light">
                        <tr>
                            <th class="py-3 text-start ps-4">Họ Tên</th>
                            <th class="py-3">Email</th>
                            <th class="py-3">Tần Suất Đơn</th>
                            <th class="py-3 text-end pe-4">Tổng Đóng Góp</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty topCustomers}">
                                <tr>
                                    <td colspan="4" class="text-center text-muted py-5">Không có số lượng khách hàng
                                        tiêu biểu trong khoảng lọc này
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="vip" items="${topCustomers}">
                                    <tr>
                                        <td class="fw-bold text-start ps-4">${vip.fullName}</td>
                                        <td class="text-muted">${vip.email}</td>
                                        <td><span class="badge bg-primary px-3 py-2 rounded-pill">${vip.totalOrders} đơn hàng</span>
                                        </td>
                                        <td class="fw-bolder text-success fs-6 text-end pe-4"><fmt:formatNumber
                                                value="${vip.totalSpent}" pattern="#,##0đ"/></td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
        <div class="row g-4 mb-5">
            <div class="col-xl-6">
                <h5 class="text-primary fw-bold mb-3"><i class="bi bi-pie-chart-fill"></i> Tỷ Lệ Trạng Thái Đơn Hàng
                </h5>
                <div class="card shadow-sm border-0 p-4 h-100">
                    <div class="chart-box-fix" style="height: 320px;">
                        <canvas id="orderStatusChart"></canvas>
                        <div id="emptyStatus" class="chart-empty-state"
                             style="display:none; position: absolute; top:0; left:0; right:0; bottom:0;">
                            <i class="bi bi-pie-chart fs-1 d-block mb-3 text-muted"></i>
                            <span class="text-muted fw-semibold">Chưa có dữ liệu trạng thái đơn hàng</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-6">
                <h5 class="text-primary fw-bold mb-3"><i class="bi bi-pie-chart-fill"></i> Cấu Trúc Doanh Thu Danh Mục
                </h5>
                <div class="card shadow-sm border-0 p-4 h-100">
                    <div class="chart-box-fix" style="height: 320px;">
                        <canvas id="categoryRevenueChart"></canvas>
                        <div id="emptyCategory" class="chart-empty-state"
                             style="display:none; position: absolute; top:0; left:0; right:0; bottom:0;">
                            <i class="bi bi-pie-chart fs-1 d-block mb-3 text-muted"></i>
                            <span class="text-muted fw-semibold">Chưa có dữ liệu doanh thu danh mục</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <section class="mb-5">
            <h5 class="text-primary fw-bold mb-3"><i class="bi bi-graph-up-arrow"></i> Biểu Độ Thay Đổi Doanh Thu 8 Ngày
                Gần Nhất</h5>
            <div class="card shadow-sm border-0 p-4 mb-5">
                <div class="chart-box-fix" style="height: 350px;">
                    <canvas id="chartDoanhThuNgay"></canvas>
                    <div id="emptyDay" class="chart-empty-state"
                         style="display:none; position: absolute; top:0; left:0; right:0; bottom:0;">
                        <i class="bi bi-bar-chart-line fs-1 d-block mb-3 text-muted"></i>
                        <span class="text-muted fw-semibold">Phạm vi 8 ngày gần nhất dường như không phát sinh doanh thu</span>
                    </div>
                </div>
            </div>
            <h5 class="text-primary fw-bold mb-3 mt-4"><i class="bi bi-graph-up-arrow"></i> Biến Động Doanh Thu Theo
                Tháng</h5>
            <div class="card shadow-sm border-0 p-4">
                <div class="chart-box-fix" style="height: 350px;">
                    <canvas id="chartDoanhThuThang"></canvas>
                    <div id="emptyMonth" class="chart-empty-state"
                         style="display:none; position: absolute; top:0; left:0; right:0; bottom:0;">
                        <i class="bi bi-bar-chart-line fs-1 d-block mb-3 text-muted"></i>
                        <span class="text-muted fw-semibold">Năm nay không phát sinh doanh thu hoạt động</span>
                    </div>
                </div>
            </div>
        </section>
    </main>
</div>
<script>
    const CSRF_TOKEN = "${sessionScope.CSRF_TOKEN}";
    $(document).ready(function () {
        let table = $("#tableDonTrongNgay").DataTable({
            paging: true,
            info: false,
            lengthChange: false,
            searching: true,
            pageLength: 10,
            ordering: false,
            language: {
                zeroRecords: "Không tìm thấy dữ liệu đối chiếu",
                emptyTable: "Bộ lọc thời gian này chưa có đơn hàng"
            }
        });
        $(".dataTables_filter, .dataTables_paginate").hide();
        $("#searchBox").on("keyup", function () {
            table.search(this.value).draw();
        });
        $("#rowsPerPage").on("change", function () {
            table.page.len($(this).val()).draw();
        });

        $('#logoutBtn').on('click', function () {
            $('#logoutModal').css('display', 'flex');
        });
        $('#cancelLogout').on('click', function () {
            $('#logoutModal').css('display', 'none');
        });
    });
    const revenueDays = [
        <c:forEach var="d" items="${revenueDays}" varStatus="st">
        "${d}"<c:if test="${!st.last}">, </c:if>
        </c:forEach>
    ];
    const revenueValues = [
        <c:forEach var="v" items="${revenueValues}" varStatus="st">
        ${v}<c:if test="${!st.last}">, </c:if>
        </c:forEach>
    ];
    const isDayEmpty = revenueValues.every(v => v === 0 || v === null);
    if (isDayEmpty) {
        document.getElementById('emptyDay').style.display = 'flex';
        document.getElementById('chartDoanhThuNgay').style.display = 'none';
    } else {
        new Chart(document.getElementById('chartDoanhThuNgay').getContext('2d'), {
            type: 'bar',
            data: {
                labels: revenueDays.map(d => {
                    let dt = new Date(d);
                    return ("0" + dt.getDate()).slice(-2) + "/" + ("0" + (dt.getMonth() + 1)).slice(-2);
                }),
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: revenueValues,
                    backgroundColor: '#0d6efd',
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {display: false},
                    tooltip: {
                        callbacks: {
                            label: ctx => ctx.parsed.y.toLocaleString("vi-VN") + " VNĐ"
                        }
                    }
                },
                scales: {
                    y: {beginAtZero: true, ticks: {callback: val => val.toLocaleString("vi-VN") + " VNĐ"}},
                    x: {grid: {display: false}}
                }
            }
        });
    }
    const revenueMonths = [
        <c:forEach var="m" items="${revenueMonths}" varStatus="st">
        "${m}"<c:if test="${!st.last}">, </c:if>
        </c:forEach>
    ];
    const revenueMonthValues = [
        <c:forEach var="v" items="${revenueMonthValues}" varStatus="st">
        ${v}<c:if test="${!st.last}">, </c:if>
        </c:forEach>
    ];
    const isMonthEmpty = revenueMonthValues.every(v => v === 0 || v === null);
    if (isMonthEmpty) {
        document.getElementById('emptyMonth').style.display = 'flex';
        document.getElementById('chartDoanhThuThang').style.display = 'none';
    } else {
        new Chart(document.getElementById('chartDoanhThuThang').getContext('2d'), {
            type: 'bar',
            data: {
                labels: revenueMonths.map(m => "Tháng " + m),
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: revenueMonthValues,
                    backgroundColor: '#0d6efd',
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {display: false},
                    tooltip: {
                        callbacks: {
                            label: ctx => ctx.parsed.y.toLocaleString("vi-VN") + " VNĐ"
                        }
                    }
                },
                scales: {
                    y: {beginAtZero: true, ticks: {callback: val => val.toLocaleString("vi-VN") + " VNĐ"}},
                    x: {grid: {display: false}}
                }
            }
        });
    }
    const orderStatusLabels = [
        <c:forEach var="entry" items="${orderStatusDistribution}" varStatus="st">
        "${entry.key}"<c:if test="${!st.last}">, </c:if>
        </c:forEach>
    ];
    const orderStatusData = [
        <c:forEach var="entry" items="${orderStatusDistribution}" varStatus="st">
        ${entry.value}<c:if test="${!st.last}">, </c:if>
        </c:forEach>
    ];
    if (orderStatusLabels.length > 0) {
        new Chart(document.getElementById('orderStatusChart').getContext('2d'), {
            type: 'doughnut',
            data: {
                labels: orderStatusLabels,
                datasets: [{
                    data: orderStatusData,
                    backgroundColor: ['#198754', '#ffc107', '#0dcaf0', '#0d6efd', '#dc3545', '#6c757d'],
                }]
            },
            options: {responsive: true, maintainAspectRatio: false, plugins: {legend: {position: 'right'}}}
        });
    } else {
        document.getElementById('emptyStatus').style.display = 'flex';
        document.getElementById('orderStatusChart').style.display = 'none';
    }
    const categoryRevLabels = [
        <c:forEach var="entry" items="${revenueByCategory}" varStatus="st">
        "${entry.key}"<c:if test="${!st.last}">, </c:if>
        </c:forEach>
    ];
    const categoryRevData = [
        <c:forEach var="entry" items="${revenueByCategory}" varStatus="st">
        ${entry.value}<c:if test="${!st.last}">, </c:if>
        </c:forEach>
    ];
    if (categoryRevLabels.length > 0) {
        new Chart(document.getElementById('categoryRevenueChart').getContext('2d'), {
            type: 'pie',
            data: {
                labels: categoryRevLabels,
                datasets: [{
                    data: categoryRevData,
                    backgroundColor: ['#17a2b8', '#ffc107', '#fd7e14', '#28a745', '#e83e8c', '#6610f2'],
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {position: 'right'},
                    tooltip: {callbacks: {label: ctx => ctx.label + ": " + ctx.parsed.toLocaleString("vi-VN") + " đ"}}
                }
            }
        });
    } else {
        document.getElementById('emptyCategory').style.display = 'flex';
        document.getElementById('categoryRevenueChart').style.display = 'none';
    }
</script>
</body>
</html>