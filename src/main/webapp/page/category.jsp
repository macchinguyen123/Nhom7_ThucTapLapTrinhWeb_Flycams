<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Danh Mục</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/common-category.css">
</head>
<body>
<jsp:include page="/page/header-common.jsp"/>
<section class="phan-san-pham">
    <h2 class="tieu-de-muc">${category.categoryName}</h2>
    <form id="filter-form" method="get" action="Category">
        <input type="hidden" name="id" value="${param.id}">
        <input type="hidden" name="sort" id="sort-input" value="${param.sort}">
        <div class="bo-loc-va-sap-xep position-relative">
            <button type="button" class="nut-bo-loc btn btn-outline-primary">
                <i class="bi bi-funnel"></i> Bộ lọc
            </button>
            <div class="hop-loc" id="hop-loc">
                <h6><i class="bi bi-funnel"></i> Lọc theo giá</h6>
                <hr class="my-2">
                <div class="danh-sach-loc">
                    <label><input type="radio" name="chon-gia" value="tat-ca" <c:if
                            test="${param['chon-gia']=='tat-ca'}">checked</c:if>> Tất cả</label>
                    <label><input type="radio" name="chon-gia" value="duoi-5000000" <c:if
                            test="${param['chon-gia']=='duoi-5000000'}">checked</c:if>> Dưới 5.000.000 ₫</label>
                    <label><input type="radio" name="chon-gia" value="5-10" <c:if
                            test="${param['chon-gia']=='5-10'}">checked</c:if>> 5.000.000 ₫ - 10.000.000 ₫</label>
                    <label><input type="radio" name="chon-gia" value="10-20" <c:if
                            test="${param['chon-gia']=='10-20'}">checked</c:if>> 10.000.000 ₫ - 20.000.000 ₫</label>
                    <label><input type="radio" name="chon-gia" value="tren-20" <c:if
                            test="${param['chon-gia']=='tren-20'}">checked</c:if>> Trên 20.000.000 ₫</label>
                    <p><b>Nhập vào khoảng giá bạn muốn</b></p>
                    <div class="d-flex align-items-center gap-1">
                        <input type="number" name="gia-tu" id="gia-tu"
                               class="form-control form-control-sm" value="${param['gia-tu']}"
                               placeholder="Từ ₫" style="width: 100px;">
                        <span>-</span>
                        <input type="number" name="gia-den" id="gia-den"
                               class="form-control form-control-sm" value="${param['gia-den']}"
                               placeholder="Đến ₫" style="width: 100px;">
                    </div>
                    <hr class="my-2">
                    <h6><i class="bi bi-box"></i> Lọc theo thương hiệu</h6>
                    <hr class="my-2">
                    <div class="row mt-2">
                        <c:set var="brands" value="${paramValues['chon-thuong-hieu']}"/>
                        <div class="col-6">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="chon-thuong-hieu"
                                       value="DJI"
                                       <c:if test="${fn:contains(brands,'DJI')}">checked</c:if>>
                                <label class="form-check-label">DJI</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="chon-thuong-hieu"
                                       value="Autel Robotics" <c:if
                                               test="${fn:contains(brands,'Autel Robotics')}">checked</c:if>>
                                <label class="form-check-label">Autel Robotics</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="chon-thuong-hieu"
                                       value="Parrot" <c:if test="${fn:contains(brands,'Parrot')}">checked
                                </c:if>>
                                <label class="form-check-label">Parrot</label>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="chon-thuong-hieu"
                                       value="Skydio" <c:if test="${fn:contains(brands,'Skydio')}">checked
                                </c:if>>
                                <label class="form-check-label">Skydio</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="chon-thuong-hieu"
                                       value="Xiaomi" <c:if test="${fn:contains(brands,'Xiaomi')}">checked
                                </c:if>>
                                <label class="form-check-label">Xiaomi</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" name="chon-thuong-hieu"
                                       value="Khác" <c:if test="${fn:contains(brands,'Khác')}">checked
                                </c:if>>
                                <label class="form-check-label">Khác</label>
                            </div>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-sm btn-primary mt-2">Áp dụng</button>
                </div>
            </div>
            <div class="sap-xep-theo">
                <span>Sắp xếp theo:</span>
                <button type="button" class="btn-sap-xep ${empty param.sort?'active':''}"
                        onclick="submitSort('')">Nổi bật
                </button>
                <button type="button" class="btn-sap-xep ${param.sort=='asc'?'active':''}"
                        onclick="submitSort('asc')">Giá Thấp → Cao
                </button>
                <button type="button" class="btn-sap-xep ${param.sort=='desc'?'active':''}"
                        onclick="submitSort('desc')">Giá Cao → Thấp
                </button>
            </div>
        </div>
    </form>
    <div class="khung-san-pham">
        <c:forEach var="p" items="${products}">
            <div class="san-pham">
                <a class="link-chi-tiet"
                   href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                    <div class="khung-anh">
                        <c:choose>
                            <c:when test="${not empty p.mainImage}">
                                <img src="${p.mainImage}" alt="${p.productName}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/no-image.png"
                                     alt="No Image">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <h3 class="ten-san-pham">${p.productName}</h3>
                    <div class="gia">
                        <b>${formatter.format(p.finalPrice)} ₫</b>

                        <c:if test="${p.price > p.finalPrice}">
                                            <span class="gia-goc">
                                                ${formatter.format(p.price)} ₫
                                            </span>
                        </c:if>
                    </div>
                </a>
                <c:set var="fullStars1" value="${p.avgRating.intValue()}"/>
                <c:set var="hasHalfStar1" value="${p.avgRating - fullStars1 >= 0.5}"/>
                <div class="hang-danh-gia">
                    <div class="danh-gia-sao">
                        <c:forEach begin="1" end="${fullStars1}">
                            <i class="bi bi-star-fill"></i>
                        </c:forEach>
                        <c:if test="${hasHalfStar1}">
                            <i class="bi bi-star-half"></i>
                        </c:if>
                        <c:forEach begin="1" end="${5 - fullStars1 - (hasHalfStar1 ? 1 : 0)}">
                            <i class="bi bi-star"></i>
                        </c:forEach>
                    </div>
                    <c:choose>
                        <c:when
                                test="${wishlistProductIds != null && wishlistProductIds.contains(p.id)}">
                            <i class="bi bi-heart-fill tim-yeu-thich yeu-thich"
                               data-product-id="${p.id}"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-heart tim-yeu-thich" data-product-id="${p.id}"></i>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="so-danh-gia">
                    (${empty p.reviewCount ? 0 : p.reviewCount} đánh giá)
                </div>
                <form action="${pageContext.request.contextPath}/add-cart" method="get">
                    <input type="hidden" name="productId" value="${p.id}">
                    <input type="hidden" name="quantity" value="1">
                    <button type="submit" class="nut-mua-ngay">
                        <i class="bi bi-cart-plus"></i>Thêm vào giỏ
                    </button>
                </form>
            </div>
        </c:forEach>
    </div>
    <div class="phan-trang text-center mt-4">
        <button class="btn btn-outline-primary nut-truoc">« Trang trước</button>
        <span class="so-trang-hien-tai mx-3">Trang <span id="trang-hien-tai">1</span> / <span
                id="tong-trang"></span></span>
        <button class="btn btn-outline-primary nut-sau">Trang sau »</button>
    </div>
