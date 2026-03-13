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
                    <div class="avatar-circle" id="currentAvatar"></div>
                    <div>
                        <div class="fw-bold fs-6" id="currentName"></div>
                        <div class="text-success" style="font-size: 12px;">
                            <i class="bi bi-circle-fill" style="font-size: 8px;"></i> Đang hoạt động
                        </div>
                    </div>
                </div>
                <div class="chat-messages" id="adminChatBody">
                </div>
                <div class="chat-input-area">
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
            <div class="no-selection-panel" id="noSelection">
                <div class="text-center">
                    <i class="bi bi-chat-dots" style="font-size: 56px; opacity: 0.3;"></i>
                    <p class="mt-3 text-muted">Chọn một cuộc trò chuyện để bắt đầu</p>
                </div>
            </div>
        </div>
    </main>
</div>
<script>
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
                renderConversationList(allConversations);
            })
            .catch(err => console.error('Lỗi tải danh sách hội thoại:', err));
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
            // Xử lý nội dung tin ngắn kèm tiền tố tên người gửi
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
        currentConvId = c.id;
        currentParticipantId = c.participantId;
        document.getElementById('noSelection').style.display = 'none';
        document.getElementById('chatMain').style.display = 'flex';
        // Cập nhật thông tin người đang chat lên tiêu đề
        document.getElementById('currentName').textContent = c.participantName || 'Guest';
        const initial = c.participantName ? c.participantName.charAt(0).toUpperCase() : '?';
        const avatarSrc = getAvatarUrl(c.participantAvatar);
        document.getElementById('currentAvatar').innerHTML = avatarSrc
            ? '<img src="' + avatarSrc + '">'
            : initial;
        loadMessages(); // Lấy tin nhắn chi tiết
        loadConversations();
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
                    const isFromCustomer = m.sendUserId == currentParticipantId;
                    div.className = 'message ' + (isFromCustomer ? 'admin' : 'user');
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
    // Gửi tin nhắn phản hồi của Admin
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
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
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
        if (currentConvId) loadMessages();
        loadConversations();
    }, 5000);
</script>
</body>
</html>
