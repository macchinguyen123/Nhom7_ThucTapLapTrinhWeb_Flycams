<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Kho Hàng - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/product-manage.css">
</head>
<body>
<div class="layout">
    <main class="main-content container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="text-primary fw-bold"><i class="bi bi-boxes"></i> Quản Lý Kho Hàng</h4>
            <div class="d-flex align-items-center gap-2">
                <form class="d-flex" role="search" style="max-width: 300px;">
                    <div class="input-group">
                        <span class="input-group-text bg-primary text-white">
                            <i class="bi bi-search"></i>
                        </span>
                        <input id="searchInput" type="search" class="form-control"
                               placeholder="Tìm kiếm sản phẩm..." aria-label="Tìm kiếm">
                    </div>
                </form>
            </div>
        </div>
        <div class="d-flex justify-content-start align-items-center mb-2">
            <label class="me-2">Hiển thị</label>
            <select id="rowsPerPage" class="form-select d-inline-block" style="width:80px;">
                <option value="5">5</option>
                <option value="10" selected>10</option>
                <option value="20">20</option>
                <option value="50">50</option>
            </select>
            <label class="ms-2">sản phẩm</label>
        </div>
        <table id="tableTonKho" class="table table-striped table-bordered">
            <thead class="table-primary">
            <tr>
                <th>Mã SP</th>
                <th>Tên SP</th>
                <th>Ảnh</th>
                <th>Danh Mục</th>
                <th>Số Lượng Tồn</th>
                <th>Trạng Thái</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty products}">
                    <c:forEach var="p" items="${products}">
                        <tr class="${p.quantity <= 0 ? 'out-of-stock' : (p.quantity <= 10 ? 'low-stock' : '')}">
                            <td>${p.id}</td>
                            <td>${p.productName}</td>
                            <td>
                                <img src="${p.mainImage}" class="img-thumbnail"
                                     style="width:60px;height:60px;object-fit:cover;" alt="${p.productName}">
                            </td>
                            <td>${p.categoryName}</td>
                            <td class="fw-bold text-center ${p.quantity <= 0 ? 'text-danger' : (p.quantity <= 10 ? 'text-warning' : 'text-success')}">
                                ${p.quantity}
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.quantity > 10}">
                                        <span class="badge bg-success">Còn hàng</span>
                                    </c:when>
                                    <c:when test="${p.quantity > 0 && p.quantity <= 10}">
                                        <span class="badge bg-warning text-dark">Sắp hết</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger">Hết hàng</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align:center;">
                                <button class="btn btn-primary btn-sm btn-import" 
                                        data-id="${p.id}" 
                                        data-name="${p.productName}"
                                        data-img="${p.mainImage}">
                                    <i class="bi bi-box-arrow-in-down"></i> Nhập kho
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/inventory-history?id=${p.id}" class="btn btn-info btn-sm text-white">
                                    <i class="bi bi-clock-history"></i> Lịch sử
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td>1</td>
                        <td>Flycam DJI Mini 3 Pro</td>
                        <td>
                            <img src="https://example.com/dji.jpg" class="img-thumbnail"
                                 style="width:60px;height:60px;object-fit:cover;" alt="Flycam DJI Mini 3 Pro" onerror="this.src='${pageContext.request.contextPath}/image/default.jpg'">
                        </td>
                        <td>Drone mini</td>
                        <td class="fw-bold text-center text-success">45</td>
                        <td><span class="badge bg-success">Còn hàng</span></td>
                        <td style="text-align:center;">
                            <button class="btn btn-primary btn-sm btn-import" data-id="1" data-name="Flycam DJI Mini 3 Pro" data-img="https://example.com/dji.jpg">
                                <i class="bi bi-box-arrow-in-down"></i> Nhập kho
                            </button>
                            <button class="btn btn-info btn-sm text-white"><i class="bi bi-clock-history"></i> Lịch sử</button>
                        </td>
                    </tr>
                    <tr class="low-stock">
                        <td>2</td>
                        <td>Flycam Autel Evo Lite+</td>
                        <td>
                            <img src="https://example.com/autel.jpg" class="img-thumbnail"
                                 style="width:60px;height:60px;object-fit:cover;" alt="Flycam Autel Evo Lite+" onerror="this.src='${pageContext.request.contextPath}/image/default.jpg'">
                        </td>
                        <td>Drone quay phim chuyên nghiệp</td>
                        <td class="fw-bold text-center text-warning">5</td>
                        <td><span class="badge bg-warning text-dark">Sắp hết</span></td>
                        <td style="text-align:center;">
                            <button class="btn btn-primary btn-sm btn-import" data-id="2" data-name="Flycam Autel Evo Lite+" data-img="https://example.com/autel.jpg">
                                <i class="bi bi-box-arrow-in-down"></i> Nhập kho
                            </button>
                            <button class="btn btn-info btn-sm text-white"><i class="bi bi-clock-history"></i> Lịch sử</button>
                        </td>
                    </tr>
                    <tr class="out-of-stock">
                        <td>3</td>
                        <td>Flycam Xiaomi Fimi X8 SE</td>
                        <td>
                            <img src="https://example.com/xiaomi.jpg" class="img-thumbnail"
                                 style="width:60px;height:60px;object-fit:cover;" alt="Flycam Xiaomi Fimi X8 SE" onerror="this.src='${pageContext.request.contextPath}/image/default.jpg'">
                        </td>
                        <td>Drone du lịch / vlog</td>
                        <td class="fw-bold text-center text-danger">0</td>
                        <td><span class="badge bg-danger">Hết hàng</span></td>
                        <td style="text-align:center;">
                            <button class="btn btn-primary btn-sm btn-import" data-id="3" data-name="Flycam Xiaomi Fimi X8 SE" data-img="https://example.com/xiaomi.jpg">
                                <i class="bi bi-box-arrow-in-down"></i> Nhập kho
                            </button>
                            <button class="btn btn-info btn-sm text-white"><i class="bi bi-clock-history"></i> Lịch sử</button>
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
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
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>
</html>
