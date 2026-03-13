<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<jsp:useBean id="now" class="java.util.Date"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang Quản Lý Khuyến Mãi - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/stylesheets/admin/promotion-manage.css">
</head>
<body>
<header class="main-header">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/image/logoo2.png" alt="Logo">
        <h2>SkyDrone Admin</h2>
    </div>
    <div class="header-right">
        <a href="${pageContext.request.contextPath}/admin/profile" class="text-decoration-none text-white">
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
<div class="bo-cuc">
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
            <a href="${pageContext.request.contextPath}/admin/dashboard">
                <li><i class="bi bi-speedometer2"></i> Tổng Quan</li>
            </a>
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
                <li class="active"><i class="bi bi-megaphone"></i> Quản Lý Khuyến Mãi</li>
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
    <main class="main-content container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="text-primary fw-bold"><i class="bi bi-tags"></i> Quản Lý Khuyến Mãi</h4>
        </div>
        <div class="toolbar-blog mb-3">
            <form class="search-box" role="search">
                <div class="input-group">
                                        <span class="input-group-text bg-primary text-white">
                                            <i class="bi bi-search"></i>
                                        </span>
                    <input id="searchBlogInput" type="search" class="form-control"
                           placeholder="Tìm kiếm khuyến mãi...">
                </div>
            </form>
            <c:if test="${not empty sessionScope.infoMsg}">
                <script>
                    Swal.fire({
                        icon: '${fn:contains(sessionScope.infoMsg, "thành công") ? "success" : "error"}',
                        title: '${fn:contains(sessionScope.infoMsg, "thành công") ? "Thành công" : "Lỗi"}',
                        text: '${sessionScope.infoMsg}',
                        timer: 2500,
                        showConfirmButton: false
                    });
                </script>
                <c:remove var="infoMsg" scope="session"/>
            </c:if>
            <button class="btn btn-success" data-bs-toggle="modal"
                    data-bs-target="#modalAddPromotion">
                <i class="bi bi-plus-lg"></i> Thêm Khuyến Mãi
            </button>
        </div>
        <table id="bangKhuyenMai" class="table table-striped table-bordered">
            <thead class="table-primary">
            <tr>
                <th>Mã KM</th>
                <th>Tên Chương Trình</th>
                <th>Mức Giảm</th>
                <th>Thời Gian Áp Dụng</th>
                <th>Phạm Vi Áp Dụng</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${promotions}">
                <tr>
                    <td>${p.id}</td>
                    <td>${p.name}</td>
                    <td>
                        <c:choose>
                            <c:when test="${p.discountType eq '%'}">
                                ${p.discountValue}%
                            </c:when>
                            <c:when test="${p.discountType eq 'fixed'}">
                                <fmt:formatNumber value="${p.discountValue}" type="number"/>₫
                            </c:when>
                            <c:otherwise>
                                Không xác định
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <fmt:formatDate value="${p.startDate}" pattern="yyyy-MM-dd"/>
                        -
                        <fmt:formatDate value="${p.endDate}" pattern="yyyy-MM-dd"/>
                    </td>
                    <td>
                            ${scopeMap[p.id]}
                    </td>
                    <td>
                        <button class="btn btn-warning btn-sm btn-edit" data-id="${p.id}"
                                data-name="<c:out value='${p.name}'/>"
                                data-discount="${p.discountValue}" data-type="${p.discountType}"
                                data-start="<fmt:formatDate value='${p.startDate}' pattern='yyyy-MM-dd'/>"
                                data-end="<fmt:formatDate value='${p.endDate}' pattern='yyyy-MM-dd'/>"
                                data-scope="${scopeMap[p.id]}"
                                data-product-ids="${promotionProductsMap[p.id]}"
                                data-category-ids="${promotionCategoriesMap[p.id]}">
                            <i class="bi bi-pencil"></i>
                        </button>
                        <button type="button" class="btn btn-danger btn-sm btn-delete-promotion"
                                data-id="${p.id}" data-name="<c:out value='${p.name}'/>">
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
<div class="modal fade" id="modalAddPromotion" tabindex="-1">
    <div class="modal-dialog modal-xl modal-dialog-scrollable">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/promotion-manage" method="post"
                  id="formAddPromotion">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">
                        <i class="bi bi-plus-circle"></i> Thêm Khuyến Mãi
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body row g-3">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productIds" id="add-selected-products-hidden">
                    <input type="hidden" name="categoryIds" id="add-selected-categories-hidden">
                    <div class="col-md-6">
                        <label class="form-label">Tên chương trình</label>
                        <input type="text" name="name" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Mức giảm</label>
                        <input type="number" name="discountValue" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Loại giảm</label>
                        <select name="discountType" class="form-select">
                            <option value="%">%</option>
                            <option value="fixed">VNĐ</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Áp dụng</label>
                        <select name="scope" id="add-scope" class="form-select">
                            <option value="ALL">Tất cả</option>
                            <option value="PRODUCT">Sản phẩm</option>
                            <option value="CATEGORY">Danh mục</option>
                        </select>
                    </div>
                    <div class="col-12 d-none" id="add-category-selection-box">
                        <hr class="my-3">
                        <h6 class="text-primary mb-3">
                            <i class="bi bi-tags"></i> Danh sách danh mục áp dụng
                        </h6>
                        <div class="row g-2 mb-3">
                            <div class="col-md-6">
                                <div class="input-group">
                                                         <span class="input-group-text"><i
                                                                 class="bi bi-search"></i></span>
                                    <input type="text" id="add-category-search" class="form-control"
                                           placeholder="Tìm kiếm danh mục...">
                                </div>
                            </div>
                            <div class="col-md-6 text-end">
                                <button type="button" class="btn btn-sm btn-outline-primary"
                                        id="add-select-all-categories">
                                    <i class="bi bi-check-square"></i> Chọn tất cả
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-secondary"
                                        id="add-deselect-all-categories">
                                    <i class="bi bi-square"></i> Bỏ chọn tất cả
                                </button>
                            </div>
                        </div>
                        <div class="alert alert-info py-2">
                            <i class="bi bi-info-circle"></i> Đã chọn: <strong
                                id="add-selected-category-count">0</strong> danh mục
                        </div>
                        <div class="product-list-container" id="add-category-list">
                            <c:forEach var="category" items="${allCategories}">
                                <div class="product-item" data-category-id="${category.id}"
                                     data-category-name="${category.categoryName}">
                                    <label class="product-checkbox-label">
                                        <input type="checkbox" class="category-checkbox"
                                               value="${category.id}">
                                        <div class="product-info">
                                            <div class="product-image">
                                                <c:choose>
                                                    <c:when test="${not empty category.image}">
                                                        <img src="${pageContext.request.contextPath}/${category.image}"
                                                             alt="${category.categoryName}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="no-image">
                                                            <i class="bi bi-tags"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="product-details">
                                                <div class="product-name">${category.categoryName}
                                                </div>
                                                <div class="product-id">ID: ${category.id}</div>
                                                <div class="product-price text-muted">
                                                        ${category.status}
                                                </div>
                                            </div>
                                        </div>
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="mt-3" id="add-selected-category-preview-container"
                             style="display: none;">
                            <h6 class="text-success mb-2">
                                <i class="bi bi-check-circle"></i> Danh mục đã chọn:
                            </h6>
                            <div class="selected-products-preview"
                                 id="add-selected-category-preview">
                            </div>
                        </div>
                    </div>
                    <div class="col-12 d-none" id="add-product-selection-box">
                        <hr class="my-3">
                        <h6 class="text-primary mb-3">
                            <i class="bi bi-box-seam"></i> Danh sách sản phẩm áp dụng
                        </h6>
                        <div class="row g-2 mb-3">
                            <div class="col-md-6">
                                <div class="input-group">
                                                         <span class="input-group-text"><i
                                                                 class="bi bi-search"></i></span>
                                    <input type="text" id="add-product-search" class="form-control"
                                           placeholder="Tìm kiếm sản phẩm...">
                                </div>
                            </div>
                            <div class="col-md-6 text-end">
                                <button type="button" class="btn btn-sm btn-outline-primary"
                                        id="add-select-all">
                                    <i class="bi bi-check-square"></i> Chọn tất cả
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-secondary"
                                        id="add-deselect-all">
                                    <i class="bi bi-square"></i> Bỏ chọn tất cả
                                </button>
                            </div>
                        </div>
                        <div class="alert alert-info py-2">
                            <i class="bi bi-info-circle"></i> Đã chọn: <strong
                                id="add-selected-count">0</strong> sản phẩm
                        </div>
                        <div class="product-list-container" id="add-product-list">
                            <c:forEach var="product" items="${allProducts}">
                                <div class="product-item" data-product-id="${product.id}"
                                     data-product-name="${product.productName}">
                                    <label class="product-checkbox-label">
                                        <input type="checkbox" class="product-checkbox"
                                               value="${product.id}">
                                        <div class="product-info">
                                            <div class="product-image">
                                                <c:choose>
                                                    <c:when test="${not empty product.mainImage}">
                                                        <img src="${product.mainImage}"
                                                             alt="${product.productName}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/image/logoTCN.png"
                                                             alt="No Image">
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="product-details">
                                                <div class="product-name">${product.productName}
                                                </div>
                                                <div class="product-id">ID: ${product.id}</div>
                                                <div class="product-price">
                                                    <fmt:formatNumber value="${product.price}"
                                                                      type="number"/>₫
                                                </div>
                                            </div>
                                        </div>
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="mt-3" id="add-selected-preview-container"
                             style="display: none;">
                            <h6 class="text-success mb-2">
                                <i class="bi bi-check-circle"></i> Sản phẩm đã chọn:
                            </h6>
                            <div class="selected-products-preview" id="add-selected-preview">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Ngày bắt đầu</label>
                        <input type="date" name="startDate" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Ngày kết thúc</label>
                        <input type="date" name="endDate" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-save"></i> Lưu
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<div class="modal fade" id="modalEditPromotion" tabindex="-1">
    <div class="modal-dialog modal-xl modal-dialog-scrollable">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/promotion-manage" method="post"
                  id="formEditPromotion">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" id="edit-id">
                <input type="hidden" name="productIds" id="edit-selected-products-hidden">
                <input type="hidden" name="categoryIds" id="edit-selected-categories-hidden">
                <div class="modal-header bg-warning">
                    <h5 class="modal-title">
                        <i class="bi bi-pencil"></i> Sửa Khuyến Mãi
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Tên chương trình</label>
                        <input type="text" name="name" id="edit-name" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Mức giảm</label>
                        <input type="number" name="discountValue" id="edit-discount"
                               class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Loại giảm</label>
                        <select name="discountType" id="edit-type" class="form-select">
                            <option value="%">%</option>
                            <option value="fixed">VNĐ</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Phạm vi áp dụng</label>
                        <select name="scope" id="edit-scope" class="form-select">
                            <option value="ALL">Tất cả</option>
                            <option value="PRODUCT">Sản phẩm</option>
                            <option value="CATEGORY">Danh mục</option>
                        </select>
                    </div>
                    <div class="col-12 d-none" id="edit-category-selection-box">
                        <hr class="my-3">
                        <h6 class="text-primary mb-3">
                            <i class="bi bi-tags"></i> Danh sách danh mục áp dụng
                        </h6>
                        <div class="row g-2 mb-3">
                            <div class="col-md-6">
                                <div class="input-group">
                                                         <span class="input-group-text"><i
                                                                 class="bi bi-search"></i></span>
                                    <input type="text" id="edit-category-search"
                                           class="form-control" placeholder="Tìm kiếm danh mục...">
                                </div>
                            </div>
                            <div class="col-md-6 text-end">
                                <button type="button" class="btn btn-sm btn-outline-primary"
                                        id="edit-select-all-categories">
                                    <i class="bi bi-check-square"></i> Chọn tất cả
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-secondary"
                                        id="edit-deselect-all-categories">
                                    <i class="bi bi-square"></i> Bỏ chọn tất cả
                                </button>
                            </div>
                        </div>
                        <div class="alert alert-info py-2">
                            <i class="bi bi-info-circle"></i> Đã chọn: <strong
                                id="edit-selected-category-count">0</strong> danh mục
                        </div>
                        <div class="product-list-container" id="edit-category-list">
                            <c:forEach var="category" items="${allCategories}">
                                <div class="product-item" data-category-id="${category.id}"
                                     data-category-name="${category.categoryName}">
                                    <label class="product-checkbox-label">
                                        <input type="checkbox" class="category-checkbox-edit"
                                               value="${category.id}">
                                        <div class="product-info">
                                            <div class="product-image">
                                                <c:choose>
                                                    <c:when test="${not empty category.image}">
                                                        <img src="${pageContext.request.contextPath}/${category.image}"
                                                             alt="${category.categoryName}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="no-image">
                                                            <i class="bi bi-tags"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="product-details">
                                                <div class="product-name">${category.categoryName}
                                                </div>
                                                <div class="product-id">ID: ${category.id}</div>
                                                <div class="product-price text-muted">
                                                        ${category.status}
                                                </div>
                                            </div>
                                        </div>
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="mt-3" id="edit-selected-category-preview-container"
                             style="display: none;">
                            <h6 class="text-success mb-2">
                                <i class="bi bi-check-circle"></i> Danh mục đã chọn:
                            </h6>
                            <div class="selected-products-preview"
                                 id="edit-selected-category-preview">
                            </div>
                        </div>
                    </div>
                    <div class="col-12 d-none" id="edit-product-selection-box">
                        <hr class="my-3">
                        <h6 class="text-primary mb-3">
                            <i class="bi bi-box-seam"></i> Danh sách sản phẩm áp dụng
                        </h6>
                        <div class="row g-2 mb-3">
                            <div class="col-md-6">
                                <div class="input-group">
                                                         <span class="input-group-text"><i
                                                                 class="bi bi-search"></i></span>
                                    <input type="text" id="edit-product-search" class="form-control"
                                           placeholder="Tìm kiếm sản phẩm...">
                                </div>
                            </div>
                            <div class="col-md-6 text-end">
                                <button type="button" class="btn btn-sm btn-outline-primary"
                                        id="edit-select-all">
                                    <i class="bi bi-check-square"></i> Chọn tất cả
                                </button>
                                <button type="button" class="btn btn-sm btn-outline-secondary"
                                        id="edit-deselect-all">
                                    <i class="bi bi-square"></i> Bỏ chọn tất cả
                                </button>
                            </div>
                        </div>
                        <div class="alert alert-info py-2">
                            <i class="bi bi-info-circle"></i> Đã chọn: <strong
                                id="edit-selected-count">0</strong> sản phẩm
                        </div>
                        <div class="product-list-container" id="edit-product-list">
                            <c:forEach var="product" items="${allProducts}">
                                <div class="product-item" data-product-id="${product.id}"
                                     data-product-name="${product.productName}">
                                    <label class="product-checkbox-label">
                                        <input type="checkbox" class="product-checkbox-edit"
                                               value="${product.id}">
                                        <div class="product-info">
                                            <div class="product-image">
                                                <c:choose>
                                                    <c:when test="${not empty product.mainImage}">
                                                        <img src="${product.mainImage}"
                                                             alt="${product.productName}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="no-image">
                                                            <i class="bi bi-image"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="product-details">
                                                <div class="product-name">${product.productName}
                                                </div>
                                                <div class="product-id">ID: ${product.id}</div>
                                                <div class="product-price">
                                                    <fmt:formatNumber value="${product.price}"
                                                                      type="number"/>₫
                                                </div>
                                            </div>
                                        </div>
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="mt-3" id="edit-selected-preview-container"
                             style="display: none;">
                            <h6 class="text-success mb-2">
                                <i class="bi bi-check-circle"></i> Sản phẩm đã chọn:
                            </h6>
                            <div class="selected-products-preview" id="edit-selected-preview">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Ngày bắt đầu</label>
                        <input type="date" name="startDate" id="edit-start" class="form-control"
                               required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Ngày kết thúc</label>
                        <input type="date" name="endDate" id="edit-end" class="form-control"
                               required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy
                    </button>
                    <button type="submit" class="btn btn-warning">
                        <i class="bi bi-save"></i> Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        $('#bangKhuyenMai').DataTable({
            language: {
                search: "Tìm kiếm:",
                lengthMenu: "Hiển thị _MENU_ dòng",
                info: "Trang _PAGE_ / _PAGES_",
                paginate: {
                    previous: "Trước",
                    next: "Sau"
                }
            }
        });
    });
