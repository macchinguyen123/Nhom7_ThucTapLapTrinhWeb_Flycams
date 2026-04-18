document.addEventListener("DOMContentLoaded", function () {
    function mapStatus(value) {
        switch (value) {
            case "Đang Kinh Doanh": return "active";
            case "Ẩn": return "inactive";
            case "Hết Hàng": return "soldout";
            default: return "active";
        }
    }
    document.getElementById("btnSaveProduct").addEventListener("click", function () {
        if (typeof validateProductForm === 'function' && !validateProductForm()) {
            return;
        }
        const moTa = window.descriptionEditor
            ? window.descriptionEditor.getData()
                .replace(/<[^>]*>/g, '')
                .replace(/&nbsp;/g, '')
                .trim()
            : document.getElementById("moTa").value.trim();
        const thongSo = window.parameterEditor
            ? window.parameterEditor.getData().replace(/<[^>]*>/g, '').trim()
            : document.getElementById("thongSo").value.trim();
        if (!moTa) {
            showToast('Vui lòng nhập mô tả chi tiết!', 'warning');
            return;
        }
        if (!thongSo) {
            showToast('Vui lòng nhập thông số kỹ thuật!', 'warning');
            return;
        }
        const data = {
            id: parseInt(document.getElementById("productId").value) || 0,
            productName: document.getElementById("tenSP").value,
            brandName: document.getElementById("thuongHieu").value,
            categoryId: parseInt(document.getElementById("danhMuc").value),
            status: mapStatus(document.getElementById("trangThai").value),
            price: parseFloat(document.getElementById("giaGoc").value),
            finalPrice: document.getElementById("giaKM").value !== "" ? parseFloat(document.getElementById("giaKM").value) : parseFloat(document.getElementById("giaGoc").value),
            quantity: parseInt(document.getElementById("soLuong").value),
            description: (window.descriptionEditor) ? window.descriptionEditor.getData() : document.getElementById("moTa").value,
            parameter: (window.parameterEditor) ? window.parameterEditor.getData() : document.getElementById("thongSo").value,
            warranty: document.getElementById("baoHanh").value,
            mainImage: document.getElementById("anhChinh").value,
            images: [...document.querySelectorAll(".image-extra")]
                .map(input => ({ imageUrl: input.value }))
                .filter(img => img.imageUrl !== "" && img.imageUrl !== document.getElementById("anhChinh").value)
        };
        fetch(contextPath + "/admin/product-save", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(data)
        })
            .then(res => res.json())
            .then(res => {
                if (res.success) {
                    Swal.fire({
                        title: "Thành công!",
                        text: data.id === 0 ? "Sản phẩm đã được thêm thành công." : "Sản phẩm đã được cập nhật thành công.",
                        icon: "success",
                        confirmButtonText: "OK"
                    }).then(() => {
                        location.reload();
                    });
                } else {
                    Swal.fire({
                        title: "Lỗi!",
                        text: res.message,
                        icon: "error",
                        confirmButtonText: "OK"
                    });
                }
            })
            .catch(err => {
                Swal.fire({
                    title: "Lỗi!",
                    text: "Có lỗi xảy ra. Vui lòng thử lại.",
                    icon: "error",
                    confirmButtonText: "OK"
                });
                console.error(err);
            });
    });
});