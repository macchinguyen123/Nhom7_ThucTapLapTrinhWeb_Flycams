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
            </table>
        </div>
    </main>
</div>
