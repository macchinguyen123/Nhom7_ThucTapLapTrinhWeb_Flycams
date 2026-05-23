<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Hộp thoại | SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/header.css">
</head>
<body>
<header class="main-header">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/image/logoo2.png" alt="Logo">
        <h2>SkyDrone Admin</h2>
    </div>
    <div class="header-right">
        <a href="${pageContext.request.contextPath}/admin/profile" class="text-decoration-none text-white">
            <div class="thong-tin-admin d-flex align-items-center gap-2">
                <i class="bi bi-person-circle fs-4"></i>
                <span class="fw-semibold">${sessionScope.user.fullName}</span>
            </div>
        </a>
        <button class="logout-btn" id="logoutBtn" title="Đăng xuất">
            <i class="bi bi-box-arrow-right"></i>
        </button>
    </div>
    <div class="logout-modal" id="logoutModal">
        <div class="logout-modal-content">
            <p>Bạn có chắc muốn đăng xuất không?</p>
            <div class="logout-actions">
                <a href="${pageContext.request.contextPath}/home">
                    <button id="confirmLogout" class="confirm">Có</button>
                </a>
                <button id="cancelLogout" class="cancel">Không</button>
            </div>
        </div>
    </div>
</header>
<div class="layout">
    <aside class="sidebar">
        <div class="user-info">
            <c:choose>
                <c:when test="${not empty sessionScope.user.avatar}">
                    <img src="${pageContext.request.contextPath}/image/avatar/${sessionScope.user.avatar}?v=${sessionScope.user.updatedAt != null ? sessionScope.user.updatedAt.time : ''}"
                         alt="Avatar"
                         style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover;">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/image/logoTCN.png" alt="Avatar">
                </c:otherwise>
            </c:choose>
            <h3>${sessionScope.user.fullName}</h3>
            <p>Chào mừng bạn trở lại 👋</p>
        </div>
        <ul class="menu">
            <a href="${pageContext.request.contextPath}/admin/dashboard">
                <li><i class="bi bi-speedometer2"></i> Tổng Quan</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/customer-manage">
                <li><i class="bi bi-person-lines-fill"></i> Quản Lý Tài Khoản</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/product-management">
                <li><i class="bi bi-box-seam"></i> Quản Lý Sản Phẩm</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/inventory-manage">
                <li><i class="bi bi-boxes"></i> Quản Lý Kho Hàng</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/category-manage">
                <li><i class="bi bi-tags"></i> Quản Lý Danh Mục</li>
            </a>
            <li class="has-submenu">
                <div class="menu-item">
                    <i class="bi bi-truck"></i>
                    <span>Quản Lý Đơn Hàng</span>
                    <i class="bi bi-chevron-right arrow"></i>
                </div>
                <ul class="submenu">
                    <a href="${pageContext.request.contextPath}/admin/unconfirmed-orders">
                        <li>Chưa Xác Nhận</li>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/order-manage">
                        <li>Đã Xác Nhận</li>
                    </a>
                </ul>
            </li>
            <a href="${pageContext.request.contextPath}/admin/blog-manage">
                <li><i class="bi bi-journal-text"></i> Quản Lý Blog</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/promotion-manage">
                <li><i class="bi bi-megaphone"></i> Quản Lý Khuyến Mãi</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/statistics">
                <li><i class="bi bi-bar-chart"></i> Báo Cáo &amp; Thống Kê</li>
            </a>
            <li class="active"><a href="${pageContext.request.contextPath}/admin/chat-manage"
                                  style="color:inherit;text-decoration:none;"><i class="bi bi-chat-left-text"></i> Hộp
                thoại</a></li>
            <a href="${pageContext.request.contextPath}/admin/banner-manage">
                <li><i class="bi bi-images"></i> Quản Lý Banner</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/review-manage">
                <li><i class="bi bi-shield-exclamation"></i> Quản Lý Đánh Giá Xấu</li>
            </a>
        </ul>
    </aside>
    <main class="main-content" style="padding: 20px;">
        <div class="chat-container">
            <div class="conversation-list">
                <div class="conv-list-header">
                    <i class="bi bi-chat-dots me-2"></i>Đoạn chat
                </div>
                <div class="p-2" style="border-bottom: 1px solid #eee;">
                    <div class="input-group input-group-sm">
                        <span class="input-group-text bg-white border-end-0" style="border-radius:20px 0 0 20px;">
                            <i class="bi bi-search text-muted"></i>
                        </span>
                        <input type="text" id="convSearch" class="form-control border-start-0"
                               placeholder="Tìm kiếm..."
                               style="border-radius:0 20px 20px 0; font-size:13px;"
                               oninput="filterConversations(this.value)">
                    </div>
                    <div class="filter-tabs">
                        <div class="filter-tab active" data-filter="all" onclick="setFilter('all', this)">
                            Tất cả <span class="tab-badge" id="badge-all">0</span>
                        </div>
                        <div class="filter-tab" data-filter="unread" onclick="setFilter('unread', this)">
                            Chưa đọc <span class="tab-badge" id="badge-unread">0</span>
                        </div>
                        <div class="filter-tab" data-filter="open" onclick="setFilter('open', this)">
                            Đang mở <span class="tab-badge" id="badge-open">0</span>
                        </div>
                        <div class="filter-tab" data-filter="resolved" onclick="setFilter('resolved', this)">
                            Đã giải quyết <span class="tab-badge" id="badge-resolved">0</span>
                        </div>
                    </div>
                </div>
                <div class="conv-list-body" id="convList">
                    <div class="text-center p-5 text-muted">
                        <i class="bi bi-arrow-clockwise fs-2 d-block mb-2"></i>
                        Đang tải...
                    </div>
                </div>
            </div>
            <div class="chat-main" id="chatMain" style="display: none; flex-direction: column;">
                <div class="chat-main-header">
                    <div class="chat-header-left">
                        <div class="avatar-circle" id="currentAvatar"></div>
                        <div>
                            <div class="fw-bold fs-6" id="currentName"></div>
                            <div class="text-success" style="font-size: 12px;">
                                <i class="bi bi-circle-fill" style="font-size: 8px;"></i> Đang hoạt động
                            </div>
                        </div>
                    </div>
                    <button class="btn-resolve" id="btnResolve" onclick="toggleResolve()">
                        <i class="bi bi-check2-circle"></i>
                        <span id="resolveLabel">Đánh dấu giải quyết</span>
                    </button>
                </div>
                <div class="chat-messages" id="adminChatBody">
                </div>
                <div class="typing-indicator" id="typingIndicator">
                    <div class="typing-bubble">
                        <div class="typing-dot"></div>
                        <div class="typing-dot"></div>
                        <div class="typing-dot"></div>
                    </div>
                    <span class="typing-label" id="typingLabel">đang gõ...</span>
                </div>
                <div class="chat-input-area">
                    <div id="quickReplyMenu"></div>
                    <div class="input-group">
                        <input type="text" id="adminChatInput" class="form-control"
                               placeholder="Nhập tin nhắn..." style="border-radius: 20px 0 0 20px;">
                        <button class="btn btn-primary px-4" id="btnAdminSend"
                                style="border-radius: 0 20px 20px 0;">
                            <i class="bi bi-send-fill"></i>
                        </button>
                    </div>
                </div>
            </div>
            <aside class="customer-details" id="customerSidebar" style="display: none;">
                <div class="sidebar-header">Thông tin khách hàng</div>
                <div class="sidebar-body">
                    <div class="detail-item">
                        <label>Số điện thoại:</label>
                        <span id="custPhone">N/A</span>
                    </div>
                    <div class="detail-item">
                        <label>Địa chỉ:</label>
                        <span id="custAddress">N/A</span>
                    </div>
                    <div class="detail-item">
                        <label>Tổng chi tiêu:</label>
                        <span id="custTotalSpend" class="text-success fw-bold">0đ</span>
                    </div>
                    <hr>
                    <h6>Đơn hàng gần đây</h6>
                    <ul id="custOrderHistory" class="list-unstyled">
                    </ul>
                </div>
            </aside>
            <div class="no-selection-panel" id="noSelection">
                <div class="text-center">
                    <i class="bi bi-chat-dots" style="font-size: 56px; opacity: 0.3;"></i>
                    <p class="mt-3 text-muted">Chọn một cuộc trò chuyện để bắt đầu</p>
                </div>
            </div>
        </div>
    </main>
