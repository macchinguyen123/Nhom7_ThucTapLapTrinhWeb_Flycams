<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Điều khoản sử dụng</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Inter', sans-serif;
            color: #212529;
        }

        .page-header {
            background: linear-gradient(135deg, #0d6efd 0%, #0043a8 100%);
            color: white;
            padding: 60px 0 40px;
            margin-bottom: 40px;
            text-align: center;
        }

        .content-card {
            background: #fff;
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            border: 1px solid rgba(0, 0, 0, 0.02);
            margin-bottom: 30px;
        }

        section {
            scroll-margin-top: 100px;
            border-bottom: 1px solid #eee;
            padding-bottom: 30px;
            margin-bottom: 30px;
        }

        section:last-child {
            border-bottom: none;
            padding-bottom: 0;
            margin-bottom: 0;
        }

        .section-title {
            color: #0d6efd;
            font-weight: 700;
            display: flex;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .section-title i {
            margin-right: 12px;
            font-size: 1.4rem;
            background: rgba(13, 110, 253, 0.1);
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
        }

        .tldr-box {
            background-color: #eff6ff;
            border-left: 5px solid #0d6efd;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 40px;
        }

        .toc-sticky {
            position: sticky;
            top: 100px;
        }

        .toc-link {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            color: #6c757d;
            text-decoration: none;
            border-radius: 8px;
            margin-bottom: 8px;
            transition: all 0.2s ease;
            font-weight: 500;
            border: 1px solid transparent;
        }

        .toc-link i {
            margin-right: 12px;
            font-size: 1.1rem;
            transition: transform 0.2s;
        }

        .toc-link:hover {
            background-color: #fff;
            color: #0d6efd;
            transform: translateX(5px);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }

        .toc-link.active {
            background-color: #fff;
            color: #0d6efd;
            font-weight: 700;
            border-left: 4px solid #0d6efd;
            box-shadow: 0 4px 12px rgba(13, 110, 253, 0.15);
        }

        .toc-link.active i {
            color: #0d6efd;
            transform: scale(1.1);
        }

        @media (max-width: 991.98px) {
            .toc-container {
                display: none;
            }
        }
    </style>
</head>
<body>
<jsp:include page="/page/header-common.jsp"/>
<div class="page-header">
    <div class="container">
        <h1 class="fw-bold mb-2"><i class="bi bi-shield-check me-2"></i>Điều khoản Sử dụng</h1>
        <p class="opacity-75 mb-0">Cập nhật lần cuối: 24 Tháng 12, 2025</p>
    </div>
</div>
<div class="container mb-5">
    <div class="row">
        <div class="col-lg-8">
            <div class="content-card">
                <div class="tldr-box">
                    <h5 class="fw-bold text-primary mb-3"><i class="bi bi-lightning-charge-fill me-2"></i>TL;DR:
                        Tóm tắt nhanh</h5>
                    <ul class="mb-0 ps-3">
                        <li class="mb-2">Bạn sở hữu nội dung của mình nhưng cấp quyền cho chúng tôi hiển thị.
                        </li>
                        <li class="mb-2">Bạn chịu trách nhiệm bảo mật tài khoản.</li>
                        <li class="mb-2">Chúng tôi có quyền tạm ngưng hoặc chấm dứt dịch vụ nếu vi phạm.</li>
                        <li>Dữ liệu của bạn được bảo mật theo Chính sách Quyền riêng tư.</li>
                    </ul>
                </div>
                <section id="section-1">
                    <h3 class="section-title">
                        <i class="bi bi-check-circle-fill"></i>
                        1. Chấp thuận các điều khoản
                    </h3>
                    <p>
                        Chào mừng bạn đến với <strong>SKYDRONE</strong>. Bằng việc truy cập hoặc sử dụng trang
                        web và dịch vụ
                        của chúng tôi, bạn đồng ý tuân thủ và chịu sự ràng buộc bởi các Điều khoản Sử dụng này.
                        Nếu bạn không đồng ý với bất kỳ phần nào của các điều khoản này, bạn không được phép
                        truy
                        cập dịch vụ.
                    </p>
                    <p class="mb-0">
                        Các điều khoản này áp dụng cho tất cả khách truy cập, người dùng và những người khác
                        truy
                        cập hoặc sử dụng Dịch vụ. Việc tiếp tục sử dụng dịch vụ sau khi các thay đổi được đăng
                        tải
                        đồng nghĩa với việc bạn chấp nhận các điều khoản đã được sửa đổi.
                    </p>
                </section>
                <section id="section-2">
                    <h3 class="section-title">
                        <i class="bi bi-award-fill"></i>
                        2. Quyền sở hữu trí tuệ
                    </h3>
                    <p>Dịch vụ và nội dung gốc, các tính năng và chức năng của nó là và sẽ tiếp tục là tài sản
                        độc quyền của
                        SKYDRONE và các bên cấp phép của nó. Dịch vụ được bảo hộ bởi bản quyền, nhãn hiệu và các
                        luật
                        khác của cả Việt Nam và nước ngoài.</p>
                    <p class="mb-0">Nhãn hiệu và trang phục thương mại của chúng tôi không được sử dụng liên
                        quan đến bất kỳ sản phẩm
                        hoặc dịch vụ nào mà không có sự đồng ý trước bằng văn bản của SKYDRONE. Bạn giữ mọi
                        quyền đối với
                        bất kỳ nội dung nào bạn gửi, đăng hoặc hiển thị trên hoặc thông qua Dịch vụ.</p>
                </section>
                <section id="section-3">
                    <h3 class="section-title">
                        <i class="bi bi-person-badge-fill"></i>
                        3. Tài khoản người dùng
                    </h3>
                    <p>Khi bạn tạo tài khoản với chúng tôi, bạn phải cung cấp cho chúng tôi thông tin chính xác,
                        đầy đủ và
                        hiện hành tại mọi thời điểm. Việc không làm như vậy cấu thành hành vi vi phạm Điều
                        khoản, có thể dẫn
                        đến việc chấm dứt ngay lập tức tài khoản của bạn trên Dịch vụ của chúng tôi.</p>
                    <p class="mb-0">Bạn chịu trách nhiệm bảo vệ mật khẩu mà bạn sử dụng để truy cập Dịch vụ và
                        cho bất kỳ hoạt động hoặc
                        hành động nào dưới mật khẩu của bạn, cho dù mật khẩu của bạn là với Dịch vụ của chúng
                        tôi hoặc dịch
                        vụ của bên thứ ba.</p>
                </section>
                <section id="section-4">
                    <h3 class="section-title">
                        <i class="bi bi-shield-exclamation"></i>
                        4. Giới hạn trách nhiệm
                    </h3>
                    <p>Trong mọi trường hợp, SKYDRONE, cũng như các giám đốc, nhân viên, đối tác, đại lý, nhà
                        cung cấp
                        hoặc bên liên kết của nó, sẽ không chịu trách nhiệm cho bất kỳ thiệt hại gián tiếp, ngẫu
                        nhiên, đặc
                        biệt, hệ quả hoặc trừng phạt nào, bao gồm nhưng không giới hạn ở việc mất lợi nhuận, dữ
                        liệu, sử
                        dụng, uy tín hoặc các tổn thất vô hình khác.</p>
                    <p class="mb-0">Chúng tôi cung cấp dịch vụ trên cơ sở "nguyên trạng" và "sẵn có". Chúng tôi
                        không đưa ra bất kỳ tuyên
                        bố hoặc bảo đảm nào, rõ ràng hay ngụ ý, về hoạt động của dịch vụ hoặc thông tin, nội
                        dung, tài liệu
                        có trong đó.</p>
                </section>
                <section id="section-5">
                    <h3 class="section-title">
                        <i class="bi bi-pencil-square"></i>
                        5. Thay đổi điều khoản
                    </h3>
                    <p>Chúng tôi có quyền, theo quyết định riêng của mình, sửa đổi hoặc thay thế các Điều khoản
                        này bất kỳ
                        lúc nào. Nếu một sửa đổi là quan trọng, chúng tôi sẽ cố gắng cung cấp thông báo ít nhất
                        30 ngày
                        trước khi bất kỳ điều khoản mới nào có hiệu lực. Những gì cấu thành một thay đổi quan
                        trọng sẽ được
                        xác định theo quyết định riêng của chúng tôi.</p>
                    <p class="mb-0">Bằng việc tiếp tục truy cập hoặc sử dụng Dịch vụ của chúng tôi sau khi những
                        sửa đổi đó có hiệu lực,
                        bạn đồng ý bị ràng buộc bởi các điều khoản đã sửa đổi. Nếu bạn không đồng ý với các điều
                        khoản mới,
                        vui lòng ngừng sử dụng Dịch vụ.</p>
                </section>
            </div>
        </div>
        <div class="col-lg-4 toc-container">
            <div class="toc-sticky">
                <div class="content-card p-3">
                    <h6 class="fw-bold text-uppercase text-secondary mb-3 ms-2 text-primary"
                        style="font-size: 0.85rem; letter-spacing: 1px;">
                        Mục lục
                    </h6>
                    <nav class="nav flex-column toc">
                        <a href="#section-1" class="toc-link">
                            <i class="bi bi-check-circle"></i> 1. Chấp thuận
                        </a>
                        <a href="#section-2" class="toc-link">
                            <i class="bi bi-award"></i> 2. Sở hữu trí tuệ
                        </a>
                        <a href="#section-3" class="toc-link">
                            <i class="bi bi-person-badge"></i> 3. Tài khoản
                        </a>
                        <a href="#section-4" class="toc-link">
                            <i class="bi bi-shield-lock"></i> 4. Giới hạn
                        </a>
                        <a href="#section-5" class="toc-link">
                            <i class="bi bi-pencil"></i> 5. Thay đổi
                        </a>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="/page/footer.jsp"/>
<script>
    const links = document.querySelectorAll('.toc-link');
    const sections = document.querySelectorAll('section');
    function changeLinkState() {
        let index = sections.length;
        while (--index && window.scrollY + 150 < sections[index].offsetTop) {
        }
        links.forEach((link) => link.classList.remove('active'));
        if (index >= 0) {
            links[index].classList.add('active');
            // Cập nhật icon filled khi active
            const icon = links[index].querySelector('i');
            const originalClass = icon.className;
        }
    }
    window.addEventListener('scroll', changeLinkState);
    changeLinkState();
</script>
</body>
</html>