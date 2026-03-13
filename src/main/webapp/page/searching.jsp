<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Tìm kiếm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/searching.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
          rel="stylesheet">
</head>
<body>
<jsp:include page="/page/header-common.jsp"/>
<section class="phan-san-pham">
    <h2 class="tieu-de-muc">Kết quả tìm kiếm: "${keyword}"</h2>
    <p class="so-luong-tim">
        Đã tìm được ${fn:length(products)} sản phẩm
    </p>
    <c:if test="${empty products}">
        <p>Không tìm thấy sản phẩm nào.</p>
    </c:if>
    <form action="<c:url value='/Searching' />" method="get" id="filterForm">
        <input type="hidden" name="keyword" value="${keyword}">
        <div class="bo-loc-va-sap-xep position-relative">
            <button type="button" class="nut-bo-loc btn btn-outline-primary">
                <i class="bi bi-funnel"></i> Bộ lọc
            </button>
            <div class="hop-loc" id="hop-loc">
                <h6><i class="bi bi-funnel"></i> Lọc theo giá</h6>
                <hr class="my-2">
                <div class="danh-sach-loc">
                    <label>
                        <input type="radio" name="chon-gia" value="tat-ca" <c:if
                                test="${param['chon-gia'] == 'tat-ca'}">checked</c:if>>
                        Tất cả
                    </label>
                    <label>
                        <input type="radio" name="chon-gia" value="duoi-5000000" <c:if
                                test="${param['chon-gia'] == 'duoi-5000000'}">checked</c:if>>
                        Dưới 5.000.000 ₫
                    </label>
                    <label>
                        <input type="radio" name="chon-gia" value="5-10" <c:if
                                test="${param['chon-gia'] == '5-10'}">checked</c:if>>
                        5.000.000 ₫ - 10.000.000 ₫
                    </label>
                    <label>
                        <input type="radio" name="chon-gia" value="10-20" <c:if
                                test="${param['chon-gia'] == '10-20'}">checked</c:if>>
                        10.000.000 ₫ - 20.000.000 ₫
                    </label>
                    <label>
                        <input type="radio" name="chon-gia" value="tren-20" <c:if
                                test="${param['chon-gia'] == 'tren-20'}">checked</c:if>>
                        Trên 20.000.000 ₫
                    </label>
                    <p><b>Nhập vào khoảng giá bạn muốn</b></p>
                    <div class="d-flex align-items-center gap-1">
                        <input type="number" name="gia-tu" id="gia-tu"
                               class="form-control form-control-sm" value="${param['gia-tu']}"
                               placeholder="Từ ₫" style="width: 100px;">
                        <span>-</span>
                        <input type="number" name="gia-den" id="gia-den"
                               class="form-control form-control-sm" value="${param['gia-den']}"
                               placeholder="Đến ₫" style="width: 100px;">
                    </div>
                    <hr class="my-2">
                    <h6><i class="bi bi-box"></i> Lọc theo thương hiệu</h6>
                    <hr class="my-2">
                    <div class="row mt-2">
                        <div class="col-6">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="chon-thuong-hieu"
                                       value="DJI" <c:if
                                               test="${fn:contains(paramValues['chon-thuong-hieu'], 'DJI')}">checked
                                </c:if>>
                                <label class="form-check-label">DJI</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="chon-thuong-hieu"
                                       value="Autel Robotics" <c:if
                                               test="${fn:contains(paramValues['chon-thuong-hieu'], 'Autel Robotics')}">checked
                                </c:if>>
                                <label class="form-check-label">Autel Robotics</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="chon-thuong-hieu"
                                       value="Parrot" <c:if
                                               test="${fn:contains(paramValues['chon-thuong-hieu'], 'Parrot')}">checked
                                </c:if>>
                                <label class="form-check-label">Parrot</label>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="chon-thuong-hieu"
                                       value="Skydio" <c:if
                                               test="${fn:contains(paramValues['chon-thuong-hieu'], 'Skydio')}">checked
                                </c:if>>
                                <label class="form-check-label">Skydio</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="chon-thuong-hieu"
                                       value="Xiaomi" <c:if
                                               test="${fn:contains(paramValues['chon-thuong-hieu'], 'Xiaomi')}">checked
                                </c:if>>
                                <label class="form-check-label">Xiaomi</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="chon-thuong-hieu"
                                       value="Khác" <c:if
                                               test="${fn:contains(paramValues['chon-thuong-hieu'], 'Khác')}">checked
                                </c:if>>
                                <label class="form-check-label">Khác</label>
                            </div>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-sm btn-primary mt-2">Áp dụng</button>
                </div>
            </div>
            <div class="sap-xep-theo">
                <span class="label">Sắp xếp theo:</span>
                <button type="submit" name="sort" value="default"
                        class="btn-sap-xep ${param.sort == 'default' || param.sort == null ? 'active' : ''}">
                    Nổi bật
                </button>
                <button type="submit" name="sort" value="low-high"
                        class="btn-sap-xep ${param.sort == 'low-high' ? 'active' : ''}">
                    <i class="bi bi-filter"></i> Giá Thấp - Cao
                </button>
                <button type="submit" name="sort" value="high-low"
                        class="btn-sap-xep ${param.sort == 'high-low' ? 'active' : ''}">
                    <i class="bi bi-filter"></i> Giá Cao - Thấp
                </button>
            </div>
        </div>
    </form>
    <div class="khung-san-pham">
        <c:forEach var="p" items="${products}">
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
<jsp:include page="/page/footer.jsp"/>
<script>
    const nutBoLoc = document.querySelector('.nut-bo-loc');
    const hopLoc = document.getElementById('hop-loc');
    const radioLocGia = document.getElementsByName('chon-gia');
    const inputTu = document.getElementById('gia-tu');
    const inputDen = document.getElementById('gia-den');
    const btnApDung = document.getElementById('btn-ap-dung-gia');
    nutBoLoc.addEventListener('click', () => {
        hopLoc.classList.toggle('hien');
    });
    // Ẩn khi click ra ngoài
    document.addEventListener('click', (e) => {
        if (!hopLoc.contains(e.target) && !nutBoLoc.contains(e.target)) {
            hopLoc.classList.remove('hien');
        }
    });
    inputTu.addEventListener('input', () => {
        radioLocGia.forEach(r => r.checked = false);
    });
    inputDen.addEventListener('input', () => {
        radioLocGia.forEach(r => r.checked = false);
    });
    // Khi nhấn Áp dụng -> gửi form
    btnApDung.addEventListener('click', () => {
        document.getElementById('filterForm').submit();
    });
    inputTu.addEventListener('input', () => {
        document.querySelectorAll("input[name='chon-gia']").forEach(r => r.checked = false);
    });
    inputDen.addEventListener('input', () => {
        document.querySelectorAll("input[name='chon-gia']").forEach(r => r.checked = false);
    });
