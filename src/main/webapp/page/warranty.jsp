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
    <div class="container">
        <h1>I. ĐIỀU KIỆN NHẬN BẢO HÀNH</h1>
        <ul>
            <li>Các sản phẩm, thiết bị do các cửa hàng của HÀNG CHÍNH HIỆU hoặc gian hàng HÀNG CHÍNH HIỆU trên
                Website.
            </li>
            <li>Đối với các sản phẩm, thiết bị được cấp phiếu bảo hành (PBH), khách hàng phải xuất trình PBH và có đầy
                đủ tem bảo hành của HÀNG CHÍNH HIỆU (nếu thiết bị không cấp PBH thì phải còn nguyên tem của HÀNG CHÍNH
                HIỆU) và phải còn trong thời hạn bảo hành.
            </li>
            <li>Tem bảo hành, mã vạch số serial,… của sản phẩm phải còn nguyên vẹn, không có dấu hiệu cạo sửa, tẩy xóa,
                bị rách, mờ.
            </li>
            <li>Trong trường hợp, tem chưa rách nhưng bị mờ hoặc tem bị rách do yếu tố khách quan nào đó, công ty sẽ tạm
                thời giữ lại để kiểm tra, xác nhận thông tin. Nếu sản phẩm, thiết bị do HÀNG CHÍNH HIỆU cung cấp thì mới
                được chính thức nhận bảo hành. Nếu có vấn đề phát sinh, HÀNG CHÍNH HIỆU sẽ liên hệ ngay để xác nhận với
                khách hàng trong vòng 24h kể từ khi nhận thiết bị.
            </li>
            <li>Những hư hỏng của thiết bị được xác định do lỗi kỹ thuật hoặc lỗi của nhà sản xuất.</li>
        </ul>
        <h1>II. TRƯỜNG HỢP KHÔNG NHẬN BẢO HÀNH</h1>
        <ul>
            <li>Số serial trên máy và Phiếu bảo hành không trùng khớp nhau hoặc không xác định được vì bất
                kỳ lý do nào
            </li>
            <li>Tem niêm phong bảo hành bị rách, vỡ, hoặc bị sửa đổi</li>
            <li>Tự ý tháo dỡ, sửa chữa bởi các cá nhân hoặc kỹ thuật viên không được sự ủy quyền của SKYDrone</li>
            <li>Các sản phẩm, thiết bị có dấu hiệu dung dịch lạ, có nước vào, có vết ẩm ướt, bị đứt mạch, bị trầy xước,
                bể mẻ, móp méo, biến dạng, có dấu hiệu cháy nổ, nấm, phù tụ, gỉ sét hoặc các hiện tượng được cho là do
                lỗi cá nhân gây ra. Hoặc nếu được nhận BH, khách hàng phải hoàn toàn chịu chi phí phát sinh đối với các
                lỗi đó.
            </li>
            <li>Thiết bị hư hỏng do thiên tai, hỏa hoạn, sử dụng nguồn điện không ổn định hoặc do lắp đặt, vận chuyển
                không đúng quy cách,…
            </li>
            <li>Các phụ kiện kèm theo thiết bị.</li>
            <li>Không bảo hành đối với quà khuyến mãi của công ty.</li>
        </ul>
        <p class="note"><b>Đặc biệt:</b> không nhận BH về dữ liệu trong các thiết bị lưu trữ.</p>
        <h1>III. THỜI GIAN TRẢ BẢO HÀNH</h1>
        <ul>
            <p class="note">Dự kiến từ 7 – 10 ngày tính từ ngày tiếp nhận bảo hành tại cửa hàng (không tính thứ 7 và chủ
                nhật, ngày lễ). Đối với những lỗi phức tạp hơn thì thời gian bảo hành có thể kéo dài, Hàng Chính Hiệu sẽ
                thông báo cho bạn nếu có thông tin bảo hành từ hãng.</p>
        </ul>
    </div>
</section>
<jsp:include page="/page/footer.jsp"/>
</body>
</html>
