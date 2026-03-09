<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết sản phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/product-details.css">
</head>
<body>
<jsp:include page="/page/header-common.jsp"/>
<div class="main-wrapper">
    <div class="container bg-white mt-4 p-4 rounded shadow-sm">
        <div class="row">
            <div class="col-md-6 text-center product-image-col">
                <div class="main-image-wrapper">
                    <div id="mainImage" class="border rounded mb-3">
                        <c:if test="${not empty product.images}">
                            <img id="displayImg" src="${product.images[0].imageUrl}">
                        </c:if>
                        <button class="nav-btn prev-btn"><i class="bi bi-chevron-left"></i></button>
                        <button class="nav-btn next-btn"><i
                                class="bi bi-chevron-right"></i></button>
                    </div>
                </div>
                <div class="fixed-bottom-block">
                    <div class="d-flex justify-content-center gap-2">
                        <c:forEach var="img" items="${product.images}">
                            <img src="${img.imageUrl}" class="img-thumbnail thumb" width="80"
                                 onclick="changeImage('${img.imageUrl}')">
                        </c:forEach>
                    </div>
                    <div class="share-icons mt-3">
                        <span>Chia sẻ:</span>
                        <i class="bi bi-messenger share-icon" onclick="shareOnMessenger()"
                           title="Chia sẻ qua Messenger"></i>
                        <i class="bi bi-facebook share-icon" onclick="shareOnFacebook()"
                           title="Chia sẻ lên Facebook"></i>
                        <i class="bi bi-pinterest share-icon" onclick="shareOnPinterest()"
                           title="Chia sẻ lên Pinterest"></i>
                        <i class="bi bi-twitter-x share-icon" onclick="shareOnTwitter()"
                           title="Chia sẻ lên Twitter/X"></i>
                        <span class="ms-2 heart-btn">
                                                <c:choose>
                                                    <c:when
                                                            test="${wishlistProductIds != null && wishlistProductIds.contains(product.id)}">
                                                        <i class="bi bi-heart-fill tim-yeu-thich yeu-thich"
                                                           data-product-id="${product.id}"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="bi bi-heart tim-yeu-thich"
                                                           data-product-id="${product.id}"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                                Yêu thích
                                            </span>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <h5 class="fw-bold mb-2">${product.productName}</h5>
                <div class="rating mb-3">
                    <c:forEach begin="1" end="${fullStars}">
                        <i class="bi bi-star-fill"></i>
                    </c:forEach>
                    <c:if test="${hasHalfStar}">
                        <i class="bi bi-star-half"></i>
                    </c:if>
                    <c:forEach begin="1" end="${5 - fullStars - (hasHalfStar ? 1 : 0)}">
                        <i class="bi bi-star"></i>
                    </c:forEach>
                    <span class="ms-2">
                                            <u>
                                                <fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/>
                                            </u> |
                                            <u class="text-muted">${reviewCount} Đánh Giá</u> |
                                            <u class="text-muted">
                                                <fmt:formatNumber value="${product.view}"/> Lượt Xem
                                            </u>
                                        </span>
                </div>
                <div class="product-info text-muted mb-2">
                    <p class="mb-1 d-flex flex-wrap gap-3">
                                            <span>
                                                <span class="fw-semibold">Thương hiệu:</span>
                                                <span class="text-primary">${product.brandName}</span>
                                            </span>
                        <span>
                                                <span class="fw-semibold">Mã sản phẩm:</span>
                                                <span class="text-secondary">${product.id}</span>
                                            </span>
                    </p>
                    <p class="mb-1">
                        <span class="fw-semibold">Danh mục:</span>
                        <a
                                href="${pageContext.request.contextPath}/Category?id=${product.categoryId}">
                            <span class="text-primary">${categoryName}</span>
                        </a>
                    </p>
                </div>
                <div class="price my-3">
                                        <span class="fs-1 fw-bold text-danger">
                                            ${formatter.format(product.finalPrice)} ₫
                                        </span>
                    <c:if test="${product.price > product.finalPrice}">
                                            <span class="text-muted text-decoration-line-through ms-2">
                                                ${formatter.format(product.price)} ₫
                                            </span>
                        <c:if test="${discountPercent > 0}">
                            <div class="discount-badge">-${discountPercent}%</div>
                        </c:if>
                    </c:if>
                </div>
                <div class="quantity mb-3 d-flex align-items-center">
                    <span class="me-3 fw-semibold">Số lượng</span>
                    <div class="quantity-box">
                        <button type="button" id="minus">-</button>
                        <input type="text" id="qty" value="1" readonly>
                        <button type="button" id="plus">+</button>
                    </div>
                </div>
                <div class="buy-buttons">
                    <form action="${pageContext.request.contextPath}/add-cart" method="get"
                          style="display:inline-block;">
                        <input type="hidden" name="productId" value="${product.id}">
                        <input type="hidden" name="quantity" id="quantityHidden" value="1">
                        <button type="button" class="btn-add-cart" onclick="addToCartClick(this)">
                            <i class="bi bi-cart-plus"></i>Thêm vào giỏ hàng
                        </button>
                    </form>
                    <form action="${pageContext.request.contextPath}/BuyNowServlet" method="post">
                        <input type="hidden" name="productId" value="${product.id}">
                        <input type="hidden" name="quantity" id="buyNowQuantity" value="1">
                        <button type="submit" class="btn-buy-now">Mua Ngay
                        </button>
                    </form>
                </div>
                <div class="policy p-3 rounded">
                    <h6 class="fw-bold mb-2">Chính sách của sản phẩm:</h6>
                    <c:forEach var="item" items="${fn:split(product.warranty, '.')}">
                        <c:if test="${not empty fn:trim(item)}">
                            <p>
                                <i class="bi bi-check-circle-fill text-success me-2"></i>
                                    ${fn:trim(item)}.
                            </p>
                        </c:if>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
    <div class="container mt-5">
        <div class="tab-buttons d-flex justify-content-center mb-3">
            <button class="tab-btn active" id="infoBtn">Thông tin sản phẩm</button>
            <button class="tab-btn" id="specBtn">Thông số kỹ thuật</button>
        </div>
        <div class="tab-content p-4 bg-white rounded shadow-sm" id="infoTab">
            <c:out value="${product.description}" escapeXml="false"/>
        </div>
        <div class="tab-content p-4 bg-white rounded shadow-sm d-none" id="specTab">
            <h5 class="fw-bold mb-3">Thông số kỹ thuật</h5>
            <c:out value="${product.parameter}" escapeXml="false"/>
        </div>
    </div>
    <section class="review-section">
        <h4 class="review-title">ĐÁNH GIÁ SẢN PHẨM</h4>
        <div class="rating-overview">
            <div class="rating-score">
                                    <span class="score">
                                        <i class="bi bi-star-fill"></i>
                                        <fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/>
                                    </span><small>/5</small>
                <p>${reviewCount} đánh giá</p>
            </div>
            <div class="rating-filters">
                <button class="filter-btn active" data-star="all">Tất Cả (${reviewCount})
                </button>
                <button class="filter-btn" data-star="5">5 Sao (${star5})
                </button>
                <button class="filter-btn" data-star="4">4 Sao (${star4})
                </button>
                <button class="filter-btn" data-star="3">3 Sao (${star3})
                </button>
                <button class="filter-btn" data-star="2">2 Sao (${star2})
                </button>
                <button class="filter-btn" data-star="1">1 Sao (${star1})
                </button>
                <button class="filter-btn" data-filter="comment">Có Bình Luận (${commentCount})
                </button>
            </div>
        </div>
        <div id="review-list">
            <c:forEach var="r" items="${reviews}">
                <div class="review" data-star="${r.rating}" data-comment="${not empty r.content}">
                    <div class="review-avatar">
                        <img src="${pageContext.request.contextPath}/image/avatar/${r.avatar}"
                             alt="${r.username}"
                             onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name=${r.username}&background=007bff&color=fff&size=50'">
                    </div>
                    <div class="review-content">
                        <div class="review-header">
                            <span class="review-name">${r.username}</span>
                            <div class="review-stars">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= r.rating}">
                                            <i class="bi bi-star-fill"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-star"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                        </div>
                        <div class="review-date">
                            <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                        </div>
                        <p class="review-text">
                                ${r.content}
                        </p>
                    </div>
                </div>
            </c:forEach>
        </div>
        <div class="pagination">
            <c:if test="${currentPage > 1}">
                <a
                        href="${pageContext.request.contextPath}/product-detail?id=${product.id}&page=${currentPage - 1}">
                    <button>&laquo;</button>
                </a>
            </c:if>
            <c:forEach begin="1" end="${totalPages}" var="i">
                <a
                        href="${pageContext.request.contextPath}/product-detail?id=${product.id}&page=${i}">
                    <button class="${i == currentPage ? 'active' : ''}">
                            ${i}
                    </button>
                </a>
            </c:forEach>
            <c:if test="${currentPage < totalPages}">
                <a
                        href="${pageContext.request.contextPath}/product-detail?id=${product.id}&page=${currentPage + 1}">
                    <button>&raquo;</button>
                </a>
            </c:if>
        </div>
        <c:choose>
            <c:when test="${!isLoggedIn}">
                <button class="write-review-btn" onclick="redirectToLogin()">
                    <i class="bi bi-star"></i> Viết đánh giá
                </button>
                <p class="text-muted text-center review-status-message">
                    <small><i class="bi bi-info-circle"></i> Bạn cần đăng nhập để đánh
                        giá</small>
                </p>
            </c:when>
            <c:when test="${isLoggedIn && hasReviewed}">
                <button class="write-review-btn" disabled
                        title="Bạn đã đánh giá sản phẩm này rồi">
                    <i class="bi bi-check-circle"></i> Đã đánh giá
                </button>
                <p class="text-success text-center review-status-message">
                    <small><i class="bi bi-check-circle-fill"></i> Bạn đã đánh giá sản phẩm
                        này</small>
                </p>
            </c:when>
            <c:when test="${isLoggedIn && !canReview && !hasReviewed}">
                <button class="write-review-btn" disabled
                        title="Bạn chỉ có thể đánh giá sản phẩm đã mua">
                    <i class="bi bi-star"></i> Viết đánh giá
                </button>
                <p class="text-muted text-center review-status-message">
                    <small><i class="bi bi-info-circle"></i> Bạn cần mua sản phẩm này để
                        có thể đánh giá</small>
                </p>
            </c:when>
            <c:otherwise>
                <button class="write-review-btn" data-product-id="${product.id}">
                    <i class="bi bi-star"></i> Viết đánh giá
                </button>
            </c:otherwise>
        </c:choose>
    </section>
