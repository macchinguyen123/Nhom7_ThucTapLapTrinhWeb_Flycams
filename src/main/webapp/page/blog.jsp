<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Blog Flycam - Drone</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/blog.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/footer.css">
</head>
<body>
<jsp:include page="/page/header-common.jsp"/>
<section class="blog-section">
    <div class="container">
        <h2 class="section-title">Flycam – Drone</h2>
        <div class="post-grid">
            <c:if test="${empty posts}">
                <p>Không có bài viết nào.</p>
            </c:if>
            <c:forEach var="post" items="${posts}">
                <article class="post-card">
                    <div class="post-thumb">
                        <a href="${pageContext.request.contextPath}/article?id=${post.id}">
                            <img src="${post.image}" alt="${post.title}">
                        </a>
                    </div>
                    <div class="post-info">
                        <h3 class="post-title">
                            <a href="${pageContext.request.contextPath}/article?id=${post.id}">${post.title}</a>
                        </h3>
                        <p class="post-excerpt">
                                ${fn:substring(post.content, 0, 120)}...
                        </p>
                        <span class="post-date">
                <fmt:formatDate value="${post.createdAt}" pattern="dd MMM yyyy"/>
            </span>
                    </div>
                </article>
            </c:forEach>
        </div>
    </div>
</section>
<jsp:include page="/page/footer.jsp"/>
</body>
</html>
