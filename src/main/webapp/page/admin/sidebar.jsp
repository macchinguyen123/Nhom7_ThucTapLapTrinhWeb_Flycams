<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="role" value="${sessionScope.user.roleId}" />
<aside class="sidebar">
    <div class="user-info">
        <c:choose>
            <c:when test="${not empty sessionScope.user.avatar}">
                <img src="${pageContext.request.contextPath}/image/avatar/${sessionScope.user.avatar}?v=${sessionScope.user.updatedAt != null ? sessionScope.user.updatedAt.time : ''}"alt="Avatar"
                     style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover;">
            </c:when>
            <c:otherwise> <img src="${pageContext.request.contextPath}/image/logoTCN.png" alt="Avatar">  </c:otherwise>
        </c:choose>
        <h3>${sessionScope.user.fullName}</h3>
        <p>Chào mừng bạn trở lại </p>
    </div>
    <ul class="menu">
        <a href="${pageContext.request.contextPath}/admin/dashboard">
            <li class="${param.activePage == 'dashboard' ? 'active' : ''}"><i class="bi bi-speedometer2"></i> Tổng Quan</li> </a>
        <c:choose>
            <c:when test="${role == 1}">
                <a href="${pageContext.request.contextPath}/admin/customer-manage">
                    <li class="${param.activePage == 'customer' ? 'active' : ''}"><i class="bi bi-person-lines-fill"></i> Quản Lý Tài Khoản</li></a>
            </c:when>
            <c:otherwise>
                <a href="javascript:void(0)" style="opacity: 0.5; cursor: not-allowed; text-decoration: none;" onclick="return false;">
                    <li style="cursor: not-allowed;"><i class="bi bi-person-lines-fill"></i> Quản Lý Tài Khoản</li></a>
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${role == 1 || role == 4}">
                <a href="${pageContext.request.contextPath}/admin/product-management">
                    <li class="${param.activePage == 'product' ? 'active' : ''}"><i class="bi bi-box-seam"></i> Quản Lý Sản Phẩm</li></a>
            </c:when>
            <c:otherwise>
                <a href="javascript:void(0)" style="opacity: 0.5; cursor: not-allowed; text-decoration: none;" onclick="return false;">
                    <li style="cursor: not-allowed;"><i class="bi bi-box-seam"></i> Quản Lý Sản Phẩm</li>
                </a>
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${role == 1 || role == 4}">
                <a href="${pageContext.request.contextPath}/admin/inventory-manage">
                    <li class="${param.activePage == 'inventory' ? 'active' : ''}"><i class="bi bi-boxes"></i> Quản Lý Kho Hàng</li>
                </a>
            </c:when>
            <c:otherwise>
                <a href="javascript:void(0)" style="opacity: 0.5; cursor: not-allowed; text-decoration: none;" onclick="return false;">
                    <li style="cursor: not-allowed;"><i class="bi bi-boxes"></i> Quản Lý Kho Hàng</li>
                </a>
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${role == 1 || role == 4}">
                <a href="${pageContext.request.contextPath}/admin/category-manage">
                    <li class="${param.activePage == 'category' ? 'active' : ''}"><i class="bi bi-tags"></i> Quản Lý Danh Mục</li>
                </a>
            </c:when>
            <c:otherwise>
                <a href="javascript:void(0)" style="opacity: 0.5; cursor: not-allowed; text-decoration: none;" onclick="return false;">
                    <li style="cursor: not-allowed;"><i class="bi bi-tags"></i> Quản Lý Danh Mục</li>
                </a>
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${role == 1 || role == 3}">
                <li class="has-submenu ${param.activePage == 'orders' ? 'active open' : ''}">
                    <div class="menu-item">
                        <i class="bi bi-truck"></i>
                        <span>Quản Lý Đơn Hàng</span>
                        <i class="bi ${param.activePage == 'orders' ? 'bi-chevron-down' : 'bi-chevron-right'} arrow"></i>
                    </div>
                    <ul class="submenu" style="${param.activePage == 'orders' ? 'display: block;' : 'display: none;'}">
                        <a href="${pageContext.request.contextPath}/admin/unconfirmed-orders">
                            <li class="${param.activeSubPage == 'unconfirmed' ? 'active' : ''}">Chưa Xác Nhận</li>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/order-manage">
                            <li class="${param.activeSubPage == 'confirmed' ? 'active' : ''}">Đã Xác Nhận</li>
                        </a>
                    </ul>
                </li>
            </c:when>
            <c:otherwise>
                <a href="javascript:void(0)" style="opacity: 0.5; cursor: not-allowed; text-decoration: none;" onclick="return false;">
                    <li style="cursor: not-allowed;"><i class="bi bi-truck"></i> Quản Lý Đơn Hàng</li></a> </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${role == 1}">
                <a href="${pageContext.request.contextPath}/admin/blog-manage">
                    <li class="${param.activePage == 'blog' ? 'active' : ''}"><i class="bi bi-journal-text"></i> Quản Lý Blog</li>  </a>
            </c:when>
            <c:otherwise>
                <a href="javascript:void(0)" style="opacity: 0.5; cursor: not-allowed; text-decoration: none;" onclick="return false;">
                    <li style="cursor: not-allowed;"><i class="bi bi-journal-text"></i> Quản Lý Blog</li>
                </a>
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${role == 1}">
                <a href="${pageContext.request.contextPath}/admin/promotion-manage">
                    <li class="${param.activePage == 'promotion' ? 'active' : ''}"><i class="bi bi-megaphone"></i> Quản Lý Khuyến Mãi</li> </a></c:when>
            <c:otherwise>
                <a href="javascript:void(0)" style="opacity: 0.5; cursor: not-allowed; text-decoration: none;" onclick="return false;">
                    <li style="cursor: not-allowed;"><i class="bi bi-megaphone"></i> Quản Lý Khuyến Mãi</li>
                </a>
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${role == 1}">
                <a href="${pageContext.request.contextPath}/admin/statistics">
                    <li class="${param.activePage == 'statistics' ? 'active' : ''}"><i class="bi bi-bar-chart"></i> Báo Cáo & Thống Kê</li>   </a> </c:when>
            <c:otherwise>
                <a href="javascript:void(0)" style="opacity: 0.5; cursor: not-allowed; text-decoration: none;" onclick="return false;">
                    <li style="cursor: not-allowed;"><i class="bi bi-bar-chart"></i> Báo Cáo & Thống Kê</li>
                </a>   </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${role == 1 || role == 5}">
                <a href="${pageContext.request.contextPath}/admin/chat-manage">
                    <li class="${param.activePage == 'chat' ? 'active' : ''}"><i class="bi bi-chat-left-text"></i> Hộp thoại</li>
                </a>  </c:when>
            <c:otherwise>
                <a href="javascript:void(0)" style="opacity: 0.5; cursor: not-allowed; text-decoration: none;" onclick="return false;">
                    <li style="cursor: not-allowed;"><i class="bi bi-chat-left-text"></i> Hộp thoại</li>
                </a>
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${role == 1 || role == 5}">
                <a href="${pageContext.request.contextPath}/admin/complaints">
                    <li class="${param.activePage == 'complaints' ? 'active' : ''}"><i class="bi bi-exclamation-triangle"></i> Quản Lý Khiếu Nại</li></a>
            </c:when>
            <c:otherwise>
                <a href="javascript:void(0)" style="opacity: 0.5; cursor: not-allowed; text-decoration: none;" onclick="return false;">
                    <li style="cursor: not-allowed;"><i class="bi bi-exclamation-triangle"></i> Quản Lý Khiếu Nại</li>
                </a> </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${role == 1 || role == 4}">
                <a href="${pageContext.request.contextPath}/admin/banner-manage">
                    <li class="${param.activePage == 'banner' ? 'active' : ''}"><i class="bi bi-images"></i> Quản Lý Banner</li> </a>
            </c:when>
            <c:otherwise>
                <a href="javascript:void(0)" style="opacity: 0.5; cursor: not-allowed; text-decoration: none;" onclick="return false;">
                    <li style="cursor: not-allowed;"><i class="bi bi-images"></i> Quản Lý Banner</li></a></c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${role == 1 || role == 5}">
                <a href="${pageContext.request.contextPath}/admin/review-manage">
                    <li class="${param.activePage == 'review' ? 'active' : ''}"><i class="bi bi-shield-exclamation"></i> Quản Lý Đánh Giá Xấu</li> </a>
            </c:when>
            <c:otherwise>
                <a href="javascript:void(0)" style="opacity: 0.5; cursor: not-allowed; text-decoration: none;" onclick="return false;">
                    <li style="cursor: not-allowed;"><i class="bi bi-shield-exclamation"></i> Quản Lý Đánh Giá Xấu</li></a> </c:otherwise>
        </c:choose>
    </ul>
</aside>
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