</div>
<c:if test="${not empty relatedProducts}">
    <div class="khung-san-pham-wrapper">
        <button class="nut-chuyen prev">
            <i class="bi bi-chevron-left"></i>
        </button>
        <h2 class="section-title">Sản Phẩm Liên Quan</h2>
        <div class="khung-san-pham">
            <c:forEach items="${relatedProducts}" var="p">
                <div class="san-pham">
                    <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                        <div class="khung-anh">
                            <img src="${empty p.mainImage ? '/assets/no-image.png' : p.mainImage}">
                        </div>
                        <h3 class="ten-san-pham">
                                ${p.productName}
                        </h3>
                        <div class="gia">
                            <b>${formatter.format(p.finalPrice)} ₫</b>
                            <c:if test="${p.price >= p.finalPrice}">
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
                    <form action="${pageContext.request.contextPath}/add-cart" method="get"
                          class="text-center">
                        <input type="hidden" name="productId" value="${p.id}">
                        <input type="hidden" name="quantity" value="1">
                        <button type="submit" class="nut-mua-ngay">
                            <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                        </button>
                    </form>
                </div>
            </c:forEach>
        </div>
        <button class="nut-chuyen next">
            <i class="bi bi-chevron-right"></i>
        </button>
    </div>
</c:if>
<div class="review-popup" id="reviewPopup">
    <div class="popup-content">
        <span class="close-btn">&times;</span>
        <h2>Thêm một đánh giá</h2>
        <p class="note">
            Tài khoản email của bạn sẽ được công bố.
            Trường bắt buộc được đánh dấu <span>*</span>
        </p>
        <form class="review-form" id="reviewForm"
              action="${pageContext.request.contextPath}/ReviewServlet" method="post">
            <input type="hidden" name="product_id" value="${product.id}">
            <div class="rating-group">
                <label>
                    <input type="radio" name="rating" value="1">
                    <div class="stars">
                        <i class="bi bi-star-fill"></i>
                    </div>
                    <div>(1)</div>
                </label>
                <label>
                    <input type="radio" name="rating" value="2">
                    <div class="stars">
                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                    </div>
                    <div>(2)</div>
                </label>
                <label>
                    <input type="radio" name="rating" value="3" checked>
                    <div class="stars">
                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i
                            class="bi bi-star-fill"></i>
                    </div>
                    <div>(3)</div>
                </label>
                <label>
                    <input type="radio" name="rating" value="4">
                    <div class="stars">
                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i
                            class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                    </div>
                    <div>(4)</div>
                </label>
                <label>
                    <input type="radio" name="rating" value="5">
                    <div class="stars">
                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i
                            class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i
                            class="bi bi-star-fill"></i>
                    </div>
                    <div>(5)</div>
                </label>
            </div>
            <div class="comment-group">
                <label for="comment-popup">Nhận xét của bạn <span>*</span></label>
                <textarea id="comment-popup" name="content" placeholder="Viết nhận xét tại đây..."
                          required></textarea>
            </div>
            <button type="submit" class="submit-btn">Xác Nhận</button>
        </form>
    </div>
