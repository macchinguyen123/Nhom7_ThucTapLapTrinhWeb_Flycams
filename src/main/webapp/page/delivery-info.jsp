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
                <a href="http://localhost:8080/Nhom12LapTrinhWebFlycams/page/shoppingcart.jsp">Giỏ hàng</a> &nbsp;>&nbsp;
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
                            ${a.defaultAddress ? "selected" : "" }>
                                ${a.phoneNumber}, ${a.addressLine}, ${a.province}, ${a.district}
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
                    <select name="ward" id="ward" class="form-select" required disabled>
                        <option value="">-- Chọn Phường/Xã --</option>
                    </select>
                </div>
                <input type="hidden" name="province_code" id="provinceCodeInput">
                <input type="hidden" name="ward_code" id="wardCodeInput">
            </div>
            <div class="mt-3">
                                    <textarea name="note" rows="5" class="form-control"
                                              placeholder="Nhập ghi chú của bạn..."></textarea>
            </div>
            <button type="submit" class="btn btn-primary w-100 mt-3">Tiếp tục đến phương thức thanh toán
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
                <span>—</span>
            </div>
            <hr>
            <div class="d-flex justify-content-between fw-bold total">
                <span>Tổng cộng</span>
                <span>
                                        <fmt:formatNumber value="${total}" type="number"/> ₫
                                    </span>
            </div>
        </c:if>
    </div>
