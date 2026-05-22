<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thống Kê Kho Hàng - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/product-manage.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .stat-card {
            border-radius: 12px;
            border: none;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            transition: transform 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .icon-box {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
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
                <span class="fw-semibold">${sessionScope.user.fullName != null ? sessionScope.user.fullName : 'Admin'}</span>
            </div>
        </a>
    </div>
</header>
<div class="layout">
    <main class="main-content container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/inventory-manage">Quản Lý Kho Hàng</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Dashboard Sản Phẩm</li>
                    </ol>
                </nav>
                <h4 class="text-primary fw-bold mb-0"><i class="bi bi-bar-chart-line"></i> Dashboard Nhập - Xuất Tồn</h4>
            </div>
            <a href="${pageContext.request.contextPath}/admin/inventory-manage" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Quay lại
            </a>
        </div>
        <div class="card shadow-sm mb-4 border-0">
            <div class="card-body">
                <div class="d-flex align-items-center gap-4">
                    <img src="${product.mainImage}" alt="${product.productName}" class="rounded border" style="width: 120px; height: 120px; object-fit: cover;" onerror="this.src='${pageContext.request.contextPath}/image/default.jpg'">
                    <div>
                        <h4 class="fw-bold mb-1">${product.productName} (ID: ${product.id})</h4>
                        <p class="text-muted mb-2">Thương hiệu: ${product.brandName}</p>
                        <span class="badge bg-success fs-6"><i class="bi bi-check-circle"></i> Đang kinh doanh</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <p class="text-muted mb-1 fw-semibold">Tồn Kho Hiện Tại</p>
                                <h3 class="mb-0 fw-bold text-dark">${stats.inventory}</h3>
                            </div>
                            <div class="icon-box bg-primary text-white bg-opacity-75">
                                <i class="bi bi-box-seam"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <p class="text-muted mb-1 fw-semibold">Tổng Đã Nhập</p>
                                <h3 class="mb-0 fw-bold text-success">${stats.totalImported}</h3>
                            </div>
                            <div class="icon-box bg-success text-white bg-opacity-75">
                                <i class="bi bi-box-arrow-in-down"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <p class="text-muted mb-1 fw-semibold">Tổng Đã Bán</p>
                                <h3 class="mb-0 fw-bold text-warning">${stats.totalSold}</h3>
                            </div>
                            <div class="icon-box bg-warning text-dark bg-opacity-75">
                                <i class="bi bi-cart-check"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <p class="text-muted mb-1 fw-semibold">Tỷ Lệ Bán / Nhập</p>
                                <h3 class="mb-0 fw-bold text-info"><fmt:formatNumber value="${stats.salesRatio}" maxFractionDigits="1"/>%</h3>
                            </div>
                            <div class="icon-box bg-info text-white bg-opacity-75">
                                <i class="bi bi-pie-chart"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row mb-4">
            <div class="col-lg-8">
                <div class="card shadow-sm h-100 border-0">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
                        <h6 class="fw-bold mb-0">Thống Kê Nhập & Bán Ra (6 Tháng Qua)</h6>
                        <select class="form-select form-select-sm" style="width: auto;">
                            <option>6 Tháng Qua</option>
                            <option>Năm nay</option>
                        </select>
                    </div>
                    <div class="card-body">
                        <canvas id="inventoryChart" height="100"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="card shadow-sm h-100 border-0">
                    <div class="card-header bg-white">
                        <h6 class="fw-bold mb-0">Lịch Sử Giao Dịch Gần Đây</h6>
                    </div>
                    <div class="card-body p-0">
                        <ul class="list-group list-group-flush">
                            <c:if test="${empty importHistory and empty exportHistory}">
                                <li class="list-group-item text-center text-muted py-4">Chưa có giao dịch nào.</li>
                            </c:if>
                            <c:forEach var="item" items="${importHistory}">
                                <li class="list-group-item d-flex justify-content-between align-items-center py-3">
                                    <div>
                                        <div class="fw-semibold text-success"><i class="bi bi-arrow-down-left"></i> Nhập kho</div>
                                        <small class="text-muted"><fmt:formatDate value="${item.created_at}" pattern="dd/MM/yyyy HH:mm"/> - ${item.created_by}</small>
                                    </div>
                                    <span class="badge bg-success rounded-pill">+${item.quantity}</span>
                                </li>
                            </c:forEach>
                            <c:forEach var="item" items="${exportHistory}">
                                <li class="list-group-item d-flex justify-content-between align-items-center py-3">
                                    <div>
                                        <div class="fw-semibold text-danger"><i class="bi bi-arrow-up-right"></i> Xuất kho (Bán ra)</div>
                                        <small class="text-muted"><fmt:formatDate value="${item.created_at}" pattern="dd/MM/yyyy HH:mm"/></small>
                                    </div>
                                    <span class="badge bg-danger rounded-pill">-${item.quantity}</span>
                                </li>
                            </c:forEach>
                        </ul>
                        <div class="card-footer bg-white text-center">
                            <a href="#" class="text-decoration-none small">Xem tất cả <i class="bi bi-chevron-right"></i></a>
                        </div>
                </div>
            </div>
        </div>
    </main>
</div>
<script>
    const CSRF_TOKEN = "${sessionScope.CSRF_TOKEN}";
    document.addEventListener("DOMContentLoaded", function() {
        const productId = '${product.id}';
        const ctx = document.getElementById('inventoryChart').getContext('2d');
        fetch('${pageContext.request.contextPath}/admin/api/inventory-detail?productId=' + productId)
            .then(res => res.json())
            .then(result => {
                if(result.status === 'success') {
                    const data = result.data;
                    const dates = [];
                    const importDataArray = [];
                    const exportDataArray = [];
                    for (let i = 6; i >= 0; i--) {
                        const d = new Date();
                        d.setDate(d.getDate() - i);
                        const dateString = d.toISOString().split('T')[0]; // YYYY-MM-DD
                        dates.push(dateString);
                        importDataArray.push(0);
                        exportDataArray.push(0);
                    }
                    if (data.importHistory) {
                        data.importHistory.forEach(item => {
                            if(!item.date) return;
                            const dateStr = item.date.split(' ')[0];
                            const index = dates.indexOf(dateStr);
                            if (index !== -1) importDataArray[index] += item.quantity;
                        });
                    }
                    if (data.exportHistory) {
                        data.exportHistory.forEach(item => {
                            if(!item.date) return;
                            const dateStr = item.date.split(' ')[0];
                            const index = dates.indexOf(dateStr);
                            if (index !== -1) exportDataArray[index] += item.quantity;
                        });
                    }
                    new Chart(ctx, {
                        type: 'line',
                        data: {
                            labels: dates,
                            datasets: [
                                {
                                    label: 'Số lượng Nhập',
                                    data: importDataArray,
                                    backgroundColor: 'rgba(40, 167, 69, 0.2)',
                                    borderColor: '#28a745',
                                    borderWidth: 2, tension: 0.3, fill: true
                                },
                                {
                                    label: 'Số lượng Bán',
                                    data: exportDataArray,
                                    backgroundColor: 'rgba(220, 53, 69, 0.2)',
                                    borderColor: '#dc3545',
                                    borderWidth: 2, tension: 0.3, fill: true
                                }
                            ]
                        },
                        options: {
                            responsive: true,
                            plugins: { legend: { position: 'top' }, tooltip: { mode: 'index', intersect: false } },
                            scales: { y: { beginAtZero: true, ticks: { stepSize: 5 } } },
                            interaction: { mode: 'nearest', axis: 'x', intersect: false }
                        }
                    });
                }
            });
    });
</script>
</body>
</html>