</div>
<jsp:include page="/page/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function redirectToLogin() {
        // Redirect trực tiếp đến trang đăng nhập
        window.location.href = '${pageContext.request.contextPath}/page/login.jsp';
    }

    const productUrl = window.location.href;
    const productTitle = "${product.productName}";
    const productImage = "${not empty product.images ? product.images[0].imageUrl : ''}";
    const productPrice = "${formatter.format(product.finalPrice)} ₫";
    const productDescription = "Xem chi tiết sản phẩm ${product.productName} với giá ${formatter.format(product.finalPrice)} ₫";

    function shareOnFacebook() {
        const facebookUrl = 'https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(productUrl);
        window.open(facebookUrl, 'facebook-share', 'width=600,height=400');
    }

    function shareOnMessenger() {
        const messengerUrl = 'fb-messenger://share?link=' + encodeURIComponent(productUrl);
        if (!/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
            alert('Messenger chỉ khả dụng trên thiết bị di động. Bạn có thể copy link để chia sẻ: ' + productUrl);
            navigator.clipboard.writeText(productUrl).then(() => {
                console.log('Link đã được copy!');
            });
        } else {
            window.location.href = messengerUrl;
        }
    }

    function shareOnTwitter() {
        const twitterText = productTitle + ' - ' + productPrice;
        const twitterUrl = 'https://twitter.com/intent/tweet?text=' + encodeURIComponent(twitterText) +
            '&url=' + encodeURIComponent(productUrl);
        window.open(twitterUrl, 'twitter-share', 'width=600,height=400');
    }

    function shareOnPinterest() {
        const fullImageUrl = window.location.origin + '${pageContext.request.contextPath}' + productImage;
        const pinterestUrl = 'https://pinterest.com/pin/create/button/?url=' + encodeURIComponent(productUrl) +
            '&media=' + encodeURIComponent(fullImageUrl) +
            '&description=' + encodeURIComponent(productDescription);
        window.open(pinterestUrl, 'pinterest-share', 'width=750,height=550');
    }

    window.addToCartClick = function (btn) {
        const form = btn.closest('form');
        const productId = form.querySelector('input[name="productId"]').value;
        const qtyInput = document.getElementById('qty');
        const quantity = qtyInput ? qtyInput.value : (form.querySelector('input[name="quantity"]') ? form.querySelector('input[name="quantity"]').value : 1);
        let productImg = document.querySelector('#displayImg');
        if (!productImg) {
            productImg = document.querySelector('.main-image-wrapper img');
        }
        console.log('addToCartClick:', productId, quantity, productImg);
        if (typeof globallyHandleAddToCart === 'function') {
            if (productImg) {
                globallyHandleAddToCart(productId, quantity, productImg, btn);
            } else {
                console.warn('Product image not found for animation');
                globallyHandleAddToCart(productId, quantity, null, btn);
            }
        } else {
            console.error('globallyHandleAddToCart not defined');
            alert('Lỗi: Dữ liệu chưa tải xong. Vui lòng thử lại sau 1 giây.');
        }
    };
    document.addEventListener('DOMContentLoaded', () => {
        const contextPath = '${pageContext.request.contextPath}';
        const thumbs = document.querySelectorAll('.thumb');
        const displayImg = document.getElementById('displayImg');
        let currentIndex = 0;

        function updateMainImage(index) {
            thumbs.forEach(t => t.classList.remove('active'));
            thumbs[index].classList.add('active');
            displayImg.src = thumbs[index].src;
        }

        thumbs.forEach((thumb, idx) => {
            thumb.addEventListener('click', () => {
                currentIndex = idx;
                updateMainImage(currentIndex);
            });
        });

        function changeImage(url) {
            displayImg.src = url;
            thumbs.forEach(t => {
                if (t.src.includes(url)) t.classList.add('active');
                else t.classList.remove('active');
            });
        }

        window.changeImage = changeImage;
        const prevBtn = document.querySelector('.prev-btn');
        const nextBtn = document.querySelector('.next-btn');
        if (prevBtn) {
            prevBtn.addEventListener('click', () => {
                currentIndex = (currentIndex - 1 + thumbs.length) % thumbs.length;
                updateMainImage(currentIndex);
            });
        }
        if (nextBtn) {
            nextBtn.addEventListener('click', () => {
                currentIndex = (currentIndex + 1) % thumbs.length;
                updateMainImage(currentIndex);
            });
        }
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
                fetch(contextPath + '/wishlist', {
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
                            // Redirect trực tiếp đến trang đăng nhập
                            window.location.href = contextPath + '/page/login.jsp';
                        } else {
                            showNotification(data.message || 'Thêm vào yêu thích thất bại', 'error');
                        }
                    })
                    .catch(err => {
                        console.error('Error:', err);
                        showNotification('Lỗi kết nối server', 'error');
                    });
            });
        });
        const infoBtn = document.getElementById("infoBtn");
        const specBtn = document.getElementById("specBtn");
        const infoTab = document.getElementById("infoTab");
        const specTab = document.getElementById("specTab");
        if (infoBtn && specBtn) {
            infoBtn.addEventListener("click", () => {
                infoBtn.classList.add("active");
                specBtn.classList.remove("active");
                infoTab.classList.remove("d-none");
                specTab.classList.add("d-none");
            });
            specBtn.addEventListener("click", () => {
                specBtn.classList.add("active");
                infoBtn.classList.remove("active");
                specTab.classList.remove("d-none");
                infoTab.classList.add("d-none");
            });
        }
        const filterButtons = document.querySelectorAll('.filter-btn');
        const reviews = document.querySelectorAll('.review');
        filterButtons.forEach(button => {
            button.addEventListener('click', () => {
                filterButtons.forEach(btn => btn.classList.remove('active'));
                button.classList.add('active');
                const star = button.getAttribute('data-star');
                const filter = button.getAttribute('data-filter');
                reviews.forEach(review => {
                    if (filter === 'comment') {
                        // Lọc theo có bình luận
                        if (review.getAttribute('data-comment') === 'true') {
                            review.style.display = 'flex';
                        } else {
                            review.style.display = 'none';
                        }
                    } else if (star === 'all') {
                        review.style.display = 'flex';
                    } else if (review.getAttribute('data-star') === star) {
                        review.style.display = 'flex';
                    } else {
                        review.style.display = 'none';
                    }
                });
            });
        });
        const khung = document.querySelector('.khung-san-pham');
        const prevBtnCarousel = document.querySelector('.nut-chuyen.prev');
        const nextBtnCarousel = document.querySelector('.nut-chuyen.next');
        if (khung && nextBtnCarousel) {
            nextBtnCarousel.addEventListener('click', () => {
                khung.scrollBy({left: 300, behavior: 'smooth'});
            });
        }
        if (khung && prevBtnCarousel) {
            prevBtnCarousel.addEventListener('click', () => {
                khung.scrollBy({left: -300, behavior: 'smooth'});
            });
        }
        const minusBtn = document.getElementById('minus');
        const plusBtn = document.getElementById('plus');
        const qtyInput = document.getElementById('qty');
        const quantityHidden = document.getElementById('quantityHidden');
        const buyNowQuantity = document.getElementById('buyNowQuantity');
        if (minusBtn && plusBtn) {
            minusBtn.addEventListener('click', () => {
                let val = parseInt(qtyInput.value);
                if (val > 1) {
                    qtyInput.value = val - 1;
                    quantityHidden.value = qtyInput.value;
                    buyNowQuantity.value = qtyInput.value;
                }
            });
            plusBtn.addEventListener('click', () => {
                let val = parseInt(qtyInput.value);
                qtyInput.value = val + 1;
                quantityHidden.value = qtyInput.value;
                buyNowQuantity.value = qtyInput.value;
            });
            buyNowQuantity.value = qtyInput.value;
        }
    });
    document.querySelectorAll('.nut-mua-ngay').forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            const form = btn.closest('form');
            if (!form) return;
            const productId = form.querySelector('input[name="productId"]').value;
            const quantity = form.querySelector('input[name="quantity"]').value || 1;
            const productCard = btn.closest('.san-pham');
            const productImg = productCard.querySelector('img');
            if (typeof globallyHandleAddToCart === 'function') {
                globallyHandleAddToCart(productId, quantity, productImg, btn);
            } else {
                console.error('globallyHandleAddToCart not defined');
                form.submit();
            }
        });
    });
    const reviewPopup = document.getElementById('reviewPopup');
    const closeBtn = document.querySelector('.close-review-popup');
    const allWriteReviewBtns = document.querySelectorAll('.write-review-btn');
    allWriteReviewBtns.forEach(btn => {
        btn.addEventListener('click', (e) => {
            if (!btn.disabled) {
                reviewPopup.style.display = 'flex';
                setTimeout(() => {
                    reviewPopup.classList.add('active');
                }, 10);
            }
        });
    });
    if (closeBtn) {
        closeBtn.addEventListener('click', () => {
            reviewPopup.classList.remove('active');
            setTimeout(() => {
                reviewPopup.style.display = 'none';
            }, 300);
        });
    }
    window.addEventListener('click', (e) => {
        if (e.target === reviewPopup) {
            reviewPopup.classList.remove('active');
            setTimeout(() => {
                reviewPopup.style.display = 'none';
            }, 300);
        }
    });
    const reviewForm = document.getElementById('reviewForm');
    if (reviewForm) {
        reviewForm.addEventListener('submit', function (e) {
            e.preventDefault();
            const productId = reviewForm.querySelector('input[name="product_id"]').value;
            const rating = reviewForm.querySelector('input[name="rating"]:checked')?.value;
            const content = reviewForm.querySelector('textarea[name="content"]').value;
            const contextPath = '<%=request.getContextPath()%>';
            if (!rating) {
                showNotification('Vui lòng chọn số sao đánh giá', 'error');
                return;
            }
            const params = new URLSearchParams({
                product_id: productId,
                rating: rating,
                content: content
            });
            fetch(contextPath + '/ReviewServlet', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: params
            })
                .then(res => res.json())
                .then(data => {
                    if (data.status === 'success') {
                        reviewPopup.classList.remove('active');
                        setTimeout(() => {
                            reviewPopup.style.display = 'none';
                        }, 300);
                        showNotification(data.message, 'success');
                        setTimeout(() => {
                            location.reload();
                        }, 1000);
                    } else {
                        showNotification(data.message, 'error');
                        if (data.status === 'login_required') {
                            setTimeout(() => {
                                window.location.href = contextPath + '/page/login.jsp';
                            }, 2000);
                        }
                    }
                })
                .catch(err => {
                    console.error('Error:', err);
                    showNotification('Lỗi kết nối server', 'error');
                });
        });
    }
</script>
</body>
</html>