package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Address;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.AddressService;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/AddAddressServlet")
public class AddAddressServlet extends HttpServlet {
    private final AddressService addressService = new AddressService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        //Lấy thông tin địa chỉ từ form
        String fullName = req.getParameter("fullName");
        String phoneNumber = req.getParameter("phoneNumber");
        String addressLine = req.getParameter("addressLine");
        String province = req.getParameter("province");
        String district = req.getParameter("district");
        boolean isDefault = req.getParameter("isDefault") != null;

        //Tạo đối tượng Address
        Address addr = new Address();
        addr.setUserId(user.getId());
        addr.setFullName(fullName);
        addr.setPhoneNumber(phoneNumber);
        addr.setAddressLine(addressLine);
        addr.setProvince(province);
        addr.setDistrict(district);
        addr.setDefaultAddress(isDefault);

        try {
            //Gọi Service để thêm địa chỉ
            boolean isAdded = addressService.addAddress(addr);
            if (isAdded) {
                req.getSession().setAttribute("success", "Thêm địa chỉ thành công!");
            } else {
                req.getSession().setAttribute("error", "Địa chỉ này đã tồn tại! Vui lòng kiểm tra lại.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi khi thêm địa chỉ!");
        }
        resp.sendRedirect(req.getContextPath() + "/personal?tab=addresses");
    }
}