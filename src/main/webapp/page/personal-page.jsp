<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Hồ Sơ Của Tôi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
          rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/footer.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/stylesheets/personal-page.css?v=${System.currentTimeMillis()}">
</head>
<jsp:include page="/page/header-common.jsp"/>

<body>
<div class="container">
    <aside class="sidebar">
        <div class="user-info">
            <div class="avatar-container"
                 onclick="document.getElementById('avatar-upload').click();"
                 style="position: relative; width: 90px; height: 90px; margin: 0 auto 15px; cursor: pointer;">
                <div class="avatar-wrapper" id="sidebar-avatar-wrapper"
                     style="width: 100%; height: 100%; border-radius: 50%; overflow: hidden; background: #ddd; border: 2px solid #fff; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                    <img src="${pageContext.request.contextPath}/image/avatar/${user.avatar}"
                         id="sidebar-avatar-img" class="avatar-img"
                         style="width: 100%; height: 100%; object-fit: cover !important;">
                </div>
                <span class="avatar-camera">
                                        <i class="bi bi-camera-fill"></i>
                                    </span>
            </div>
            <input type="file" id="avatar-upload" accept="image/*" style="display: none !important;"
                   onclick="this.value=''" onchange="previewAndSaveAvatar(this)">
            <p class="username">${user.username}</p>
        </div>
        <nav class="menu">
            <ul>
                <li class="active" data-section="profile-section"><a href="#">Tài Khoản Của Tôi</a>
                </li>
                <li data-section="repass-section"><a href="#">Đổi mật khẩu</a></li>
                <li data-section="orders-section"><a href="#">Đơn Mua</a></li>
                <li data-section="addresses-section"><a
                        href="${pageContext.request.contextPath}/ListAddressServlet">Địa Chỉ Nhận
                    Hàng</a></li>
            </ul>
        </nav>
        <div class="logout-section">
            <a href="${pageContext.request.contextPath}/purchasehistory">
                <button id="logoutBtn1">Lịch sử mua hàng</button>
            </a>
            <a href="${pageContext.request.contextPath}/Logout">
                <button id="logoutBtn">Đăng Xuất</button>
            </a>
        </div>
    </aside>
    <main class="content">
        <section id="profile-section" class="section active">
            <h2>Hồ Sơ Của Tôi</h2>
            <p class="desc">Quản lý thông tin hồ sơ để bảo mật tài khoản</p>
            <form action="${pageContext.request.contextPath}/UpdateProfileServlet" method="post">
                <div class="form-row">
                    <div class="form-group">
                        <label for="fullName">Họ tên</label>
                        <input type="text" name="fullName" id="fullName" value="${user.fullName}"
                               required>
                    </div>
                    <div class="form-group">
                        <label for="username">Tên tài khoản</label>
                        <input type="text" name="username" id="username" value="${user.username}">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="text" id="email" value="${user.email}" readonly>
                    </div>
                    <div class="form-group">
                        <label for="phoneNumber">Số điện thoại</label>
                        <input type="text" name="phoneNumber" id="phoneNumber"
                               value="${user.phoneNumber}" required pattern="[0-9]{10}"
                               title="Số điện thoại phải bao gồm đúng 10 chữ số">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="gender">Giới tính</label>
                        <select name="gender" id="gender">
                            <option value="Nam" ${user.gender eq 'Nam' ? 'selected' : '' }>Nam
                            </option>
                            <option value="Nữ" ${user.gender eq 'Nữ' ? 'selected' : '' }>Nữ</option>
                            <option value="" ${empty user.gender ? 'selected' : '' }>Chưa chọn
                            </option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="birthDate">Ngày sinh</label>
                        <input type="date" name="birthDate" id="birthDate"
                               value="<fmt:formatDate value='${user.birthDate}' pattern='yyyy-MM-dd'/>"
                               max="<fmt:formatDate value='${now}' pattern='yyyy-MM-dd'/>">
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">Cập nhật</button>
            </form>
        </section>
        <section id="repass-section" class="section" style="max-width: 450px; margin: 0 auto;">
            <h2>Đổi Mật Khẩu</h2>
            <p class="desc">Vui lòng xác minh qua mã OTP để đảm bảo an toàn cho tài khoản của bạn
            </p>
            <form id="passwordForm" class="password-form" method="post"
                  action="SendOtpChangePassword">
                <div class="form-group">
                    <label for="currentPassword">Mật khẩu hiện tại</label>
                    <input type="password" name="currentPassword" id="currentPassword" required>
                    <c:if test="${not empty currentPasswordError}">
                        <span class="error">${currentPasswordError}</span>
                    </c:if>
                </div>
                <div class="form-group">
                    <label for="newPassword">Mật khẩu mới</label>
                    <input type="password" name="password" id="newPassword" required>
                    <div id="newPasswordFeedback"
                         style="font-size: 0.85rem; margin-top: 5px; display: none;"></div>
                    <c:if test="${not empty passwordError}">
                        <span class="error">${passwordError}</span>
                    </c:if>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Nhập lại mật khẩu mới</label>
                    <input type="password" name="confirm" id="confirmPassword" required>
                    <c:if test="${not empty confirmPasswordError}">
                        <span class="error">${confirmPasswordError}</span>
                    </c:if>
                </div>
                <div class="otp-group">
                    <label for="otpInput">Nhập mã OTP</label>
                    <input type="text" name="otp" id="otpInput" maxlength="6">
                    <c:if test="${not empty otpError}">
                        <span class="error">${otpError}</span>
                    </c:if>
                </div>
                <div class="btn-group">
                    <button type="button" id="sendOtpBtn" class="save-btn">Gửi OTP</button>
                    <button type="button" id="confirmChangeBtn" class="save-btn"
                            style="display: none;">Xác nhận đổi mật khẩu
                    </button>
                </div>
            </form>
            <c:if test="${otpSent}">
                <script>
                    document.querySelector(".otp-group").style.display = "block";
                    document.getElementById("sendOtpBtn").style.display = "none";
                    document.getElementById("confirmChangeBtn").style.display = "inline-block";
                </script>
            </c:if>
        </section>
        <section id="orders-section" class="section">
            <h2>Đơn Mua</h2>
            <div id="order-list" class="order-table"
                 style="display: ${not empty selectedOrder ? 'none' : 'block'}">
                <div class="order-tabs">
                    <button class="order-tab active" data-status="PENDING"><i
                            class="bi bi-hourglass-split me-1"></i> Chờ xác nhận
                    </button>
                    <button class="order-tab" data-status="PROCESSING"><i
                            class="bi bi-box-seam me-1"></i> Đang xử lý
                    </button>
                    <button class="order-tab" data-status="OUT_FOR_DELIVERY"><i
                            class="bi bi-truck me-1"></i> Đang giao
                    </button>
                    <button class="order-tab" data-status="DELIVERED"><i
                            class="bi bi-check-circle me-1"></i> Hoàn thành
                    </button>
                    <button class="order-tab" data-status="CANCELLED"><i
                            class="bi bi-x-circle me-1"></i> Hủy
                    </button>
                    <button class="order-tab" data-status="RETURN_REQUESTED"><i
                            class="bi bi-arrow-return-left me-1"></i> Yêu cầu trả hàng
                    </button>
                    <button class="order-tab" data-status="RETURNED"><i
                            class="bi bi-box-arrow-in-left me-1"></i> Đã trả hàng
                    </button>
                </div>
                <h3>Hóa đơn gần đây</h3>
                <table>
                    <thead>
                    <tr>
                        <th>Mã hóa đơn</th>
                        <th>Thời gian cập nhật</th>
                        <th>Trạng thái</th>
                        <th>Tổng giá trị</th>
                        <th class="text-center">Thao Tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="5" class="text-center">Chưa có đơn hàng</td>
                        </tr>
                    </c:if>
                    <c:forEach var="o" items="${orders}">
                        <tr>
                            <td>${o.id}</td>
                            <td>
                                <fmt:formatDate value="${o.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </td>
                            <td class="status-col" data-status="${o.status.name()}">
                                <c:choose>
                                    <c:when test="${o.status.name() eq 'PENDING'}">
                                        <span class="badge bg-warning text-dark"><i class="bi bi-hourglass-split me-1"></i> Chờ xác nhận</span>
                                    </c:when>
                                    <c:when test="${o.status.name() eq 'PROCESSING'}">
                                        <span class="badge bg-primary"><i class="bi bi-box-seam me-1"></i> Đang xử lý</span>
                                    </c:when>
                                    <c:when test="${o.status.name() eq 'OUT_FOR_DELIVERY'}">
                                                                <span class="badge bg-info text-dark"><i class="bi bi-truck me-1"></i> Đang giao</span>
                                    </c:when>
                                    <c:when test="${o.status.name() eq 'DELIVERED'}">
                                                                <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i> Hoàn thành</span>
                                    </c:when>
                                    <c:when test="${o.status.name() eq 'CANCELLED'}">
                                                                <span class="badge bg-danger"><i class="bi bi-x-circle me-1"></i> Đã huỷ</span>
                                    </c:when>
                                    <c:when test="${o.status.name() eq 'RETURN_REQUESTED'}">
                                                                <span class="badge bg-info text-dark"><i class="bi bi-arrow-return-left me-1"></i> Yêu cầu trả hàng</span>
                                    </c:when>
                                    <c:when test="${o.status.name() eq 'RETURNED'}">
                                                                <span class="badge bg-secondary"><i class="bi bi-box-arrow-in-left me-1"></i> Đã trả hàng</span>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>
                                <fmt:formatNumber value="${o.totalPrice}" type="number"/> ₫
                            </td>
                            <td class="thao-tac-col">
                                <a class="btn btn-view btn-sm"
                                   href="${pageContext.request.contextPath}/personal?orderId=${o.id}">
                                    <i class="bi bi-eye"></i> Xem chi tiết
                                </a>
                                <c:if test="${o.status.name() eq 'PENDING'}">
                                    <form method="post"
                                          action="${pageContext.request.contextPath}/personal"
                                          style="display:inline"
                                          onsubmit="return confirm('Bạn có chắc muốn huỷ đơn hàng #${o.id} ?');">
                                        <input type="hidden" name="action" value="cancelOrder">
                                        <input type="hidden" name="orderId" value="${o.id}">
                                        <button type="button" class="btn btn-danger btn-sm"
                                                onclick="openCancelModal(${o.id})">
                                            <i class="bi bi-trash"></i> Huỷ đơn
                                        </button>
                                    </form>
                                </c:if>
                                <c:if test="${o.returnable}">
                                    <button type="button" class="btn btn-warning btn-sm"
                                            onclick="openReturnModal(${o.id})">
                                        <i class="bi bi-arrow-return-left"></i> Trả hàng
                                    </button>
                                </c:if>
                                <c:if test="${o.status.name() eq 'RETURN_REQUESTED'}">
                                    <button type="button" class="btn btn-secondary btn-sm"
                                            onclick="openUndoReturnModal(${o.id})">
                                        <i class="bi bi-arrow-counterclockwise"></i> Hoàn tác
                                    </button>
                                </c:if>
                                <c:if test="${o.status.name() eq 'OUT_FOR_DELIVERY'}">
                                    <button type="button" class="btn btn-success btn-sm"
                                            onclick="openReceiveModal(${o.id})">
                                        <i class="bi bi-check2-circle"></i> Đã nhận hàng
                                    </button>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="modal fade" id="cancelModal" tabindex="-1"
                 aria-labelledby="cancelModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <form method="post" action="${pageContext.request.contextPath}/personal">
                        <div class="modal-content">
                            <div class="modal-header bg-danger text-white">
                                <h5 class="modal-title" id="cancelModalLabel">
                                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                    Xác nhận hủy đơn hàng
                                </h5>
                                <button type="button" class="btn-close btn-close-white"
                                        data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" name="action" value="cancelOrder">
                                <input type="hidden" name="orderId" id="cancelOrderId">
                                <div class="alert alert-warning" role="alert">
                                    <i class="bi bi-info-circle-fill me-2"></i>
                                    Bạn có chắc chắn muốn hủy đơn hàng này? Hành động này không thể hoàn tác.
                                </div>
                                <div class="mb-3">
                                    <label for="cancelReason" class="form-label">
                                        Lý do hủy đơn <span class="text-muted">(không bắt buộc)</span>
                                    </label>
                                    <textarea class="form-control" id="cancelReason" rows="3"
                                              placeholder="Ví dụ: Tôi muốn thay đổi địa chỉ giao hàng, Tôi tìm được giá tốt hơn..."></textarea>
                                    <small class="text-muted">
                                    </small>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">
                                    <i class="bi bi-x-circle me-1"></i>
                                    Không, giữ đơn hàng
                                </button>
                                <button type="submit" class="btn btn-danger">
                                    <i class="bi bi-trash-fill me-1"></i>
                                    Xác nhận hủy đơn
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="modal fade" id="returnModal" tabindex="-1"
                 aria-labelledby="returnModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <form method="post" action="${pageContext.request.contextPath}/personal">
                        <div class="modal-content">
                            <div class="modal-header bg-warning text-dark">
                                <h5 class="modal-title" id="returnModalLabel">
                                    <i class="bi bi-arrow-return-left me-2"></i>
                                    Yêu cầu trả hàng
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" name="action" value="returnOrder">
                                <input type="hidden" name="orderId" id="returnOrderId">
                                <div class="alert alert-info" role="alert">
                                    <i class="bi bi-info-circle-fill me-2"></i>
                                    Bạn có chắc chắn muốn trả đơn hàng này? Việc trả hàng chỉ được phép trong vòng 30 ngày kể từ khi hoàn thành đơn.
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">
                                    <i class="bi bi-x-circle me-1"></i>
                                    Đóng
                                </button>
                                <button type="submit" class="btn btn-warning">
                                    <i class="bi bi-check-circle-fill me-1"></i>
                                    Yêu cầu trả hàng
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="modal fade" id="undoReturnModal" tabindex="-1"
                 aria-labelledby="undoReturnModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <form method="post" action="${pageContext.request.contextPath}/personal">
                        <div class="modal-content">
                            <div class="modal-header bg-secondary text-white">
                                <h5 class="modal-title" id="undoReturnModalLabel">
                                    <i class="bi bi-arrow-counterclockwise me-2"></i>
                                    Hoàn tác yêu cầu trả hàng
                                </h5>
                                <button type="button" class="btn-close btn-close-white"
                                        data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" name="action" value="undoReturnOrder">
                                <input type="hidden" name="orderId" id="undoReturnOrderId">
                                <div class="alert alert-info" role="alert">
                                    <i class="bi bi-info-circle-fill me-2"></i>
                                    Bạn có chắc chắn muốn hoàn tác yêu cầu trả hàng? Đơn hàng sẽ trở lại trạng thái "Hoàn thành".
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-light" data-bs-dismiss="modal">
                                    <i class="bi bi-x-circle me-1"></i>
                                    Đóng
                                </button>
                                <button type="submit" class="btn btn-secondary">
                                    <i class="bi bi-check-circle-fill me-1"></i>
                                    Xác nhận hoàn tác
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="modal fade" id="receiveModal" tabindex="-1"
                 aria-labelledby="receiveModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <form method="post" action="${pageContext.request.contextPath}/personal">
                        <div class="modal-content">
                            <div class="modal-header bg-success text-white">
                                <h5 class="modal-title" id="receiveModalLabel">
                                    <i class="bi bi-check2-circle me-2"></i>
                                    Xác nhận nhận hàng
                                </h5>
                                <button type="button" class="btn-close btn-close-white"
                                        data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" name="action" value="receiveOrder">
                                <input type="hidden" name="orderId" id="receiveOrderId">
                                <div class="alert alert-success" role="alert">
                                    <i class="bi bi-info-circle-fill me-2"></i>
                                    Bạn xác nhận đã nhận được đơn hàng này thành công? Trạng thái sẽ cập nhật thành Hoàn thành.
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">
                                    <i class="bi bi-x-circle me-1"></i>
                                    Đóng
                                </button>
                                <button type="submit" class="btn btn-success">
                                    <i class="bi bi-check-circle-fill me-1"></i>
                                    Đã nhận hàng
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div id="order-detail" class="order-card"
                 style="display: ${empty selectedOrder ? 'none' : 'block'}">
                <a href="${pageContext.request.contextPath}/personal?tab=orders" class="btn mb-3"
                   style="background:#0051c6;color:white">← Quay lại danh sách
                </a>
                <c:if test="${not empty selectedOrder}">
                    <p>
                        Mã vận chuyển:
                        <strong>${selectedOrder.shippingCode}</strong>
                    </p>
                    <p>
                        Ngày nhận hàng dự kiến:
                        <strong>
                            <fmt:formatDate value="${expectedDeliveryDate}" pattern="dd/MM/yyyy"/>
                        </strong>
                    </p>
                    <div class="order-progress">
                        <div
                                class="step ${selectedOrder.status.name() eq 'PROCESSING' ? 'active' : ''}">
                            ĐANG XỬ LÝ
                        </div>
                        <div
                                class="step ${selectedOrder.status.name() eq 'OUT_FOR_DELIVERY' ? 'active' : ''}">
                            ĐANG VẬN CHUYỂN
                        </div>
                        <div
                                class="step ${selectedOrder.status.name() eq 'DELIVERED' ? 'active' : ''}">
                            ĐÃ GIAO
                        </div>
                    </div>
                    <hr>
                    <c:forEach var="item" items="${orderItems}">
                        <a href="${pageContext.request.contextPath}/product-detail?id=${item.product.id}"
                           style="text-decoration: none; color: inherit; display:flex; gap:12px; margin-bottom:16px">
                            <c:choose>
                                <c:when
                                        test="${fn:startsWith(item.product.mainImage, 'http://') || fn:startsWith(item.product.mainImage, 'https://')}">
                                    <img src="${item.product.mainImage}"
                                         onerror="this.src='${pageContext.request.contextPath}/image/products/no-image.png'"
                                         loading="lazy" width="80" height="80"
                                         alt="${item.product.productName}"
                                         style="border: 1px solid #ccc; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/${item.product.mainImage}"
                                         onerror="this.src='${pageContext.request.contextPath}/image/products/no-image.png'"
                                         loading="lazy" width="80" height="80"
                                         alt="${item.product.productName}"
                                         style="border: 1px solid #ccc; object-fit: cover;">
                                </c:otherwise>
                            </c:choose>
                            <div>
                                <div style="color: #0051c6;">
                                    <strong>${item.product.productName}</strong></div>
                                <div>Số lượng: ${item.quantity}</div>
                                <div>
                                    Giá:
                                    <fmt:formatNumber value="${item.price}" type="number"/> đ
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                    <hr>
                    <div class="row">
                        <div class="col-md-6">
                            <h5>Địa chỉ giao hàng</h5>
                            <c:if test="${not empty selectedOrder}">
                                <p>Người nhận: ${shippingInfo.recipientName}</p>
                                <p>SĐT: ${shippingInfo.receiverPhone}</p>
                                <p>Địa chỉ: ${shippingInfo.shippingAddress}</p>
                            </c:if>
                        </div>
                        <div class="col-md-6 text-end">
                            <p class="fs-5">
                                <strong>
                                    Tổng tiền:
                                    <fmt:formatNumber value="${selectedOrder.totalPrice}"
                                                      type="number"/> ₫
                                </strong>
                            </p>
                            <p>Phương thức: ${selectedOrder.paymentMethod}</p>
                        </div>
                    </div>
                </c:if>
            </div>
        </section>
        <section id="addresses-section" class="section">
            <h2>Địa Chỉ Nhận Hàng</h2>
            <button id="openPopup" class="btn btn-outline">Thêm địa chỉ</button>
            <div class="address-list">
                <c:if test="${not empty addresses}">
                    <ul>
                        <c:forEach var="addr" items="${addresses}">
                            <li class="address-item">
                                <div class="address-item__header">
                                    <div class="address-item__info">
                                        <strong>${addr.fullName}</strong> - ${addr.phoneNumber}<br>
                                            ${addr.addressLine}, ${addr.district}, ${addr.province}
                                        <c:if test="${addr.defaultAddress}">
                                            <span class="address-item__default">[Mặc định]</span>
                                        </c:if>
                                    </div>
                                    <div class="address-item__actions">
                                        <button
                                                onclick="openEditPopup(${addr.id}, '${addr.fullName}', '${addr.phoneNumber}', '${addr.addressLine}', '${addr.province}', '${addr.district}', '${addr.ward}', ${addr.defaultAddress})"
                                                class="btn btn-sm btn-primary">Sửa
                                        </button>
                                        <a href="${pageContext.request.contextPath}/DeleteAddressServlet?id=${addr.id}"
                                           onclick="confirmDeleteAddress(event, this.href); return false;"
                                           class="btn btn-sm btn-danger">Xóa</a>
                                    </div>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:if>
                <c:if test="${empty addresses}">
                    <p style="display: flex; flex-direction: column; align-items: center; gap: 10px;">
                        <i class="bi bi-inbox" style="font-size: 48px; color: #ccc;"></i>
                        <span>Chưa có địa chỉ nào.</span>
                    </p>
                </c:if>
            </div>
            <p class="instruction">Vui lòng nhập đầy đủ thông tin để đảm bảo đơn hàng được giao
                chính xác</p>
            <div id="popup" class="popup hidden">
                <div class="popup-content">
                    <span id="closePopup" class="close">&times;</span>
                    <h2>Thêm địa chỉ</h2>
                    <form action="${pageContext.request.contextPath}/AddAddressServlet"
                          method="post">
                        <div class="form-group">
                            <label for="fullName">Họ tên</label>
                            <input type="text" name="fullName" id="fullName" required>
                        </div>
                        <div class="form-group">
                            <label for="phoneNumber">Số điện thoại</label>
                            <input type="text" name="phoneNumber" id="phoneNumber" required pattern="[0-9]{10}" title="Số điện thoại phải bao gồm đúng 10 chữ số">
                        </div>
                        <div class="form-group">
                            <label for="addressLine">Địa chỉ</label>
                            <input type="text" name="addressLine" id="addressLine" required>
                        </div>
                        <div class="form-group">
                            <label for="province">Tỉnh/Thành phố</label>
                            <select name="province" id="province" required>
                                <option value="">-- Chọn Tỉnh/Thành phố --</option>
                            </select>
                            <input type="hidden" name="provinceCode" id="provinceCodeInput">
                        </div>
                        <div class="form-group">
                            <label for="district">Quận/Huyện</label>
                            <select name="district" id="district" required disabled>
                                <option value="">-- Chọn Quận/Huyện --</option>
                            </select>
                            <input type="hidden" name="districtCode" id="districtCodeInput">
                        </div>
                        <div class="form-group">
                            <label for="ward">Phường/Xã</label>
                            <select name="ward" id="ward" required disabled>
                                <option value="">-- Chọn Phường/Xã --</option>
                            </select>
                            <input type="hidden" name="wardCode" id="wardCodeInput">
                        </div>
                        <div class="checkbox-group">
                            <input type="checkbox" name="isDefault" id="isDefault">
                            <label for="isDefault">Đặt làm địa chỉ mặc định</label>
                        </div>
                        <button type="submit" class="green-button">Thêm địa chỉ</button>
                    </form>
                </div>
            </div>
            <div id="editPopup" class="popup hidden">
                <div class="popup-content">
                    <span id="closeEditPopup" class="close">&times;</span>
                    <h2>Sửa địa chỉ</h2>
                    <form action="${pageContext.request.contextPath}/EditAddressServlet"
                          method="post">
                        <input type="hidden" name="id" id="editId">
                        <div class="form-group">
                            <label for="editFullName">Họ tên</label>
                            <input type="text" name="fullName" id="editFullName" required>
                        </div>
                        <div class="form-group">
                            <label for="editPhoneNumber">Số điện thoại</label>
                            <input type="text" name="phoneNumber" id="editPhoneNumber" required pattern="[0-9]{10}" title="Số điện thoại phải bao gồm đúng 10 chữ số">
                        </div>
                        <div class="form-group">
                            <label for="editAddressLine">Địa chỉ</label>
                            <input type="text" name="addressLine" id="editAddressLine" required>
                        </div>
                        <div class="form-group">
                            <label for="editProvince">Tỉnh/Thành phố</label>
                            <select name="province" id="editProvince" required>
                                <option value="">-- Chọn Tỉnh/Thành phố --</option>
                            </select>
                            <input type="hidden" name="provinceCode" id="editProvinceCodeInput">
                        </div>
                        <div class="form-group">
                            <label for="editDistrict">Quận/Huyện</label>
                            <select name="district" id="editDistrict" required disabled>
                                <option value="">-- Chọn Quận/Huyện --</option>
                            </select>
                            <input type="hidden" name="districtCode" id="editDistrictCodeInput">
                        </div>
                        <div class="form-group">
                            <label for="editWard">Phường/Xã</label>
                            <select name="ward" id="editWard" required disabled>
                                <option value="">-- Chọn Phường/Xã --</option>
                            </select>
                            <input type="hidden" name="wardCode" id="editWardCodeInput">
                        </div>
                        <div class="checkbox-group">
                            <input type="checkbox" name="isDefault" id="editIsDefault">
                            <label for="editIsDefault">Đặt làm địa chỉ mặc định</label>
                        </div>
                        <button type="submit" class="green-button">Cập nhật địa chỉ</button>
                    </form>
                </div>
            </div>
        </section>
    </main>