</div>
<div id="quickReplyMenu" class="list-group position-absolute" style="display:none; z-index: 1000; width: 300px;">
</div>
<script>
    const CSRF_TOKEN = "${sessionScope.CSRF_TOKEN}";
    (function () {
        const logoutBtn = document.getElementById('logoutBtn');
        const logoutModal = document.getElementById('logoutModal');
        const cancelLogout = document.getElementById('cancelLogout');
        if (logoutBtn) logoutBtn.addEventListener('click', () => logoutModal.style.display = 'flex');
        if (cancelLogout) cancelLogout.addEventListener('click', () => logoutModal.style.display = 'none');
        if (logoutModal) logoutModal.addEventListener('click', (e) => {
            if (e.target === logoutModal) logoutModal.style.display = 'none';
        });
        const hasSubmenu = document.querySelector('.has-submenu');
        if (hasSubmenu) hasSubmenu.addEventListener('click', function () {
            this.classList.toggle('open');
        });
    })();

    const contextPath = '${pageContext.request.contextPath}';
    const currentAdminName = '${sessionScope.user.fullName}';
    let currentConvId = null;
    let currentParticipantId = null;
    let allConversations = [];
    const resolvedMap = {};
    let activeFilter  = 'all';
    let lastMsgCount  = 0;
    let typingTimer   = null;
    function getAvatarUrl(avatar) {
        if (!avatar) return null;
        if (avatar.startsWith('http') || avatar.startsWith('https')) return avatar;
        return contextPath + '/image/avatar/' + avatar;
    }
    function scrollToBottom(el, smooth = false) {
        if (!el) return;
        requestAnimationFrame(() => {
            el.scrollTo({top: el.scrollHeight, behavior: smooth ? 'smooth' : 'auto'});
            setTimeout(() => {
                el.scrollTop = el.scrollHeight;
            }, 100);
        });
    }
    function loadConversations() {
        fetch(contextPath + '/admin/chat?action=list')
            .then(res => res.json())
            .then(data => {
                allConversations = data || [];
                allConversations.forEach(c => {
                    if (resolvedMap[c.id] !== undefined) c.resolved = resolvedMap[c.id];
                });
                updateFilterBadges();
                applyFilterAndSearch();
            })
            .catch(err => console.error('Lỗi tải danh sách hội thoại:', err));
    }
    function updateFilterBadges() {
        const all      = allConversations.length;
        const unread   = allConversations.filter(c => c.hasUnread === true || (typeof c.hasUnread === 'number' && c.hasUnread > 0)).length;
        const resolved = allConversations.filter(c => c.resolved).length;
        const open     = all - resolved;
        document.getElementById('badge-all').textContent      = all;
        document.getElementById('badge-unread').textContent   = unread;
        document.getElementById('badge-open').textContent     = open;
        document.getElementById('badge-resolved').textContent = resolved;
    }

    function setFilter(filter, tabEl) {
        activeFilter = filter;
        document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active'));
        tabEl.classList.add('active');
        applyFilterAndSearch();
    }

    function applyFilterAndSearch() {
        const keyword = (document.getElementById('convSearch').value || '').trim().toLowerCase();
        let filtered = allConversations;
        if (activeFilter === 'unread')   filtered = filtered.filter(c => c.hasUnread === true || (typeof c.hasUnread === 'number' && c.hasUnread > 0));
        else if (activeFilter === 'open')     filtered = filtered.filter(c => !c.resolved);
        else if (activeFilter === 'resolved') filtered = filtered.filter(c => c.resolved);
        if (keyword) filtered = filtered.filter(c =>
            (c.participantName || '').toLowerCase().includes(keyword) ||
            (c.lastMessage     || '').toLowerCase().includes(keyword)
        );
        renderConversationList(filtered);
    }

    function filterConversations(keyword) {
        applyFilterAndSearch();
    }

    function updateResolveButton(isResolved) {
        const btn = document.getElementById('btnResolve');
        if (isResolved) {
            btn.classList.add('resolved');
            btn.querySelector('i').className = 'bi bi-arrow-counterclockwise';
            document.getElementById('resolveLabel').textContent = 'Mở lại hội thoại';
        } else {
            btn.classList.remove('resolved');
            btn.querySelector('i').className = 'bi bi-check2-circle';
            document.getElementById('resolveLabel').textContent = 'Đánh dấu giải quyết';
        }
    }
    const quickReplies = [
        { key: 'Giá', text: 'Sản phẩm này có giá là [Giá] ạ.' },
        { key: 'Bảo hành', text: 'Bảo hành 12 tháng, lỗi 1 đổi 1 ạ.' },
        { key: 'Địa chỉ', text: 'Shop ở 123 Đường ABC, HCM bạn nhé.' },
        { key: 'Ship', text: 'Bên mình có ship COD toàn quốc ạ.' }
    ];

    const chatInput = document.getElementById('adminChatInput');
    const replyMenu = document.getElementById('quickReplyMenu');

    function renderQuickReplies() {
        replyMenu.innerHTML = quickReplies.map(r =>
            '<div class="reply-item" onclick="insertReply(\'' + r.text + '\')">' +
            '<strong>' + r.key + '</strong>' +
            '</div>'
        ).join('');
    }

    chatInput.addEventListener('focus', function() {
        renderQuickReplies();
        replyMenu.style.display = 'block';
    });

    function insertReply(text) {
        chatInput.value = text;
        chatInput.focus();

    }

    chatInput.addEventListener('blur', function() {
        setTimeout(() => {
        }, 200);
    });
    function toggleResolve() {
        if (!currentConvId) {
            console.warn('toggleResolve: currentConvId is null');
            return;
        }
        const convId = String(currentConvId);
        const conv = allConversations.find(c => String(c.id) === convId);

        const wasResolved = conv ? !!conv.resolved : !!resolvedMap[convId];
        const newResolved = !wasResolved;

        resolvedMap[convId] = newResolved;
        if (conv) conv.resolved = newResolved;
        updateResolveButton(newResolved);
        updateFilterBadges();
        applyFilterAndSearch();

        fetch(contextPath + '/admin/chat?action=resolve', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded'
                'X-CSRF-Token': CSRF_TOKEN},
            body: new URLSearchParams({
                conversationId: convId,
                resolved: newResolved ? '1' : '0'
            })
        })
            .then(res => {
                if (!res.ok) console.warn('Backend resolve chưa implement, lưu client-side.');
                else return res.json();
            })
            .catch(err => console.warn('Lỗi gọi resolve:', err));
    }

    function showTypingIndicator(name) {
        document.getElementById('typingLabel').textContent = (name || 'Khách') + ' đang gõ...';
        document.getElementById('typingIndicator').classList.add('visible');
        scrollToBottom(document.getElementById('adminChatBody'), true);
        clearTimeout(typingTimer);
        typingTimer = setTimeout(hideTypingIndicator, 8000);
    }

    function hideTypingIndicator() {
        clearTimeout(typingTimer);
        document.getElementById('typingIndicator').classList.remove('visible');
    }

    function checkTypingStatus() {
        if (!currentConvId) return;
        fetch(contextPath + '/admin/chat?action=typing&conversationId=' + currentConvId)
            .then(res => { if (!res.ok) throw new Error(); return res.json(); })
            .then(data => { data && data.typing ? showTypingIndicator(data.userName) : hideTypingIndicator(); })
            .catch(() => {});
    }
    function filterConversations(keyword) {
        const q = keyword.trim().toLowerCase();
        if (!q) {
            renderConversationList(allConversations);
        } else {
            renderConversationList(allConversations.filter(c =>
                (c.participantName || '').toLowerCase().includes(q) ||
                (c.lastMessage || '').toLowerCase().includes(q)
            ));
        }
    }
    function renderConversationList(list) {
        const listEl = document.getElementById('convList');
        if (!list || list.length === 0) {
            listEl.innerHTML = '<div class="text-center p-5 text-muted">Chưa có cuộc trò chuyện nào</div>';
            return;
        }
        listEl.innerHTML = '';
        list.forEach(c => {
            const isUnread = c.hasUnread === true || (typeof c.hasUnread === 'number' && c.hasUnread > 0);
            const div = document.createElement('div');
            div.className = 'conv-item' + (currentConvId == c.id ? ' active' : '') + (isUnread ? ' unread' : '');
            div.onclick = () => selectConversation(c);
            const initial = c.participantName ? c.participantName.charAt(0).toUpperCase() : '?';
            const avatarSrc = getAvatarUrl(c.participantAvatar);
            const avatarHtml = avatarSrc
                ? '<img src="' + avatarSrc + '">'
                : initial;
            const timeStr = c.lastMessageTime ? formatAdminTime(c.lastMessageTime) : '';
            let lastMsgDisp = c.lastMessage || 'Chưa có tin nhắn';
            if (c.lastSenderId) {
                const senderName = (c.lastSenderId === c.participantId)
                    ? (c.participantName || 'Guest')
                    : (currentAdminName || 'Admin');
                lastMsgDisp = senderName + ': ' + lastMsgDisp;
            }
            div.innerHTML =
                '<div class="avatar-circle">' + avatarHtml + '</div>' +
                '<div class="conv-info">' +
                '<div style="display:flex; justify-content:space-between; align-items:flex-start; gap: 8px;">' +
                '<div class="conv-name" style="flex:1;">' + (c.participantName || 'Guest') + '</div>' +
                (isUnread ? '<div class="unread-dot"></div>' : '') +
                '</div>' +
                '<div style="display:flex;justify-content:space-between;align-items:center;gap:4px;">' +
                '<div class="conv-last-msg">' + lastMsgDisp + '</div>' +
                (timeStr ? '<span style="font-size:11px;color:#9ca3af;white-space:nowrap;">' + timeStr + '</span>' : '') +
                '</div>' +
                '</div>';
            listEl.appendChild(div);
        });
    }
    function selectConversation(c) {
        console.log('Conversation selected:', c);
        currentConvId = c.id;
        currentParticipantId = c.participantId;
        document.getElementById('noSelection').style.display = 'none';
        document.getElementById('chatMain').style.display = 'flex';
        document.getElementById('currentName').textContent = c.participantName || 'Guest';
        const initial = c.participantName ? c.participantName.charAt(0).toUpperCase() : '?';
        const avatarSrc = getAvatarUrl(c.participantAvatar);
        document.getElementById('currentAvatar').innerHTML = avatarSrc
            ? '<img src="' + avatarSrc + '">'
            : initial;
        loadMessages();
        hideTypingIndicator();
        lastMsgCount = 0;
        updateResolveButton(!!c.resolved);
        loadConversations();
        document.getElementById('customerSidebar').style.display = 'block';
        loadCustomerContext(c.participantId);
    }
    function loadCustomerContext(userId) {
        fetch(contextPath + '/admin/chat?action=getCustomerInfo&userId=' + userId)
            .then(res => res.json())
            .then(data => {
                document.getElementById('custPhone').textContent = data.phone || 'Chưa cập nhật';
                document.getElementById('custAddress').textContent = data.address || 'N/A';
                document.getElementById('custTotalSpend').textContent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(data.totalSpend);

                let orderHtml = '';
                if (data.orders && data.orders.length > 0) {
                    data.orders.forEach(o => {
                        orderHtml += '<li class="mb-2 p-2 bg-white border rounded shadow-sm">' +
                            '<small>#' + o.id + ' - ' + o.date + '</small><br>' +
                            '<strong>' + o.status + '</strong> - ' + o.total + 'đ' +
                            '</li>';
                    });
                } else {
                    orderHtml = '<li class="text-muted">Chưa có đơn hàng nào</li>';
                }
                document.getElementById('custOrderHistory').innerHTML = orderHtml;
            });
    }
    function formatAdminTime(ts) {
        if (!ts) return '';
        let d;
        try {
            if (typeof ts === 'number' || !isNaN(ts)) {
                d = new Date(parseInt(ts));
            } else {
                d = new Date(ts);
            }
            if (isNaN(d.getTime())) return '';
            const now = new Date();
            const diff = now.getTime() - d.getTime();
            if (diff >= 0 && diff < 60000) return 'Vừa xong';
            const isToday = d.toDateString() === now.toDateString();
            const hours = d.getHours().toString().padStart(2, '0');
            const minutes = d.getMinutes().toString().padStart(2, '0');
            const timeStr = hours + ':' + minutes;
            if (isToday) return timeStr;
            const day = d.getDate().toString().padStart(2, '0');
            const month = (d.getMonth() + 1).toString().padStart(2, '0');
            return day + '/' + month + ' ' + timeStr;
        } catch (e) {
            return '';
        }
    }
    function loadMessages() {
        if (!currentConvId) return;
        fetch(contextPath + '/admin/chat?action=messages&conversationId=' + currentConvId)
            .then(res => res.json())
            .then(data => {
                const body = document.getElementById('adminChatBody');
                body.innerHTML = '';
                data.sort((a, b) => a.id - b.id).forEach(m => {
                    const div = document.createElement('div');
                    const isFromCustomer = Number(m.sendUserId) === Number(currentParticipantId);
                    div.className = 'message ' + (isFromCustomer ? 'admin' : 'user'); // ✅ Thêm dòng này
                    const timeStr = m.sendTime ? formatAdminTime(m.sendTime) : '';
                    div.innerHTML = '<span class="msg-text">' + (m.content || '') + '</span>' +
                        (timeStr ? '<span class="msg-time">' + timeStr + '</span>' : '');
                    body.appendChild(div);
                });
                scrollToBottom(body);
            })
            .catch(err => console.error('Lỗi tải tin nhắn:', err));
    }
    document.getElementById('btnAdminSend').addEventListener('click', sendReply);
    document.getElementById('adminChatInput').addEventListener('keypress', (e) => {
        if (e.key === 'Enter') sendReply();
    });
    function sendReply() {
        const input = document.getElementById('adminChatInput');
        const content = input.value.trim();
        if (!content || !currentConvId) return;
        input.value = '';
        const body = document.getElementById('adminChatBody');
        const tempDiv = document.createElement('div');
        tempDiv.className = 'message user';
        const now = new Date();
        const tStr = now.getHours().toString().padStart(2, '0') + ':' + now.getMinutes().toString().padStart(2, '0');
        tempDiv.innerHTML = '<span class="msg-text">' + content + '</span><span class="msg-time">' + tStr + '</span>';
        body.appendChild(tempDiv);
        scrollToBottom(body, true);
        fetch(contextPath + '/admin/chat?action=send', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'
                'X-CSRF-Token': CSRF_TOKEN},
            body: new URLSearchParams({
                conversationId: currentConvId,
                participantId: currentParticipantId,
                content: content
            })
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    loadMessages();
                    loadConversations();
                }
            })
            .catch(err => console.error('Lỗi gửi tin nhắn:', err));
    }
    loadConversations();
    setInterval(() => {
        if (currentConvId) { loadMessages(); checkTypingStatus(); }
        loadConversations();
    }, 2500);
</script>
</body>
</html>
