<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang Quản Lý Blog - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="../../stylesheets/admin/blog-manage.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <link rel="stylesheet" href="https://cdn.ckeditor.com/ckeditor5/47.2.0/ckeditor5.css" crossorigin>
    <link rel="stylesheet"
          href="https://cdn.ckeditor.com/ckeditor5-premium-features/47.2.0/ckeditor5-premium-features.css" crossorigin>
    <script src="https://cdn.ckeditor.com/ckeditor5/47.2.0/ckeditor5.umd.js" crossorigin></script>
    <script src="https://cdn.ckeditor.com/ckeditor5-premium-features/47.2.0/ckeditor5-premium-features.umd.js"
            crossorigin></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/blog-manage.css">
    <style>
        .dataTables_paginate,
        .dataTables_filter,
        .dataTables_length,
        .dataTables_info {
            display: none !important;
        }

        .ck-editor__editable {
            min-height: 400px;
        }

        .ck.ck-editor__main > .ck-editor__editable {
            background: #fff;
        }

        .ck.ck-balloon-panel {
            z-index: 10055 !important;
        }

        .ck.ck-modal__overlay {
            z-index: 10060 !important;
        }

        .ck-body-wrapper {
            z-index: 10065 !important;
        }

        .modal {
            --bs-modal-zindex: 1055;
        }

        .modal-backdrop {
            z-index: 1054;
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
                    <img src="${pageContext.request.contextPath}/image/logoTCN.png"
                         alt="Avatar">
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
                <li class="active"><i class="bi bi-journal-text"></i> Quản Lý Blog</li>
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
    <main class="main-content container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="text-primary fw-bold"><i class="bi bi-journal-text"></i> Quản Lý Blog
            </h4>
        </div>
        <div class="d-flex justify-content-between align-items-center mb-3">
            <form class="d-flex" role="search" style="max-width: 300px;">
                <div class="input-group">
                                            <span class="input-group-text bg-primary text-white">
                                                <i class="bi bi-search"></i>
                                            </span>
                    <input id="searchBlogInput" type="search" class="form-control"
                           placeholder="Tìm kiếm bài viết...">
                </div>
            </form>
            <button class="btn btn-success" data-bs-toggle="modal"
                    data-bs-target="#addBlogModal">
                <i class="bi bi-plus-lg"></i> Thêm Bài Viết
            </button>

        </div>
        <div class="modal fade" id="addBlogModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form id="addBlogForm"
                          action="${pageContext.request.contextPath}/admin/blog-manage"
                          method="post" onsubmit="return syncAddEditor()">
                        <div class="modal-header">
                            <h5 class="modal-title"><i class="bi bi-plus-lg"></i> Thêm Bài Viết</h5>
                            <button type="button" class="btn-close"
                                    data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="action" value="add">
                            <div class="mb-3">
                                <label class="form-label">Tiêu đề</label>
                                <input type="text" name="title" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Nội dung</label>
                                <textarea name="content" id="add-content" class="form-control"
                                          rows="6"></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Link ảnh</label>
                                <input type="text" name="image" class="form-control"
                                       placeholder="https://...">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mã sản phẩm</label>
                                <input type="number" name="productId" class="form-control">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary"
                                    data-bs-dismiss="modal">
                                Hủy
                            </button>
                            <button type="submit" class="btn btn-success">
                                Lưu
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div id="dsblog" class="users-table mt-4">
            <section>
                <table id="tableBlog"
                       class="table table-striped table-bordered align-middle text-center">
                    <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th style="width: 200px;">Tiêu đề</th>
                        <th>Nội dung</th>
                        <th>Ảnh</th>
                        <th>Ngày tạo</th>
                        <th>Mã sản phẩm</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="p" items="${posts}">
                        <tr>
                            <td>${p.id}</td>
                            <td class="text-start">${p.title}</td>
                            <td class="text-start">
                                <c:set var="words"
                                       value="${fn:split(p.content, ' ')}"/>
                                <c:choose>
                                    <c:when test="${fn:length(words) > 8}">
                                        <c:forEach var="w" items="${words}" begin="0"
                                                   end="7">
                                            ${w}
                                        </c:forEach>...
                                    </c:when>
                                    <c:otherwise>
                                        ${p.content}
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty p.image}">
                                        <img src="${p.image}" class="blog-thumb">
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Không có ảnh</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <fmt:formatDate value="${p.createdAt}"
                                                pattern="yyyy-MM-dd"/>
                            </td>
                            <td>${p.productId}</td>
                            <td>
                                <button type="button"
                                        class="btn btn-warning btn-sm me-1"
                                        data-id="${p.id}"
                                        data-title="${fn:escapeXml(p.title)}"
                                        data-content="${fn:escapeXml(p.content)}"
                                        data-image="${p.image}"
                                        data-product="${p.productId}"
                                        onclick="openEditModal(this)">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button type="button" class="btn btn-danger btn-sm"
                                        data-id="${p.id}" onclick="confirmDelete(this)">
                                    <i class="bi bi-trash"></i>
                                </button>
                                <button type="button" class="btn btn-info btn-sm"
                                        data-id="${p.id}"
                                        data-title="${fn:escapeXml(p.title)}"
                                        data-content="${fn:escapeXml(p.content)}"
                                        data-image="${p.image}"
                                        data-date="<fmt:formatDate value='${p.createdAt}' pattern='yyyy-MM-dd'/>"
                                        data-product="${p.productId}"
                                        onclick="openViewModal(this)">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                <div class="d-flex justify-content-end align-items-center mt-3">
                    <button id="prevPage"
                            class="btn btn-outline-primary btn-sm">Trước
                    </button>
                    <span id="pageInfo" class="mx-2">1 / 1</span>
                    <button id="nextPage"
                            class="btn btn-outline-primary btn-sm">Sau
                    </button>
                </div>
            </section>
            <section>
                <div id="blog-detail" style="display: none;">
                    <button class="btn btn-secondary mb-3" onclick="showList()"><i class="bi bi-arrow-left"></i> Quay
                        lại
                    </button>
                    <table class="table table-bordered">
                        <tr>
                            <td>ID bài viết</td>
                            <td id="post-id"></td>
                        </tr>
                        <tr>
                            <td>Tiêu đề</td>
                            <td id="post-title"></td>
                        </tr>
                        <tr>
                            <td>Nội dung</td>
                            <td id="post-content"></td>
                        </tr>
                        <tr>
                            <td>Ảnh</td>
                            <td><img id="post-image" width="250"></td>
                        </tr>
                        <tr>
                            <td>Ngày tạo</td>
                            <td id="post-date"></td>
                        </tr>
                        <tr>
                            <td>Mã sản phẩm</td>
                            <td id="post-product"></td>
                        </tr>
                    </table>
                </div>
            </section>
            <div class="modal fade" id="editBlogModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <form id="editBlogForm"
                              action="${pageContext.request.contextPath}/admin/blog-manage"
                              method="post" onsubmit="return syncEditEditor()">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="bi bi-pencil"></i> Sửa bài viết</h5>
                                <button type="button" class="btn-close"
                                        data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" name="action" value="edit">
                                <input type="hidden" name="id" id="edit-id">
                                <div class="mb-3">
                                    <label class="form-label">Tiêu đề</label>
                                    <input type="text" name="title" id="edit-title"
                                           class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Nội dung</label>
                                    <textarea name="content" id="edit-content"
                                              class="form-control" rows="6"></textarea>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Ảnh</label>
                                    <input type="text" name="image" id="edit-image"
                                           class="form-control">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Mã sản phẩm</label>
                                    <input type="number" name="productId" id="edit-product"
                                           class="form-control">
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Hủy
                                </button>
                                <button type="submit" class="btn btn-success">
                                    Lưu
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="viewBlogModal" tabindex="-1">
                <div class="modal-dialog modal-lg modal-dialog-scrollable">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title"><i class="bi bi-eye"></i> Chi tiết bài viết</h5>
                            <button type="button" class="btn-close"
                                    data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <table class="table table-bordered">
                                <tr>
                                    <th style="width: 150px;">ID</th>
                                    <td id="view-id"></td>
                                </tr>
                                <tr>
                                    <th>Tiêu đề</th>
                                    <td id="view-title"></td>
                                </tr>
                                <tr>
                                    <th>Nội dung</th>
                                    <td id="view-content" style="white-space: pre-wrap;">
                                    </td>
                                </tr>
                                <tr>
                                    <th>Ảnh</th>
                                    <td>
                                        <img id="view-image"
                                             style="max-width: 100%; border-radius: 6px;">
                                    </td>
                                </tr>
                                <tr>
                                    <th>Ngày tạo</th>
                                    <td id="view-date"></td>
                                </tr>
                                <tr>
                                    <th>Mã sản phẩm</th>
                                    <td id="view-product"></td>
                                </tr>
                            </table>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary"
                                    data-bs-dismiss="modal">Đóng
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
<script>
    const baseUrl = "${pageContext.request.contextPath}";
    $(document).ready(function () {
        blogTable = $('#tableBlog').DataTable({
            pageLength: 5,
            columnDefs: [{targets: [2, 3, 6], orderable: false}],
            language: {zeroRecords: "Không tìm thấy dữ liệu"}
        });
        $('#searchBlogInput').on('keyup', function () {
            blogTable.search(this.value).draw();
        });
        // Pagination custom
        $('#prevPage').click(() => {
            blogTable.page('previous').draw('page');
            updatePageInfo();
        });
        $('#nextPage').click(() => {
            blogTable.page('next').draw('page');
            updatePageInfo();
        });
        blogTable.on('draw', updatePageInfo);
        updatePageInfo();
        document.addEventListener('focusin', function (e) {
            if (e.target.closest('.ck-body-wrapper, .ck-balloon-panel, .ck-link-form, .ck-input')) {
                e.stopImmediatePropagation();
            }
        }, true);
        const urlParams = new URLSearchParams(window.location.search);
        const msg = urlParams.get('msg');
        const error = urlParams.get('error');
        if (msg === 'added') {
            Swal.fire({
                icon: 'success',
                title: 'Thành công!',
                text: 'Đã thêm bài viết mới thành công.',
                timer: 2000,
                showConfirmButton: false
            });
        } else if (msg === 'edited') {
            Swal.fire({
                icon: 'success',
                title: 'Thành công!',
                text: 'Đã cập nhật bài viết thành công.',
                timer: 2000,
                showConfirmButton: false
            });
        } else if (msg === 'deleted') {
            Swal.fire({
                icon: 'success',
                title: 'Đã xóa!',
                text: 'Bài viết đã được xóa khỏi hệ thống.',
                timer: 2000,
                showConfirmButton: false
            });
        } else if (error === 'add_failed') {
            Swal.fire({
                icon: 'error',
                title: 'Thất bại!',
                text: 'Không thể thêm bài viết. Vui lòng thử lại.',
            });
        } else if (error === 'edit_failed') {
            Swal.fire({
                icon: 'error',
                title: 'Thất bại!',
                text: 'Không thể cập nhật bài viết. Vui lòng thử lại.',
            });
        } else if (error === 'delete_failed') {
            Swal.fire({
                icon: 'error',
                title: 'Thất bại!',
                text: 'Không thể xóa bài viết. Vui lòng thử lại.',
            });
        }
    });
    const {
        ClassicEditor,
        Essentials,
        Paragraph,
        Alignment,
        AutoImage,
        Autoformat,
        AutoLink,
        ImageBlock,
        BlockQuote,
        Bold,
        Code,
        CodeBlock,
        FontBackgroundColor,
        FontColor,
        FontFamily,
        FontSize,
        Heading,
        Highlight,
        HorizontalLine,
        ImageCaption,
        ImageInsert,
        ImageInsertViaUrl,
        ImageResize,
        ImageStyle,
        ImageTextAlternative,
        ImageToolbar,
        ImageUpload,
        Indent,
        IndentBlock,
        Italic,
        Link,
        LinkImage,
        List,
        ListProperties,
        MediaEmbed,
        RemoveFormat,
        SpecialCharacters,
        SpecialCharactersArrows,
        SpecialCharactersCurrency,
        SpecialCharactersEssentials,
        SpecialCharactersLatin,
        SpecialCharactersMathematical,
        SpecialCharactersText,
        Strikethrough,
        Subscript,
        Superscript,
        Table,
        TableCaption,
        TableCellProperties,
        TableColumnResize,
        TableProperties,
        TableToolbar,
        Underline,
        Base64UploadAdapter
    } = window.CKEDITOR;
    let addEditor, editEditor;
    const editorConfig = {
        licenseKey: 'eyJhbGciOiJFUzI1NiJ9.eyJleHAiOjE3NzAwNzY3OTksImp0aSI6IjFkYzBmZGQ1LThhMTgtNGFhYy1iOTEwLWRkMTA0MDkxZmNjZCIsInVzYWdlRW5kcG9pbnQiOiJodHRwczovL3Byb3h5LWV2ZW50LmNrZWRpdG9yLmNvbSIsImRpc3RyaWJ1dGlvbkNoYW5uZWwiOlsiY2xvdWQiLCJkcnVwYWwiLCJzaCJdLCJ3aGl0ZUxhYmVsIjp0cnVlLCJsaWNlbnNlVHlwZSI6InRyaWFsIiwiZmVhdHVyZXMiOlsiKiJdLCJ2YyI6ImQwYWQwMTgyIn0.4qtYn6Q_c-EZwACzzNRQTfTLUjqrjRo12fRQXuGhzTmwPnaJOT3Jw6J6NK3u0Jf_skSkzhR36nezFQka3szCuA',
        toolbar: {
            items: [
                'undo', 'redo',
                '|',
                'heading',
                '|',
                'fontSize', 'fontFamily', 'fontColor', 'fontBackgroundColor',
                '|',
                'bold', 'italic', 'underline', 'strikethrough', 'subscript', 'superscript', 'code', 'removeFormat',
                '|',
                'specialCharacters', 'horizontalLine', 'link', 'insertImage', 'insertImageViaUrl', 'mediaEmbed', 'insertTable',
                'highlight', 'blockQuote', 'codeBlock',
                '|',
                'alignment',
                '|',
                'bulletedList', 'numberedList', 'outdent', 'indent'
            ],
            shouldNotGroupWhenFull: true
        },
        plugins: [
            Alignment,
            Autoformat,
            AutoImage,
            AutoLink,
            Base64UploadAdapter,
            BlockQuote,
            Bold,
            Code,
            CodeBlock,
            Essentials,
            FontBackgroundColor,
            FontColor,
            FontFamily,
            FontSize,
            Heading,
            Highlight,
            HorizontalLine,
            ImageBlock,
            ImageCaption,
            ImageInsert,
            ImageInsertViaUrl,
            ImageResize,
            ImageStyle,
            ImageTextAlternative,
            ImageToolbar,
            ImageUpload,
            Indent,
            IndentBlock,
            Italic,
            Link,
            LinkImage,
            List,
            ListProperties,
            MediaEmbed,
            Paragraph,
            RemoveFormat,
            SpecialCharacters,
            SpecialCharactersArrows,
            SpecialCharactersCurrency,
            SpecialCharactersEssentials,
            SpecialCharactersLatin,
            SpecialCharactersMathematical,
            SpecialCharactersText,
            Strikethrough,
            Subscript,
            Superscript,
            Table,
            TableCaption,
            TableCellProperties,
            TableColumnResize,
            TableProperties,
            TableToolbar,
            Underline
        ],
        fontFamily: {
            options: [
                'default',
                'Arial, Helvetica, sans-serif',
                'Courier New, Courier, monospace',
                'Georgia, serif',
                'Lucida Sans Unicode, Lucida Grande, sans-serif',
                'Tahoma, Geneva, sans-serif',
                'Times New Roman, Times, serif',
                'Trebuchet MS, Helvetica, sans-serif',
                'Verdana, Geneva, sans-serif'
            ],
            supportAllValues: true
        },
        fontSize: {
            options: [10, 12, 14, 'default', 18, 20, 22, 24, 26, 28, 36],
            supportAllValues: true
        },
        heading: {
            options: [
                {model: 'paragraph', title: 'Paragraph', class: 'ck-heading_paragraph'},
                {model: 'heading1', view: 'h1', title: 'Heading 1', class: 'ck-heading_heading1'},
                {model: 'heading2', view: 'h2', title: 'Heading 2', class: 'ck-heading_heading2'},
                {model: 'heading3', view: 'h3', title: 'Heading 3', class: 'ck-heading_heading3'},
                {model: 'heading4', view: 'h4', title: 'Heading 4', class: 'ck-heading_heading4'},
                {model: 'heading5', view: 'h5', title: 'Heading 5', class: 'ck-heading_heading5'},
                {model: 'heading6', view: 'h6', title: 'Heading 6', class: 'ck-heading_heading6'}
            ]
        },
        image: {
            toolbar: [
                'imageTextAlternative', 'imageStyle:inline', 'imageStyle:block', 'imageStyle:side', 'linkImage'
            ]
        },
        link: {
            addTargetToExternalLinks: true,
            defaultProtocol: 'https://'
        },
        list: {
            properties: {
                styles: true,
                startIndex: true,
                reversed: true
            }
        },
        table: {
            contentToolbar: ['tableColumn', 'tableRow', 'mergeTableCells', 'tableProperties', 'tableCellProperties']
        },
        placeholder: 'Nhập nội dung bài viết tại đây...'
    };
    ClassicEditor
        .create(document.querySelector('#add-content'), editorConfig)
        .then(editor => {
            addEditor = editor;
        })
        .catch(error => {
            console.error('Error initializing add editor:', error);
        });
    ClassicEditor
        .create(document.querySelector('#edit-content'), editorConfig)
        .then(editor => {
            editEditor = editor;
        })
        .catch(error => {
            console.error('Error initializing edit editor:', error);
        });

    function syncAddEditor() {
        try {
            if (addEditor) {
                const content = addEditor.getData();
                const tempDiv = document.createElement('div');
                tempDiv.innerHTML = content;
                const textContent = tempDiv.textContent || tempDiv.innerText || '';
                if (textContent.trim().length === 0) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Thông báo',
                        text: 'Vui lòng nhập nội dung bài viết!'
                    });
                    return false;
                }
                const textarea = document.querySelector('#add-content');
                if (textarea) {
                    textarea.value = content;
                    console.log('Add editor synced, content length:', content.length);
                    return true;
                } else {
                    console.error('Add content textarea not found');
                    Swal.fire({
                        icon: 'error',
                        title: 'Lỗi',
                        text: 'Không tìm thấy trường nội dung!'
                    });
                    return false;
                }
            } else {
                console.error('Add editor not initialized');
                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi',
                    text: 'Editor chưa được khởi tạo!'
                });
                return false;
            }
        } catch (error) {
            console.error('Error syncing add editor:', error);
            Swal.fire({
                icon: 'error',
                title: 'Lỗi',
                text: 'Lỗi khi lưu nội dung: ' + error.message
            });
            return false;
        }
    }

    function syncEditEditor() {
        try {
            if (editEditor) {
                const content = editEditor.getData();
                const tempDiv = document.createElement('div');
                tempDiv.innerHTML = content;
                const textContent = tempDiv.textContent || tempDiv.innerText || '';
                if (textContent.trim().length === 0) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Thông báo',
                        text: 'Vui lòng nhập nội dung bài viết!'
                    });
                    return false;
                }
                const textarea = document.querySelector('#edit-content');
                if (textarea) {
                    textarea.value = content;
                    console.log('Edit editor synced, content length:', content.length);
                    return true;
                } else {
                    console.error('Edit content textarea not found');
                    Swal.fire({
                        icon: 'error',
                        title: 'Lỗi',
                        text: 'Không tìm thấy trường nội dung!'
                    });
                    return false;
                }
            } else {
                console.error('Edit editor not initialized');
                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi',
                    text: 'Editor chưa được khởi tạo!'
                });
                return false;
            }
        } catch (error) {
            console.error('Error syncing edit editor:', error);
            Swal.fire({
                icon: 'error',
                title: 'Lỗi',
                text: 'Lỗi khi lưu nội dung: ' + error.message
            });
            return false;
        }
    }

    function updatePageInfo() {
        const info = blogTable.page.info();
        $('#pageInfo').text((info.page + 1) + ' / ' + info.pages);
    }

    function showList() {
        $('#blog-detail').hide();
        $('.users-table').show();
    }

    document.addEventListener("DOMContentLoaded", () => {
        const logoutBtn = document.getElementById("logoutBtn");
        const logoutModal = document.getElementById("logoutModal");
        const cancelLogout = document.getElementById("cancelLogout");
        if (logoutBtn && logoutModal && cancelLogout) {
            logoutBtn.addEventListener("click", () => logoutModal.style.display = "flex");
            cancelLogout.addEventListener("click", () => logoutModal.style.display = "none");
        }
    });
