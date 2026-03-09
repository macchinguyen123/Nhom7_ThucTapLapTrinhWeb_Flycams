<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="cart" value="${sessionScope.cart}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>Giỏ hàng Flycam</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
          rel="stylesheet">
    <link rel="stylesheet" href="../stylesheets/shoppingcart.css">
</head>
<body>
<jsp:include page="/page/header-common.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<div class="gio-hang">
    <div class="gio-hang-noi-dung">
        <div class="container py-4">
            <div class="mb-3">
                <h3 class="text-center mb-4 fw-bold text-primary">Giỏ hàng của bạn</h3>
            </div>
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="form-check">
                    <input type="checkbox" class="form-check-input" id="chon_tat_ca">
                    <label for="chon_tat_ca" class="form-check-label">Chọn tất cả</label>
                </div>
                <button type="button" class="btn btn-outline-danger btn-sm nut_xoa_da_chon">
                    <i class="bi bi-trash"></i> Xóa sản phẩm đã chọn
                </button>
            </div>
            <div id="danh_sach_san_pham">
                <c:if test="${empty cart or empty cart.items}">
                    <p class="text-center text-muted">Giỏ hàng trống</p>
                </c:if>
                <c:forEach var="item" items="${cart.items}">
                    <div class="khung_san_pham d-flex justify-content-between align-items-center
            border rounded shadow-sm p-3 mb-3 bg-white" data-id="${item.product.id}">
                        <div class="d-flex align-items-center gap-3">
                            <input type="checkbox" class="chon_san_pham form-check-input me-3">
                            <a
                                    href="${pageContext.request.contextPath}/product-detail?id=${item.product.id}">
                                <img src="${not empty item.product.images? item.product.images[0].imageUrl
                                 : pageContext.request.contextPath.concat('/image/no-image.png')}"
                                     class="anh_san_pham me-3">
                            </a>
                            <div>
                                <h6 class="ten_san_pham mb-1 fw-semibold text-truncate"
                                    style="max-width: 260px;">
                                        ${item.product.productName}
                                </h6>
                                <div class="gia_san_pham">
                                    <c:if test="${item.product.price > item.product.finalPrice}">
                                        <div
                                                class="gia_goc text-muted text-decoration-line-through small">
                                            <fmt:formatNumber value="${item.product.price}"
                                                              type="number"/> ₫
                                        </div>
                                    </c:if>
                                    <div class="gia_hien_tai text-danger fw-bold">
                                        <fmt:formatNumber value="${item.product.finalPrice}"
                                                          type="number"/> ₫
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <button class="btn btn-outline-secondary btn-sm nut_giam">−</button>
                            <input type="text" class="form-control text-center o_so_luong mx-1"
                                   value="${item.quantity}" style="width:50px;" readonly>
                            <button class="btn btn-outline-secondary btn-sm nut_tang">+</button>
                            <button class="btn btn-outline-danger btn-sm nut_xoa_1"
                                    title="Xóa sản phẩm">
                                <i class="bi bi-trash"></i>
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <div class="card p-3 shadow-sm">
                <div>
                    <div class="d-flex align-items-center gap-2">
                        <span class="fw-bold">Tạm tính:</span>
                        <span class="so_tien fw-bold">0 ₫</span>
                    </div>
                    <div class="d-flex align-items-center gap-2 text-success small mt-1 so_tien_giam"
                         style="display:none">
                        <span>Đã giảm:</span>
                        <span class="tien_giam">0 ₫</span>
                    </div>
                </div>
                <hr>
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="tong_cong text-danger m-0">Tổng cộng: 0 ₫</h5>
                    <button type="button" class="btn btn-primary nut_thanh_toan" id="btnMuaNgay">Mua ngay
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="/page/footer.jsp"/>
<script>
    const chonTatCa = document.getElementById("chon_tat_ca");
    const nutXoaDaChon = document.querySelector(".nut_xoa_da_chon");
    const danhSach = document.getElementById("danh_sach_san_pham");

    function dinhDangTien(amount) {
        if (isNaN(amount)) return "0 ₫";
        return amount.toLocaleString("vi-VN") + " ₫";
    }

    function capNhatTongTien() {
        let tong = 0;
        let tongGoc = 0;
        document.querySelectorAll(".khung_san_pham").forEach(sp => {
            const check = sp.querySelector(".chon_san_pham");
            if (check && check.checked) {
                const giaHienTai = parseInt(
                    sp.querySelector(".gia_hien_tai").textContent.replace(/[^\d]/g, "")
                );
                const giaGocEl = sp.querySelector(".gia_goc");
                let giaGoc = giaHienTai;
                if (giaGocEl) {
                    giaGoc = parseInt(giaGocEl.textContent.replace(/[^\d]/g, ""));
                }
                const soLuong = parseInt(sp.querySelector(".o_so_luong").value);
                tong += giaHienTai * soLuong;
                tongGoc += giaGoc * soLuong;
            }
        });
        const tienGiam = tongGoc - tong;
        document.querySelector(".so_tien").textContent = dinhDangTien(tongGoc);
        document.querySelector(".tong_cong").textContent =
            "Tổng cộng: " + dinhDangTien(tong);
        const giamBox = document.querySelector(".so_tien_giam");
        if (tienGiam > 0) {
            giamBox.style.display = "flex";
            document.querySelector(".tien_giam").textContent = dinhDangTien(tienGiam);
        } else {
            giamBox.style.display = "none";
        }
    }

    chonTatCa.addEventListener("change", () => {
        document.querySelectorAll(".chon_san_pham")
            .forEach(cb => cb.checked = chonTatCa.checked);
        capNhatTongTien();
    });
    danhSach.addEventListener("change", e => {
        if (e.target.classList.contains("chon_san_pham")) {
            const checkboxes = document.querySelectorAll(".chon_san_pham");
            const checked = document.querySelectorAll(".chon_san_pham:checked");
            chonTatCa.checked = (checkboxes.length > 0 && checkboxes.length === checked.length);
            capNhatTongTien();
        }
    });
    danhSach.addEventListener("click", e => {
        const sp = e.target.closest(".khung_san_pham");
        if (!sp) return;
        // tăng / giảm
        if (e.target.classList.contains("nut_tang") ||
            e.target.classList.contains("nut_giam")) {
            const input = sp.querySelector(".o_so_luong");
            let soLuong = parseInt(input.value);
            if (e.target.classList.contains("nut_tang")) soLuong++;
            else if (soLuong > 1) soLuong--;
            const productId = sp.dataset.id;
            // cập nhật lên server
            fetch("${pageContext.request.contextPath}/UpdateCartQuantity", {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: "productId=" + productId + "&quantity=" + soLuong
            }).then(res => {
                if (res.ok) {
                    input.value = soLuong;
                    capNhatTongTien();
                } else {
                    if (typeof showNotification === 'function') {
                        showNotification("Cập nhật số lượng thất bại!", "error");
                    } else {
                        alert("Cập nhật số lượng thất bại!");
                    }
                }
            }).catch(err => {
                console.error("Error updating quantity:", err);
            });
        }
    });
    danhSach.addEventListener("click", e => {
        if (e.target.closest(".nut_xoa_1")) {
            const sp = e.target.closest(".khung_san_pham");
            const productId = sp.dataset.id;
            fetch("${pageContext.request.contextPath}/RemoveFromCart", {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: "productId=" + productId
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        sp.remove();
                        capNhatTongTien();
                        if (typeof updateCartBadge === 'function') {
                            updateCartBadge(data.cartSize);
                        }
                        if (typeof showNotification === 'function') {
                            showNotification('Đã xóa sản phẩm', 'success');
                        }
                    } else {
                        if (typeof showNotification === 'function') {
                            showNotification('Xóa thất bại', 'error');
                        }
                    }
                });
        }
    });
    nutXoaDaChon.addEventListener("click", () => {
        const ids = [];
        document.querySelectorAll(".chon_san_pham:checked").forEach(cb => {
            const sp = cb.closest(".khung_san_pham");
            ids.push(sp.dataset.id);
        });
        if (ids.length === 0) {
            showNotification('Bạn chưa chọn sản phẩm nào', 'error');
            return;
        }
        const body = ids.map(id => "productIds[]=" + id).join("&");
        fetch("${pageContext.request.contextPath}/RemoveMultiFromCart", {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: body
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    document.querySelectorAll(".chon_san_pham:checked").forEach(cb => {
                        cb.closest(".khung_san_pham").remove();
                    });
                    capNhatTongTien();
                    if (typeof updateCartBadge === 'function') {
                        updateCartBadge(data.cartSize);
                    }
                    if (typeof showNotification === 'function') {
                        showNotification('Đã xóa sản phẩm đã chọn', 'success');
                    }
                } else {
                    if (typeof showNotification === 'function') {
                        showNotification('Xóa thất bại', 'error');
                    }
                }
            });
    });
    // gọi khi load trang
    window.addEventListener("load", capNhatTongTien);
</script>
<script>
    document.getElementById("btnMuaNgay").addEventListener("click", () => {
        const checked = document.querySelectorAll(".chon_san_pham:checked");
        if (checked.length === 0) {
            if (typeof showNotification === 'function') {
                showNotification('Vui lòng chọn ít nhất 1 sản phẩm', 'error');
            } else {
                alert('Vui lòng chọn ít nhất 1 sản phẩm');
            }
            return;
        }
        const form = document.createElement("form");
        form.method = "POST";
        form.action = "${pageContext.request.contextPath}/BuyNowFromCart";
        checked.forEach(cb => {
            const sp = cb.closest(".khung_san_pham");
            const pid = document.createElement("input");
            pid.type = "hidden";
            pid.name = "productId";
            pid.value = sp.dataset.id;
            const qty = document.createElement("input");
            qty.type = "hidden";
            qty.name = "quantities";
            qty.value = sp.querySelector(".o_so_luong").value;
            form.appendChild(pid);
            form.appendChild(qty);
        });
        document.body.appendChild(form);
        form.submit();
    });
</script>
</body>
</html>