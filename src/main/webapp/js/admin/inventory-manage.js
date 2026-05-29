document.addEventListener('DOMContentLoaded', () => {
    const ctx = (typeof contextPath !== 'undefined') ? contextPath : '';
    const API_MANAGE = ctx + '/admin/api/inventory-manage';
    const API_IMPORT = ctx + '/admin/api/inventory-import';
    let currentPage = 1;
    let currentLimit = 10;
    let currentSearch = '';
    let debounceTimer = null;
    const tableBody = document.querySelector('#inventoryTable tbody');
    const searchInput = document.querySelector('#searchInput');
    const paginationContainer = document.querySelector('#paginationContainer');
    const loadingSpinner = document.querySelector('#loadingSpinner');
    const importSubmitBtn = document.querySelector('#btnSubmitImport');
    const btnReload = document.querySelector('#btnReloadInventory');
    init();
    function init() {
        bindEvents();
        fetchInventoryData();
    }
    function bindEvents() {
        if (searchInput) {
            searchInput.addEventListener('keyup', (e) => {
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(() => {
                    currentSearch = e.target.value.trim();
                    currentPage = 1;
                    fetchInventoryData();
                }, 300);
            });
        }
        if (btnReload) {
            btnReload.addEventListener('click', () => {
                fetchInventoryData();
            });
        }
        if (importSubmitBtn) {
            importSubmitBtn.addEventListener('click', handleImportSubmit);
        }
        if (paginationContainer) {
            paginationContainer.addEventListener('click', (e) => {
                const target = e.target.closest('.page-link');
                if (!target) return;
                e.preventDefault();
                const page = parseInt(target.dataset.page);
                if (page && page !== currentPage) {
                    currentPage = page;
                    fetchInventoryData();
                }
            });
        }
    }
    async function fetchInventoryData() {
        showSpinner();
        try {
            const url = `${API_MANAGE}?page=${currentPage}&limit=${currentLimit}&search=${encodeURIComponent(currentSearch)}`;
            const response = await fetch(url, {
                method: 'GET',
                credentials: 'same-origin',
                headers: { 
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            });
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const result = await response.json();
            if (result.status === 'success') {
                renderInventoryTable(result.data);
                renderPagination(result.pagination);
            } else {
                showToast('error', result.message || 'Lỗi khi tải dữ liệu kho hàng.');
            }
        } catch (error) {
            (function(){})('Error fetching inventory:', error);
            showToast('error', 'Không thể kết nối đến máy chủ.');
            if (tableBody) {
                tableBody.innerHTML = `<tr><td colspan="9" class="text-center text-danger">Lỗi tải dữ liệu: ${error.message}</td></tr>`;
            }
        } finally {
            hideSpinner();
        }
    }
    function renderInventoryTable(data) {
        if (!tableBody) return;

        if (!data || data.length === 0) {
            tableBody.innerHTML = `<tr><td colspan="9" class="text-center text-danger">Không tìm thấy sản phẩm nào.</td></tr>`;
            return;
        }
        let html = '';
        data.forEach((item, index) => {
            let statusBadge = '';
            if (item.status === 'Hết hàng') {
                statusBadge = '<span class="badge bg-danger">Hết hàng</span>';
            } else if (item.status === 'Sắp hết hàng') {
                statusBadge = '<span class="badge bg-warning text-dark">Sắp hết hàng</span>';
            } else {
                statusBadge = `<span class="badge bg-success">${item.status || 'Còn hàng'}</span>`;
            }
            const imgHtml = item.imageUrl
                ? `<img src="${item.imageUrl}" alt="${item.productName}" class="img-thumbnail" style="width: 50px; height: 50px; object-fit: cover;" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';"><div style="display:none; width: 50px; height: 50px; background: #f8f9fa; align-items: center; justify-content: center; border: 1px dashed #ccc; border-radius: 4px;" class="img-thumbnail"><i class="bi bi-image text-muted"></i></div>`
                : `<div style="width: 50px; height: 50px; background: #f8f9fa; display: flex; align-items: center; justify-content: center; border: 1px dashed #ccc; border-radius: 4px;" class="img-thumbnail"><i class="bi bi-image text-muted"></i></div>`;

            html += `
                <tr>
                    <td class="align-middle">${(currentPage - 1) * currentLimit + index + 1}</td>
                    <td class="align-middle"><strong>#${item.id}</strong></td>
                    <td class="align-middle text-center">
                        ${imgHtml}
                    </td>
                    <td class="align-middle text-start">
                        <span class="d-block text-truncate" style="max-width: 250px;" title="${item.productName}">
                            ${item.productName}
                        </span>
                        <small class="text-muted">${item.categoryName || 'Không phân loại'}</small>
                    </td>
                    <td class="align-middle text-success font-weight-bold">+${item.totalImported}</td>
                    <td class="align-middle text-danger font-weight-bold">-${item.totalSold}</td>
                    <td class="align-middle">
                        <span class="fs-5 fw-bold ${item.currentStock <= 0 ? 'text-danger' : 'text-primary'}">
                            ${item.currentStock}
                        </span>
                    </td>
                    <td class="align-middle">${statusBadge}</td>
                    <td class="align-middle">
                        <button class="btn btn-sm btn-outline-info btn-view-chart" data-id="${item.id}" title="Xem biểu đồ">
                            <i class="fas fa-chart-line"></i>
                        </button>
                        <button class="btn btn-sm btn-primary btn-quick-import" data-id="${item.id}" data-name="${item.productName}" data-img="${item.imageUrl || ''}" title="Nhập kho nhanh">
                            <i class="fas fa-plus"></i> Nhập
                        </button>
                    </td>
                </tr>
            `;
        });
        tableBody.innerHTML = html;
        attachDynamicTableEvents();
    }
    function attachDynamicTableEvents() {
        document.querySelectorAll('.btn-view-chart').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const productId = e.currentTarget.dataset.id;
                window.location.href = ctx + '/admin/inventory-detail?id=' + productId;
            });
        });
        document.querySelectorAll('.btn-quick-import').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const btnEl = e.currentTarget;
                const productId = btnEl.dataset.id;
                const productName = btnEl.dataset.name;
                const productImg = btnEl.dataset.img;
                const inputProductId = document.getElementById('importProductId');
                const labelProductIdDisplay = document.getElementById('importProductIdDisplay');
                const labelProductName = document.getElementById('importProductName');
                const imgEl = document.getElementById('importProductImg');
                const placeholderEl = document.getElementById('importProductImgPlaceholder');
                if (inputProductId) inputProductId.value = productId;
                if (labelProductIdDisplay) labelProductIdDisplay.textContent = productId;
                if (labelProductName) labelProductName.textContent = productName;
                if (productImg && productImg.trim() !== '') {
                    if (imgEl) { imgEl.src = productImg; imgEl.style.display = 'block'; }
                    if (placeholderEl) placeholderEl.style.display = 'none';
                } else {
                    if (imgEl) imgEl.style.display = 'none';
                    if (placeholderEl) placeholderEl.style.display = 'flex';
                }
                if (typeof bootstrap !== 'undefined') {
                    const modalEl = document.getElementById('modalNhapKho');
                    if (modalEl) {
                        const modal = new bootstrap.Modal(modalEl);
                        modal.show();
                    }
                }
            });
        });
    }
    function renderPagination(paginationInfo) {
        if (!paginationContainer) return;
        const { currentPage, totalPages } = paginationInfo;
        if (totalPages <= 1) {
            paginationContainer.innerHTML = '';
            return;
        }
        let html = '<ul class="pagination justify-content-end mb-0">';
        html += `
            <li class="page-item ${currentPage === 1 ? 'disabled' : ''}">
                <a class="page-link" href="#" data-page="${currentPage - 1}">Trước</a>
            </li>
        `;
        for (let i = 1; i <= totalPages; i++) {
            html += `
                <li class="page-item ${i === currentPage ? 'active' : ''}">
                    <a class="page-link" href="#" data-page="${i}">${i}</a>
                </li>
            `;
        }
        html += `
            <li class="page-item ${currentPage === totalPages ? 'disabled' : ''}">
                <a class="page-link" href="#" data-page="${currentPage + 1}">Sau</a>
            </li>
        `;
        html += '</ul>';
        paginationContainer.innerHTML = html;
    }
    async function handleImportSubmit(e) {
        e.preventDefault();
        const productIdEl = document.getElementById('importProductId');
        const quantityEl = document.getElementById('importQuantity');
        const importPriceEl = document.getElementById('importPrice');
        const noteEl = document.getElementById('importNote');
        if (!productIdEl || !quantityEl || !importPriceEl) {
            showToast('error', 'Lỗi giao diện: Không tìm thấy trường dữ liệu.');
            return;
        }
        const productId = productIdEl.value.trim();
        const quantity = parseInt(quantityEl.value.trim());
        const importPrice = parseFloat(importPriceEl.value.trim());
        const note = noteEl ? noteEl.value.trim() : '';
        if (!productId) {
            showToast('warning', 'Vui lòng chọn hoặc nhập ID sản phẩm.');
            return;
        }
        if (isNaN(quantity) || quantity <= 0) {
            showToast('warning', 'Số lượng nhập phải là số lớn hơn 0.');
            quantityEl.focus();
            return;
        }
        if (isNaN(importPrice) || importPrice < 0) {
            showToast('warning', 'Giá nhập phải là số không âm.');
            importPriceEl.focus();
            return;
        }
        importSubmitBtn.disabled = true;
        importSubmitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
        try {
            const payload = {
                productId: parseInt(productId),
                quantity: quantity,
                importPrice: importPrice,
                note: note
            };
            const response = await fetch(API_IMPORT, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(payload)
            });
            const result = await response.json();
            if (response.ok && result.status === 'success') {
                if (typeof bootstrap !== 'undefined') {
                    const modalEl = document.getElementById('modalNhapKho');
                    if (modalEl) {
                        const modal = bootstrap.Modal.getInstance(modalEl);
                        if (modal) modal.hide();
                    }
                }
                document.getElementById('formImport').reset();
                if (typeof Swal !== 'undefined') {
                    Swal.fire({
                        icon: 'success',
                        title: 'Thành công!',
                        text: result.message,
                        timer: 2000,
                        showConfirmButton: false
                    });
                } else {
                    alert(result.message);
                }
                fetchInventoryData();
            } else {
                throw new Error(result.message || 'Có lỗi xảy ra từ server.');
            }
        } catch (error) {
            (function(){})('Import Error:', error);
            if (typeof Swal !== 'undefined') {
                Swal.fire({
                    icon: 'error',
                    title: 'Thất bại',
                    text: error.message
                });
            } else {
                alert('Lỗi: ' + error.message);
            }
        } finally {
            importSubmitBtn.disabled = false;
            importSubmitBtn.innerHTML = 'Xác nhận nhập kho';
        }
    }
    function showSpinner() {
        if (loadingSpinner) loadingSpinner.style.display = 'block';
    }
    function hideSpinner() {
        if (loadingSpinner) loadingSpinner.style.display = 'none';
    }
    function showToast(type, message) {
        if (typeof Swal !== 'undefined') {
            const Toast = Swal.mixin({
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 3000,
                timerProgressBar: true
            });
            Toast.fire({
                icon: type,
                title: message
            });
        } else {
            alert(`[${type.toUpperCase()}] ${message}`);
        }
    }
});