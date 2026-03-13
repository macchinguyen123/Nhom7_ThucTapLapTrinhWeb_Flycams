<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hỗ Trợ Khách Hàng | SkyDrone Việt Nam</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/support.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
<jsp:include page="/page/header-common.jsp"/>
<section class="hotro-container">
    <div class="hotro-header">
        <i class="bi bi-headset"></i>
        <h1>HỖ TRỢ KHÁCH HÀNG</h1>
        <p>SkyDrone luôn sẵn sàng hỗ trợ bạn qua các kênh liên hệ nhanh chóng và tiện lợi.</p>
    </div>
    <div class="hotro-grid">
        <div class="hotro-item">
            <img src="https://upload.wikimedia.org/wikipedia/commons/9/91/Icon_of_Zalo.svg" alt="Zalo">
            <h3>Chat qua Zalo</h3>
            <p>Liên hệ trực tiếp với đội ngũ hỗ trợ qua Zalo để được phản hồi nhanh nhất.</p>
            <a href="https://zalo.me/0966089465"
               target="_blank" rel="noopener noreferrer"
               class="hotro-btn">Mở Zalo</a>
        </div>
        <div class="hotro-item">
            <i class="bi bi-envelope-paper"></i>
            <h3>Hỗ trợ qua Email</h3>
            <p>Gửi email cho bộ phận chăm sóc khách hàng 24/7 để được hỗ trợ chi tiết.</p>
            <a href="mailto:23130211@st.hcmuaf.edu.vn" class="hotro-btn">Gửi Email</a>
        </div>
        <div class="hotro-item">
            <i class="bi bi-facebook"></i>
            <h3>Fanpage Facebook</h3>
            <p>Theo dõi Fanpage SkyDrone để nhận thông báo, ưu đãi và hỗ trợ nhanh chóng.</p>
            <a href="https://www.facebook.com/skydrone.vn"
               target="_blank" rel="noopener noreferrer"
               class="hotro-btn">Đến Fanpage</a>
        </div>
        <div class="hotro-item">
            <i class="bi bi-messenger"></i>
            <h3>Chat qua Messenger</h3>
            <p>Trao đổi trực tiếp với đội ngũ hỗ trợ SkyDrone qua Facebook Messenger.</p>
            <a href="https://m.me/skydrone.vn"
               target="_blank" rel="noopener noreferrer"
               class="hotro-btn">Nhắn Messenger</a>
        </div>
    </div>
    <section class="map-section" style="margin-top: 50px; text-align: center;">
        <h2 style="font-weight: 600; margin-bottom: 20px;">ĐỊA CHỈ SKYDRONE VIỆT NAM</h2>
        <p>Số 1 Đường Số 1, Phường Linh Xuân, TP Hồ Chí Minh</p>
        <div style="width: 100%; max-width: 1200px; height: 450px; margin: 0 auto; border-radius: 10px; overflow: hidden;">
            <iframe
                    src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3919.2295471115876!2d106.76981577592729!3d10.793515589353548!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x317528ee99999999%3A0xa7c4c478d37cbbb!2zSOG7jWMgQ8O0bmcgTmdo4buvbSBT4buRIMSQ4buTbmggTmfhu41jIChOSFUp!5e0!3m2!1svi!2s!4v1732508619777!"
                    width="100%" height="100%" style="border:0;"
                    allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade">
            </iframe>
        </div>
    </section>
</section>
<jsp:include page="/page/footer.jsp"/>
</body>
</html>
