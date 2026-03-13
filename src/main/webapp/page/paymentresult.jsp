<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết quả thanh toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>
<body>
<div class="result-box">
    <%
        String message = (String) request.getAttribute("message");
        String amount = request.getParameter("vnp_Amount");
        String txnRef = request.getParameter("vnp_TxnRef");
    %>
    <% if ("Thanh toán thành công!".equals(message)) { %>
    <div class="success">✔</div>
    <h4 class="mt-3">Thanh toán thành công</h4>
    <p class="text-muted">Cảm ơn bạn đã mua hàng</p>
    <hr>
    <p>Mã giao dịch</p>
    <p><b><%=txnRef%>
    </b></p>
    <p>Số tiền thanh toán</p>
    <p class="amount"><%=Long.parseLong(amount) / 100%> ₫</p>
    <% } else { %>
    <div class="fail">✖</div>
    <h4 class="mt-3">Thanh toán thất bại</h4>
    <p class="text-muted">Giao dịch không thành công hoặc đã bị hủy</p>
    <% } %>
    <div class="mt-4">
        <a href="<%=request.getContextPath()%>/personal?tab=orders" class="btn btn-primary w-100 mb-2">Xem đơn hàng</a>
        <a href="<%=request.getContextPath()%>/home" class="btn btn-outline-secondary w-100"> Về trang chủ </a>
    </div>
</div>
</body>
</html>