<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trang Quản Trị - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/dashboard.css">
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
            <li class="active"><i class="bi bi-speedometer2"></i> Tổng Quan</li>
            <a href="${pageContext.request.contextPath}/admin/customer-manage">
                <li><i class="bi bi-person-lines-fill"></i> Quản Lý Tài Khoản</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/product-management">
                <li><i class="bi bi-box-seam"></i> Quản Lý Sản Phẩm</li>
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
        </ul>
    </aside>
    <main class="main-content">
        <div class="stats">
            <div class="card-stat stat-blue">
                <div class="stat-icon"><i class="bi bi-people-fill"></i></div>
                <div class="stat-info">
                    <h6>Tổng khách hàng</h6>
                    <div class="value">
                        <fmt:formatNumber value="${totalUsers}" type="number"/>
                    </div>
                    <small>
                        <c:choose>
                            <c:when test="${userGrowthRate >= 0}">
                                +
                                <fmt:formatNumber value="${userGrowthRate}" maxFractionDigits="1"/>%
                                so với tuần trước
                            </c:when>
                            <c:otherwise>
                                <fmt:formatNumber value="${userGrowthRate}" maxFractionDigits="1"/>%
                                so với tuần trước
                            </c:otherwise>
                        </c:choose>
                    </small>
                </div>
            </div>
            <div class="card-stat stat-green">
                <div class="stat-icon"><i class="bi bi-box-seam"></i></div>
                <div class="stat-info">
                    <h6>Tổng sản phẩm</h6>
                    <div class="value">
                        <fmt:formatNumber value="${totalProducts}" type="number"/>
                    </div>
                    <small>
                        <fmt:formatNumber value="${totalCategories}" type="number"/> danh mục
                    </small>
                </div>
            </div>
            <div class="card-stat stat-orange">
                <div class="stat-icon"><i class="bi bi-receipt"></i></div>
                <div class="stat-info">
                    <h6>Tổng đơn hàng</h6>
                    <div class="value">
                        <fmt:formatNumber value="${totalOrders}" type="number"/>
                    </div>
                    <small>
                        Đang xử lý:
                        <fmt:formatNumber value="${processingOrders}" type="number"/>
                    </small>
                </div>
            </div>
            <div class="card-stat stat-purple">
                <div class="stat-icon"><i class="bi bi-cash-stack"></i></div>
                <div class="stat-info">
                    <h6>Doanh thu (tháng)</h6>
                    <div class="value">
                        <fmt:formatNumber value="${monthlyRevenue}" type="number"/> VNĐ
                    </div>
                    <small>
                        Mục tiêu:
                        <fmt:formatNumber value="${monthlyTarget}" type="number"/> VNĐ
                    </small>
                </div>
            </div>
        </div>
        <div class="card-panel">
            <div class="panel-title">
                <h6>Biểu đồ doanh thu</h6>
                <small style="color:#6b7280">30 ngày gần nhất</small>
            </div>
            <canvas id="salesChart" height="100"></canvas>
        </div>
        <div class="card-panel">
            <div class="panel-title">
                <h6>Khách hàng mới</h6>
                <small style="color:#6b7280">7 ngày gần nhất</small>
            </div>
            <table id="customerTable" class="table table-striped table-hover align-middle">
                <thead class="table-primary">
                <tr>
                    <th>Tên</th>
                    <th>Điện thoại</th>
                    <th>Ngày đăng ký</th>
                </tr>
                </thead>
                <jsp:useBean id="now" class="java.util.Date"/>
                <tbody>
                <c:forEach var="u" items="${newUsers}">
                    <tr>
                        <td>${u.fullName}</td>
                        <td>${u.phoneNumber}</td>
                        <td>
                            <c:set var="days"
                                   value="${Math.floor((now.time - u.createdAt.time) / (1000*60*60*24))}"/>
                            <c:set var="days" value="${days < 0 ? 0 : days}"/>
                            <c:choose>
                                <c:when test="${days == 0}">
                                    Hôm nay
                                </c:when>
                                <c:when test="${days == 1}">
                                    Hôm qua
                                </c:when>
                                <c:otherwise>
                                    ${days} ngày trước
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty newUsers}">
                    <tr>
                        <td colspan="3" class="text-center text-muted">
                            Không có khách hàng mới
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
        <div class="card-panel">
            <div class="panel-title">
                <h6>Trạng thái đơn hàng</h6>
                <small style="color:#6b7280">Tổng quan</small>
            </div>
            <table id="orderTable" class="table table-striped table-hover align-middle">
                <thead class="table-primary">
                <tr>
                    <th>Mã ĐH</th>
                    <th>Khách hàng</th>
                    <th>Trạng thái</th>
                    <th class="text-end">Tổng tiền</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="o" items="${recentOrders}">
                    <tr>
                        <td>#${o.shippingCode}</td>
                        <td>${o.customerName}</td>
                        <td>
                                                <span class="badge-status ${o.statusClass}">
                                                        ${o.statusLabel}
                                                </span>
                        </td>
                        <td class="text-end">
                            <fmt:formatNumber value="${o.totalPrice}" type="number"/> VNĐ
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty recentOrders}">
                    <tr>
                        <td colspan="4" class="text-center text-muted">
                            Chưa có đơn hàng mới
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.3.0/dist/chart.umd.min.js"></script>
<c:if test="${not empty revenueLabels and not empty revenueValues}">
    <script>
        const revenueLabels = [
            <c:forEach var="d" items="${revenueLabels}" varStatus="s">
            "${d}"<c:if test="${!s.last}">, </c:if>
            </c:forEach>
        ];
        const revenueData = [
            <c:forEach var="v" items="${revenueValues}" varStatus="s">
            ${v}<c:if test="${!s.last}">, </c:if>
            </c:forEach>
        ];
    </script>
</c:if>
<script>
    $(document).ready(function () {
        if (typeof revenueLabels === 'undefined'
            || typeof revenueData === 'undefined'
            || revenueLabels.length === 0) {
            return;
        }
        const ctx = document.getElementById('salesChart');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: revenueLabels,
                datasets: [{
                    label: 'Doanh thu (VNĐ)',
                    data: revenueData,
                    borderWidth: 2,
                    fill: true,
                    tension: 0.3
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {display: true}
                }
            }
        });
    });
</script>
<script>
    $(document).ready(function () {
        let customerTable = $('#customerTable').DataTable({
            paging: true,        // Phân trang
            pageLength: 5,       // Số dòng mỗi trang
            lengthChange: false, // Ẩn select số lượng
            searching: true,     // Bật tìm kiếm
            ordering: true,      // Cho phép sắp xếp
            info: false,         // Ẩn thông tin số trang
            language: {
                search: "Tìm kiếm:",
                zeroRecords: "Không tìm thấy kết quả",
                paginate: {
                    previous: "Trước",
                    next: "Sau"
                }
            },
            columnDefs: [
                {orderable: false, targets: []}
            ]
        });
        let orderTable = $('#orderTable').DataTable({
            paging: true,
            pageLength: 5,
            lengthChange: false,
            searching: true,
            ordering: true,
            info: false,
            language: {
                search: "Tìm kiếm:",
                zeroRecords: "Không tìm thấy kết quả",
                paginate: {
                    previous: "Trước",
                    next: "Sau"
                }
            },
            columnDefs: [
                {orderable: false, targets: 2}
            ]
        });
    });
</script>
<script>
    $("#logoutBtn").on("click", function () {
        $("#logoutModal").css("display", "flex");
    });
    $("#cancelLogout").on("click", function () {
        $("#logoutModal").hide();
    });
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