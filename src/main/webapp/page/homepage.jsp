<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SkyDrone - Trang chủ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
          rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/category-homepage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/homepage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/product-homepage.css">
</head>
<body>
<jsp:include page="/page/header-common.jsp"/>
<div class="container d-flex">
    <div class="menu-left">
        <ul>
            <c:forEach items="${headerCategories}" var="cat">
                <li>
                    <a href="${pageContext.request.contextPath}/Category?id=${cat.id}">
                        <img src="${pageContext.request.contextPath}/${cat.image}" class="menu-icon">
                            ${cat.categoryName}
                    </a>
                </li>
            </c:forEach>
        </ul>
    </div>
    <c:if test="${not empty banners && banners.size() > 0}">
        <c:set var="banner" value="${banners[0]}"/>
        <div class="banner-right">
            <c:choose>
                <c:when test="${banner.type == 'video'}">
                    <a
                            href="${not empty banner.link ? banner.link : '#'}">
                        <video autoplay loop muted playsinline>
                            <source src="${banner.videoUrl}"
                                    type="video/mp4">
                        </video>
                    </a>
                </c:when>
                <c:otherwise>
                    <a
                            href="${not empty banner.link ? banner.link : '#'}">
                        <img src="${banner.imageUrl}"
                             alt="Banner ${banner.id}">
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>
</div>
<c:if test="${not empty banners && banners.size() > 1}">
    <div class="banner-wrapper">
        <c:forEach var="banner" items="${banners}" begin="1" end="3">
            <a href="${not empty banner.link ? banner.link : '#'}">
                <div class="banner-item">
                    <c:choose>
                        <c:when test="${banner.type == 'image'}">
                            <img src="${banner.imageUrl}" alt="Banner ${banner.id}">
                        </c:when>
                        <c:otherwise>
                            <video autoplay loop muted playsinline>
                                <source src="${banner.videoUrl}" type="video/mp4">
                            </video>
                        </c:otherwise>
                    </c:choose>
                </div>
            </a>
        </c:forEach>
    </div>
</c:if>
<c:if test="${not empty banners && banners.size() > 4}">
    <div class="banner-right slider-2">
        <div class="slider slider-2-inner">
            <c:forEach var="banner" items="${banners}" begin="4">
                <a href="${not empty banner.link ? banner.link : '#'}" class="slider-2-link">
                    <div class="slide">
                        <c:choose>
                            <c:when test="${banner.type == 'image'}">
                                <img src="${banner.imageUrl}" alt="Banner ${banner.id}"
                                     style="width: 100%; height: 100%; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                <video autoplay loop muted playsinline
                                       style="width: 100%; height: 100%; object-fit: cover;">
                                    <source src="${banner.videoUrl}" type="video/mp4">
                                </video>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </a>
            </c:forEach>
        </div>
        <div class="arrow left slider-2-left">&#10094;</div>
        <div class="arrow right slider-2-right">&#10095;</div>
        <div class="dots slider-2-dots"></div>
    </div>
</c:if>
<section class="phan-san-pham">
    <h2 class="tieu-de-muc">SẢN PHẨM BÁN CHẠY NHẤT</h2>
    <div class="khung-san-pham">
        <c:forEach var="p" items="${bestSellerProducts}">
            <div class="san-pham">
                <a class="link-chi-tiet"
                   href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                    <div class="khung-anh">
                        <c:choose>
                            <c:when test="${not empty p.mainImage}">
                                <img src="${p.mainImage}" alt="${p.productName}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/no-image.png"
                                     alt="No Image">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <h3 class="ten-san-pham">${p.productName}</h3>
                    <div class="gia">
                        <b>${formatter.format(p.finalPrice)} ₫</b>

                        <c:if test="${p.price > p.finalPrice}">
                                            <span class="gia-goc">
                                                ${formatter.format(p.price)}  ₫
                                            </span>
                        </c:if>
                    </div>
                </a>
                <c:set var="fullStars1" value="${p.avgRating.intValue()}"/>
                <c:set var="hasHalfStar1" value="${p.avgRating - fullStars1 >= 0.5}"/>
                <div class="hang-danh-gia">
                    <div class="danh-gia-sao">
                        <c:forEach begin="1" end="${fullStars1}">
                            <i class="bi bi-star-fill"></i>
                        </c:forEach>
                        <c:if test="${hasHalfStar1}">
                            <i class="bi bi-star-half"></i>
                        </c:if>
                        <c:forEach begin="1" end="${5 - fullStars1 - (hasHalfStar1 ? 1 : 0)}">
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
                <form action="${pageContext.request.contextPath}/add-cart" method="get">
                    <input type="hidden" name="productId" value="${p.id}">
                    <input type="hidden" name="quantity" value="1">
                    <button type="submit" class="nut-mua-ngay">
                        <i class="bi bi-cart-plus"></i>
                        Thêm vào giỏ
                    </button>
                </form>
            </div>
        </c:forEach>
    </div>