</div>
<jsp:include page="/page/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    (function () {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('vnpaySuccess') === '1') {
            const url = new URL(window.location.href);
            url.searchParams.delete('vnpaySuccess');
            window.history.replaceState({}, '', url.toString());
            Swal.fire({
                icon: 'success',
                title: 'Thanh toán thành công!',
                html: '<p style="font-size:1.1rem; margin-top:8px;">Đơn hàng của bạn đã được đặt thành công qua <strong>VNPAY</strong>.<br>Cảm ơn bạn đã mua hàng!</p>',
                confirmButtonColor: '#0051c6',
                showConfirmButton: true,
                timer: 5000,
                timerProgressBar: true,
                width: '480px',
                padding: '2em',
                customClass: {
                    title: 'swal-title-big',
                    popup: 'swal-popup-center'
                }
            });
        }
    })();
</script>
<script>
    function openCancelModal(orderId) {
        document.getElementById("cancelOrderId").value = orderId;
        const modal = new bootstrap.Modal(
            document.getElementById("cancelModal")
        );
        modal.show();
    }

    function openReturnModal(orderId) {
        document.getElementById("returnOrderId").value = orderId;
        const modal = new bootstrap.Modal(
            document.getElementById("returnModal")
        );
        modal.show();
    }

    function openUndoReturnModal(orderId) {
        document.getElementById("undoReturnOrderId").value = orderId;
        const modal = new bootstrap.Modal(
            document.getElementById("undoReturnModal")
        );
        modal.show();
    }

    function openReceiveModal(orderId) {
        document.getElementById("receiveOrderId").value = orderId;
        const modal = new bootstrap.Modal(
            document.getElementById("receiveModal")
        );
        modal.show();
    }
