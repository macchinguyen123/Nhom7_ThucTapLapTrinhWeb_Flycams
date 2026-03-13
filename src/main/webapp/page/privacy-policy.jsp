<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Chính sách Bảo mật | SKYDRONE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #ffffff;
            color: #0f172a;
            line-height: 1.8;
        }

        .page-header {
            background: linear-gradient(135deg, #0d6efd 0%, #0043a8 100%);
            color: white;
            padding: 60px 0 40px;
            margin-bottom: 40px;
            text-align: center;
        }

        .header-border {
            border-bottom: 1px solid #f1f5f9;
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.125rem;
            letter-spacing: -0.025em;
        }

        .nav-link-custom {
            color: #64748b;
            font-size: 0.875rem;
            font-weight: 500;
            transition: color 0.2s;
        }

        .nav-link-custom:hover {
            color: #0f172a;
        }

        .prose h2 {
            font-size: 1.875rem;
            font-weight: 700;
            margin-top: 3rem;
            margin-bottom: 1.5rem;
            color: #0f172a;
            letter-spacing: -0.025em;
        }

        .prose h3 {
            font-size: 1.25rem;
            font-weight: 600;
            margin-top: 2rem;
            margin-bottom: 1rem;
            color: #0f172a;
        }

        .prose p {
            margin-bottom: 1.5rem;
            color: #334155;
            font-size: 1.125rem;
            line-height: 2;
        }

        .prose ul {
            list-style-type: disc;
            padding-left: 1.5rem;
            margin-bottom: 1.5rem;
            color: #334155;
            font-size: 1.125rem;
        }

        .prose ul li {
            margin-bottom: 0.75rem;
        }

        .prose strong {
            font-weight: 600;
            color: #0f172a;
        }

        .contact-info {
            font-weight: 500;
            color: #0f172a;
        }

        .footer-border {
            border-top: 1px solid #f1f5f9;
        }

        .footer-link {
            color: #94a3b8;
            font-size: 0.875rem;
            text-decoration: none;
            transition: color 0.2s;
        }

        .footer-link:hover {
            color: #0f172a;
        }

        .footer-text {
            color: #64748b;
            font-size: 0.875rem;
        }

        @media (max-width: 768px) {
            .page-title {
                font-size: 2.25rem;
            }
        }
    </style>
</head>
<body>
<jsp:include page="/page/header-common.jsp"/>
<div class="page-header">
    <div class="container">
        <h1 class="fw-bold mb-2"><i class="bi bi-shield-check me-2"></i>Chính sách Bảo mật</h1>
        <p class="opacity-75 mb-0">Cập nhật lần cuối: 24 Tháng 10, 2025</p>
    </div>
</div>
<main class="container py-5" style="max-width: 768px;">
    <article class="prose">
        <p>
            Chào mừng bạn đến với SKYDRONE. Chúng tôi coi trọng quyền riêng tư của bạn và cam kết bảo vệ dữ liệu cá nhân
            của bạn. Chính sách bảo mật này sẽ giải thích cách chúng tôi thu thập, sử dụng và bảo vệ thông tin của bạn
            khi bạn sử dụng dịch vụ của chúng tôi.
        </p>
        <h2>1. Thông tin chúng tôi thu thập</h2>
        <p>
            Chúng tôi thu thập các loại thông tin khác nhau để cung cấp và cải thiện dịch vụ của chúng tôi cho bạn. Điều
            này bao gồm dữ liệu cá nhân bạn cung cấp trực tiếp và dữ liệu được thu thập tự động thông qua việc sử dụng
            dịch vụ.
        </p>
        <ul>
            <li><strong>Thông tin định danh:</strong> Tên, địa chỉ email, số điện thoại và địa chỉ bưu điện.</li>
            <li><strong>Thông tin đăng nhập:</strong> Tên người dùng, mật khẩu đã mã hóa và các khóa bảo mật.</li>
            <li><strong>Dữ liệu sử dụng:</strong> Địa chỉ IP, loại trình duyệt, thời gian truy cập và các trang đã xem.
            </li>
        </ul>
        <h3>Thu thập dữ liệu tự động</h3>
        <p>
            Khi bạn truy cập trang web của chúng tôi, máy chủ của chúng tôi có thể tự động ghi lại các thông tin tiêu
            chuẩn do trình duyệt web của bạn cung cấp. Nó có thể bao gồm địa chỉ Giao thức Internet (IP) của thiết bị,
            loại và phiên bản trình duyệt của bạn, các trang bạn truy cập, thời gian và ngày bạn truy cập.
        </p>
        <h2>2. Cách chúng tôi sử dụng dữ liệu</h2>
        <p>
            Dữ liệu của bạn được sử dụng để cá nhân hóa trải nghiệm người dùng, duy trì tính bảo mật của tài khoản và
            tuân thủ các nghĩa vụ pháp lý hiện hành. Chúng tôi xử lý thông tin cá nhân của bạn dựa trên các cơ sở pháp
            lý như sự đồng ý của bạn, thực hiện hợp đồng hoặc lợi ích hợp pháp của chúng tôi.
        </p>
        <p>
            Chúng tôi cam kết không bao giờ bán dữ liệu cá nhân của bạn cho các nhà môi giới dữ liệu hoặc bên thứ ba
            nhằm mục đích tiếp thị mà không có sự đồng ý rõ ràng của bạn.
        </p>
        <h2>3. Chia sẻ với bên thứ ba</h2>
        <p>
            Chúng tôi có thể chia sẻ thông tin với các nhà cung cấp dịch vụ giúp chúng tôi vận hành ứng dụng, chẳng hạn
            như dịch vụ lưu trữ đám mây, trình xử lý thanh toán và công cụ phân tích dữ liệu. Các bên thứ ba này chỉ
            được phép truy cập vào thông tin của bạn để thực hiện các nhiệm vụ cụ thể thay mặt chúng tôi và có nghĩa vụ
            không tiết lộ hoặc sử dụng thông tin đó cho bất kỳ mục đích nào khác.
        </p>
        <h2>4. Quyền của người dùng</h2>
        <p>
            Tùy thuộc vào vị trí của bạn, bạn có thể có các quyền sau đối với dữ liệu cá nhân của mình:
        </p>
        <ul>
            <li><strong>Quyền truy cập:</strong> Bạn có quyền yêu cầu bản sao dữ liệu cá nhân mà chúng tôi lưu trữ.</li>
            <li><strong>Quyền chỉnh sửa:</strong> Bạn có quyền yêu cầu chúng tôi sửa bất kỳ thông tin nào bạn cho là
                không chính xác.
            </li>
            <li><strong>Quyền xóa bỏ:</strong> Bạn có quyền yêu cầu chúng tôi xóa dữ liệu cá nhân của bạn trong một số
                điều kiện nhất định.
            </li>
            <li><strong>Quyền phản đối:</strong> Bạn có quyền phản đối việc chúng tôi xử lý dữ liệu cá nhân của bạn.
            </li>
        </ul>
        <h2>5. Bảo mật dữ liệu</h2>
        <p>
            Sự an toàn của dữ liệu của bạn là quan trọng đối với chúng tôi, nhưng hãy nhớ rằng không có phương thức
            truyền tải qua Internet hoặc phương thức lưu trữ điện tử nào là an toàn 100%. Mặc dù chúng tôi cố gắng sử
            dụng các phương tiện được chấp nhận về mặt thương mại để bảo vệ dữ liệu cá nhân của bạn, chúng tôi không thể
            đảm bảo an ninh tuyệt đối.
        </p>
        <h2>6. Liên hệ với chúng tôi</h2>
        <p>
            Nếu bạn có bất kỳ câu hỏi nào về Chính sách Bảo mật này hoặc cách chúng tôi xử lý dữ liệu của bạn, vui lòng
            liên hệ với bộ phận Bảo vệ Dữ liệu (DPO) của chúng tôi tại:
        </p>
        <p class="contact-info">
            Email: privacy@skydrone.com<br/>
            Địa chỉ: Tầng 12, Tòa nhà Innovation, Quận 1, TP. Hồ Chí Minh
        </p>
    </article>
</main>
<jsp:include page="/page/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