</section>
<section class="danh-muc">
    <h2>DANH MỤC NỔI BẬT</h2>
    <div class="danh-muc-list">
        <c:forEach items="${headerCategories}" var="cat">
            <div class="item">
                <a href="${pageContext.request.contextPath}/Category?id=${cat.id}">
                    <img src="${pageContext.request.contextPath}/${cat.image}"
                         alt="${cat.categoryName}">
                    <p>${cat.categoryName}</p>
                </a>
            </div>
        </c:forEach>
    </div>
</section>
<section class="phan-san-pham-noi-bat">
    <h2>SẢN PHẨM NỔI BẬT</h2>
    <div class="khung-san-pham">
        <c:forEach var="p" items="${topReviewedProducts}">
            <div class="san-pham">
                <a class="link-chi-tiet"
                   href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                    <div class="khung-anh">
                        <c:choose>
                            <c:when test="${not empty p.mainImage}">
                                <img src="${p.mainImage}" alt="${p.productName}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/no-image.png"
                                     alt="No Image">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <h3 class="ten-san-pham">${p.productName}</h3>
                    <div class="gia">
                        <b>${formatter.format(p.finalPrice)} ₫</b>
                        <c:if test="${p.price > p.finalPrice}">
                                            <span class="gia-goc">
                                                ${formatter.format(p.price)} ₫
                                            </span>
                        </c:if>
                    </div>
                </a>
                <c:set var="fullStars1" value="${p.avgRating.intValue()}"/>
                <c:set var="hasHalfStar1" value="${p.avgRating - fullStars1 >= 0.5}"/>
                <div class="hang-danh-gia">
                    <div class="danh-gia-sao">
                        <c:forEach begin="1" end="${fullStars1}">
                            <i class="bi bi-star-fill"></i>
                        </c:forEach>
                        <c:if test="${hasHalfStar1}">
                            <i class="bi bi-star-half"></i>
                        </c:if>
                        <c:forEach begin="1" end="${5 - fullStars1 - (hasHalfStar1 ? 1 : 0)}">
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
                <form action="${pageContext.request.contextPath}/add-cart" method="get">
                    <input type="hidden" name="productId" value="${p.id}">
                    <input type="hidden" name="quantity" value="1">
                    <button type="submit" class="nut-mua-ngay">
                        <i class="bi bi-cart-plus"></i>
                        Thêm vào giỏ
                    </button>
                </form>
            </div>
        </c:forEach>
    </div>
</section>
<a href="http://localhost:8080/Nhom12LapTrinhWebFlycams/page/payment-policy.jsp">
    <div class="banner">
        <img src="${pageContext.request.contextPath}/image/banner/hinh4.png" alt="Banner ưu đãi">
    </div>
