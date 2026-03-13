<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>Chính sách thanh toán</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/payment-policy.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/page/header-common.jsp"/>
<section class="warranty">
    <div class="container">
        <h1>Thanh toán tiền mặt/COD</h1>
        <ul>
            <p>Quý khách có thể chọn phương thức thanh toán COD khi mua hàng online qua website skydrone.vn và thanh
                toán tiền mặt cho nhân viên giao hàng</p>
        </ul>
        <h1>Thanh toán quét mã QR</h1>
        <ul>
            <p>Thanh toán VNPAY-QR là hình thức thanh toán tiên phong cho xu thế tiêu dùng không dùng tiền mặt tương
                lai. Thao tác thanh toán an toàn, đơn giản, nhanh chóng và bảo mật cấp cao. Chỉ cần sử dụng app Mobile
                Banking ngân hàng của Quý khách và quét mã VNPAY-QR để thanh toán. Bên cạnh đó, thanh toán bằng
                VNPAY-QR, Quý khách sẽ có thể nhận được những chương trình ưu đãi đặc biệt. VNPAY-QR được áp dụng thanh
                toán tại website skydrone.vn.</p>
        </ul>
        <h1>Thanh toán thẻ ATM nội địa - Internet Banking</h1>
        <ul>
            <p class="note">Quý khách có thể thanh toán bằng thẻ ATM thông qua cổng Internet Banking khi mua hàng online
                tại skydrone.vn</p>
        </ul>
        <h1>Thanh toán chuyển khoản</h1>
        <ul>
            <li>Chủ tài khoản: Công ty TNHH SKYDrone Việt Nam</li>
            <li>Tên ngân hàng: Ngân hàng BIDV - CN Chợ Lớn</li>
            <li>Số tài khoản: <b>060033893739</b></li>
            <li>Nội dung chuyển khoản: Mã đơn hàng</li>
        </ul>
    </div>
</section>
<jsp:include page="/page/footer.jsp"/>
</body>
</html>