</section>
<jsp:include page="/page/footer.jsp"/>
<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>
<script>
    document.querySelectorAll('.tim-yeu-thich').forEach(tim => {
        tim.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            const productId = this.getAttribute('data-product-id');
            const isLiked = this.classList.contains('yeu-thich');
            const action = isLiked ? 'remove' : 'add';
            console.log('SEND:', action, productId);
            if (!productId) {
                console.error('productId is null');
                return;
            }
            fetch('${pageContext.request.contextPath}/wishlist', {
                method: 'POST',
                credentials: 'same-origin',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: new URLSearchParams({
                    action: action,
                    productId: productId
                })
            })
                .then(res => {
                    if (res.status === 401) {
                        window.location.href = '${pageContext.request.contextPath}/Login';
                        return;
                    }
                    return res.json();
                })
                .then(data => {
                    if (data.success) {
                        this.classList.toggle('bi-heart');
                        this.classList.toggle('bi-heart-fill');
                        this.classList.toggle('yeu-thich');
                    }
                });
        });
    });
</script>
<script>
    const nutSapXep = document.querySelectorAll('.btn-sap-xep');
    nutSapXep.forEach(btn => {
        btn.addEventListener('click', () => {
            nutSapXep.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            console.log("🔹 Đã chọn:", btn.textContent.trim());
        });
    });
    const sanPhams = document.querySelectorAll('.san-pham');
    const spMoiTrang = 20; // số sản phẩm mỗi trang
    let trangHienTai = 1;
    const tongTrang = Math.ceil(sanPhams.length / spMoiTrang);
    const spanTrang = document.getElementById('trang-hien-tai');
    const spanTongTrang = document.getElementById('tong-trang');
    spanTongTrang.textContent = tongTrang;

    function hienThiTrang(trang) {
        sanPhams.forEach((sp, index) => {
            if (index >= (trang - 1) * spMoiTrang && index < trang * spMoiTrang) {
                sp.style.display = ''; // giữ nguyên layout gốc (grid/flex)
                sp.style.visibility = 'visible';
            } else {
                sp.style.display = 'none'; // ẩn hẳn phần tử ngoài trang hiện tại
            }
        });
        spanTrang.textContent = trang;
    }

    document.querySelector('.nut-truoc').addEventListener('click', () => {
        if (trangHienTai > 1) {
            trangHienTai--;
            hienThiTrang(trangHienTai);
        }
    });
    document.querySelector('.nut-sau').addEventListener('click', () => {
        if (trangHienTai < tongTrang) {
            trangHienTai++;
            hienThiTrang(trangHienTai);
        }
    });
    const nutBoLoc = document.querySelector('.nut-bo-loc');
    const hopLoc = document.getElementById('hop-loc');
    const radioLocGia = document.getElementsByName('chon-gia');
    const nhapGiaDiv = document.getElementById('nhap-gia-tuy-chinh');
    const btnApDung = document.getElementById('btn-ap-dung-gia');
    const inputTu = document.getElementById('gia-tu');
    const inputDen = document.getElementById('gia-den');
    // Toggle cửa sổ khi nhấn nút "Bộ lọc"
    nutBoLoc.addEventListener('click', () => {
        hopLoc.classList.toggle('hien');
    });
    // Ẩn khi click ra ngoài
    document.addEventListener('click', (e) => {
        if (!hopLoc.contains(e.target) && !nutBoLoc.contains(e.target)) {
            hopLoc.classList.remove('hien');
        }
    });
    // Hiển thị trang đầu tiên khi tải trang
    hienThiTrang(trangHienTai);
</script>
<script>
    function submitSort(sortValue) {
        document.getElementById('sort-input').value = sortValue;
        document.getElementById('filter-form').submit();
    }

    // Toggle hiển thị bộ lọc
    document.querySelector('.nut-bo-loc').addEventListener('click', function () {
        document.getElementById('hop-loc').classList.toggle('show');
    });
</script>
</body>
</html>