</a>
<section class="phan-san-pham-1">
    <h2>DRONE QUAY PHIM</h2>
    <div class="khung-san-pham-1">
        <a href="product-details.jsp">
            <div class="poster">
                <img src="${pageContext.request.contextPath}/image/banner/img_2.png" alt="Poster 1">
            </div>
        </a>
        <c:forEach var="p" items="${quayPhim}">
            <div class="san-pham">
                <a class="link-chi-tiet"
                   href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                    <div class="khung-anh">
                        <c:choose>
                            <c:when test="${not empty p.mainImage}">
                                <img src="${p.mainImage}" alt="${p.productName}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/no-image.png"
                                     alt="No Image">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <h3 class="ten-san-pham">${p.productName}</h3>
                    <div class="gia">
                        <b>${formatter.format(p.finalPrice)} ₫</b>
                        <c:if test="${p.price > p.finalPrice}">
                                            <span class="gia-goc">
                                                ${formatter.format(p.price)} ₫
                                            </span>
                        </c:if>
                    </div>
                </a>
                <c:set var="fullStars1" value="${p.avgRating.intValue()}"/>
                <c:set var="hasHalfStar1" value="${p.avgRating - fullStars1 >= 0.5}"/>
                <div class="hang-danh-gia">
                    <div class="danh-gia-sao">
                        <c:forEach begin="1" end="${fullStars1}">
                            <i class="bi bi-star-fill"></i>
                        </c:forEach>
                        <c:if test="${hasHalfStar1}">
                            <i class="bi bi-star-half"></i>
                        </c:if>
                        <c:forEach begin="1" end="${5 - fullStars1 - (hasHalfStar1 ? 1 : 0)}">
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
                <form action="${pageContext.request.contextPath}/add-cart" method="get">
                    <input type="hidden" name="productId" value="${p.id}">
                    <input type="hidden" name="quantity" value="1">
                    <button type="submit" class="nut-mua-ngay">
                        <i class="bi bi-cart-plus"></i>
                        Thêm vào giỏ
                    </button>
                </form>
            </div>
        </c:forEach>
    </div>
    <a href="${pageContext.request.contextPath}/Category?id=1001">
        <button class="xem">Xem Tất Cả »</button>
    </a>
</section>
<section class="phan-san-pham-1">
    <h2>DRONE MINI</h2>
    <div class="khung-san-pham-1">
        <a href="product-details.jsp">
            <div class="poster">
                <img src="${pageContext.request.contextPath}/image/banner/img.png" alt="Poster 1">
            </div>
        </a>
        <c:forEach var="p" items="${mini}">
            <div class="san-pham">
                <a class="link-chi-tiet"
                   href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                    <div class="khung-anh">
                        <c:choose>
                            <c:when test="${not empty p.mainImage}">
                                <img src="${p.mainImage}" alt="${p.productName}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/no-image.png"
                                     alt="No Image">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <h3 class="ten-san-pham">${p.productName}</h3>
                    <div class="gia">
                        <b>${formatter.format(p.finalPrice)} ₫</b>
                        <c:if test="${p.price > p.finalPrice}">
                                            <span class="gia-goc">
                                                ${formatter.format(p.price)} ₫
                                            </span>
                        </c:if>
                    </div>
                </a>
                <c:set var="fullStars1" value="${p.avgRating.intValue()}"/>
                <c:set var="hasHalfStar1" value="${p.avgRating - fullStars1 >= 0.5}"/>
                <div class="hang-danh-gia">
                    <div class="danh-gia-sao">
                        <c:forEach begin="1" end="${fullStars1}">
                            <i class="bi bi-star-fill"></i>
                        </c:forEach>
                        <c:if test="${hasHalfStar1}">
                            <i class="bi bi-star-half"></i>
                        </c:if>
                        <c:forEach begin="1" end="${5 - fullStars1 - (hasHalfStar1 ? 1 : 0)}">
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
                <form action="${pageContext.request.contextPath}/add-cart" method="get">
                    <input type="hidden" name="productId" value="${p.id}">
                    <input type="hidden" name="quantity" value="1">
                    <button type="submit" class="nut-mua-ngay">
                        <i class="bi bi-cart-plus"></i>
                        Thêm vào giỏ
                    </button>
                </form>
            </div>
        </c:forEach>
    </div>
    <a href="${pageContext.request.contextPath}/Category?id=1004">
        <button class="xem">Xem Tất Cả »</button>
    </a>
</section>
<section class="related-articles">
    <h2>BÀI VIẾT MỚI NHẤT</h2>
    <div class="related-grid">
        <c:forEach var="post" items="${latestPosts}">
            <div class="related-item">
                <a href="${pageContext.request.contextPath}/article?id=${post.id}">
                    <img src="${empty post.image ? '/assets/no-image.png' : post.image}"
                         alt="${post.title}">
                    <p>${post.title}</p>
                </a>
            </div>
        </c:forEach>
    </div>
