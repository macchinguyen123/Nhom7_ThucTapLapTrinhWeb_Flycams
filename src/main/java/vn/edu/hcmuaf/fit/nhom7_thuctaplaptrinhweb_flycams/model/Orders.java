package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.List;

public class Orders implements Serializable {
    private int id;
    private int userId;
    private String shippingCode;
    private double totalPrice;
    private Status status;
    private Integer addressId;
    private String phoneNumber;
    private Timestamp createdAt;
    private String paymentMethod;
    private Timestamp completedAt;
    private String note;

    public enum Status {
        PENDING("Xác nhận"),
        PROCESSING("Đang xử lý"),
        OUT_FOR_DELIVERY("Đang giao"),
        DELIVERED("Hoàn thành"),
        CANCELLED("Hủy");

        private final String dbValue;

        Status(String dbValue) {
            this.dbValue = dbValue;
        }

        public String toDB() {
            return dbValue;
        }

        public static Status fromDB(String dbValue) {
            if (dbValue == null) return null;

            return switch (dbValue) {
                case "Xác nhận" -> PENDING;
                case "Đang xử lý" -> PROCESSING;
                case "Đang giao" -> OUT_FOR_DELIVERY;
                case "Hoàn thành" -> DELIVERED;
                case "Hủy" -> CANCELLED;
                default -> PENDING;
            };
        }
    }


    // getter/setter
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getShippingCode() {
        return shippingCode;
    }

    public void setShippingCode(String shippingCode) {
        this.shippingCode = shippingCode;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public Integer getAddressId() {
        return addressId;
    }

    public void setAddressId(Integer addressId) {
        this.addressId = addressId;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

    public String getNote() {
        return note;
    }

    private String customerName;

    // THÊM 2 FIELD PHỤ CHO VIEW
    private String statusLabel;
    private String statusClass;

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getStatusLabel() {
        return statusLabel;
    }

    public void setStatusLabel(String statusLabel) {
        this.statusLabel = statusLabel;
    }

    public String getStatusClass() {
        return statusClass;
    }

    public void setStatusClass(String statusClass) {
        this.statusClass = statusClass;
    }

    public void setNote(String note) {
        this.note = note;
    }

    //thêm danh sách sản phẩm
    private List<OrderItems> items;

    public List<OrderItems> getItems() {
        return items;
    }

    public void setItems(List<OrderItems> items) {
        this.items = items;
    }

    //thêm để hiển thị (không map DB)
    private String fullAddress;

    public String getFullAddress() {
        return fullAddress;
    }

    public void setFullAddress(String fullAddress) {
        this.fullAddress = fullAddress;
    }

}
