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
    <div class="container py-4" style="max-width: 800px;">
        <h1 class="fw-semibold mb-4" style="font-size: 1.5rem;">Chính sách thanh toán</h1>
        <div class="card border mb-3">
            <div class="card-body">
                <div class="d-flex align-items-center gap-3 mb-2">
                    <div class="rounded-2 d-flex align-items-center justify-content-center bg-primary bg-opacity-10"
                         style="width:40px;height:40px;flex-shrink:0;">
                        <i class="bi bi-truck text-primary fs-5"></i>
                    </div>
                    <h2 class="fw-semibold mb-0" style="font-size:1.1rem;">Thanh toán tiền mặt / COD</h2>
                </div>
                <p class="text-muted mb-0">
                    Quý khách có thể chọn phương thức thanh toán COD khi mua hàng online qua website skydrone.vn
                    và thanh toán tiền mặt cho nhân viên giao hàng.
                </p>
            </div>
        </div>

        <div class="card border mb-3">
            <div class="card-body">
                <div class="d-flex align-items-center gap-3 mb-2">
                    <div class="rounded-2 d-flex align-items-center justify-content-center bg-success bg-opacity-10"
                         style="width:40px;height:40px;flex-shrink:0;">
                        <i class="bi bi-qr-code text-success fs-5"></i>
                    </div>
                    <h2 class="fw-semibold mb-0" style="font-size:1.1rem;">Thanh toán quét mã QR</h2>
                </div>
                <p class="text-muted mb-0">
                    Thanh toán VNPAY-QR là hình thức thanh toán tiên phong cho xu thế tiêu dùng không dùng tiền mặt.
                    Thao tác an toàn, đơn giản, nhanh chóng — chỉ cần dùng app Mobile Banking và quét mã VNPAY-QR.
                    Áp dụng tại website skydrone.vn.
                </p>
            </div>
        </div>

        <div class="card border mb-3">
            <div class="card-body">
                <div class="d-flex align-items-center gap-3 mb-2">
                    <div class="rounded-2 d-flex align-items-center justify-content-center bg-warning bg-opacity-10"
                         style="width:40px;height:40px;flex-shrink:0;">
                        <i class="bi bi-credit-card text-warning fs-5"></i>
                    </div>
                    <h2 class="fw-semibold mb-0" style="font-size:1.1rem;">Thanh toán thẻ ATM nội địa / Internet Banking</h2>
                </div>
                <p class="text-muted mb-0">
                    Quý khách có thể thanh toán bằng thẻ ATM thông qua cổng Internet Banking
                    khi mua hàng online tại skydrone.vn.
                </p>
            </div>
        </div>

        <div class="card border mb-3">
            <div class="card-body">
                <div class="d-flex align-items-center gap-3 mb-3">
                    <div class="rounded-2 d-flex align-items-center justify-content-center"
                         style="width:40px;height:40px;flex-shrink:0;background:rgba(83,74,183,.1);">
                        <i class="bi bi-bank" style="color:#534AB7;" class="fs-5"></i>
                    </div>
                    <h2 class="fw-semibold mb-0" style="font-size:1.1rem;">Thanh toán chuyển khoản</h2>
                </div>
                <div class="d-flex flex-column gap-2">
                    <div class="d-flex justify-content-between px-3 py-2 rounded-2 bg-light">
                        <span class="text-muted">Chủ tài khoản</span>
                        <span class="fw-semibold">Công ty TNHH SKYDrone Việt Nam</span>
                    </div>
                    <div class="d-flex justify-content-between px-3 py-2 rounded-2 bg-light">
                        <span class="text-muted">Ngân hàng</span>
                        <span class="fw-semibold">BIDV – CN Chợ Lớn</span>
                    </div>
                    <div class="d-flex justify-content-between px-3 py-2 rounded-2"
                         style="background:rgba(83,74,183,.08);">
                        <span style="color:#534AB7;">Số tài khoản</span>
                        <span class="fw-semibold" style="color:#3C3489;letter-spacing:1px;">060033893739</span>
                    </div>
                    <div class="d-flex justify-content-between px-3 py-2 rounded-2 bg-light">
                        <span class="text-muted">Nội dung chuyển khoản</span>
                        <span class="fw-semibold">Mã đơn hàng</span>
                    </div>
                </div>
            </div>
        </div>

    </div>
</section>
<jsp:include page="/page/footer.jsp"/>
</body>
</html>
