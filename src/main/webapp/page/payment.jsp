<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Phương thức thanh toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <link rel="stylesheet" href="../stylesheets/payment.css">
</head>
<body>
<div class="wrap">
    <div class="left">
        <div class="text-start mb-4">
            <img src="../image/dronefooter.png" alt="Logo" height="100">
            <nav class="breadcrumb mt-2">
                <a href="shoppingcart.jsp">Giỏ hàng</a> &nbsp;>&nbsp;
                <a href="delivery-info.jsp">Thông tin giao hàng</a> &nbsp;>&nbsp;
                <span class="current">Phương thức thanh toán</span>
            </nav>
        </div>
        <h5 class="mb-4 fw-bold">Phương Thức Thanh Toán</h5>
        <form id="paymentForm" action="${pageContext.request.contextPath}/PaymentServlet"
              method="post">
            <input type="hidden" name="paymentMethod" id="paymentMethod">
            <div class="form-check mb-3">
                <input class="form-check-input" type="radio" name="payment" value="COD" id="cod">
                <label class="form-check-label" for="cod">
                    <i class="bi bi-cash-coin me-2 text-success"></i>
                    Thanh toán khi giao hàng (COD)
                </label>
            </div>
            <div class="form-check mb-4">
                <input class="form-check-input" type="radio" name="payment" value="VNPAY"
                       id="vnpay">
                <label class="form-check-label" for="vnpay">
                    <i class="bi bi-credit-card-2-front me-2 text-primary"></i>
                    Thanh toán qua VNPAY
                </label>
            </div>
            <button type="button" id="btnHoanTat" class="btn btn-primary w-100">
                Hoàn tất đơn hàng
            </button>
        </form>
    </div>
    <div class="right">
        <h5 class="fw-bold mb-4">Đơn hàng của bạn</h5>
        <c:set var="items" value="${sessionScope.BUY_NOW_ITEM}"/>
        <c:if test="${not empty items}">
            <c:forEach var="item" items="${items}">
                <div class="d-flex align-items-center mb-3">
                    <img src="${not empty item.product.images
                    ? item.product.images[0].imageUrl
                    : pageContext.request.contextPath.concat('/image/no-image.png')}" width="60" class="me-3 prod-img">
                    <div>
                        <p class="mb-0 fw-semibold">
                                ${item.product.productName}
                        </p>
                        <small class="text-muted">
                            Số lượng: ${item.quantity}
                        </small>
                    </div>
                    <span class="ms-auto fw-semibold">
                                            <fmt:formatNumber value="${item.price * item.quantity}" type="number"/> ₫
                                        </span>
                </div>
            </c:forEach>
            <c:set var="total" value="0"/>
            <c:forEach var="item" items="${items}">
                <c:set var="total" value="${total + (item.price * item.quantity)}"/>
            </c:forEach>
            <div class="d-flex justify-content-between">
                <span>Tạm tính</span>
                <span>
                                        <fmt:formatNumber value="${total}" type="number"/> ₫
                                    </span>
            </div>
            <div class="d-flex justify-content-between mb-2">
                <span>Phí vận chuyển</span>
                <span>Miễn phí</span>
            </div>
            <hr>
            <div class="d-flex justify-content-between fw-bold total">
                <span>Tổng cộng</span>
                <span>
                                        <fmt:formatNumber value="${total}" type="number"/> ₫
                                    </span>
            </div>
        </c:if>
        <c:if test="${empty items}">
            <p class="text-muted">Không có sản phẩm nào</p>
        </c:if>
    </div>
</div>
<div class="cod-popup" id="codPopup" style="display:none;">
    <div class="cod-box">
        <h5 class="text-center mb-3">Xác nhận đơn hàng</h5>
        <p>Bạn chắc chắn muốn thanh toán khi nhận hàng?</p>
        <div class="text-center mt-3">
            <button type="button" class="btn btn-success me-2" id="confirmCOD">Xác nhận</button>
            <button type="button" class="btn btn-outline-secondary" id="cancelCOD">Hủy</button>
        </div>
    </div>
</div>
<div class="vnpay-popup" id="vnpayPopup" style="display:none;">
    <div class="vnpay-box">
        <div class="text-center mb-3">
            <img src="https://tse3.mm.bing.net/th/id/OIP.kklIaX3TV97u5KnjU_Kr4wHaHa?rs=1&pid=ImgDetMain&o=7&rm=3"
                 height="40" alt="VNPAY logo">
            <h5 class="mt-3">Bạn chắc chắn muốn thanh toán VNPAY?</h5>
        </div>
        <div class="text-center mt-3">
            <button type="button" class="btn btn-success me-2" id="confirmVNPAY">
                Xác nhận thanh toán
            </button>
            <a href="#" class="btn btn-outline-secondary" id="cancelVNPAY">Hủy</a>
        </div>
    </div>
</div>
<script>
    const btnHoanTat = document.getElementById('btnHoanTat');
    const codPopup = document.getElementById('codPopup');
    const confirmCOD = document.getElementById('confirmCOD');
    const cancelCOD = document.getElementById('cancelCOD');
    const vnpayPopup = document.getElementById('vnpayPopup');
    const confirmVNPAY = document.getElementById('confirmVNPAY');
    const cancelVNPAY = document.getElementById('cancelVNPAY');
    const paymentMethodInput = document.getElementById('paymentMethod');
    const paymentForm = document.getElementById('paymentForm');
    // Bấm Hoàn tất đơn hàng
    btnHoanTat.addEventListener('click', () => {
        const payment = document.querySelector('input[name="payment"]:checked');
        if (!payment) {
            alert('Vui lòng chọn phương thức thanh toán!');
            return;
        }
        if (payment.value === 'COD') {
            codPopup.style.display = 'flex';
        } else if (payment.value === 'VNPAY') {
            vnpayPopup.style.display = 'flex';
        }
    });
    // COD popup
    cancelCOD.addEventListener('click', () => codPopup.style.display = 'none');
    confirmCOD.addEventListener('click', () => {
        paymentMethodInput.value = 'COD';
        paymentForm.submit();
    });
    // VNPAY popup
    cancelVNPAY.addEventListener('click', () => vnpayPopup.style.display = 'none');
    confirmVNPAY.addEventListener('click', () => {
        paymentMethodInput.value = 'VNPAY';
        paymentForm.submit(); // submit form POST
    });
</script>
</body>
</html>