</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const avatarUpload = document.getElementById("avatar-upload");
        if (avatarUpload) {
            avatarUpload.addEventListener("change", function () {
                const file = this.files[0];
                if (!file) return;
                console.log("File selected:", file.name);
                if (!file.type.startsWith('image/')) {
                    Swal.fire({icon: 'error', title: 'Lỗi', text: 'Vui lòng chọn tập tin hình ảnh.'});
                    return;
                }
                const reader = new FileReader();
                reader.onload = function (e) {
                    const result = e.target.result;
                    console.log("FileReader done, updating UI...");
                    const img = document.getElementById("sidebar-avatar-img");
                    if (img) {
                        img.src = result;
                        img.style.display = 'block';
                        img.style.opacity = '1';
                    }
                    const wrapper = document.getElementById("sidebar-avatar-wrapper");
                    if (wrapper) {
                        wrapper.style.backgroundImage = `url('${result}')`;
                        wrapper.style.backgroundSize = 'cover';
                        wrapper.style.backgroundPosition = 'center';
                    }
                    document.querySelectorAll(".avatar-img").forEach(item => {
                        if (item.id !== "sidebar-avatar-img") {
                            item.src = result;
                        }
                    });
                };
                reader.readAsDataURL(file);
                Swal.fire({
                    title: 'Đang lưu ảnh đại diện...',
                    didOpen: () => {
                        Swal.showLoading();
                    },
                    allowOutsideClick: false,
                    showConfirmButton: false
                });
                const formData = new FormData();
                formData.append("avatar", file);
                fetch("${pageContext.request.contextPath}/UpdateAvatar", {
                    method: "POST",
                    body: formData
                }).then(res => {
                    if (res.ok) return res.text();
                    return res.text().then(text => {
                        throw new Error(text || "Mã lỗi " + res.status);
                    });
                }).then(newFileName => {
                    console.log("Server saved successfully:", newFileName);
                    const timestamp = new Date().getTime();
                    const finalSrc = "${pageContext.request.contextPath}/image/avatar/" + newFileName + "?t=" + timestamp;
                    document.querySelectorAll(".avatar-img").forEach(img => {
                        img.src = finalSrc;
                    });
                    Swal.fire({
                        icon: "success",
                        title: "Đã lưu thành công!",
                        text: "Ảnh đại diện đã được cập nhật vĩnh viễn.",
                        timer: 1000,
                        showConfirmButton: false
                    });
                }).catch(err => {
                    console.error("Lỗi upload avatar:", err);
                    Swal.fire({
                        icon: "error",
                        title: "Lỗi lưu ảnh!",
                        text: err.message,
                        confirmButtonText: 'Đóng'
                    });
                });
            });
        }
    });
