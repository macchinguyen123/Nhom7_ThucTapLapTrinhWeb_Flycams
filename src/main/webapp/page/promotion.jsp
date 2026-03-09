<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>Khuyến mãi Flycam</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/promotion.css">
</head>
<body>
<jsp:include page="/page/header-common.jsp"/>
<header class="khung-tieu-de">
    <h1 id="ten-chuong-trinh" style="color: #dc3545;">KHUYẾN MÃI FLYCAM THÁNG NÀY</h1>
    <p class="mo-ta-chuong-trinh">
        Ưu đãi đặc biệt cho dòng flycam chính hãng — giảm giá sập sàn!
    </p>
</header>
<main class="khung-noi-dung">
    <c:if test="${empty promotionMap}">
        <div style="text-align:center; padding:50px; color:white">
            <h2>Hiện tại chưa có chương trình khuyến mãi</h2>
        </div>
    </c:if>
    <c:forEach var="entry" items="${promotionMap}">
        <section class="khung-tieu-de">
            <h2 class="ten-chuong-trinh-promo"
                style="color: #ffffff; text-align: center; font-weight: 700;">
                    ${entry.key.name}
            </h2>
            <p class="mo-ta-chuong-trinh">
                Áp dụng từ
                <fmt:formatDate value="${entry.key.startDate}" pattern="dd/MM/yyyy"/>
                đến
                <fmt:formatDate value="${entry.key.endDate}" pattern="dd/MM/yyyy"/>
            </p>
        </section>
        <section class="danh-sach-flycam">
            <c:forEach var="p" items="${entry.value}">
                <article class="the-san-pham">
                    <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                        <img class="anh-san-pham"
                             src="${empty p.mainImage ? '/assets/no-image.png' : p.mainImage}"
                             alt="${p.productName}">
                    </a>
                    <div class="noi-dung-san-pham">
                        <h3 class="ten-san-pham">
                                ${p.productName}
                        </h3>
                        <div class="gia-block">
                                            <span class="gia-moi">
                                                <fmt:formatNumber value="${p.finalPrice}" type="number"/> ₫
                                            </span>
                            <c:if test="${p.price > p.finalPrice}">
                                                <span class="gia-cu">
                                                    <fmt:formatNumber value="${p.price}" type="number"/> ₫
                                                </span>
                            </c:if>
                        </div>
                        <c:set var="fullStars" value="${p.avgRating.intValue()}"/>
                        <c:set var="hasHalfStar" value="${p.avgRating - fullStars >= 0.5}"/>
                        <div class="hang-danh-gia">
                            <div class="danh-gia-sao">
                                <c:forEach begin="1" end="${fullStars}">
                                    <i class="bi bi-star-fill"></i>
                                </c:forEach>
                                <c:if test="${hasHalfStar}">
                                    <i class="bi bi-star-half"></i>
                                </c:if>
                                <c:forEach begin="1" end="${5 - fullStars - (hasHalfStar ? 1 : 0)}">
                                    <i class="bi bi-star"></i>
                                </c:forEach>
                            </div>
                            <c:choose>
                                <c:when
                                        test="${wishlistProductIds != null && wishlistProductIds.contains(p.id)}">
                                    <i class="bi bi-heart-fill tim-yeu-thich yeu-thich"
                                       data-product-id="${p.id}"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-heart tim-yeu-thich" data-product-id="${p.id}"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="so-danh-gia">
                            (${empty p.reviewCount ? 0 : p.reviewCount} đánh giá)
                        </div>
                        <form action="${pageContext.request.contextPath}/add-cart" method="get"
                              class="text-center">
                            <input type="hidden" name="productId" value="${p.id}">
                            <input type="hidden" name="quantity" value="1">
                            <button type="submit" class="nut-mua-ngay">
                                <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                            </button>
                        </form>
                    </div>
                </article>
            </c:forEach>
        </section>
    </c:forEach>
</main>
<jsp:include page="/page/footer.jsp"/>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        document.querySelectorAll('.nut-mua-ngay').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                const form = btn.closest('form');
                if (!form) return;
                const productId = form.querySelector('input[name="productId"]').value;
                const quantity = form.querySelector('input[name="quantity"]').value;
                const productCard = btn.closest('.the-san-pham');
                const productImg = productCard.querySelector('img');
                if (typeof globallyHandleAddToCart === 'function') {
                    globallyHandleAddToCart(productId, quantity, productImg, btn);
                } else {
                    console.error('globallyHandleAddToCart not defined');
                    form.submit();
                }
            });
        });
    });
</script>
<script>
    document.querySelectorAll('.tim-yeu-thich').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            const productId = btn.dataset.productId;
            fetch('${pageContext.request.contextPath}/wishlist', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'action=toggle&productId=' + productId
            })
                .then(res => {
                    if (res.status === 401) {
                        if (confirm('Bạn cần đăng nhập để sử dụng tính năng này. Chuyển đến trang đăng nhập?')) {
                            window.location.href = '${pageContext.request.contextPath}/page/login.jsp';
                        }
                        return null;
                    }
                    return res.json();
                })
                .then(data => {
                    if (!data) return;
                    if (data.success) {
                        const isActive = btn.classList.contains('bi-heart-fill');
                        btn.classList.toggle('bi-heart', isActive);
                        btn.classList.toggle('bi-heart-fill', !isActive);
                        btn.classList.toggle('yeu-thich', !isActive);
                    } else {
                        if (typeof showNotification === 'function') {
                            showNotification(data.message || 'Thao tác thất bại', 'error');
                        } else {
                            alert(data.message || 'Thao tác thất bại');
                        }
                    }
                })
                .catch(err => {
                    console.error('Error:', err);
                    if (typeof showNotification === 'function') {
                        showNotification('Lỗi kết nối server', 'error');
                    }
                });
        });
    });
</script>
</body>
</html>