</section>
<jsp:include page="/page/footer.jsp"/>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const slider2 = document.querySelector('.slider-2-inner');
        const slides2 = document.querySelectorAll('.slider-2-inner .slide');
        const dotsContainer2 = document.querySelector('.slider-2-dots');
        const arrowLeft2 = document.querySelector('.slider-2-left');
        const arrowRight2 = document.querySelector('.slider-2-right');
        const slider2Container = document.querySelector('.slider-2');
        if (!slider2 || !slides2.length) {
            console.log('Slider 2 không tồn tại hoặc không có slide');
            return;
        }
        if (slides2.length < 2) {
            if (arrowLeft2) arrowLeft2.style.display = 'none';
            if (arrowRight2) arrowRight2.style.display = 'none';
            if (dotsContainer2) dotsContainer2.style.display = 'none';
            return;
        }
        let index2 = 0;
        let autoSlide2;

        function createDots2() {
            if (!dotsContainer2) return;
            dotsContainer2.innerHTML = '';
            slides2.forEach((_, i) => {
                const dot = document.createElement('span');
                dot.classList.add('dot2');
                if (i === 0) dot.classList.add('active');
                dot.addEventListener('click', () => {
                    goToSlide2(i);
                    stopSlide2();
                    startSlide2();
                });
                dotsContainer2.appendChild(dot);
            });
        }

        function updateDots2() {
            document.querySelectorAll('.dot2').forEach((dot, i) => {
                dot.classList.toggle('active', i === index2);
            });
        }

        function goToSlide2(i) {
            index2 = (i + slides2.length) % slides2.length;
            console.log('DEBUG: index2=', index2);
            const percentage = index2 * 100;
            console.log('DEBUG: percentage=', percentage);
            const transformValue = 'translateX(-' + percentage + '%)';
            console.log('DEBUG: transformValue string=', transformValue);
            if (slider2) {
                slider2.style.transform = transformValue;
                console.log('DEBUG: Element style.transform after set:', slider2.style.transform);
            } else {
                console.error('DEBUG: slider2 element is missing!');
            }
            updateDots2();
        }

        window.addEventListener('resize', () => {
            goToSlide2(index2);
        });
        if (arrowLeft2) {
            arrowLeft2.addEventListener('click', () => {
                goToSlide2(index2 - 1);
                stopSlide2();
                startSlide2();
            });
        }
        if (arrowRight2) {
            arrowRight2.addEventListener('click', () => {
                goToSlide2(index2 + 1);
                stopSlide2();
                startSlide2();
            });
        }

        function startSlide2() {
            stopSlide2();
            autoSlide2 = setInterval(() => {
                goToSlide2(index2 + 1);
            }, 3000);
        }

        function stopSlide2() {
            if (autoSlide2) {
                clearInterval(autoSlide2);
            }
        }

        if (slider2Container) {
            slider2Container.addEventListener('mouseenter', stopSlide2);
            slider2Container.addEventListener('mouseleave', startSlide2);
        }
        createDots2();
        startSlide2();
        console.log('Slider 2 đã khởi động với ' + slides2.length + ' slides');
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.querySelectorAll('.tim-yeu-thich').forEach(tim => {
        tim.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            const productId = this.getAttribute('data-product-id');
            const isLiked = this.classList.contains('yeu-thich');
            const action = isLiked ? 'remove' : 'add';
            console.log('SEND:', action, productId);
            if (!productId) {
                console.error('productId is null');
                return;
            }
            fetch('${pageContext.request.contextPath}/wishlist', {
                method: 'POST',
                credentials: 'same-origin',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: new URLSearchParams({
                    action: action,
                    productId: productId
                })
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        this.classList.toggle('bi-heart');
                        this.classList.toggle('bi-heart-fill');
                        this.classList.toggle('yeu-thich');
                    } else if (data.error === 'login_required' || data.message === 'NOT_LOGIN') {
                        window.location.href = '${pageContext.request.contextPath}/page/login.jsp';
                    }
                })
                .catch(err => {
                    console.error('Error:', err);
                });
        });
    });
</script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        document.querySelectorAll('.nut-mua-ngay').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                const form = btn.closest('form');
                if (!form) return;
                const productIdInput = form.querySelector('input[name="productId"]');
                const quantityInput = form.querySelector('input[name="quantity"]');
                if (!productIdInput) return;
                const productId = productIdInput.value;
                const quantity = quantityInput ? quantityInput.value : 1;
                const productCard = btn.closest('.san-pham');
                const productImg = productCard ? (productCard.querySelector('.khung-anh img') || productCard.querySelector('img')) : null;
                if (typeof globallyHandleAddToCart === 'function') {
                    globallyHandleAddToCart(productId, quantity, productImg, btn);
                } else {
                    console.error('globallyHandleAddToCart function not found');
                    form.submit();
                }
            });
        });
    });
</script>
</body>
</html>