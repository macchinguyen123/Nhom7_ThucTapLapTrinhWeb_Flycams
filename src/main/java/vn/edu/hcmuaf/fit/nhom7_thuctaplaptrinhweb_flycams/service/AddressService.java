package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service;

import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.AddressDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Address;

import java.sql.SQLException;
import java.util.List;

public class AddressService {
    private AddressDAO addressDAO = new AddressDAO();

    //Lấy danh sách địa chỉ theo userId
    public List<Address> findByUserId(int userId) throws SQLException {
        return addressDAO.findByUserId(userId);
    }

    //Lấy danh sách địa chỉ theo userId
    public boolean addAddress(Address newAddress) throws SQLException {
        List<Address> existingAddresses = addressDAO.findByUserId(newAddress.getUserId());
        for (Address existing : existingAddresses) {
            if (isDuplicateAddress(existing, newAddress)) {
                return false;
            }
        }

        if (newAddress.isDefaultAddress()) {
            addressDAO.resetDefault(newAddress.getUserId());
        }

        addressDAO.insert(newAddress);
        return true;
    }

    //Xóa địa chỉ theo addressId và userId
    public boolean deleteAddress(int addressId, int userId) throws SQLException {
        return addressDAO.delete(addressId, userId);
    }

    //Xử lý địa chỉ khi checkout
    public int processCheckoutAddress(int userId, String savedAddrId, String fullName, String phone, String addr,
                                      String prov, String ward) throws Exception {
        // 1. NẾU CHỌN ĐỊA CHỈ CÓ SẴN
        if (savedAddrId != null && !savedAddrId.isEmpty()) {
            return Integer.parseInt(savedAddrId);
        }

        // 2. TẠO ĐỊA CHỈ MỚI
        Address address = new Address();
        address.setUserId(userId);
        address.setFullName(fullName);
        address.setPhoneNumber(phone);
        address.setAddressLine(addr);
        address.setProvince(prov);
        address.setDistrict(ward);
        address.setDefaultAddress(false);

        int newId = addressDAO.insertID(address);
        if (newId <= 0) {
            throw new Exception("Insert address failed");
        }
        return newId;
    }

    //Cập nhật thông tin địa chỉ
    public boolean updateAddress(Address addr) throws SQLException {
        List<Address> existingAddresses = addressDAO.findByUserId(addr.getUserId());
        for (Address existing : existingAddresses) {
            if (existing.getId() == addr.getId())
                continue;

            if (isDuplicateAddress(existing, addr)) {
                return false;
            }
        }

        if (addr.isDefaultAddress()) {
            addressDAO.resetDefault(addr.getUserId());
        }

        addressDAO.update(addr);
        return true;
    }

    //Kiểm tra hai địa chỉ có bị trùng hay không
    private boolean isDuplicateAddress(Address existing, Address newAddress) {
        String existingAddr = normalizeString(existing.getAddressLine());
        String newAddr = normalizeString(newAddress.getAddressLine());

        String existingProv = normalizeString(existing.getProvince());
        String newProv = normalizeString(newAddress.getProvince());

        String existingDist = normalizeString(existing.getDistrict());
        String newDist = normalizeString(newAddress.getDistrict());

        return existingAddr.equals(newAddr)
                && existingProv.equals(newProv)
                && existingDist.equals(newDist);
    }

    //Chuẩn hóa chuỗi để so sánh
    private String normalizeString(String str) {
        if (str == null)
            return "";
        return str.trim()
                .toLowerCase()
                .replaceAll("\\s+", " ");
    }
}
