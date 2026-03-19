<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Thông tin giao hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/delivery-info.css">
</head>

<body>
<div class="wrap">
    <div class="left">
        <div class="text-start mb-4">
            <img src="${pageContext.request.contextPath}/image/dronefooter.png" alt="Logo"
                 height="100">
            <nav class="breadcrumb mt-2">
                <a
                        href="http://localhost:8080/Nhom7_ThucTapLapTrinhWeb_Flycams/page/shoppingcart.jsp">Giỏ
                    hàng</a> &nbsp;>&nbsp;
                <span class="current">Thông tin giao hàng</span> &nbsp;>&nbsp;
                <a href="#">Phương thức thanh toán</a>
            </nav>
        </div>
        <h5 class="mb-4 fw-bold">Thông tin giao hàng</h5>
        <c:if test="${not empty sessionScope.user}">
            <div class="d-flex align-items-center mb-3">
                <c:choose>
                    <c:when test="${not empty sessionScope.user.avatar}">
                        <div class="avatar rounded-circle me-3">
                            <img src="${pageContext.request.contextPath}/image/avatar/${sessionScope.user.avatar}"
                                 alt="Avatar">
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div
                                class="avatar rounded-circle d-flex justify-content-center align-items-center me-3">
                            <i class="bi bi-person fs-3 text-secondary"></i>
                        </div>
                    </c:otherwise>
                </c:choose>
                <div>
                    <p class="mb-0 fw-semibold">${sessionScope.user.fullName}</p>
                    <small>${sessionScope.user.email}</small><br>
                </div>
            </div>
        </c:if>
        <form id="checkoutForm" action="${pageContext.request.contextPath}/CheckoutServlet"
              method="post">
            <div class="mb-3">
                <select id="savedAddress" name="savedAddress" class="form-select">
                    <option value="">Thêm địa chỉ mới...</option>
                    <c:forEach items="${addresses}" var="a">
                        <option value="${a.id}" data-name="${a.fullName}"
                                data-phone="${a.phoneNumber}" data-address="${a.addressLine}"
                                data-province="${a.province}" data-district="${a.district}"
                                data-ward="${a.ward}" ${a.defaultAddress ? "selected" : "" }>
                                ${a.phoneNumber}, ${a.addressLine}, ${a.ward}, ${a.district},
                                ${a.province}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div id="manualInputFields">
                <div class="mb-3">
                    <input id="fullName" type="text" name="fullName" class="form-control"
                           placeholder="Họ và tên" required>
                </div>
                <div class="mb-3">
                    <input id="phoneNumber" type="tel" name="phone" class="form-control"
                           placeholder="Số điện thoại" required>
                </div>
                <div class="mb-3">
                    <input id="addressLine" type="text" name="address" class="form-control"
                           placeholder="Địa chỉ cụ thể (Số nhà, đường...)" required>
                </div>
                <div class="address-select-group">
                    <select name="province" id="province" class="form-select" required>
                        <option value="">-- Chọn Tỉnh/Thành phố --</option>
                    </select>
                    <select name="district" id="district" class="form-select" required disabled>
                        <option value="">-- Chọn Quận/Huyện --</option>
                    </select>
                    <select name="ward" id="ward" class="form-select" required disabled>
                        <option value="">-- Chọn Phường/Xã --</option>
                    </select>
                </div>
                <%-- Hidden fields lưu GHN IDs để tính phí và đặt hàng --%>
                <input type="hidden" name="ghn_province_id"  id="ghnProvinceId">
                <input type="hidden" name="ghn_district_id"  id="ghnDistrictId">
                <input type="hidden" name="ghn_ward_code"    id="ghnWardCode">
                <input type="hidden" name="shippingFee"      id="shippingFeeInput" value="0">
            </div>
            <div class="mt-3">
                                <textarea name="note" rows="5" class="form-control"
                                          placeholder="Nhập ghi chú của bạn..."></textarea>
            </div>
            <button type="submit" class="btn btn-primary w-100 mt-3">Tiếp tục đến phương thức thanh
                toán
            </button>
        </form>
    </div>
    <c:set var="items" value="${sessionScope.BUY_NOW_ITEM}"/>
    <div class="right">
        <h5 class="fw-bold mb-4">Đơn hàng của bạn</h5>
        <c:if test="${not empty items}">
            <c:set var="total" value="0"/>
            <c:forEach var="item" items="${items}">
                <div class="d-flex align-items-center mb-3">
                    <img src="${item.product.images[0].imageUrl}" width="60" class="me-3 prod-img">
                    <div>
                        <p class="mb-0 fw-semibold">
                                ${item.product.productName}
                        </p>
                        <small class="text-muted">
                            Số lượng: ${item.quantity}
                        </small>
                    </div>
                    <span class="ms-auto fw-semibold">
                                            <fmt:formatNumber value="${item.price * item.quantity}" type="number"/> ₫
                                        </span>
                </div>
                <c:set var="total" value="${total + (item.price * item.quantity)}"/>
            </c:forEach>
            <div class="d-flex justify-content-between">
                <span>Tạm tính</span>
                <span>
                                        <fmt:formatNumber value="${total}" type="number"/> ₫
                                    </span>
            </div>
            <div class="d-flex justify-content-between mb-2">
                <span>Phí vận chuyển</span>
                <span id="shippingFeeDisplay">—</span>
            </div>
            <hr>
            <div class="d-flex justify-content-between fw-bold total">
                <span>Tổng cộng</span>
                <span id="totalDisplay">
                    <fmt:formatNumber value="${total}" type="number"/> ₫
                </span>
            </div>
            <%-- Lưu subtotal để JS cộng phí ship --%>
            <input type="hidden" id="subtotalValue" value="${total}">
        </c:if>
    </div>
