<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Footer</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/footer.css">
</head>
<body>
<footer class="footer">
    <div class="footer-container">
        <div class="footer-column">
            <h6>SKYDRONE VIỆT NAM</h6>
            <img src="${pageContext.request.contextPath}/image/dronefooter.png" alt="SKYDRONE Logo" class="mascot">
            <p><strong>Công ty Cổ phần thương mại SKYDrone Việt Nam</strong></p>
            <p>Địa chỉ: Số 1 Đường Số 1, Phường Linh Xuân, TP Hồ Chí Minh, Việt Nam</p>
            <p><strong>Hotline:</strong> 0815.000.060</p>
            <p>ĐKKD số 0108676636 do Sở KH&ĐT TP. Hồ Chí Minh cấp ngày 10/10/2025</p>
            <div class="social-icons">
                <a href="#"><i class="fa-brands fa-facebook"></i></a>
                <a href="#"><i class="fa-brands fa-instagram"></i></a>
                <a href="#"><i class="fa-brands fa-x-twitter"></i></a>
                <a href="#"><i class="fa-solid fa-envelope"></i></a>
            </div>
        </div>
        <div class="footer-column">
            <h6>SẢN PHẨM</h6>
            <ul>
                <li><a href="${pageContext.request.contextPath}/Category?id=1001">Drone quay phim chuyên nghiệp</a></li>
                <li><a href="${pageContext.request.contextPath}/Category?id=1006">Drone du lịch / vlog</a></li>
                <li><a href="${pageContext.request.contextPath}/Category?id=1003">Drone thể thao tốc độ cao</a></li>
                <li><a href="${pageContext.request.contextPath}/Category?id=1002">Drone nông nghiệp</a></li>
                <li><a href="${pageContext.request.contextPath}/Category?id=1005">Drone giám sát / an ninh</a></li>
                <li><a href="${pageContext.request.contextPath}/Category?id=1004">Drone mini / cỡ nhỏ</a></li>
            </ul>
            <h3>TƯ VẤN MUA HÀNG</h3>
            <div class="hotline">
                <i class="fa-solid fa-phone"></i>0813.660.666
            </div>
        </div>
        <div class="footer-column">
            <h6>HỆ THỐNG PHÂN PHỐI</h6>
            <ul>
                <li><a href="${pageContext.request.contextPath}/home">SKYDrone Store</a></li>
                <li><a href="${pageContext.request.contextPath}/home">Hà Nội</a></li>
                <li><a href="${pageContext.request.contextPath}/home">TP. Hồ Chí Minh</a></li>
                <li><a href="${pageContext.request.contextPath}/home">Đà Nẵng</a></li>
                <li><a href="${pageContext.request.contextPath}/home">Nghệ An</a></li>
            </ul>
            <section class="payment-methods">
                <h6>PHƯƠNG THỨC THANH TOÁN</h6>
                <div class="payment-icons">
                    <img src="https://tse3.mm.bing.net/th/id/OIP.kklIaX3TV97u5KnjU_Kr4wHaHa?rs=1&pid=ImgDetMain&o=7&rm=3"
                         alt="VNPay">
                </div>
            </section>
        </div>
        <div class="footer-column">
            <h6>THÔNG TIN VỀ CHÍNH SÁCH</h6>
            <ul>
                <li><a href="${pageContext.request.contextPath}/page/payment-policy.jsp">Mua hàng và thanh toán
                    Online</a></li>
                <li><a href="${pageContext.request.contextPath}/page/payment-policy.jsp">Tra thông tin bảo hành</a></li>
                <li><a href="${pageContext.request.contextPath}/purchasehistory">Thông tin hoá đơn mua hàng</a></li>
                <li><a href="${pageContext.request.contextPath}/page/terms-of-use.jsp">Điều khoản sử dụng</a></li>
                <li><a href="${pageContext.request.contextPath}/page/privacy-policy.jsp">Chính sách bảo mật</a>.</li>
            </ul>
            <section class="social-connect">
                <h6>KẾT NỐI VỚI SKYDRONE</h6>
                <div class="social-icons">
                    <a href="https://www.youtube.com/@F8VNOfficial"
                       class="icon youtube" target="_blank" rel="noopener noreferrer">
                        <img src="https://cdn-icons-png.flaticon.com/512/1384/1384060.png" alt="YouTube">
                    </a>
                    <a href="https://www.facebook.com/dhkcntt.nlu"
                       class="icon facebook" target="_blank" rel="noopener noreferrer">
                        <img src="https://cdn-icons-png.flaticon.com/512/733/733547.png" alt="Facebook">
                    </a>
                    <a href="https://www.instagram.com/truyenthongchinhphu/"
                       class="icon instagram" target="_blank" rel="noopener noreferrer">
                        <img src="https://cdn-icons-png.flaticon.com/512/174/174855.png" alt="Instagram">
                    </a>
                    <a href="https://www.tiktok.com/@nonglam.university"
                       class="icon tiktok" target="_blank" rel="noopener noreferrer">
                        <img src="https://cdn-icons-png.flaticon.com/512/3046/3046121.png" alt="TikTok">
                    </a>
                    <a href="https://zalo.me/0966089465"
                       class="icon zalo" target="_blank" rel="noopener noreferrer">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/9/91/Icon_of_Zalo.svg" alt="Zalo">
                    </a>
                </div>
            </section>
        </div>
    </div>
    <div class="footer-bottom">
        <p>Copyright © 2025 © <strong>SKYDrone Việt Nam</strong></p>
        <p>Các nội dung, tài liệu và hình ảnh thuộc bản quyền của SKYDrone Việt Nam. Mọi hành vi sao chép sẽ bị nghiêm
            cấm.</p>
    </div>
</footer>
</body>
</html>