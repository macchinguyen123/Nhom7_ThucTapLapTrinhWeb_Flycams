<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${post.title}"/> - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/article.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/footer.css">
</head>
<body>
<jsp:include page="/page/header-common.jsp"/>
<article class="article-container">
    <header class="article-header">
        <div class="meta-info">
            <span class="post-date">
                <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy"/>
            </span>
            <span class="author">by Admin</span>
        </div>
        <h1 class="article-title">${post.title}</h1>
    </header>
    <div class="article-content">
        <div class="article-image">
            <img src="${post.image}" alt="${post.title}">
        </div>
        <div class="article-text" style="white-space: pre-line;">
            ${post.content}
        </div>
        <section class="related-posts mt-4">
            <h3 class="mb-3">Xem thêm</h3>
            <ul class="list-group list-group-flush">
                <c:forEach var="p" items="${morePosts}">
                    <li class="list-group-item px-0 d-flex align-items-center">
                        <i class="bi bi-chevron-right me-2 text-primary"></i>
                        <a href="${pageContext.request.contextPath}/article?id=${p.id}"
                           class="text-decoration-none fw-semibold text-dark">
                                ${p.title}
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </section>
        <section class="related-articles mt-5">
            <h3>Bài viết cùng chủ đề</h3>
            <div class="row">
                <c:forEach var="p" items="${relatedPosts}">
                    <div class="col-md-4 col-6 mb-4">
                        <a href="${pageContext.request.contextPath}/article?id=${p.id}"
                           class="text-decoration-none text-dark">
                            <img src="${p.image}" class="img-fluid rounded mb-2">
                            <h6 class="fw-semibold">${p.title}</h6>
                            <small class="text-muted">
                                <fmt:formatDate value="${p.createdAt}" pattern="dd/MM/yyyy"/>
                            </small>
                            <p class="small text-muted mt-1">
                                    ${fn:substring(p.content, 0, 120)}...
                            </p>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </section>
        <section class="comment-section">
            <h2>Bình luận</h2>
            <c:forEach var="c" items="${comments}">
                <div class="card mb-3 shadow-sm">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <strong>
                                <i class="bi bi-person-circle"></i>
                                    ${c.username}
                            </strong>
                            <small class="text-muted">
                                <fmt:formatDate value="${c.createdAt}" pattern="dd/MM/yyyy"/>
                            </small>
                        </div>
                        <p class="mb-0">${c.content}</p>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty sessionScope.user}">
                <div class="alert alert-warning mt-3">
                    <i class="bi bi-exclamation-circle me-1"></i>Bạn cần
                    <a href="${pageContext.request.contextPath}/login"
                       class="fw-semibold text-decoration-underline">đăng nhập
                    </a>để bình luận bài viết này.
                </div>
            </c:if>
            <c:if test="${not empty sessionScope.user}">
                <c:choose>
                    <c:when test="${hasReviewed}">
                        <div class="alert alert-success mt-3">
                            <i class="bi bi-check-circle-fill me-1"></i>Bạn đã bình luận bài viết này.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <form method="post"
                              action="${pageContext.request.contextPath}/BlogReview"
                              class="card p-3 shadow-sm mt-3">
                            <input type="hidden" name="blogId" value="${post.id}"/>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Viết bình luận
                                </label>
                                <textarea name="content"
                                          class="form-control"
                                          rows="4"
                                          placeholder="Nhập bình luận của bạn..."
                                          required></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-send"></i> Gửi bình luận
                            </button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </section>
    </div>
</article>
<jsp:include page="/page/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>