</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const hasOrderDetail = ${ selectedOrder != null };
        const activeTab = "${activeTab}";
        const urlParams = new URLSearchParams(window.location.search);
        const tabParam = urlParams.get('tab');
        if (hasOrderDetail || activeTab === "orders" || tabParam === "orders") {
            document.querySelectorAll(".menu li").forEach(li => li.classList.remove("active"));
            const ordersMenuItem = document.querySelector('[data-section="orders-section"]');
            if (ordersMenuItem) {
                ordersMenuItem.classList.add("active");
            }
            document.querySelectorAll(".section").forEach(sec => sec.classList.remove("active"));
            const ordersSection = document.getElementById("orders-section");
            if (ordersSection) {
                ordersSection.classList.add("active");
            }
            if (tabParam === "orders" && !hasOrderDetail) {
                const orderList = document.getElementById("order-list");
                const orderDetail = document.getElementById("order-detail");
                if (orderList) orderList.style.display = "block";
                if (orderDetail) orderDetail.style.display = "none";
            }
        }
    });
</script>
<script>
    document.querySelectorAll(".order-tab").forEach(tab => {
        tab.addEventListener("click", function () {
            document.querySelectorAll(".order-tab").forEach(t => t.classList.remove("active"));
            this.classList.add("active");
            const status = this.dataset.status;
            const rows = document.querySelectorAll("#order-list tbody tr");
            if (rows.length === 0) return;
            rows.forEach(row => {
                const rowStatus = row.querySelector(".status-col")?.dataset.status;
                row.style.display = (rowStatus === status) ? "" : "none";
            });
        });
    });
    document.addEventListener("DOMContentLoaded", () => {
        document.querySelector(".order-tab")?.click();
    });