</script>
<script>
    function openEditModal(btn) {
        document.getElementById("edit-id").value = btn.dataset.id;
        document.getElementById("edit-title").value = btn.dataset.title;
        document.getElementById("edit-content").value = btn.dataset.content;
        document.getElementById("edit-image").value = btn.dataset.image;
        document.getElementById("edit-product").value = btn.dataset.product;
        if (editEditor) {
            editEditor.setData(btn.dataset.content);
        }
        let modal = new bootstrap.Modal(
            document.getElementById("editBlogModal")
        );
        modal.show();
    }

    function openViewModal(btn) {
        console.log("VIEW", btn.dataset);
        document.getElementById("view-id").innerText = btn.dataset.id;
        document.getElementById("view-title").innerText = btn.dataset.title;
        document.getElementById("view-content").innerHTML = btn.dataset.content;
        document.getElementById("view-date").innerText = btn.dataset.date;
        document.getElementById("view-product").innerText = "SP" + btn.dataset.product;
        const img = document.getElementById("view-image");
        img.src = btn.dataset.image;
        let modal = new bootstrap.Modal(
            document.getElementById("viewBlogModal")
        );
        modal.show();
    }

    function confirmDelete(btn) {
        const id = btn.dataset.id;
        Swal.fire({
            title: 'Bạn có chắc chắn?',
            text: "Bạn sẽ không thể khôi phục lại bài viết này!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Có, xóa nó!',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = baseUrl + '/admin/blog-manage';
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                form.appendChild(actionInput);
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = id;
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        })
    }
</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const menuItems = document.querySelectorAll(".has-submenu .menu-item");
        menuItems.forEach(item => {
            item.addEventListener("click", function () {
                const parent = this.parentElement;
                parent.classList.toggle("open");
            });
        });
    });
    setTimeout(() => {
        const alert = document.getElementById("alertMsg");
        if (alert) {
            alert.classList.add("fade");
            alert.style.opacity = "0";
            setTimeout(() => alert.remove(), 500);
        }
    }, 3000);
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</html>