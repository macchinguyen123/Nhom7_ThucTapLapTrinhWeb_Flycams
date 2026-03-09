<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<meta charset="UTF-8">
<title>SkyDrone Header</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/header.css?v=2">
<c:set var="currentPage" value="${pageContext.request.requestURI}"/>
<div class="header-bg">
    <div class="header-wrapper">
        <header class="top-header">
            <a href="${pageContext.request.contextPath}/home">
                <div class="logo">
                    <img src="${pageContext.request.contextPath}/image/logoo2.png" alt="Logo">
                    <h2>SkyDrone</h2>
                </div>
            </a>
            <form action="${pageContext.request.contextPath}/Searching" method="get"
                  class="search-bar position-relative">
                <i class="bi bi-search" id="searchBtn" style="cursor: pointer;"></i>
                <input id="searchInput" name="keyword" type="text" placeholder="Tìm kiếm drone, flycam..."
                       autocomplete="off" value="${keyword != null ? keyword : ''}">
                <ul id="suggestList" class="list-group position-absolute w-100 shadow-sm"
                    style="top: 100%; left: 0; z-index: 1000; display: none;">
                </ul>
            </form>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/wishlist">
                    <div class="icon-btn ${currentPage.contains('/wishlist') ? 'active' : ''}"
                         title="Yêu thích">
                        <div class="icon-wrapper">
                            <i class="bi bi-heart"></i>
                        </div>
                        <span>Yêu thích</span>
                    </div>
                </a>
                <a href="${pageContext.request.contextPath}/page/shoppingcart.jsp">
                    <div class="icon-btn ${currentPage.contains('shoppingcart') ? 'active' : ''}"
                         title="Giỏ hàng">
                        <div class="icon-wrapper">
                            <i class="bi bi-cart3"></i>
                            <span class="cart-badge badge rounded-pill bg-danger" id="cartBadge"
                                  style="${(empty cart or cart.totalQuantity() == 0) ? 'display: none !important;' : 'display: flex !important;'}">
                                ${not empty cart ? cart.totalQuantity() : '0'}
                            </span>
                        </div>
                        <span>Giỏ hàng</span>
                    </div>
                </a>
                <a href="${pageContext.request.contextPath}/personal">
                    <div class="icon-btn ${currentPage.contains('/personal') ? 'active' : ''}"
                         title="${not empty user ? user.username : 'Tài khoản'}">
                        <div class="icon-wrapper">
                            <i class="bi bi-person-circle"></i>
                        </div>
                        <span>${not empty user ? user.username : 'Tài khoản'}</span>
                    </div>
                </a>
            </div>
        </header>
    </div>