</div>
<script>
    const API_BASE = "${pageContext.request.contextPath}/api/provinces";
    const provinceSelect = document.getElementById("province");
    const wardSelect = document.getElementById("ward");
    const savedAddressSelect = document.getElementById("savedAddress");
    const fullNameInput = document.getElementById("fullName");
    const phoneInput = document.getElementById("phoneNumber");
    const addressInput = document.getElementById("addressLine");
    const manualInputFields = document.getElementById("manualInputFields");
    let provincesLoaded = false;
    console.log("Loading provinces from:", API_BASE);
    fetch(API_BASE)
        .then(res => {
            console.log("Province response status:", res.status);
            if (!res.ok) throw new Error("HTTP " + res.status);
            return res.json();
        })
        .then(provinces => {
            console.log("Loaded provinces:", provinces.length);
            provinces.forEach(p => {
                const opt = document.createElement("option");
                opt.value = p.name;
                opt.textContent = p.name;
                opt.dataset.code = p.code;
                provinceSelect.appendChild(opt);
            });
            provincesLoaded = true;
            console.log("Provinces loaded, checking for saved address...");
            // Trigger saved address nếu có
            if (savedAddressSelect.value) {
                console.log("Found saved address, triggering change event");
                setTimeout(function () {
                    savedAddressSelect.dispatchEvent(new Event('change'));
                }, 500);
            }
        })
        .catch(err => {
            console.error("Lỗi load tỉnh:", err);
            alert("Không thể tải danh sách tỉnh/thành phố: " + err.message);
        });
    provinceSelect.addEventListener("change", function () {
        const selectedOption = this.options[this.selectedIndex];
        const code = selectedOption.dataset.code;
        console.log("Selected province:", selectedOption.value, "Code:", code);
        document.getElementById("provinceCodeInput").value = code || '';
        wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
        wardSelect.disabled = true;
        document.getElementById("wardCodeInput").value = '';
        if (!code) {
            console.log("No code selected");
            return;
        }
        const wardsUrl = API_BASE + "/p/" + code + "?depth=2";
        console.log("Loading wards from:", wardsUrl);
        fetch(wardsUrl)
            .then(res => {
                console.log("Wards response status:", res.status);
                if (!res.ok) {
                    return res.text().then(text => {
                        console.error("Error response:", text);
                        throw new Error("HTTP " + res.status + ": " + text);
                    });
                }
                return res.json();
            })
            .then(data => {
                console.log("Full response data:", data);
                if (data.wards && Array.isArray(data.wards) && data.wards.length > 0) {
                    data.wards.forEach(function (w) {
                        const opt = document.createElement("option");
                        opt.value = w.name;
                        opt.textContent = w.name;
                        opt.dataset.code = w.code;
                        wardSelect.appendChild(opt);
                    });
                    wardSelect.disabled = false;
                    console.log("Successfully loaded " + data.wards.length + " wards");
                } else {
                    console.warn("No wards found in response");
                    alert("Không có phường/xã cho tỉnh này");
                }
            })
            .catch(err => {
                console.error("Lỗi load phường/xã:", err);
                alert("Không thể tải danh sách phường/xã: " + err.message);
            });
    });
    wardSelect.addEventListener("change", function () {
        const selectedOption = this.options[this.selectedIndex];
        const code = selectedOption.dataset.code;
        console.log("Selected ward:", selectedOption.value, "Code:", code);
        document.getElementById("wardCodeInput").value = code || '';
    });

    function toggleRequiredFields(isRequired) {
        const fields = manualInputFields.querySelectorAll('input, select');
        fields.forEach(function (field) {
            if (isRequired) {
                field.setAttribute('required', 'required');
            } else {
                field.removeAttribute('required');
            }
        });
    }

    savedAddressSelect.addEventListener("change", function () {
        const opt = this.options[this.selectedIndex];
        console.log("Saved address change triggered, value:", opt.value);
        if (!opt.value) {
            fullNameInput.value = "";
            phoneInput.value = "";
            addressInput.value = "";
            provinceSelect.value = "";
            wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
            wardSelect.disabled = true;
            document.getElementById("provinceCodeInput").value = '';
            document.getElementById("wardCodeInput").value = '';
            toggleRequiredFields(true);
            manualInputFields.style.opacity = "1";
            return;
        }
        // Fill thông tin cơ bản
        fullNameInput.value = opt.dataset.name || "";
        phoneInput.value = opt.dataset.phone || "";
        addressInput.value = opt.dataset.address || "";
        const provinceName = opt.dataset.province || "";
        const districtName = opt.dataset.district || "";
        console.log("Saved address - Province:", provinceName, "District:", districtName);
        if (provinceName) {
            if (!provincesLoaded) {
                console.warn("Provinces not loaded yet, retrying in 1 second...");
                setTimeout(function () {
                    savedAddressSelect.dispatchEvent(new Event('change'));
                }, 1000);
                return;
            }
            const provinceOptions = Array.from(provinceSelect.options);
            console.log("Available provinces:", provinceOptions.length);
            const matchingProvince = provinceOptions.find(function (o) {
                return o.value === provinceName;
            });
            console.log("Found matching province?", matchingProvince ? "YES" : "NO");
            if (matchingProvince) {
                provinceSelect.value = provinceName;
                const code = matchingProvince.dataset.code;
                console.log("Setting province:", provinceName, "Code:", code);
                document.getElementById("provinceCodeInput").value = code;
                const wardsUrl = API_BASE + "/p/" + code + "?depth=2";
                console.log("Loading wards from:", wardsUrl);
                fetch(wardsUrl)
                    .then(function (res) {
                        if (!res.ok) throw new Error("HTTP " + res.status);
                        return res.json();
                    })
                    .then(function (data) {
                        console.log("Wards data:", data);
                        if (data.wards && data.wards.length > 0) {
                            wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                            data.wards.forEach(function (w) {
                                const wardOpt = document.createElement("option");
                                wardOpt.value = w.name;
                                wardOpt.textContent = w.name;
                                wardOpt.dataset.code = w.code;
                                wardSelect.appendChild(wardOpt);
                            });
                            wardSelect.disabled = false;
                            console.log("Added", data.wards.length, "wards");
                            if (districtName) {
                                console.log("Looking for ward:", districtName);
                                let foundWard = false;
                                for (let i = 0; i < wardSelect.options.length; i++) {
                                    if (wardSelect.options[i].value === districtName) {
                                        wardSelect.selectedIndex = i;
                                        const wardCode = wardSelect.options[i].dataset.code;
                                        document.getElementById("wardCodeInput").value = wardCode;
                                        console.log("Found and selected ward:", districtName, "Code:", wardCode);
                                        foundWard = true;
                                        break;
                                    }
                                }
                                if (!foundWard) {
                                    console.warn("Ward not found:", districtName);
                                }
                            }
                        } else {
                            console.warn("No wards in response");
                        }
                    })
                    .catch(function (err) {
                        console.error("Error loading wards:", err);
                    });
            } else {
                console.error("Province not found in list:", provinceName);
            }
        }
        toggleRequiredFields(false);
        manualInputFields.style.opacity = "1";
    });
    window.addEventListener('DOMContentLoaded', function () {
        console.log("Page loaded");
        console.log("API_BASE:", API_BASE);
        console.log("Saved address value:", savedAddressSelect.value);
    });
</script>
</body>
</html>