</script>
<script>
    const menuItems = document.querySelectorAll(".menu li");
    const sections = document.querySelectorAll(".section");
    menuItems.forEach(item => {
        item.addEventListener("click", function (e) {
            const target = this.getAttribute("data-section");
            if (!target) return;
            e.preventDefault();
            menuItems.forEach(i => i.classList.remove("active"));
            this.classList.add("active");
            sections.forEach(sec => sec.classList.remove("active"));
            document.getElementById(target).classList.add("active");
        });
    });
</script>
<script>
    document.getElementById("newPassword").addEventListener("input", function () {
        const val = this.value;
        const feedback = document.getElementById("newPasswordFeedback");
        if (!val) {
            feedback.style.display = 'none';
            return;
        }
        feedback.style.display = 'block';
        let errors = [];
        if (val.length < 8) errors.push("ít nhất 8 ký tự");
        if (!/[A-Z]/.test(val)) errors.push("1 chữ hoa");
        if (!/[a-z]/.test(val)) errors.push("1 chữ thường");
        if (!/\d/.test(val)) errors.push("1 số");
        if (!/[\W_]/.test(val)) errors.push("1 ký tự đặc biệt");
        if (errors.length > 0) {
            feedback.style.color = '#dc3545';
            feedback.innerHTML = "Mật khẩu yếu: " + errors.join(", ");
        } else {
            feedback.style.color = '#28a745';
            feedback.innerHTML = "Mật khẩu hợp lệ!";
        }
    });
    document.getElementById("sendOtpBtn").addEventListener("click", function () {
        const currentPass = document.getElementById("currentPassword").value;
        const newPass = document.getElementById("newPassword").value;
        const confirmPass = document.getElementById("confirmPassword").value;
        let errors = [];
        if (!currentPass || !newPass || !confirmPass) {
            Swal.fire({icon: 'warning', title: 'Thiếu thông tin', text: 'Vui lòng nhập đầy đủ các trường mật khẩu.'});
            return;
        }
        if (newPass.length < 8) {
            errors.push("Mật khẩu phải có ít nhất 8 ký tự.");
        }
        if (!/[A-Z]/.test(newPass)) {
            errors.push("Mật khẩu phải chứa ít nhất 1 chữ hoa.");
        }
        if (!/[a-z]/.test(newPass)) {
            errors.push("Mật khẩu phải chứa ít nhất 1 chữ thường.");
        }
        if (!/\d/.test(newPass)) {
            errors.push("Mật khẩu phải chứa ít nhất 1 con số.");
        }
        if (!/[\W_]/.test(newPass)) {
            errors.push("Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt.");
        }
        if (newPass !== confirmPass) {
            errors.push("Mật khẩu nhập lại không khớp.");
        }
        if (errors.length > 0) {
            Swal.fire({
                icon: 'error',
                title: 'Lỗi xác thực',
                html: '<div style="text-align: left;">' + errors.map(err => '<p style="margin-bottom: 5px;">• ' + err + '</p>').join('') + '</div>',
                confirmButtonText: 'Đã hiểu'
            });
            return;
        }
        const formData = new FormData();
        formData.append("currentPassword", currentPass);
        const sendOtpBtn = document.getElementById("sendOtpBtn");
        const originalText = sendOtpBtn.innerText;
        sendOtpBtn.innerText = "Đang kiểm tra...";
        sendOtpBtn.disabled = true;
        fetch("${pageContext.request.contextPath}/SendOtpChangePassword", {
            method: "POST",
            body: new URLSearchParams(formData)
        })
            .then(res => res.json())
            .then(data => {
                sendOtpBtn.innerText = originalText;
                sendOtpBtn.disabled = false;
                if (data.status === "ok") {
                    document.querySelector(".otp-group").style.display = "block";
                    document.getElementById("sendOtpBtn").style.display = "none";
                    document.getElementById("confirmChangeBtn").style.display = "inline-block";
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 1000,
                        timerProgressBar: true
                    });
                    Toast.fire({
                        icon: 'success',
                        title: 'Mã OTP đã được gửi đến email của bạn'
                    });
                } else {
                    document.querySelector(".otp-group").style.display = "none";
                    document.getElementById("sendOtpBtn").style.display = "inline-block";
                    document.getElementById("confirmChangeBtn").style.display = "none";
                    Swal.fire({
                        icon: 'error',
                        title: 'Lỗi',
                        text: data.message || 'Không thể gửi mã OTP.'
                    });
                }
            })
            .catch(error => {
                sendOtpBtn.innerText = originalText;
                sendOtpBtn.disabled = false;
                document.querySelector(".otp-group").style.display = "none";
                document.getElementById("sendOtpBtn").style.display = "inline-block";
                document.getElementById("confirmChangeBtn").style.display = "none";
                console.error("Lỗi gửi OTP:", error);
                Swal.fire({icon: 'error', title: 'Lỗi', text: 'Không thể gửi mã OTP. Vui lòng thử lại sau.'});
            });
    });
    document.getElementById("confirmChangeBtn").addEventListener("click", function () {
        const form = document.getElementById("passwordForm");
        form.action = "${pageContext.request.contextPath}/ChangePassword";
        form.submit();
    });