</div>
<div class="menu-bg">
    <div class="header-wrapper">
        <nav class="main-nav">
            <a href="${pageContext.request.contextPath}/home">
                <button class="nav-item ${currentPage.endsWith('homepage.jsp') ? 'active' : ''}">
                    <i class="bi bi-house-door"></i>Trang chủ
                </button>
            </a>
            <button class="nav-item ${currentPage.contains('/category') ? 'active' : ''}" id="btnDanhMuc">
                <i class="bi bi-grid"></i>Danh mục<i class="bi bi-caret-down-fill ms-1"></i>
            </button>
            <a href="${pageContext.request.contextPath}/promotion">
                <button class="nav-item ${currentPage.endsWith('promotion.jsp') ? 'active' : ''}">
                    <i class="bi bi-gift"></i>Khuyến mãi
                </button>
            </a>
            <a href="${pageContext.request.contextPath}/page/warranty.jsp">
                <button class="nav-item ${currentPage.endsWith('warranty.jsp') ? 'active' : ''}">
                    <i class="bi bi-tools"></i>Bảo hành
                </button>
            </a>
            <a href="${pageContext.request.contextPath}/page/payment-policy.jsp">
                <button class="nav-item ${currentPage.endsWith('payment-policy.jsp') ? 'active' : ''}">
                    <i class="bi bi-credit-card"></i>Thanh toán
                </button>
            </a>
            <a href="${pageContext.request.contextPath}/page/support.jsp">
                <button class="nav-item ${currentPage.endsWith('support.jsp') ? 'active' : ''}">
                    <i class="bi bi-headset"></i>Hỗ trợ
                </button>
            </a>
            <a href="${pageContext.request.contextPath}/blog">
                <button class="nav-item ${currentPage.contains('/blog') ? 'active' : ''}">
                    <i class="bi bi-journal-text"></i>Bài viết
                </button>
            </a>
            <c:if test="${not empty user and user.roleId == 1}">
                <a href="${pageContext.request.contextPath}/admin/dashboard">
                    <button class="nav-item ${currentPage.contains('/admin') ? 'active' : ''}">
                        <i class="bi bi-shield-lock"></i>Quản lý Admin
                    </button>
                </a>
            </c:if>
        </nav>
    </div>
    <div class="menu-left-1" id="menuLeft">
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
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const btnDanhMuc = document.getElementById('btnDanhMuc');
    const menuLeft = document.getElementById('menuLeft');
    btnDanhMuc.addEventListener('click', () => {
        menuLeft.classList.toggle('show');
    });
    //ẩn menu khi click ra ngoài
    document.addEventListener('click', (e) => {
        if (!menuLeft.contains(e.target) && !btnDanhMuc.contains(e.target)) {
            menuLeft.classList.remove('show');
        }
    });
