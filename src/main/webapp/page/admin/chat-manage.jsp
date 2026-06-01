<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Hộp thoại | SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/header.css">
    <style>
        .chat-container, .chat-container * {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif !important;
        }
        .chat-container {
            display: flex !important;
            height: calc(100vh - 120px) !important;
            width: 100% !important;
            background-color: #ffffff;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.04), 0 1px 3px rgba(0, 0, 0, 0.02) !important;
            border-radius: 16px !important;
            overflow: hidden;
            border: 1px solid #f1f5f9;
        }
        .conversation-list {
            width: 320px !important;
            flex-shrink: 0;
            border-right: 1px solid #f1f5f9;
            display: flex;
            flex-direction: column;
            background: #ffffff;
            z-index: 10;
        }
        .conv-list-header {
            padding: 18px 20px;
            font-weight: 700;
            font-size: 16px;
            color: #0f172a;
            border-bottom: 1px solid #f1f5f9;
            background: #ffffff;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .conv-search-container {
            padding: 12px 16px;
            border-bottom: 1px solid #f1f5f9;
            background: #ffffff;
        }
        .conv-search-input {
            width: 100%;
            padding: 8px 12px 8px 36px !important;
            font-size: 13px !important;
            background-color: #f8fafc !important;
            border: 1px solid #e2e8f0 !important;
            border-radius: 10px !important;
            transition: all 0.2s ease;
        }
        .conv-search-input:focus {
            background-color: #ffffff !important;
            border-color: #3b82f6 !important;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1) !important;
            outline: none;
        }
        .filter-tabs-override {
            display: grid !important;
            grid-template-columns: repeat(4, 1fr) !important;
            gap: 4px !important;
            padding: 6px !important;
            background: #f1f5f9;
            border-radius: 10px;
            margin: 0 10px 10px 10px;
        }
        .filter-tab-override {
            display: flex !important;
            flex-direction: column !important;
            align-items: center !important;
            justify-content: center !important;
            padding: 6px 2px !important;
            font-size: 10px !important;
            font-weight: 600 !important;
            color: #64748b !important;
            cursor: pointer;
            border-radius: 8px !important;
            transition: all 0.2s ease !important;
            text-align: center !important;
            background: transparent !important;
            border: none !important;
            user-select: none;
        }
        .filter-tab-override:hover {
            color: #0f172a !important;
            background: rgba(255,255,255,0.4) !important;
        }
        .filter-tab-override.active {
            background: #ffffff !important;
            color: #2563eb !important;
            box-shadow: 0 2px 4px rgba(0,0,0,0.04) !important;
        }
        .filter-tab-override .tab-badge {
            font-size: 9px !important;
            font-weight: 700 !important;
            background: #e2e8f0 !important;
            color: #64748b !important;
            padding: 1px 6px !important;
            border-radius: 8px !important;
            margin-top: 3px !important;
            min-width: 18px;
            text-align: center;
        }
        .filter-tab-override.active .tab-badge {
            background: #dbeafe !important;
            color: #2563eb !important;
        }
        .conv-list-body {
            flex: 1;
            overflow-y: auto;
            padding: 8px;
            background: #ffffff;
        }
        .conv-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px;
            margin-bottom: 6px;
            cursor: pointer;
            transition: all 0.2s ease;
            border-radius: 12px;
            border: 1px solid transparent;
            background: #ffffff;
        }
        .conv-item:hover {
            background: #f8fafc;
        }
        .conv-item.active {
            background: #eff6ff;
            border-color: #bfdbfe;
        }
        .conv-item.unread {
            background: #faf5ff;
        }
        .conv-item.unread:hover {
            background: #f3e8ff;
        }
        .conv-item.unread .conv-name {
            font-weight: 700 !important;
            color: #0f172a;
        }
        .conv-item.unread .conv-last-msg {
            font-weight: 600;
            color: #1e1b4b;
        }
        .unread-dot {
            width: 8px;
            height: 8px;
            background: #2563eb;
            border-radius: 50%;
            flex-shrink: 0;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
        }
        .chat-main {
            flex: 1 !important;
            display: flex !important;
            flex-direction: column;
            background: #f8fafc;
            position: relative;
        }
        .chat-main-header {
            height: 68px;
            padding: 0 20px;
            border-bottom: 1px solid #f1f5f9;
            background: #ffffff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 1px 2px rgba(0,0,0,0.02);
        }
        .chat-header-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .chat-header-left .avatar-circle {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #2563eb, #4f46e5);
            color: white;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
        }
        .chat-header-left .avatar-circle img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 50%;
        }
        .btn-resolve {
            border: 1px solid #e2e8f0;
            background: #ffffff;
            color: #475569;
            border-radius: 10px;
            padding: 8px 14px;
            font-size: 13px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
            box-shadow: 0 1px 2px rgba(0,0,0,0.04);
            cursor: pointer;
        }
        .btn-resolve:hover {
            background: #f8fafc;
            color: #0f172a;
            border-color: #cbd5e1;
        }
        .btn-resolve.resolved {
            background: #f0fdf4 !important;
            color: #166534 !important;
            border-color: #bbf7d0 !important;
        }
        .btn-resolve.resolved:hover {
            background: #dcfce7 !important;
        }
        .btn-toggle-sidebar {
            border: 1px solid #e2e8f0;
            background: #ffffff;
            color: #64748b;
            border-radius: 10px;
            width: 38px;
            height: 38px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            cursor: pointer;
            box-shadow: 0 1px 2px rgba(0,0,0,0.04);
        }
        .btn-toggle-sidebar:hover, .btn-toggle-sidebar.active {
            background: #f1f5f9;
            color: #0f172a;
            border-color: #cbd5e1;
        }
        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            gap: 12px;
            background: #f8fafc;
            scrollbar-width: thin;
        }
        .chat-messages::-webkit-scrollbar {
            width: 6px;
        }
        .chat-messages::-webkit-scrollbar-track {
            background: transparent;
        }
        .chat-messages::-webkit-scrollbar-thumb {
            background-color: #cbd5e1;
            border-radius: 10px;
        }
        .chat-messages .message {
            display: flex !important;
            flex-direction: column !important;
            max-width: 70% !important;
            gap: 4px !important;
            background: transparent !important;
            padding: 0 !important;
            border: none !important;
            box-shadow: none !important;
        }
        .chat-messages .message.admin {
            align-self: flex-start !important;
            background: transparent !important;
        }
        .chat-messages .message.user {
            align-self: flex-end !important;
            background: transparent !important;
        }
        .message.admin .msg-text {
            background: #ffffff;
            color: #1e293b;
            border-radius: 16px 16px 16px 4px;
            border: 1px solid #e2e8f0;
            padding: 10px 16px;
            font-size: 14px;
            line-height: 1.5;
            box-shadow: 0 1px 2px rgba(0,0,0,0.02);
            word-break: break-word;
        }
        .message.user {
            align-self: flex-end;
        }
        .message.user .msg-text {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #ffffff;
            border-radius: 16px 16px 4px 16px;
            padding: 10px 16px;
            font-size: 14px;
            line-height: 1.5;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.15);
            word-break: break-word;
        }
        .msg-time {
            font-size: 10px;
            color: #94a3b8;
            padding: 0 4px;
            margin-top: 2px;
        }
        .message.user .msg-time {
            text-align: right;
        }
        .message.admin .msg-time {
            text-align: left;
        }
        .quick-replies-bar {
            display: flex;
            gap: 8px;
            overflow-x: auto;
            padding: 10px 16px;
            background: #ffffff;
            border-top: 1px solid #f1f5f9;
            scrollbar-width: none;
        }
        .quick-replies-bar::-webkit-scrollbar {
            display: none;
        }
        .reply-chip {
            white-space: nowrap;
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #e2e8f0;
            border-radius: 20px;
            padding: 6px 14px;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .reply-chip:hover {
            background: #eff6ff;
            color: #2563eb;
            border-color: #bfdbfe;
            transform: translateY(-1px);
        }
        .chat-input-area {
            padding: 16px 20px;
            border-top: 1px solid #f1f5f9;
            background: #ffffff;
        }
        .chat-input-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .chat-input-field {
            flex: 1;
            border-radius: 24px !important;
            padding: 10px 18px !important;
            font-size: 14px !important;
            border: 1px solid #e2e8f0 !important;
            background-color: #f8fafc !important;
            transition: all 0.2s ease !important;
        }
        .chat-input-field:focus {
            background-color: #ffffff !important;
            border-color: #2563eb !important;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1) !important;
            outline: none;
        }
        .btn-send-message {
            width: 42px;
            height: 42px;
            border-radius: 50% !important;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #2563eb !important;
            border: none !important;
            color: white !important;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 2px 6px rgba(37, 99, 235, 0.2);
            padding: 0 !important;
        }
        .btn-send-message:hover {
            background: #1d4ed8 !important;
            transform: scale(1.05);
        }
        .btn-send-message i {
            font-size: 16px;
            margin-left: 2px;
        }
        .typing-indicator {
            display: none;
            align-items: center;
            gap: 8px;
            padding: 8px 24px;
            background: transparent;
        }
        .typing-indicator.visible {
            display: flex;
        }
        .typing-bubble {
            background: #e2e8f0;
            border-radius: 12px;
            padding: 8px 12px;
            display: flex;
            gap: 4px;
            align-items: center;
        }
        .typing-dot {
            width: 6px;
            height: 6px;
            background: #64748b;
            border-radius: 50%;
            animation: bounce 1.4s infinite ease-in-out both;
        }
        .typing-dot:nth-child(1) { animation-delay: -0.32s; }
        .typing-dot:nth-child(2) { animation-delay: -0.16s; }
        .typing-label {
            font-size: 11px;
            color: #64748b;
        }
        @keyframes bounce {
            0%, 80%, 100% { transform: scale(0); }
            40% { transform: scale(1.0); }
        }
        .customer-details {
            width: 300px !important;
            flex-shrink: 0;
            background: #ffffff;
            border-left: 1px solid #f1f5f9;
            padding: 24px 20px;
            overflow-y: auto;
            box-shadow: -2px 0 10px rgba(0,0,0,0.01);
            scrollbar-width: thin;
        }
        .customer-profile-card {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            padding-bottom: 20px;
            border-bottom: 1px solid #f1f5f9;
            margin-bottom: 20px;
        }
        .profile-avatar-wrapper {
            position: relative;
            margin-bottom: 12px;
        }
        .profile-avatar {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3b82f6, #8b5cf6);
            color: white;
            font-weight: 700;
            font-size: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 10px rgba(59, 130, 246, 0.15);
            overflow: hidden;
        }
        .status-badge-active {
            width: 14px;
            height: 14px;
            background: #10b981;
            border: 2px solid #ffffff;
            border-radius: 50%;
            position: absolute;
            bottom: 2px;
            right: 2px;
        }
        .profile-name {
            font-size: 15px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 2px;
        }
        .profile-role {
            font-size: 12px;
            color: #64748b;
            font-weight: 500;
        }

        .sidebar-section {
            width: 100%;
        }
        .sidebar-section-title {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #94a3b8;
            margin-bottom: 12px;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 4px;
        }
        .info-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .info-item {
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }
        .info-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            background: #f1f5f9;
            color: #475569;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            flex-shrink: 0;
        }
        .info-content {
            display: flex;
            flex-direction: column;
            min-width: 0;
        }
        .info-label {
            font-size: 10px;
            color: #94a3b8;
            font-weight: 500;
        }
        .info-value {
            font-size: 13px;
            color: #334155;
            font-weight: 600;
            word-break: break-word;
        }
        
        .order-history-list {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .order-history-item {
            padding: 10px 12px;
            background: #f8fafc;
            border: 1px solid #f1f5f9;
            border-radius: 10px;
            transition: all 0.2s ease;
        }
        .order-history-item:hover {
            background: #ffffff;
            border-color: #cbd5e1;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        }
        .order-meta {
            display: flex;
            justify-content: space-between;
            font-size: 10px;
            color: #64748b;
            margin-bottom: 4px;
        }
        .order-summary {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .order-status-badge {
            font-size: 9px;
            font-weight: 700;
            padding: 2px 6px;
            border-radius: 6px;
        }
        .order-total {
            font-size: 12px;
            font-weight: 700;
            color: #0f172a;
        }
        .order-empty-state {
            font-size: 12px;
            color: #94a3b8;
            text-align: center;
            padding: 16px 0;
            font-style: italic;
        }
        .no-selection-panel {
            flex: 1 !important;
            display: flex;
            align-items: center;
            justify-content: center;
            background: radial-gradient(circle at top right, #f8fafc, #f1f5f9);
            padding: 40px;
        }
        .placeholder-content {
            max-width: 480px;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .placeholder-icon-wrapper {
            position: relative;
            width: 100px;
            height: 100px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 24px;
        }
        .placeholder-icon {
            font-size: 48px;
            color: #3b82f6;
            z-index: 2;
            filter: drop-shadow(0 4px 12px rgba(59, 130, 246, 0.2));
        }
        .pulse-ring {
            position: absolute;
            width: 80px;
            height: 80px;
            background: rgba(59, 130, 246, 0.08);
            border-radius: 50%;
            animation: pulse-ring-animation 3s infinite ease-in-out;
            z-index: 1;
        }
        @keyframes pulse-ring-animation {
            0% { transform: scale(0.9); opacity: 0.6; }
            50% { transform: scale(1.2); opacity: 1; }
            100% { transform: scale(0.9); opacity: 0.6; }
        }
        .placeholder-title {
            font-size: 20px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 8px;
        }
        .placeholder-subtitle {
            font-size: 13px;
            color: #64748b;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        .placeholder-stats {
            display: flex;
            gap: 12px;
            width: 100%;
            justify-content: center;
        }
        .stat-card {
            flex: 1;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
            text-align: left;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
            min-width: 120px;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            border-color: #cbd5e1;
        }
        .stat-icon-wrapper {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            flex-shrink: 0;
        }
        .stat-info {
            display: flex;
            flex-direction: column;
        }
        .stat-value {
            font-size: 16px;
            font-weight: 700;
            color: #0f172a;
            line-height: 1.2;
        }
        .stat-label {
            font-size: 10px;
            color: #64748b;
            font-weight: 600;
        }
        .stat-unread .stat-icon-wrapper {
            background: #fee2e2;
            color: #ef4444;
        }
        .stat-unread:hover {
            border-color: #fca5a5;
            background: #fffafb;
        }
        .stat-open .stat-icon-wrapper {
            background: #dbeafe;
            color: #2563eb;
        }
        .stat-open:hover {
            border-color: #93c5fd;
            background: #fafdff;
        }
        .stat-resolved .stat-icon-wrapper {
            background: #dcfce7;
            color: #10b981;
        }
        .stat-resolved:hover {
            border-color: #86efac;
            background: #fafffa;
        }
    </style>
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
    <jsp:include page="sidebar.jsp">
        <jsp:param name="activePage" value="chat"/>
    </jsp:include>
    <main class="main-content" style="padding: 20px;">
        <div class="chat-container">
            <!-- 1. Left Sidebar: Conversation List -->
            <div class="conversation-list">
                <div class="conv-list-header">
                    <span><i class="bi bi-chat-dots-fill me-2 text-primary"></i>Đoạn chat</span>
                </div>
                <div class="conv-search-container">
                    <div class="position-relative">
                        <i class="bi bi-search text-muted position-absolute" style="left: 12px; top: 50%; transform: translateY(-50%); font-size: 13px;"></i>
                        <input type="text" id="convSearch" class="conv-search-input"
                               placeholder="Tìm kiếm hội thoại..."
                               oninput="filterConversations(this.value)">
                    </div>
                </div>
                <div class="filter-tabs-override">
                    <div class="filter-tab-override active filter-tab" data-filter="all" onclick="setFilter('all', this)">
                        <span>Tất cả</span>
                        <span class="tab-badge" id="badge-all">0</span>
                    </div>
                    <div class="filter-tab-override filter-tab" data-filter="unread" onclick="setFilter('unread', this)">
                        <span>Chưa đọc</span>
                        <span class="tab-badge" id="badge-unread">0</span>
                    </div>
                    <div class="filter-tab-override filter-tab" data-filter="open" onclick="setFilter('open', this)">
                        <span>Đang mở</span>
                        <span class="tab-badge" id="badge-open">0</span>
                    </div>
                    <div class="filter-tab-override filter-tab" data-filter="resolved" onclick="setFilter('resolved', this)">
                        <span>Đã xong</span>
                        <span class="tab-badge" id="badge-resolved">0</span>
                    </div>
                </div>
                <div class="conv-list-body" id="convList">
                    <div class="text-center p-5 text-muted">
                        <div class="spinner-border spinner-border-sm text-primary mb-2" role="status"></div>
                        <div class="small">Đang tải...</div>
                    </div>
                </div>
            </div>

            <!-- 2. Chat Main Column -->
            <div class="chat-main" id="chatMain" style="display: none; flex-direction: column;">
                <div class="chat-main-header">
                    <div class="chat-header-left">
                        <div class="avatar-circle" id="currentAvatar">?</div>
                        <div>
                            <div class="fw-bold fs-6" id="currentName">Khách</div>
                            <div class="text-success" style="font-size: 11px; font-weight: 500;">
                                <i class="bi bi-circle-fill" style="font-size: 6px; vertical-align: middle;"></i> Đang hoạt động
                            </div>
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <button class="btn-resolve" id="btnResolve" onclick="toggleResolve()">
                            <i class="bi bi-check2-circle"></i>
                            <span id="resolveLabel">Đánh dấu giải quyết</span>
                        </button>
                        <button class="btn-toggle-sidebar" id="btnToggleSidebar" title="Thông tin khách hàng" onclick="toggleSidebar()">
                            <i class="bi bi-layout-sidebar-reverse"></i>
                        </button>
                    </div>
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
                    <div id="quickReplyBar" class="quick-replies-bar"></div>
                    <div class="chat-input-group">
                        <input type="text" id="adminChatInput" class="form-control chat-input-field"
                               placeholder="Nhập tin nhắn..." onkeypress="handleKeyPress(event)">
                        <button class="btn btn-primary btn-send-message" id="btnAdminSend" onclick="sendReply()" title="Gửi tin nhắn">
                            <i class="bi bi-send-fill"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- 3. Elegant Placeholder Panel (shown when no conversation is selected) -->
            <div class="no-selection-panel" id="noSelection">
                <div class="placeholder-content">
                    <div class="placeholder-icon-wrapper">
                        <div class="pulse-ring"></div>
                        <i class="bi bi-chat-heart-fill placeholder-icon"></i>
                    </div>
                    <h3 class="placeholder-title">Hộp thoại Chăm sóc Khách hàng</h3>
                    <p class="placeholder-subtitle">Chọn một cuộc hội thoại từ danh sách bên trái để phản hồi khách hàng và quản lý đơn hàng</p>
                </div>
            </div>

            <!-- 4. Customer Details Sidebar -->
            <aside class="customer-details" id="customerSidebar" style="display: none;">
                <div class="customer-profile-card">
                    <div class="profile-avatar-wrapper">
                        <div class="profile-avatar" id="custAvatar">?</div>
                        <span class="status-badge-active"></span>
                    </div>
                    <h5 class="profile-name" id="custName">Khách hàng</h5>
                    <span class="profile-role">Khách mua hàng</span>
                </div>
                
                <div class="sidebar-section">
                    <div class="sidebar-section-title">Thông tin liên hệ</div>
                    <div class="info-list">
                        <div class="info-item">
                            <div class="info-icon"><i class="bi bi-telephone-fill"></i></div>
                            <div class="info-content">
                                <span class="info-label">Số điện thoại</span>
                                <span class="info-value" id="custPhone">Chưa cập nhật</span>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-icon"><i class="bi bi-geo-alt-fill"></i></div>
                            <div class="info-content">
                                <span class="info-label">Địa chỉ</span>
                                <span class="info-value" id="custAddress">Chưa cập nhật</span>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-icon"><i class="bi bi-credit-card-fill"></i></div>
                            <div class="info-content">
                                <span class="info-label">Tổng chi tiêu</span>
                                <span class="info-value text-success font-semibold" id="custTotalSpend">0đ</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="sidebar-section mt-4">
                    <div class="sidebar-section-title">Đơn hàng gần đây</div>
                    <ul id="custOrderHistory" class="order-history-list">
                        <li class="order-empty-state"><i class="bi bi-inbox me-1"></i> Chưa có đơn hàng nào</li>
                    </ul>
                </div>
            </aside>
        </div>
    </main>
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
    
    // Sidebar visibility state
    let sidebarVisible = true;
    (function() {
        const stored = localStorage.getItem('chat_sidebar_visible');
        if (stored === '0') {
            sidebarVisible = false;
        }
    })();

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
        fetch(contextPath + '/admin/chat?action=list&_t=' + new Date().getTime())
            .then(res => res.json())
            .then(data => {
                allConversations = data || [];
                allConversations.forEach(c => {
                    if (resolvedMap[c.id] !== undefined) c.resolved = resolvedMap[c.id];
                });
                updateFilterBadges();
                applyFilterAndSearch();
            })
            .catch(err => (function(){})('Lỗi tải danh sách hội thoại:', err));
    }
    
    function updateFilterBadges() {
        const all      = allConversations.length;
        const unread   = allConversations.filter(c => c.hasUnread === true || (typeof c.hasUnread === 'number' && c.hasUnread > 0)).length;
        const resolved = allConversations.filter(c => c.resolved).length;
        const open     = all - resolved;
        
        // Update sidebar badges
        document.getElementById('badge-all').textContent      = all;
        document.getElementById('badge-unread').textContent   = unread;
        document.getElementById('badge-open').textContent     = open;
        document.getElementById('badge-resolved').textContent = resolved;
        
    }

    function setFilter(filter, tabEl) {
        activeFilter = filter;
        document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active'));
        if (tabEl) {
            tabEl.classList.add('active');
        } else {
            // Find tab element based on filter
            const targetTab = document.querySelector(`.filter-tab[data-filter="${filter}"]`);
            if (targetTab) targetTab.classList.add('active');
        }
        applyFilterAndSearch();
    }

    function triggerFilter(filterName) {
        setFilter(filterName, null);
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
        if (!btn) return;
        if (isResolved) {
            btn.classList.add('resolved');
            const icon = btn.querySelector('i');
            if (icon) icon.className = 'bi bi-arrow-counterclockwise';
            const label = document.getElementById('resolveLabel');
            if (label) label.textContent = 'Mở lại hội thoại';
        } else {
            btn.classList.remove('resolved');
            const icon = btn.querySelector('i');
            if (icon) icon.className = 'bi bi-check2-circle';
            const label = document.getElementById('resolveLabel');
            if (label) label.textContent = 'Đánh dấu giải quyết';
        }
    }
    
    const quickReplies = [
        { key: 'Giá cả', text: 'Chào bạn, dòng sản phẩm này hiện có giá niêm yết là [Giá] ạ.' },
        { key: 'Bảo hành', text: 'Chào bạn, sản phẩm SkyDrone được bảo hành chính hãng 12 tháng, hỗ trợ 1 đổi 1 trong 30 ngày đầu nếu phát sinh lỗi từ NSX ạ.' },
        { key: 'Địa chỉ', text: 'Bạn có thể ghé trực tiếp Showroom tại 123 Đường ABC, Quận 1, TP. HCM để trải nghiệm sản phẩm nhé.' },
        { key: 'Giao hàng', text: 'Dạ, bên mình miễn phí giao hàng toàn quốc và hỗ trợ đồng kiểm khi nhận hàng ạ.' }
    ];

    const chatInput = document.getElementById('adminChatInput');
    const replyBar = document.getElementById('quickReplyBar');

    function renderQuickReplies() {
        if (!replyBar) return;
        replyBar.innerHTML = quickReplies.map(r =>
            '<div class="reply-chip" onclick="insertReply(\'' + r.text.replace(/'/g, "\\'") + '\')">' +
            r.key +
            '</div>'
        ).join('');
        replyBar.style.display = 'flex';
    }

    function insertReply(text) {
        if (!chatInput) return;
        chatInput.value = text;
        chatInput.focus();
    }

    function toggleSidebar() {
        if (!currentConvId) return;
        sidebarVisible = !sidebarVisible;
        const sidebar = document.getElementById('customerSidebar');
        const toggleBtn = document.getElementById('btnToggleSidebar');
        
        if (sidebarVisible) {
            if (sidebar) sidebar.style.display = 'block';
            if (toggleBtn) toggleBtn.classList.add('active');
        } else {
            if (sidebar) sidebar.style.display = 'none';
            if (toggleBtn) toggleBtn.classList.remove('active');
        }
        localStorage.setItem('chat_sidebar_visible', sidebarVisible ? '1' : '0');
    }

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
            headers: { 'Content-Type': 'application/x-www-form-urlencoded',
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
        const label = document.getElementById('typingLabel');
        const indicator = document.getElementById('typingIndicator');
        const body = document.getElementById('adminChatBody');
        
        if (label) label.textContent = (name || 'Khách') + ' đang gõ...';
        if (indicator) indicator.classList.add('visible');
        if (body) scrollToBottom(body, true);
        
        clearTimeout(typingTimer);
        typingTimer = setTimeout(hideTypingIndicator, 8000);
    }

    function hideTypingIndicator() {
        clearTimeout(typingTimer);
        const indicator = document.getElementById('typingIndicator');
        if (indicator) indicator.classList.remove('visible');
    }

    function checkTypingStatus() {
        if (!currentConvId) return;
        fetch(contextPath + '/admin/chat?action=typing&conversationId=' + currentConvId + '&_t=' + new Date().getTime())
            .then(res => { if (!res.ok) throw new Error(); return res.json(); })
            .then(data => { data && data.typing ? showTypingIndicator(data.userName) : hideTypingIndicator(); })
            .catch(() => {});
    }

    function renderConversationList(list) {
        const listEl = document.getElementById('convList');
        if (!listEl) return;
        if (!list || list.length === 0) {
            listEl.innerHTML = '<div class="text-center p-5 text-muted small"><i class="bi bi-chat-left mb-2 d-block fs-3 opacity-50"></i>Chưa có cuộc trò chuyện nào</div>';
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
                ? '<img src="' + avatarSrc + '" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">'
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
                '<div class="conv-name" style="flex:1; font-weight: 500;">' + (c.participantName || 'Guest') + '</div>' +
                (isUnread ? '<div class="unread-dot"></div>' : '') +
                '</div>' +
                '<div style="display:flex;justify-content:space-between;align-items:center;gap:4px;">' +
                '<div class="conv-last-msg" style="max-width: 140px;">' + lastMsgDisp + '</div>' +
                (timeStr ? '<span style="font-size:11px;color:#94a3b8;white-space:nowrap;">' + timeStr + '</span>' : '') +
                '</div>' +
                '</div>';
            listEl.appendChild(div);
        });
    }

    function selectConversation(c) {
        (function(){})('Conversation selected:', c);
        currentConvId = c.id;
        currentParticipantId = c.participantId;
        
        // Hide placeholder, show chat panel
        document.getElementById('noSelection').style.display = 'none';
        document.getElementById('chatMain').style.display = 'flex';
        
        // Update header details
        document.getElementById('currentName').textContent = c.participantName || 'Guest';
        const initial = c.participantName ? c.participantName.charAt(0).toUpperCase() : '?';
        const avatarSrc = getAvatarUrl(c.participantAvatar);
        
        document.getElementById('currentAvatar').innerHTML = avatarSrc
            ? '<img src="' + avatarSrc + '" style="width:100%; height:100%; object-fit:cover; border-radius:50%;">'
            : initial;
            
        // Update customer avatar & name in sidebar
        const custNameEl = document.getElementById('custName');
        const custAvatarEl = document.getElementById('custAvatar');
        if (custNameEl) custNameEl.textContent = c.participantName || 'Guest';
        if (custAvatarEl) {
            custAvatarEl.innerHTML = avatarSrc
                ? '<img src="' + avatarSrc + '" style="width:100%; height:100%; object-fit:cover; border-radius:50%;">'
                : initial;
        }

        // Show sidebar based on state
        const sidebar = document.getElementById('customerSidebar');
        const toggleBtn = document.getElementById('btnToggleSidebar');
        if (sidebarVisible) {
            if (sidebar) sidebar.style.display = 'block';
            if (toggleBtn) toggleBtn.classList.add('active');
        } else {
            if (sidebar) sidebar.style.display = 'none';
            if (toggleBtn) toggleBtn.classList.remove('active');
        }

        loadMessages();
        hideTypingIndicator();
        lastMsgCount = 0;
        updateResolveButton(!!c.resolved);
        renderQuickReplies();
        loadConversations();
        loadCustomerContext(c.participantId);
    }

    function loadCustomerContext(userId) {
        fetch(contextPath + '/admin/chat?action=getCustomerInfo&userId=' + userId)
            .then(res => res.json())
            .then(data => {
                document.getElementById('custPhone').textContent = data.phone || 'Chưa cập nhật';
                document.getElementById('custAddress').textContent = data.address || 'Chưa cập nhật';
                document.getElementById('custTotalSpend').textContent = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(data.totalSpend || 0);

                let orderHtml = '';
                if (data.orders && data.orders.length > 0) {
                    data.orders.forEach(o => {
                        let badgeClass = 'bg-secondary-subtle text-secondary';
                        let statusText = o.status || 'Chờ xác nhận';
                        
                        if (statusText === 'Đã giao' || statusText.toLowerCase() === 'delivered' || statusText.toLowerCase() === 'đã giao hàng') {
                            badgeClass = 'bg-success-subtle text-success';
                        } else if (statusText === 'Đã xác nhận' || statusText.toLowerCase() === 'confirmed') {
                            badgeClass = 'bg-primary-subtle text-primary';
                        } else if (statusText === 'Đang xử lý' || statusText.toLowerCase() === 'processing') {
                            badgeClass = 'bg-warning-subtle text-warning';
                        } else if (statusText === 'Đã hủy' || statusText.toLowerCase() === 'cancelled' || statusText.toLowerCase() === 'hủy đơn') {
                            badgeClass = 'bg-danger-subtle text-danger';
                        }
                        
                        let formattedTotal = o.total;
                        if (typeof o.total === 'number' || !isNaN(o.total)) {
                            formattedTotal = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(o.total);
                        } else {
                            formattedTotal = o.total + 'đ';
                        }

                        orderHtml += '<li class="order-history-item">' +
                            '<div class="order-meta">' +
                            '<span>#' + o.id + '</span>' +
                            '<span>' + o.date + '</span>' +
                            '</div>' +
                            '<div class="order-summary">' +
                            '<span class="order-status-badge ' + badgeClass + '">' + statusText + '</span>' +
                            '<span class="order-total">' + formattedTotal + '</span>' +
                            '</div>' +
                            '</li>';
                    });
                } else {
                    orderHtml = '<li class="order-empty-state"><i class="bi bi-inbox me-1"></i> Chưa có đơn hàng nào</li>';
                }
                document.getElementById('custOrderHistory').innerHTML = orderHtml;
            })
            .catch(err => {});
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
        fetch(contextPath + '/admin/chat?action=messages&conversationId=' + currentConvId + '&_t=' + new Date().getTime())
            .then(res => res.json())
            .then(data => {
                const body = document.getElementById('adminChatBody');
                if (!body) return;
                body.innerHTML = '';
                data.sort((a, b) => a.id - b.id).forEach(m => {
                    const div = document.createElement('div');
                    const isFromCustomer = Number(m.sendUserId) === Number(currentParticipantId);
                    div.className = 'message ' + (isFromCustomer ? 'admin' : 'user');
                    const timeStr = m.sendTime ? formatAdminTime(m.sendTime) : '';
                    let contentHtml = m.content || '';
                    div.innerHTML = '<span class="msg-text">' + contentHtml + '</span>' +
                        (timeStr ? '<span class="msg-time">' + timeStr + '</span>' : '');
                    body.appendChild(div);
                });
                scrollToBottom(body);
            })
            .catch(err => {});
    }

    function handleKeyPress(e) {
        if (e.key === 'Enter') {
            sendReply();
        }
    }

    if (chatInput) {
        let adminTypingTimer = null;
        chatInput.addEventListener('input', () => {
            if (!currentConvId) return;
            if (adminTypingTimer) return;
            adminTypingTimer = setTimeout(() => { adminTypingTimer = null; }, 3000);
            fetch(contextPath + '/admin/chat?action=typingSignal', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded', 'X-CSRF-Token': CSRF_TOKEN},
                body: new URLSearchParams({conversationId: currentConvId})
            }).catch(()=>{});
        });
    }

    function sendReply() {
        const input = document.getElementById('adminChatInput');
        if (!input) return;
        const content = input.value.trim();
        if (!content || !currentConvId) return;
        input.value = '';
        const body = document.getElementById('adminChatBody');
        const tempDiv = document.createElement('div');
        tempDiv.className = 'message user';
        const now = new Date();
        const tStr = now.getHours().toString().padStart(2, '0') + ':' + now.getMinutes().toString().padStart(2, '0');
        tempDiv.innerHTML = '<span class="msg-text">' + content + '</span><span class="msg-time">' + tStr + '</span>';
        if (body) {
            body.appendChild(tempDiv);
            scrollToBottom(body, true);
        }
        fetch(contextPath + '/admin/chat?action=send', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded', 'X-CSRF-Token': CSRF_TOKEN},
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
            .catch(err => (function(){})('Lỗi gửi tin nhắn:', err));
    }

    // Initialize logout dialog and sidebar submenus
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

    loadConversations();
    setInterval(() => {
        if (currentConvId) { loadMessages(); checkTypingStatus(); }
        loadConversations();
    }, 2500);
</script>
</body>
</html>