</div>
<script>
    const GHN_API   = "${pageContext.request.contextPath}/ghn";
    const provinceSelect = document.getElementById("province");
    const districtSelect = document.getElementById("district");
    const wardSelect     = document.getElementById("ward");
    const savedAddressSelect = document.getElementById("savedAddress");
    const fullNameInput  = document.getElementById("fullName");
    const phoneInput     = document.getElementById("phoneNumber");
    const addressInput   = document.getElementById("addressLine");
    const manualInputFields = document.getElementById("manualInputFields");

    const ghnProvinceIdInput  = document.getElementById("ghnProvinceId");
    const ghnDistrictIdInput  = document.getElementById("ghnDistrictId");
    const ghnWardCodeInput    = document.getElementById("ghnWardCode");
    const shippingFeeInput    = document.getElementById("shippingFeeInput");
    const shippingFeeDisplay  = document.getElementById("shippingFeeDisplay");
    const totalDisplay        = document.getElementById("totalDisplay");
    const subtotalEl          = document.getElementById("subtotalValue");

    const subtotal = subtotalEl ? parseFloat(subtotalEl.value) : 0;

    // ─── Load tỉnh GHN ────────────────────────────────────────────────────────
    fetch(GHN_API + "/provinces")
        .then(r => r.json())
        .then(json => {
            if (json.code !== 200) throw new Error(json.message || "GHN error");
            json.data.forEach(p => {
                const opt = document.createElement("option");
                opt.value        = p.ProvinceName;
                opt.textContent  = p.ProvinceName;
                opt.dataset.ghnId = p.ProvinceID;
                provinceSelect.appendChild(opt);
            });
            // Nếu đã có địa chỉ mặc định, kích hoạt change
            if (savedAddressSelect.value) {
                setTimeout(() => savedAddressSelect.dispatchEvent(new Event('change')), 300);
            }
        })
        .catch(err => {
            console.error("Lỗi load tỉnh GHN:", err);
            provinceSelect.innerHTML = '<option value="">-- Không tải được tỉnh --</option>';
        });

    // ─── Chọn Tỉnh → load Quận GHN ───────────────────────────────────────────
    provinceSelect.addEventListener("change", function () {
        const opt = this.options[this.selectedIndex];
        const ghnProvinceId = opt.dataset.ghnId || "";
        ghnProvinceIdInput.value = ghnProvinceId;

        resetDistrict();
        resetWard();
        resetShippingFee();

        if (!ghnProvinceId) return;

        fetch(GHN_API + "/districts?provinceId=" + ghnProvinceId)
            .then(r => r.json())
            .then(json => {
                if (json.code !== 200) throw new Error(json.message);
                json.data.forEach(d => {
                    const dOpt = document.createElement("option");
                    dOpt.value        = d.DistrictName;
                    dOpt.textContent  = d.DistrictName;
                    dOpt.dataset.ghnId = d.DistrictID;
                    districtSelect.appendChild(dOpt);
                });
                districtSelect.disabled = false;
            })
            .catch(err => console.error("Lỗi load quận GHN:", err));
    });

    // ─── Chọn Quận → load Phường GHN ─────────────────────────────────────────
    districtSelect.addEventListener("change", function () {
        const opt = this.options[this.selectedIndex];
        const ghnDistrictId = opt.dataset.ghnId || "";
        ghnDistrictIdInput.value = ghnDistrictId;

        resetWard();
        resetShippingFee();

        if (!ghnDistrictId) return;

        fetch(GHN_API + "/wards?districtId=" + ghnDistrictId)
            .then(r => r.json())
            .then(json => {
                if (json.code !== 200) throw new Error(json.message);
                (json.data || []).forEach(w => {
                    const wOpt = document.createElement("option");
                    wOpt.value        = w.WardName;
                    wOpt.textContent  = w.WardName;
                    wOpt.dataset.code = w.WardCode;
                    wardSelect.appendChild(wOpt);
                });
                wardSelect.disabled = false;
            })
            .catch(err => console.error("Lỗi load phường GHN:", err));
    });

    // ─── Chọn Phường → tính phí ship ─────────────────────────────────────────
    wardSelect.addEventListener("change", function () {
        const opt = this.options[this.selectedIndex];
        const wardCode      = opt.dataset.code || "";
        ghnWardCodeInput.value = wardCode;

        const districtId = ghnDistrictIdInput.value;
        if (!districtId) return;

        shippingFeeDisplay.textContent = "Đang tính...";

        fetch(GHN_API + "/fee?districtId=" + districtId + "&wardCode=" + wardCode)
            .then(r => r.json())
            .then(json => {
                if (json.code !== 200) {
                    shippingFeeDisplay.textContent = "Không tính được";
                    shippingFeeInput.value = 0;
                    return;
                }
                const fee = json.data.total || 0;
                shippingFeeInput.value = fee;
                shippingFeeDisplay.textContent = formatVND(fee) + " ₫";
                if (totalDisplay) {
                    totalDisplay.textContent = formatVND(subtotal + fee) + " ₫";
                }
            })
            .catch(err => {
                console.error("Lỗi tính phí ship:", err);
                shippingFeeDisplay.textContent = "Lỗi";
                shippingFeeInput.value = 0;
            });
    });

    // ─── Chọn địa chỉ đã lưu ─────────────────────────────────────────────────
    savedAddressSelect.addEventListener("change", function () {
        const opt = this.options[this.selectedIndex];
        if (!opt.value) {
            fullNameInput.value  = "";
            phoneInput.value     = "";
            addressInput.value   = "";
            resetProvince();
            resetDistrict();
            resetWard();
            resetShippingFee();
            toggleRequiredFields(true);
            manualInputFields.style.opacity = "1";
            return;
        }
        fullNameInput.value  = opt.dataset.name    || "";
        phoneInput.value     = opt.dataset.phone   || "";
        addressInput.value   = opt.dataset.address || "";

        const savedProvince  = opt.dataset.province  || "";
        const savedDistrict  = opt.dataset.district  || "";
        const savedWard      = opt.dataset.ward      || "";

        // Tìm tỉnh trong dropdown và chọn
        if (savedProvince) {
            const pOpt = Array.from(provinceSelect.options).find(o => o.value === savedProvince);
            if (pOpt) {
                provinceSelect.value = savedProvince;
                ghnProvinceIdInput.value = pOpt.dataset.ghnId || "";
                // Load quận theo tỉnh GHN
                const ghnProvinceId = pOpt.dataset.ghnId;
                if (ghnProvinceId) {
                    resetDistrict();
                    fetch(GHN_API + "/districts?provinceId=" + ghnProvinceId)
                        .then(r => r.json())
                        .then(json => {
                            if (json.code !== 200) return;
                            json.data.forEach(d => {
                                const dOpt = document.createElement("option");
                                dOpt.value       = d.DistrictName;
                                dOpt.textContent = d.DistrictName;
                                dOpt.dataset.ghnId = d.DistrictID;
                                districtSelect.appendChild(dOpt);
                            });
                            districtSelect.disabled = false;
                            // Tự động chọn quận đã lưu
                            if (savedDistrict) {
                                const dOpt = Array.from(districtSelect.options).find(o => o.value === savedDistrict);
                                if (dOpt) {
                                    districtSelect.value = savedDistrict;
                                    ghnDistrictIdInput.value = dOpt.dataset.ghnId || "";
                                    const ghnDistrictId = dOpt.dataset.ghnId;
                                    if (ghnDistrictId) {
                                        resetWard();
                                        fetch(GHN_API + "/wards?districtId=" + ghnDistrictId)
                                            .then(r => r.json())
                                            .then(wJson => {
                                                if (wJson.code !== 200) return;
                                                (wJson.data || []).forEach(w => {
                                                    const wOpt = document.createElement("option");
                                                    wOpt.value       = w.WardName;
                                                    wOpt.textContent = w.WardName;
                                                    wOpt.dataset.code = w.WardCode;
                                                    wardSelect.appendChild(wOpt);
                                                });
                                                wardSelect.disabled = false;
                                                // Tự động chọn phường đã lưu
                                                if (savedWard) {
                                                    const wOpt = Array.from(wardSelect.options).find(o => o.value === savedWard);
                                                    if (wOpt) {
                                                        wardSelect.value = savedWard;
                                                        ghnWardCodeInput.value = wOpt.dataset.code || "";
                                                        // Tính phí ship tự động
                                                        triggerFeeCalc(ghnDistrictId, wOpt.dataset.code);
                                                    }
                                                }
                                            });
                                    }
                                }
                            }
                        });
                }
            }
        }
        toggleRequiredFields(false);
        manualInputFields.style.opacity = "1";
    });

    // ─── Tính phí ship (gọi lại khi auto-fill địa chỉ đã lưu) ───────────────
    function triggerFeeCalc(districtId, wardCode) {
        if (!districtId) return;
        shippingFeeDisplay.textContent = "Đang tính...";
        fetch(GHN_API + "/fee?districtId=" + districtId + "&wardCode=" + (wardCode || ""))
            .then(r => r.json())
            .then(json => {
                if (json.code !== 200) {
                    shippingFeeDisplay.textContent = "Không tính được";
                    shippingFeeInput.value = 0;
                    return;
                }
                const fee = json.data.total || 0;
                shippingFeeInput.value = fee;
                shippingFeeDisplay.textContent = formatVND(fee) + " ₫";
                if (totalDisplay) {
                    totalDisplay.textContent = formatVND(subtotal + fee) + " ₫";
                }
            })
            .catch(() => { shippingFeeDisplay.textContent = "Lỗi"; });
    }

    // ─── Helpers ──────────────────────────────────────────────────────────────
    function resetProvince() {
        provinceSelect.value = "";
        ghnProvinceIdInput.value = "";
    }
    function resetDistrict() {
        districtSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
        districtSelect.disabled = true;
        ghnDistrictIdInput.value = "";
    }
    function resetWard() {
        wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
        wardSelect.disabled = true;
        ghnWardCodeInput.value = "";
    }
    function resetShippingFee() {
        if (shippingFeeDisplay) shippingFeeDisplay.textContent = "—";
        if (shippingFeeInput)   shippingFeeInput.value = 0;
        if (totalDisplay && subtotalEl) totalDisplay.textContent = formatVND(subtotal) + " ₫";
    }
    function toggleRequiredFields(isRequired) {
        manualInputFields.querySelectorAll('input, select').forEach(f => {
            if (isRequired) f.setAttribute('required', 'required');
            else            f.removeAttribute('required');
        });
    }
    function formatVND(n) {
        return Math.round(n).toLocaleString('vi-VN');
    }
</script>
</body>

</html>