</script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const urlParams = new URLSearchParams(window.location.search);
        const message = urlParams.get('message');
        const status = urlParams.get('status');
        if (message && status) {
            showNotification(decodeURIComponent(message), status);
            const cleanUrl = window.location.pathname;
            window.history.replaceState({}, document.title, cleanUrl);
        }
    });

    function showNotification(message, type = 'success') {
        const oldNotification = document.querySelector('.custom-notification');
        if (oldNotification) {
            oldNotification.remove();
        }
        const notification = document.createElement('div');
        notification.className = 'custom-notification';
        let icon = '';
        if (type === 'success') {
            icon = '<i class="bi bi-check-circle-fill me-2"></i>';
        } else {
            icon = '<i class="bi bi-exclamation-circle-fill me-2"></i>';
        }
        notification.innerHTML = icon + message;
        notification.style.position = 'fixed';
        notification.style.top = '80px';
        notification.style.right = '-300px';
        notification.style.padding = '12px 20px';
        notification.style.borderRadius = '8px';
        notification.style.zIndex = '10000';
        notification.style.fontWeight = '500';
        notification.style.boxShadow = '0 4px 12px rgba(0,0,0,0.2)';
        notification.style.transition = 'right 0.3s ease';
        notification.style.display = 'flex';
        notification.style.alignItems = 'center';
        notification.style.minWidth = '250px';
        if (type === 'success') {
            notification.style.backgroundColor = '#28a745';
            notification.style.color = 'white';
        } else {
            notification.style.backgroundColor = '#dc3545';
            notification.style.color = 'white';
        }
        document.body.appendChild(notification);
        setTimeout(() => {
            notification.style.right = '20px';
        }, 10);
        setTimeout(() => {
            notification.style.right = '-300px';
        }, 2500);
        setTimeout(() => {
            notification.remove();
        }, 3000);
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<c:if test="${not empty error}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            Swal.fire({
                icon: "error",
                title: "Lỗi",
                text: "${error}",
                timer: 4000,
                showConfirmButton: false
            });
        });
    </script>