</script>
<script>
    document.querySelectorAll('.tim-yeu-thich').forEach(tim => {
        tim.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            // Kiểm tra đăng nhập
            <c:if test="${empty sessionScope.user}">
            // Redirect trực tiếp đến trang đăng nhập
            window.location.href = '${pageContext.request.contextPath}/page/login.jsp';
            return;
            </c:if>
            const productId = this.getAttribute('data-product-id');
            const isLiked = this.classList.contains('yeu-thich');
            const action = isLiked ? 'remove' : 'add';
            console.log('Action:', action, 'Product ID:', productId);
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
                .then(res => {
                    if (res.status === 401) {
                        window.location.href = '${pageContext.request.contextPath}/Login';
                        return;
                    }
                    if (!res.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return res.json();
                })
                .then(data => {
                    console.log('Response:', data);
                    if (data.success) {
                        if (isLiked) {
                            this.classList.remove('bi-heart-fill', 'yeu-thich');
                            this.classList.add('bi-heart');
                        } else {
                            this.classList.remove('bi-heart');
                            this.classList.add('bi-heart-fill', 'yeu-thich');
                        }
                    } else {
                        alert(data.message || 'Có lỗi xảy ra');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Không thể kết nối đến server');
                });
        });
    });
</script>
<script>
    function showNotification(message, type = 'success') {
        const oldNotification = document.querySelector('.custom-notification');
        if (oldNotification) {
            oldNotification.remove();
        }
        const notification = document.createElement('div');
        notification.className = 'custom-notification';
        let icon = '';
        if (type === 'success') {
            icon = '<i class="bi bi-check-circle-fill me-2"></i>';
        } else {
            icon = '<i class="bi bi-exclamation-circle-fill me-2"></i>';
        }
        notification.innerHTML = icon + message;
        notification.style.position = 'fixed';
        notification.style.top = '80px';
        notification.style.right = '-300px';
        notification.style.padding = '12px 20px';
        notification.style.borderRadius = '8px';
        notification.style.zIndex = '10000';
        notification.style.fontWeight = '500';
        notification.style.boxShadow = '0 4px 12px rgba(0,0,0,0.2)';
        notification.style.transition = 'right 0.3s ease';
        notification.style.display = 'flex';
        notification.style.alignItems = 'center';
        notification.style.minWidth = '250px';
        if (type === 'success') {
            notification.style.backgroundColor = '#28a745';
            notification.style.color = 'white';
        } else {
            notification.style.backgroundColor = '#dc3545';
            notification.style.color = 'white';
        }
        document.body.appendChild(notification);
        setTimeout(() => {
            notification.style.right = '20px';
        }, 10);
        setTimeout(() => {
            notification.style.right = '-300px';
        }, 2500);
        setTimeout(() => {
            notification.remove();
        }, 3000);
    }

    function updateCartBadge(newCount) {
        const cartBadge = document.querySelector(
            '.cart-badge, .badge, ' +
            '.bi-cart + .badge, .bi-cart2 + .badge, .bi-cart3 + .badge, ' +
            '.bi-bag + .badge, [class*="cart"] .badge'
        );
        if (cartBadge) {
            if (newCount !== undefined) {
                cartBadge.textContent = newCount;
            } else {
                const currentCount = parseInt(cartBadge.textContent) || 0;
                cartBadge.textContent = currentCount + 1;
            }
            cartBadge.style.transition = 'transform 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55)';
            cartBadge.style.transform = 'scale(1.5)';
            setTimeout(() => {
                cartBadge.style.transform = 'scale(1)';
            }, 300);
        }
    }

    document.addEventListener('DOMContentLoaded', () => {
        const style = document.createElement('style');
        style.textContent = `
            @keyframes cartShake {
                0%, 100% { transform: translateX(0); }
                10%, 30%, 50%, 70%, 90% { transform: translateX(-4px); }
                20%, 40%, 60%, 80% { transform: translateX(4px); }
            }
            .cart-shaking {
                animation: cartShake 0.5s ease !important;
                display: inline-block !important;
            }
        `;
        document.head.appendChild(style);
        document.querySelectorAll('.nut-mua-ngay').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                const form = btn.closest('form');
                const productId = form.querySelector('input[name="productId"]').value;
                const quantity = form.querySelector('input[name="quantity"]').value;
                const productCard = btn.closest('.san-pham');
                const productImg = productCard.querySelector('.khung-anh img');
                if (!productImg) {
                    console.error('Không tìm thấy ảnh sản phẩm');
                    return;
                }
                const flyingImg = productImg.cloneNode(true);
                flyingImg.style.position = 'fixed';
                flyingImg.style.zIndex = '9999';
                flyingImg.style.width = '100px';
                flyingImg.style.height = '100px';
                flyingImg.style.objectFit = 'cover';
                flyingImg.style.transition = 'all 1.0s ease-in-out'; // Slightly faster for list view
                flyingImg.style.pointerEvents = 'none';
                flyingImg.style.borderRadius = '50%';
                flyingImg.style.boxShadow = '0 10px 25px rgba(0,0,0,0.3)';
                flyingImg.style.border = '2px solid white';
                const imgRect = productImg.getBoundingClientRect();
                flyingImg.style.left = imgRect.left + 'px';
                flyingImg.style.top = imgRect.top + 'px';
                document.body.appendChild(flyingImg);
                // Tìm vị trí icon giỏ hàng trong header để ảnh bay đến
                let cartIcon = document.querySelector('a[href*="shoppingcart"] i, a[href*="cart"] i');
                // Nếu không tìm thấy, thử tìm theo class icon
                if (!cartIcon) {
                    cartIcon = document.querySelector(
                        '.bi-cart, .bi-cart2, .bi-cart3, .bi-cart-plus, ' +
                        '.bi-bag, .bi-bag-fill, .bi-basket, .bi-basket-fill'
                    );
                }
                // Nếu vẫn không tìm thấy, thử tìm thẻ a chứa cart
                if (!cartIcon) {
                    const cartLink = document.querySelector('a[href*="cart"], a[href*="shoppingcart"]');
                    if (cartLink) {
                        cartIcon = cartLink.querySelector('i') || cartLink;
                    }
                }
                let cartButton = null;
                // Cách 1: Tìm theo href
                cartButton = document.querySelector('a[href*="shoppingcart"], a[href*="cart"], a[href*="gio-hang"]');
                // Cách 2: Nếu không có, tìm thẻ cha của icon
                if (!cartButton && cartIcon) {
                    cartButton = cartIcon.closest('a') || cartIcon.closest('button') || cartIcon.closest('[class*="cart"]');
                }
                // Cách 3: Tìm parent có class chứa 'cart'
                if (!cartButton) {
                    cartButton = document.querySelector('[class*="cart-"]');
                }
                setTimeout(() => {
                    let targetX = window.innerWidth - 50; // Default fallback: top right
                    let targetY = 20;
                    if (cartIcon) {
                        const cartRect = cartIcon.getBoundingClientRect();
                        targetX = cartRect.left;
                        targetY = cartRect.top;
                    }
                    flyingImg.style.left = targetX + 'px';
                    flyingImg.style.top = targetY + 'px';
                    flyingImg.style.width = '20px';
                    flyingImg.style.height = '20px';
                    flyingImg.style.opacity = '0';
                    flyingImg.style.transform = 'scale(0.1)';
                }, 10);
                setTimeout(() => {
                    flyingImg.remove();
                }, 1100);
                const fetchUrl = '${pageContext.request.contextPath}/add-cart?productId=' + productId + '&quantity=' + quantity;
                fetch(fetchUrl, {
                    method: 'GET',
                    headers: {'X-Requested-With': 'XMLHttpRequest'}
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            showNotification('Đã thêm vào giỏ hàng!', 'success');
                            if (data.cartSize) updateCartBadge(data.cartSize);
                            else updateCartBadge();
                            // Hiệu ứng rung NHẸ NHÀNG cho NÚT giỏ hàng
                            if (cartButton) {
                                console.log('Applying shake to button');
                                cartButton.classList.add('cart-shaking');
                                setTimeout(() => {
                                    cartButton.classList.remove('cart-shaking');
                                }, 500);
                            } else if (cartIcon) {
                                console.log('Applying shake to icon only');
                                cartIcon.classList.add('cart-shaking');
                                setTimeout(() => {
                                    cartIcon.classList.remove('cart-shaking');
                                }, 500);
                            }
                        } else {
                            showNotification('Thêm vào giỏ hàng thất bại', 'error');
                        }
                    })
                    .catch(err => {
                        console.error(err);
                        showNotification('Lỗi kết nối server', 'error');
                    });
            });
        });
    });
</script>
</body>
</html>