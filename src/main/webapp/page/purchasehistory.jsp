<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử mua hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
          rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/purchasehistory.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/common-category.css">
</head>
<body>
<jsp:include page="/page/header-common.jsp"/>
<div id="lich-su-mua-hang">
    <h2>Đơn hàng đã mua gần đây</h2>
    <table>
        <thead>
        <tr>
            <th>Mã đơn hàng</th>
            <th>Sản phẩm</th>
            <th>Giá</th>
            <th>Ngày đặt mua</th>
            <th>Trạng thái</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="order" items="${orders}">
            <tr>
                <td>
                    <a href="#" class="ma-don">#${order.id}</a>
                </td>
                <td>
                    <c:if test="${not empty order.items}">
                        <c:forEach var="item" items="${order.items}">
                            <div style="display:inline-block; margin:4px;">
                                <c:choose>
                                    <c:when test="${not empty item.product.mainImage}">
                                        <img src="${item.product.mainImage}"
                                             alt="${item.product.productName}" class="anh-san-pham"
                                             width="80" style="border-radius: 6px;">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/no-image.png"
                                             alt="No Image" class="anh-san-pham" width="80"
                                             style="border-radius: 6px;">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:forEach>
                    </c:if>
                </td>
                <td class="gia">
                    <fmt:formatNumber value="${order.totalPrice}" type="currency"
                                      currencySymbol="₫"/>
                </td>
                <td>
                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy"/>
                </td>
                <td class="trang-thai">
                                        <span class="status ${order.statusClass}">
                                                ${order.statusLabel}
                                        </span>
                </td>
                <td>
                    <button type="button" class="nut-mua-lai" onclick="muaLai(${order.id})">
                        Mua lại
                    </button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
<script>
    function muaLai(orderId) {
        // Tạo form động để submit
        const form = document.createElement("form");
        form.method = "POST";
        form.action = "${pageContext.request.contextPath}/BuyNowFromCart";
        // Thêm orderId để server biết đang mua lại đơn hàng nào
        const orderInput = document.createElement("input");
        orderInput.type = "hidden";
        orderInput.name = "orderId";
        orderInput.value = orderId;
        form.appendChild(orderInput);
        // Submit form
        document.body.appendChild(form);
        form.submit();
    }
</script>
</html>