</c:if>
<c:if test="${not empty success}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            Swal.fire({
                icon: "success",
                title: "Thành công",
                text: "${success}",
                timer: 4000,
                showConfirmButton: false
            });
        });
    </script>
</c:if>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const popup = document.getElementById("popup");
        const openBtn = document.getElementById("openPopup");
        const closeBtn = document.getElementById("closePopup");
        openBtn.addEventListener("click", () => {
            popup.classList.remove("hidden");
        });
        closeBtn.addEventListener("click", () => {
            popup.classList.add("hidden");
        });
        popup.addEventListener("click", (e) => {
            if (e.target === popup) {
                popup.classList.add("hidden");
            }
        });
        const editPopup = document.getElementById("editPopup");
        const closeEditBtn = document.getElementById("closeEditPopup");
        closeEditBtn.addEventListener("click", () => {
            editPopup.classList.add("hidden");
        });
        editPopup.addEventListener("click", (e) => {
            if (e.target === editPopup) {
                editPopup.classList.add("hidden");
            }
        });
    });
    const editProvinceSelect = document.getElementById("editProvince");
    const editDistrictSelect = document.getElementById("editDistrict");
    const editWardSelect = document.getElementById("editWard");
    function openEditPopup(id, fullName, phoneNumber, addressLine, province, district, ward, isDefault) {
        document.getElementById("editId").value = id;
        document.getElementById("editFullName").value = fullName;
        document.getElementById("editPhoneNumber").value = phoneNumber;
        document.getElementById("editAddressLine").value = addressLine;
        document.getElementById("editIsDefault").checked = isDefault;
        if (editProvinceSelect.options.length <= 1) {
            fetch(API_BASE + "/")
                .then(res => res.json())
                .then(provinces => {
                    editProvinceSelect.innerHTML = '<option value="">-- Chọn Tỉnh/Thành phố --</option>';
                    provinces.forEach(p => {
                        const opt = document.createElement("option");
                        opt.value = p.name;
                        opt.textContent = p.name;
                        opt.dataset.code = p.code;
                        if (p.name === province) opt.selected = true;
                        editProvinceSelect.appendChild(opt);
                    });

                    const selectedProvince = editProvinceSelect.options[editProvinceSelect.selectedIndex];
                    if (selectedProvince && selectedProvince.dataset.code) {
                        const code = selectedProvince.dataset.code;
                        document.getElementById("editProvinceCodeInput").value = code;
                        fetch(API_BASE + "/p/" + code + "?depth=2")
                            .then(res => res.json())
                            .then(data => {
                                if (data.districts && data.districts.length > 0) {
                                    editDistrictSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
                                    data.districts.forEach(d => {
                                        const distOpt = document.createElement("option");
                                        distOpt.value = d.name;
                                        distOpt.textContent = d.name;
                                        distOpt.dataset.code = d.code;
                                        if (d.name === district) {
                                            distOpt.selected = true;
                                            document.getElementById("editDistrictCodeInput").value = d.code;
                                        }
                                        editDistrictSelect.appendChild(distOpt);
                                    });
                                    editDistrictSelect.disabled = false;
                                    const selectedDist = editDistrictSelect.options[editDistrictSelect.selectedIndex];
                                    if (selectedDist && selectedDist.dataset.code) {
                                        fetch(API_BASE + "/d/" + selectedDist.dataset.code + "?depth=2")
                                            .then(res => res.json())
                                            .then(dData => {
                                                if (dData.wards && dData.wards.length > 0) {
                                                    editWardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                                                    dData.wards.forEach(w => {
                                                        const wardOpt = document.createElement("option");
                                                        wardOpt.value = w.name;
                                                        wardOpt.textContent = w.name;
                                                        wardOpt.dataset.code = w.code;
                                                        if (w.name === ward) {
                                                            wardOpt.selected = true;
                                                            document.getElementById("editWardCodeInput").value = w.code;
                                                        }
                                                        editWardSelect.appendChild(wardOpt);
                                                    });
                                                    editWardSelect.disabled = false;
                                                }
                                            })
                                            .catch(err => console.error(err));
                                    }
                                }
                            })
                            .catch(err => console.error(err));
                    }
                })
                .catch(err => console.error(err));
        } else {
            editProvinceSelect.value = province;
            editProvinceSelect.dispatchEvent(new Event('change'));
            setTimeout(() => {
                editDistrictSelect.value = district;
                editDistrictSelect.dispatchEvent(new Event('change'));
                setTimeout(() => {
                    editWardSelect.value = ward;
                    const selectedWard = editWardSelect.options[editWardSelect.selectedIndex];
                    if (selectedWard && selectedWard.dataset.code) {
                        document.getElementById("editWardCodeInput").value = selectedWard.dataset.code;
                    }
                }, 500);
            }, 500);
        }
        document.getElementById("editPopup").classList.remove("hidden");
    }

    editProvinceSelect.addEventListener("change", function () {
        const selectedOption = this.options[this.selectedIndex];
        const code = selectedOption.dataset.code;
        document.getElementById("editProvinceCodeInput").value = code || '';
        editDistrictSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
        editDistrictSelect.disabled = true;
        editWardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
        editWardSelect.disabled = true;
        document.getElementById("editDistrictCodeInput").value = '';
        document.getElementById("editWardCodeInput").value = '';
        if (!code) return;
        fetch(API_BASE + "/p/" + code + "?depth=2")
            .then(res => res.json())
            .then(data => {
                if (data.districts && data.districts.length > 0) {
                    data.districts.forEach(d => {
                        const opt = document.createElement("option");
                        opt.value = d.name;
                        opt.textContent = d.name;
                        opt.dataset.code = d.code;
                        editDistrictSelect.appendChild(opt);
                    });
                    editDistrictSelect.disabled = false;
                }
            })
            .catch(err => console.error(err));
    });

    editDistrictSelect.addEventListener("change", function () {
        const selectedOption = this.options[this.selectedIndex];
        const code = selectedOption.dataset.code;
        document.getElementById("editDistrictCodeInput").value = code || '';
        editWardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
        editWardSelect.disabled = true;
        document.getElementById("editWardCodeInput").value = '';
        if (!code) return;
        fetch(API_BASE + "/d/" + code + "?depth=2")
            .then(res => res.json())
            .then(data => {
                if (data.wards && data.wards.length > 0) {
                    data.wards.forEach(w => {
                        const opt = document.createElement("option");
                        opt.value = w.name;
                        opt.textContent = w.name;
                        opt.dataset.code = w.code;
                        editWardSelect.appendChild(opt);
                    });
                    editWardSelect.disabled = false;
                }
            })
            .catch(err => console.error(err));
    });

    editWardSelect.addEventListener("change", function () {
        const selectedOption = this.options[this.selectedIndex];
        document.getElementById("editWardCodeInput").value = selectedOption.dataset.code || '';
    });
