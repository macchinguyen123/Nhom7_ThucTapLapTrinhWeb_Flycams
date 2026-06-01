<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>Chính sách bảo hành</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/warranty.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/page/header-common.jsp"/>
<section class="warranty">
    <div class="container py-4" style="max-width: 800px;">

        <h1 class="fw-semibold mb-4" style="font-size: 1.5rem;">Chính sách bảo hành</h1>

        <div class="card border mb-3">
            <div class="card-body">
                <div class="d-flex align-items-center gap-3 mb-3">
                    <div class="rounded-2 d-flex align-items-center justify-content-center bg-success bg-opacity-10"
                         style="width:40px;height:40px;flex-shrink:0;">
                        <i class="bi bi-patch-check text-success fs-5"></i>
                    </div>
                    <h2 class="fw-semibold mb-0" style="font-size:1.1rem;">I. Điều kiện nhận bảo hành</h2>
                </div>
                <ul class="mb-0 text-muted" style="line-height:1.9;">
                    <li class="mb-2">Các sản phẩm, thiết bị do các cửa hàng của HÀNG CHÍNH HIỆU hoặc gian hàng HÀNG CHÍNH HIỆU trên website cung cấp.</li>
                    <li class="mb-2">Đối với sản phẩm được cấp phiếu bảo hành (PBH), khách hàng phải xuất trình PBH và có đầy đủ tem bảo hành còn trong thời hạn.</li>
                    <li class="mb-2">Tem bảo hành, mã vạch, số serial phải còn nguyên vẹn, không có dấu hiệu cạo sửa, tẩy xóa, rách, mờ.</li>
                    <li class="mb-2">Trường hợp tem bị mờ hoặc rách do yếu tố khách quan, công ty sẽ giữ lại kiểm tra và phản hồi trong vòng 24h kể từ khi nhận thiết bị.</li>
                    <li class="mb-0">Hư hỏng được xác định do lỗi kỹ thuật hoặc lỗi của nhà sản xuất.</li>
                </ul>
            </div>
        </div>

        <div class="card border mb-3">
            <div class="card-body">
                <div class="d-flex align-items-center gap-3 mb-3">
                    <div class="rounded-2 d-flex align-items-center justify-content-center bg-danger bg-opacity-10"
                         style="width:40px;height:40px;flex-shrink:0;">
                        <i class="bi bi-x-circle text-danger fs-5"></i>
                    </div>
                    <h2 class="fw-semibold mb-0" style="font-size:1.1rem;">II. Trường hợp không nhận bảo hành</h2>
                </div>
                <ul class="mb-3 text-muted" style="line-height:1.9;">
                    <li class="mb-2">Số serial trên máy và phiếu bảo hành không trùng khớp hoặc không xác định được.</li>
                    <li class="mb-2">Tem niêm phong bảo hành bị rách, vỡ hoặc bị sửa đổi.</li>
                    <li class="mb-2">Tự ý tháo dỡ, sửa chữa bởi cá nhân hoặc kỹ thuật viên không được ủy quyền của SKYDrone.</li>
                    <li class="mb-2">Sản phẩm có dấu hiệu vào nước, ẩm ướt, đứt mạch, trầy xước, bể mẻ, biến dạng, cháy nổ, gỉ sét hoặc các hư hỏng do lỗi cá nhân gây ra.</li>
                    <li class="mb-2">Thiết bị hư hỏng do thiên tai, hỏa hoạn, nguồn điện không ổn định hoặc lắp đặt, vận chuyển sai quy cách.</li>
                    <li class="mb-2">Các phụ kiện kèm theo thiết bị.</li>
                    <li class="mb-0">Quà khuyến mãi của công ty.</li>
                </ul>
                <div class="px-3 py-2 rounded-2 border-start border-danger border-3 bg-danger bg-opacity-10">
                    <span class="fw-semibold text-danger">Đặc biệt: </span>
                    <span class="text-muted">Không nhận bảo hành đối với dữ liệu trong các thiết bị lưu trữ.</span>
                </div>
            </div>
        </div>

        <div class="card border mb-3">
            <div class="card-body">
                <div class="d-flex align-items-center gap-3 mb-3">
                    <div class="rounded-2 d-flex align-items-center justify-content-center bg-warning bg-opacity-10"
                         style="width:40px;height:40px;flex-shrink:0;">
                        <i class="bi bi-clock text-warning fs-5"></i>
                    </div>
                    <h2 class="fw-semibold mb-0" style="font-size:1.1rem;">III. Thời gian trả bảo hành</h2>
                </div>
                <p class="text-muted mb-0" style="line-height:1.9;">
                    Dự kiến từ <strong class="text-dark">7 – 10 ngày</strong> tính từ ngày tiếp nhận
                    (không tính thứ 7, chủ nhật và ngày lễ). Đối với các lỗi phức tạp, thời gian có thể kéo dài —
                    SKYDrone sẽ thông báo ngay khi có thông tin từ hãng.
                </p>
            </div>
        </div>

    </div>
</section>
<jsp:include page="/page/footer.jsp"/>
</body>
</html>