</script>
<script>
    const contextPath = '${pageContext.request.contextPath}';
    const searchInput = document.getElementById("searchInput");
    const suggestList = document.getElementById("suggestList");
    let debounceTimer = null;
    //QUẢN LÝ LỊCH SỬ TÌM KIẾM
    const SearchHistory = {
        maxItems: 10,
        storageKey: 'skydrone_search_history',
        get: function () {
            try {
                const history = localStorage.getItem(this.storageKey);
                return history ? JSON.parse(history) : [];
            } catch (e) {
                return [];
            }
        },
        save: function (history) {
            try {
                localStorage.setItem(this.storageKey, JSON.stringify(history));
            } catch (e) {
                console.error('Không thể lưu lịch sử tìm kiếm', e);
            }
        },
        add: function (keyword) {
            keyword = keyword.trim();
            if (!keyword) return;
            let history = this.get();
            history = history.filter(function (item) {
                return item.toLowerCase() !== keyword.toLowerCase();
            });
            history.unshift(keyword);
            if (history.length > this.maxItems) {
                history = history.slice(0, this.maxItems);
            }
            this.save(history);
        },
        remove: function (keyword) {
            let history = this.get();
            history = history.filter(function (item) {
                return item !== keyword;
            });
            this.save(history);
        },
        clear: function () {
            localStorage.removeItem(this.storageKey);
        }
    };
    searchInput.addEventListener("input", function () {
        triggerSuggest();
    });

    searchInput.addEventListener("focus", function () {
        const keyword = searchInput.value.trim();
        if (keyword === "") {
            showSearchHistory();
        } else {
            triggerSuggest();
        }
    });

    //HIỂN THỊ LỊCH SỬ TÌM KIẾM
    function showSearchHistory() {
        const history = SearchHistory.get();
        if (history.length === 0) {
            suggestList.style.display = "none";
            return;
        }
        suggestList.innerHTML = "";
        const header = document.createElement("div");
        header.className = "suggest-header";
        header.innerHTML = '<span>Lịch sử tìm kiếm</span><span class="clear-history" onclick="clearAllHistory()">Xóa tất cả</span>';
        suggestList.appendChild(header);
        history.forEach(function (keyword) {
            const li = document.createElement("li");
            li.className = "list-group-item list-group-item-action history-item";
            li.innerHTML = '<span style="flex: 1;">' + escapeHtml(keyword) + '</span><i class="bi bi-x-lg delete-history-item" onclick="deleteHistoryItem(event, \'' + escapeHtml(keyword) + '\')"></i>';
            li.onclick = function (e) {
                if (!e.target.classList.contains('delete-history-item')) {
                    searchInput.value = keyword;
                    SearchHistory.add(keyword);
                    searchInput.form.submit();
                }
            };
            suggestList.appendChild(li);
        });
        suggestList.style.display = "block";
    }

    //TÌM KIẾM VÀ GỢI Ý
    function triggerSuggest() {
        const keyword = searchInput.value.trim();
        if (keyword.length === 0) {
            showSearchHistory();
            return;
        }
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(function () {
            fetch(contextPath + "/search-suggestion?keyword=" + encodeURIComponent(keyword))
                .then(function (res) {
                    if (!res.ok) throw new Error('Network response was not ok');
                    return res.json();
                })
                .then(function (data) {
                    console.log('Received suggestions:', data);
                    displaySuggestions(data, keyword);
                })
                .catch(function (err) {
                    console.error('Lỗi khi tìm kiếm:', err);
                    suggestList.innerHTML = '<div class="suggest-empty">Không thể tải gợi ý</div>';
                    suggestList.style.display = "block";
                });
        }, 200);
    }

    //HIỂN THỊ GỢI Ý
    function displaySuggestions(data, keyword) {
        suggestList.innerHTML = "";
        const history = SearchHistory.get();
        const hasHistory = history.length > 0;
        const hasSuggestions = data && data.length > 0;
        console.log('Display suggestions - hasHistory:', hasHistory, 'hasSuggestions:', hasSuggestions); // ✅ Debug
        if (!hasHistory && !hasSuggestions) {
            suggestList.innerHTML = '<div class="suggest-empty">Không tìm thấy kết quả</div>';
            suggestList.style.display = "block";
            return;
        }
        if (hasHistory) {
            const relatedHistory = history.filter(function (item) {
                return item.toLowerCase().includes(keyword.toLowerCase());
            });
            if (relatedHistory.length > 0) {
                const historyHeader = document.createElement("div");
                historyHeader.className = "suggest-header";
                historyHeader.innerHTML = '<span>Lịch sử tìm kiếm</span>';
                suggestList.appendChild(historyHeader);
                relatedHistory.slice(0, 3).forEach(function (item) {
                    const li = document.createElement("li");
                    li.className = "list-group-item list-group-item-action history-item";
                    li.innerHTML = '<span style="flex: 1;">' + highlightKeyword(item, keyword) + '</span><i class="bi bi-x-lg delete-history-item" onclick="deleteHistoryItem(event, \'' + escapeHtml(item) + '\')"></i>';
                    li.onclick = function (e) {
                        if (!e.target.classList.contains('delete-history-item')) {
                            searchInput.value = item;
                            SearchHistory.add(item);
                            searchInput.form.submit();
                        }
                    };
                    suggestList.appendChild(li);
                });
                if (hasSuggestions) {
                    const divider = document.createElement("div");
                    divider.className = "suggest-divider";
                    suggestList.appendChild(divider);
                }
            }
        }
        if (hasSuggestions) {
            const suggestionHeader = document.createElement("div");
            suggestionHeader.className = "suggest-header";
            suggestionHeader.innerHTML = '<span>Gợi ý sản phẩm</span>';
            suggestList.appendChild(suggestionHeader);
            data.forEach(function (item) {
                const li = document.createElement("li");
                li.className = "list-group-item list-group-item-action search-item";
                li.innerHTML = highlightKeyword(item.name, keyword);
                li.onclick = function () {
                    SearchHistory.add(item.name);
                    window.location.href = contextPath + "/product-detail?id=" + item.id;
                };
                suggestList.appendChild(li);
            });
        }
        suggestList.style.display = "block";
    }

    //XÓA LỊCH SỬ
    function deleteHistoryItem(event, keyword) {
        event.stopPropagation();
        SearchHistory.remove(keyword);
        if (searchInput.value.trim() === "") {
            showSearchHistory();
        } else {
            triggerSuggest();
        }
    }

    function clearAllHistory() {
        if (confirm('Bạn có chắc muốn xóa toàn bộ lịch sử tìm kiếm?')) {
            SearchHistory.clear();
            showSearchHistory();
        }
    }

    //LƯU LỊCH SỬ KHI SUBMIT
    searchInput.form.addEventListener('submit', function (e) {
        const keyword = searchInput.value.trim();
        if (keyword) {
            SearchHistory.add(keyword);
        }
    });
    //ẨN SUGGEST KHI CLICK RA NGOÀI
    document.addEventListener("click", function (e) {
        if (!e.target.closest(".search-bar")) {
            suggestList.style.display = "none";
        }
    });

    function escapeHtml(text) {
        const div = document.createElement("div");
        div.textContent = text;
        return div.innerHTML;
    }

    function highlightKeyword(text, keyword) {
        if (!keyword) return escapeHtml(text);
        const escapedKeyword = keyword.replace(/[.*+?^$()|[\]\\]/g, "\\$&");
        try {
            const regex = new RegExp("(" + escapedKeyword + ")", "gi");
            return escapeHtml(text).replace(regex, "<strong>$1</strong>");
        } catch (e) {
            console.error("Highlight error:", e);
            return escapeHtml(text);
        }
    }

    //CẬP NHẬT BADGE GIỎ HÀNG TOÀN CỤC
    function updateCartBadge(newCount) {
        const cartBadge = document.getElementById('cartBadge');
        if (cartBadge) {
            let count = 0;
            if (newCount !== undefined) {
                count = parseInt(newCount);
            } else {
                count = (parseInt(cartBadge.textContent.trim()) || 0) + 1;
            }
            //cập nhật nội dung số lượng
            cartBadge.textContent = count;
            if (count > 0) {
                cartBadge.style.setProperty('display', 'flex', 'important');
            } else {
                cartBadge.style.setProperty('display', 'none', 'important');
            }
            //hiệu ứng scale khi cập nhật
            cartBadge.style.transition = 'transform 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55)';
            cartBadge.style.transform = 'scale(1.5)';
            setTimeout(() => {
                cartBadge.style.transform = 'scale(1)';
            }, 300);
            //hiệu ứng rung icon giỏ hàng
            const cartBtn = cartBadge.closest('.icon-btn') || cartBadge.closest('a') || cartBadge.closest('.icon-wrapper');
            if (cartBtn) {
                cartBtn.classList.add('cart-shaking');
                setTimeout(() => {
                    cartBtn.classList.remove('cart-shaking');
                }, 500);
            }
        }
    }

    //HIỂN THỊ THÔNG BÁO CUSTOM
    function showNotification(message, type = 'success') {
        const oldNotification = document.querySelector('.custom-notification');
        if (oldNotification) oldNotification.remove();
        const notification = document.createElement('div');
        notification.className = 'custom-notification ' + type;
        notification.innerHTML = (type === 'success'
            ? '<i class="bi bi-check-circle-fill me-2"></i>'
            : '<i class="bi bi-exclamation-circle-fill me-2"></i>') + message;
        Object.assign(notification.style, {
            position: 'fixed',
            top: '80px',
            right: '-300px',
            padding: '12px 20px',
            borderRadius: '8px',
            zIndex: '10001',
            fontWeight: '500',
            boxShadow: '0 4px 12px rgba(0,0,0,0.2)',
            transition: 'right 0.3s ease',
            backgroundColor: type === 'success' ? '#28a745' : '#dc3545',
            color: 'white',
            display: 'flex',
            alignItems: 'center',
            minWidth: '250px'
        });
        document.body.appendChild(notification);
        setTimeout(() => notification.style.right = '20px', 10);
        setTimeout(() => notification.style.right = '-300px', 2500);
        setTimeout(() => notification.remove(), 3000);
    }

    //XỬ LÝ THÊM VÀO GIỎ HÀNG TOÀN CỤC
    function globallyHandleAddToCart(productId, quantity, sourceImg, btnElement) {
        if (!productId) return;
        //1.Hiệu ứng bay vào giỏ hàng
        if (sourceImg && sourceImg.src) {
            const flyingImg = document.createElement('img');
            flyingImg.src = sourceImg.src;
            const imgRect = sourceImg.getBoundingClientRect();
            const cartIcon = document.querySelector('.bi-cart3');
            const cartRect = cartIcon ? cartIcon.getBoundingClientRect() : {
                left: window.innerWidth - 100,
                top: 20,
                width: 24,
                height: 24
            };
            const targetX = cartRect.left + (cartRect.width / 2);
            const targetY = cartRect.top + (cartRect.height / 2);
            //kích thước cố định để nhất quán giữa trang chủ và chi tiết
            const size = 100;
            Object.assign(flyingImg.style, {
                position: 'fixed',
                zIndex: '100000',
                width: size + 'px',
                height: size + 'px',
                objectFit: 'cover',
                transition: 'none',
                pointerEvents: 'none',
                borderRadius: '50%', //hình tròn phẳng
                boxShadow: '0 2px 10px rgba(0,0,0,0.1)', //đổ bóng nhẹ
                border: '2px solid white',
                left: (imgRect.left + imgRect.width / 2 - size / 2) + 'px',
                top: (imgRect.top + imgRect.height / 2 - size / 2) + 'px',
                opacity: '1'
            });
            document.body.appendChild(flyingImg);
            requestAnimationFrame(() => {
                requestAnimationFrame(() => {
                    Object.assign(flyingImg.style, {
                        transition: 'all 1.2s cubic-bezier(0.1, 0, 0.3, 1)',
                        left: (targetX - size / 4) + 'px',
                        top: (targetY - size / 4) + 'px',
                        width: '20px',
                        height: '20px',
                        opacity: '0.2',
                        transform: 'scale(0.1) rotate(360deg)' //xoay 1 vòng từ từ
                    });
                });
            });
            setTimeout(() => flyingImg.remove(), 1300);
        }
        //2.gọi AJAX
        const fetchUrl = contextPath + '/add-cart?productId=' + productId + '&quantity=' + quantity;
        fetch(fetchUrl, {
            method: 'GET',
            headers: {'X-Requested-With': 'XMLHttpRequest'}
        })
            .then(res => {
                if (res.redirected) {
                    if (confirm('Bạn cần đăng nhập để thêm vào giỏ hàng. Chuyển đến trang đăng nhập?')) {
                        window.location.href = res.url;
                    }
                    return null;
                }
                return res.json();
            })
            .then(data => {
                if (!data) return;
                if (data.success) {
                    showNotification('Đã thêm vào giỏ hàng!', 'success');
                    updateCartBadge(data.totalQuantity);
                } else {
                    showNotification(data.message || 'Thêm vào giỏ hàng thất bại', 'error');
                }
            })
            .catch(err => {
                console.error('Add cart error:', err);
                showNotification('Lỗi kết nối server', 'error');
            });
    }

    //khởi tạo trạng thái badge ban đầu
    document.addEventListener('DOMContentLoaded', () => {
        const cartBadge = document.getElementById('cartBadge');
        if (cartBadge) {
            const count = parseInt(cartBadge.textContent.trim()) || 0;
            if (count <= 0) {
                cartBadge.style.setProperty('display', 'none', 'important');
            } else {
                cartBadge.style.setProperty('display', 'flex', 'important');
            }
        }
    });
</script>