</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const activeTab = "${activeTab}";
        if (activeTab === "addresses") {
            document.querySelectorAll(".menu li").forEach(li => li.classList.remove("active"));
            document.querySelectorAll(".section").forEach(sec => sec.classList.remove("active"));
            const addressMenuItem = document.querySelector('[data-section="addresses-section"]');
            if (addressMenuItem) {
                addressMenuItem.classList.add("active");
            }
            const addressSection = document.getElementById("addresses-section");
            if (addressSection) {
                addressSection.classList.add("active");
            }
        }
        const successMsg = "${sessionScope.success}";
        const errorMsg = "${sessionScope.error}";
        if (successMsg && successMsg !== "") {
            Swal.fire({
                icon: 'success',
                title: 'Thành công',
                text: successMsg,
                timer: 1000,
                showConfirmButton: false
            });
            <% session.removeAttribute("success"); %>
        }
        if (errorMsg && errorMsg !== "") {
            Swal.fire({
                icon: 'error',
                title: 'Lỗi',
                text: errorMsg
            });
            <% session.removeAttribute("error"); %>
        }
    });
</script>
<script>
    const API_BASE = "${pageContext.request.contextPath}/api/provinces";
    const provinceSelect = document.getElementById("province");
    const districtSelect = document.getElementById("district");
    const wardSelect = document.getElementById("ward");
    let provincesData = [];
    document.getElementById("openPopup").addEventListener("click", function () {
        if (provincesData.length === 0) {
            fetch(API_BASE + "/")
                .then(res => res.json())
                .then(provinces => {
                    provincesData = provinces;
                    provinceSelect.innerHTML = '<option value="">-- Chọn Tỉnh/Thành phố --</option>';
                    provinces.forEach(p => {
                        const opt = document.createElement("option");
                        opt.value = p.name;
                        opt.textContent = p.name;
                        opt.dataset.code = p.code;
                        provinceSelect.appendChild(opt);
                    });
                })
                .catch(err => console.error(err));
        }
    });
    provinceSelect.addEventListener("change", function () {
        const selectedOption = this.options[this.selectedIndex];
        const code = selectedOption.dataset.code;
        document.getElementById("provinceCodeInput").value = code || '';
        districtSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
        districtSelect.disabled = true;
        wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
        wardSelect.disabled = true;
        document.getElementById("districtCodeInput").value = '';
        document.getElementById("wardCodeInput").value = '';
        if (!code) return;
        fetch(API_BASE + "/p/" + code + "?depth=2")
            .then(res => res.json())
            .then(data => {
                if (data.districts && data.districts.length > 0) {
                    data.districts.forEach(d => {
                        const opt = document.createElement("option");
                        opt.value = d.name;
                        opt.textContent = d.name;
                        opt.dataset.code = d.code;
                        districtSelect.appendChild(opt);
                    });
                    districtSelect.disabled = false;
                }
            })
            .catch(err => console.error(err));
    });

    districtSelect.addEventListener("change", function () {
        const selectedOption = this.options[this.selectedIndex];
        const code = selectedOption.dataset.code;
        document.getElementById("districtCodeInput").value = code || '';
        wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
        wardSelect.disabled = true;
        document.getElementById("wardCodeInput").value = '';
        if (!code) return;

        fetch(API_BASE + "/d/" + code + "?depth=2")
            .then(res => res.json())
            .then(data => {
                if (data.wards && data.wards.length > 0) {
                    data.wards.forEach(w => {
                        const opt = document.createElement("option");
                        opt.value = w.name;
                        opt.textContent = w.name;
                        opt.dataset.code = w.code;
                        wardSelect.appendChild(opt);
                    });
                    wardSelect.disabled = false;
                }
            })
            .catch(err => console.error(err));
    });

    wardSelect.addEventListener("change", function () {
        const selectedOption = this.options[this.selectedIndex];
        document.getElementById("wardCodeInput").value = selectedOption.dataset.code || '';
    });
</script>
<script>
    function confirmDeleteAddress(e, url) {
        if (e) e.preventDefault();
        Swal.fire({
            title: 'Xác nhận xóa',
            text: "Bạn có chắc muốn xóa địa chỉ này?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Xóa ngay',
            cancelButtonText: 'Hủy bỏ'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = url;
            }
        });
    }
</script>

<script>
    function previewAndSaveAvatar(input) {
        const file = input.files[0];
        if (!file) return;
        console.log("GOD MODE: File selected", file.name);
        if (!file.type.startsWith('image/')) {
            alert("Vui lòng chọn file hình ảnh!");
            return;
        }
        const reader = new FileReader();
        reader.onload = function (e) {
            console.log("GOD MODE: Previewing image...");
            const result = e.target.result;
            const img = document.getElementById("sidebar-avatar-img");
            if (img) {
                img.src = result;
                img.style.display = "block";
                img.style.opacity = "1";
            }
            const wrapper = document.getElementById("sidebar-avatar-wrapper");
            if (wrapper) {
                wrapper.style.backgroundImage = "url('" + result + "')";
                wrapper.style.backgroundSize = "cover";
            }
            document.querySelectorAll(".avatar-img").forEach(i => i.src = result);
        };
        reader.readAsDataURL(file);
        const formData = new FormData();
        formData.append("avatar", file);
        fetch("${pageContext.request.contextPath}/UpdateAvatar", {
            method: "POST",
            body: formData
        }).then(res => {
            if (res.ok) return res.text();
            throw new Error("Server error " + res.status);
        }).then(newFileName => {
            console.log("GOD MODE: Saved to server", newFileName);
            const ts = new Date().getTime();
            const finalSrc = "${pageContext.request.contextPath}/image/avatar/" + newFileName + "?t=" + ts;
            document.querySelectorAll(".avatar-img").forEach(i => i.src = finalSrc);
            if (window.Swal) {
                Swal.fire({
                    icon: 'success',
                    title: 'Thành công',
                    text: 'Đã cập nhật ảnh đại diện!',
                    timer: 1000,
                    showConfirmButton: false
                });
            }
        }).catch(err => {
            console.error("GOD MODE ERROR:", err);
            if (window.Swal) {
                Swal.fire({icon: 'error', title: 'Lỗi lưu ảnh', text: err.message});
            }
        });
    }
</script>
</body>

</html>