</script>
<script>
    class ProductSelectionManager {
        constructor(prefix) {
            this.prefix = prefix;
            this.selectedProducts = new Set();
            this.init();
        }

        init() {
            this.setupEventListeners();
        }

        setupEventListeners() {
            $('#' + this.prefix + '-product-search').on('input', (e) => {
                this.filterProducts(e.target.value);
            });
            $('#' + this.prefix + '-select-all').on('click', () => {
                this.selectAll();
            });
            $('#' + this.prefix + '-deselect-all').on('click', () => {
                this.deselectAll();
            });
            $('#' + this.prefix + '-product-list').on('change', '.product-checkbox' + (this.prefix === 'edit' ? '-edit' : ''), (e) => {
                this.handleCheckboxChange(e.target);
            });
            $('#' + this.prefix + '-selected-preview').on('click', '.remove-product-btn', (e) => {
                const productId = $(e.currentTarget).data('product-id');
                this.removeProduct(productId);
            });
        }

        filterProducts(searchTerm) {
            const term = searchTerm.toLowerCase();
            $('#' + this.prefix + '-product-list .product-item').each(function () {
                const name = $(this).data('product-name').toLowerCase();
                const id = $(this).data('product-id').toString();
                if (name.includes(term) || id.includes(term)) {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            });
        }

        selectAll() {
            $('#' + this.prefix + '-product-list .product-item:visible .product-checkbox' + (this.prefix === 'edit' ? '-edit' : '')).each((i, checkbox) => {
                if (!checkbox.checked) {
                    checkbox.checked = true;
                    this.selectedProducts.add(checkbox.value);
                    $(checkbox).closest('.product-item').addClass('selected');
                }
            });
            this.updateUI();
        }

        deselectAll() {
            $('#' + this.prefix + '-product-list .product-item:visible .product-checkbox' + (this.prefix === 'edit' ? '-edit' : '')).each((i, checkbox) => {
                if (checkbox.checked) {
                    checkbox.checked = false;
                    this.selectedProducts.delete(checkbox.value);
                    $(checkbox).closest('.product-item').removeClass('selected');
                }
            });
            this.updateUI();
        }

        handleCheckboxChange(checkbox) {
            const productId = checkbox.value;
            if (checkbox.checked) {
                this.selectedProducts.add(productId);
                $(checkbox).closest('.product-item').addClass('selected');
            } else {
                this.selectedProducts.delete(productId);
                $(checkbox).closest('.product-item').removeClass('selected');
            }
            this.updateUI();
        }

        removeProduct(productId) {
            this.selectedProducts.delete(productId.toString());
            $('#' + this.prefix + '-product-list .product-checkbox' + (this.prefix === 'edit' ? '-edit' : '') + '[value="' + productId + '"]').prop('checked', false);
            $('#' + this.prefix + '-product-list .product-item[data-product-id="' + productId + '"]').removeClass('selected');
            this.updateUI();
        }

        updateUI() {
            $('#' + this.prefix + '-selected-count').text(this.selectedProducts.size);
            $('#' + this.prefix + '-selected-products-hidden').val(Array.from(this.selectedProducts).join(','));
            if (this.selectedProducts.size > 0) {
                $('#' + this.prefix + '-selected-preview-container').show();
                this.renderPreview();
            } else {
                $('#' + this.prefix + '-selected-preview-container').hide();
            }
        }

        renderPreview() {
            const self = this;
            const previewHtml = Array.from(this.selectedProducts).map(function (productId) {
                const productItem = $('#' + self.prefix + '-product-list .product-item[data-product-id="' + productId + '"]');
                const productName = productItem.data('product-name');
                return '<div class="selected-product-tag">' +
                    '<span>' + productName + ' (ID: ' + productId + ')</span>' +
                    '<button type="button" class="remove-product-btn" data-product-id="' + productId + '">' +
                    '<i class="bi bi-x"></i>' +
                    '</button>' +
                    '</div>';
            }).join('');
            $('#' + this.prefix + '-selected-preview').html(previewHtml);
        }

        setSelectedProducts(productIds) {
            const self = this;
            this.selectedProducts.clear();
            $('#' + this.prefix + '-product-list .product-checkbox' + (this.prefix === 'edit' ? '-edit' : '')).prop('checked', false);
            $('#' + this.prefix + '-product-list .product-item').removeClass('selected');

            if (productIds && productIds.length > 0) {
                productIds.forEach(function (id) {
                    self.selectedProducts.add(id.toString());
                    const checkbox = $('#' + self.prefix + '-product-list .product-checkbox' + (self.prefix === 'edit' ? '-edit' : '') + '[value="' + id + '"]');
                    checkbox.prop('checked', true);
                    checkbox.closest('.product-item').addClass('selected');
                });
            }
            this.updateUI();
        }

        reset() {
            this.selectedProducts.clear();
            $('#' + this.prefix + '-product-list .product-checkbox' + (this.prefix === 'edit' ? '-edit' : '')).prop('checked', false);
            $('#' + this.prefix + '-product-list .product-item').removeClass('selected');
            $('#' + this.prefix + '-product-search').val('');
            this.filterProducts('');
            this.updateUI();
        }
    }

    const addProductManager = new ProductSelectionManager('add');
    const editProductManager = new ProductSelectionManager('edit');
</script>
<script>
    $('#logoutBtn').on('click', function () {
        $('#logoutModal').css('display', 'flex');
    });
    $('#cancelLogout').on('click', function () {
        $('#logoutModal').css('display', 'none');
    });
    $('.has-submenu').on('click', function () {
        $(this).toggleClass('open');
    });
</script>
<script>
    class CategorySelectionManager {
        constructor(prefix) {
            this.prefix = prefix;
            this.selectedCategories = new Set();
            this.init();
        }

        init() {
            this.setupEventListeners();
        }

        setupEventListeners() {
            $('#' + this.prefix + '-category-search').on('input', (e) => {
                this.filterCategories(e.target.value);
            });
            $('#' + this.prefix + '-select-all-categories').on('click', () => {
                this.selectAll();
            });
            $('#' + this.prefix + '-deselect-all-categories').on('click', () => {
                this.deselectAll();
            });
            $('#' + this.prefix + '-category-list').on('change', '.category-checkbox' + (this.prefix === 'edit' ? '-edit' : ''), (e) => {
                this.handleCheckboxChange(e.target);
            });
            $('#' + this.prefix + '-selected-category-preview').on('click', '.remove-product-btn', (e) => {
                const categoryId = $(e.currentTarget).data('category-id');
                this.removeCategory(categoryId);
            });
        }

        filterCategories(searchTerm) {
            const term = searchTerm.toLowerCase();
            $('#' + this.prefix + '-category-list .product-item').each(function () {
                const name = $(this).data('category-name').toLowerCase();
                const id = $(this).data('category-id').toString();
                if (name.includes(term) || id.includes(term)) {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            });
        }

        selectAll() {
            $('#' + this.prefix + '-category-list .product-item:visible .category-checkbox' + (this.prefix === 'edit' ? '-edit' : '')).each((i, checkbox) => {
                if (!checkbox.checked) {
                    checkbox.checked = true;
                    this.selectedCategories.add(checkbox.value);
                    $(checkbox).closest('.product-item').addClass('selected');
                }
            });
            this.updateUI();
        }

        deselectAll() {
            $('#' + this.prefix + '-category-list .product-item:visible .category-checkbox' + (this.prefix === 'edit' ? '-edit' : '')).each((i, checkbox) => {
                if (checkbox.checked) {
                    checkbox.checked = false;
                    this.selectedCategories.delete(checkbox.value);
                    $(checkbox).closest('.product-item').removeClass('selected');
                }
            });
            this.updateUI();
        }

        handleCheckboxChange(checkbox) {
            const categoryId = checkbox.value;
            if (checkbox.checked) {
                this.selectedCategories.add(categoryId);
                $(checkbox).closest('.product-item').addClass('selected');
            } else {
                this.selectedCategories.delete(categoryId);
                $(checkbox).closest('.product-item').removeClass('selected');
            }
            this.updateUI();
        }

        removeCategory(categoryId) {
            this.selectedCategories.delete(categoryId.toString());
            $('#' + this.prefix + '-category-list .category-checkbox' + (this.prefix === 'edit' ? '-edit' : '') + '[value="' + categoryId + '"]').prop('checked', false);
            $('#' + this.prefix + '-category-list .product-item[data-category-id="' + categoryId + '"]').removeClass('selected');
            this.updateUI();
        }

        updateUI() {
            $('#' + this.prefix + '-selected-category-count').text(this.selectedCategories.size);
            $('#' + this.prefix + '-selected-categories-hidden').val(Array.from(this.selectedCategories).join(','));
            if (this.selectedCategories.size > 0) {
                $('#' + this.prefix + '-selected-category-preview-container').show();
                this.renderPreview();
            } else {
                $('#' + this.prefix + '-selected-category-preview-container').hide();
            }
        }

        renderPreview() {
            const self = this;
            const previewHtml = Array.from(this.selectedCategories).map(function (categoryId) {
                const categoryItem = $('#' + self.prefix + '-category-list .product-item[data-category-id="' + categoryId + '"]');
                const categoryName = categoryItem.data('category-name');
                return '<div class="selected-product-tag">' +
                    '<span><i class="bi bi-tags"></i> ' + categoryName + ' (ID: ' + categoryId + ')</span>' +
                    '<button type="button" class="remove-product-btn" data-category-id="' + categoryId + '">' +
                    '<i class="bi bi-x"></i>' +
                    '</button>' +
                    '</div>';
            }).join('');
            $('#' + this.prefix + '-selected-category-preview').html(previewHtml);
        }

        setSelectedCategories(categoryIds) {
            const self = this;
            this.selectedCategories.clear();
            $('#' + this.prefix + '-category-list .category-checkbox' + (this.prefix === 'edit' ? '-edit' : '')).prop('checked', false);
            $('#' + this.prefix + '-category-list .product-item').removeClass('selected');
            if (categoryIds && categoryIds.length > 0) {
                categoryIds.forEach(function (id) {
                    self.selectedCategories.add(id.toString());
                    const checkbox = $('#' + self.prefix + '-category-list .category-checkbox' + (self.prefix === 'edit' ? '-edit' : '') + '[value="' + id + '"]');
                    checkbox.prop('checked', true);
                    checkbox.closest('.product-item').addClass('selected');
                });
            }
            this.updateUI();
        }

        reset() {
            this.selectedCategories.clear();
            $('#' + this.prefix + '-category-list .category-checkbox' + (this.prefix === 'edit' ? '-edit' : '')).prop('checked', false);
            $('#' + this.prefix + '-category-list .product-item').removeClass('selected');
            $('#' + this.prefix + '-category-search').val('');
            this.filterCategories('');
            this.updateUI();
        }
    }

    const addCategoryManager = new CategorySelectionManager('add');
    const editCategoryManager = new CategorySelectionManager('edit');
    $('#add-scope').on('change', function () {
        const scope = $(this).val();
        $('#add-product-selection-box').addClass('d-none');
        $('#add-category-selection-box').addClass('d-none');
        if (scope === 'PRODUCT') {
            $('#add-product-selection-box').removeClass('d-none');
        } else if (scope === 'CATEGORY') {
            $('#add-category-selection-box').removeClass('d-none');
        }
        if (scope !== 'PRODUCT') {
            addProductManager.reset();
        }
        if (scope !== 'CATEGORY') {
            addCategoryManager.reset();
        }
    });
    $('#edit-scope').on('change', function () {
        const scope = $(this).val();
        $('#edit-product-selection-box').addClass('d-none');
        $('#edit-category-selection-box').addClass('d-none');
        if (scope === 'PRODUCT') {
            $('#edit-product-selection-box').removeClass('d-none');
        } else if (scope === 'CATEGORY') {
            $('#edit-category-selection-box').removeClass('d-none');
        }
        if (scope !== 'PRODUCT') {
            editProductManager.reset();
        }
        if (scope !== 'CATEGORY') {
            editCategoryManager.reset();
        }
    });
    $(document).on('click', '.btn-edit', function () {
        const btn = $(this);
        const promotionId = btn.data('id');
        $('#edit-id').val(promotionId);
        $('#edit-name').val(btn.data('name'));
        $('#edit-discount').val(btn.data('discount'));
        $('#edit-type').val(btn.data('type'));
        $('#edit-start').val(btn.data('start'));
        $('#edit-end').val(btn.data('end'));
        let scope = "ALL";
        const scopeText = btn.data('scope').toLowerCase();
        if (scopeText.includes("sản phẩm")) scope = "PRODUCT";
        if (scopeText.includes("danh mục")) scope = "CATEGORY";
        $('#edit-scope').val(scope);
        $('#edit-scope').trigger('change');
        if (scope === 'PRODUCT') {
            setTimeout(function () {
                const productIdsString = btn.data('product-ids');
                if (productIdsString && productIdsString.toString().trim() !== '') {
                    const idsStr = productIdsString.toString().replace(/[\[\]]/g, '').trim();
                    if (idsStr !== '') {
                        const selectedProductIds = idsStr.split(',').map(id => id.trim()).filter(id => id !== '');
                        if (selectedProductIds.length > 0) {
                            editProductManager.setSelectedProducts(selectedProductIds);
                        }
                    }
                } else {
                    editProductManager.reset();
                }
            }, 150);
        } else if (scope === 'CATEGORY') {
            setTimeout(function () {
                const categoryIdsString = btn.data('category-ids');
                if (categoryIdsString && categoryIdsString.toString().trim() !== '') {
                    const idsStr = categoryIdsString.toString().replace(/[\[\]]/g, '').trim();
                    if (idsStr !== '') {
                        const selectedCategoryIds = idsStr.split(',').map(id => id.trim()).filter(id => id !== '');
                        if (selectedCategoryIds.length > 0) {
                            editCategoryManager.setSelectedCategories(selectedCategoryIds);
                        }
                    }
                } else {
                    editCategoryManager.reset();
                }
            }, 150);
        } else {
            editProductManager.reset();
            editCategoryManager.reset();
        }
        $('.modal-backdrop').remove();
        $('body').removeClass('modal-open');
        const editModal = new bootstrap.Modal(document.getElementById('modalEditPromotion'));
        editModal.show();
    });
    $('#modalAddPromotion').on('hidden.bs.modal', function () {
        addProductManager.reset();
        addCategoryManager.reset();
        $('#formAddPromotion')[0].reset();
        $('.modal-backdrop').remove();
        $('body').removeClass('modal-open');
    });
    $('#modalEditPromotion').on('hidden.bs.modal', function () {
        editProductManager.reset();
        editCategoryManager.reset();
        $('.modal-backdrop').remove();
        $('body').removeClass('modal-open');
    });
    $(document).on('click', '.btn-delete-promotion', function () {
        const promotionId = $(this).data('id');
        const promotionName = $(this).data('name');
        Swal.fire({
            title: 'Xác nhận xóa?',
            html: `Bạn có chắc chắn muốn xóa khuyến mãi <b>${promotionName}</b>? <br> Hành động này không thể hoàn tác!`,
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Xóa ngay',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/admin/promotion-manage';
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                form.appendChild(actionInput);
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = promotionId;
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        });
    });
</script>
</body>
</html>