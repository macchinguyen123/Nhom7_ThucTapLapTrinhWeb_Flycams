package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.cart.Carts;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.User;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.LoginHistory;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.LoginHistoryDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.AuthService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.CartService;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.LoginAttemptService;

import java.io.IOException;

@WebServlet(name = "Login", value = "/Login")
public class Login extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/page/login.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String input = request.getParameter("loginInput");
        String password = request.getParameter("password");
        boolean isPossibleEmail = input.contains("@");
        boolean isPossiblePhone = input.matches("\\d+");

        if (isPossibleEmail) {
            if (!vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.validate.Validator.isValidEmail(input)) {
                request.setAttribute("error", "Email không đúng định dạng. Vui lòng kiểm tra lại.");
                request.getRequestDispatcher("/page/login.jsp").forward(request, response);
                return;
            }
        } else if (isPossiblePhone) {
            if (!vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.validate.Validator.isValidPhoneNumber(input)) {
                request.setAttribute("error", "Số điện thoại không đúng định dạng. Vui lòng kiểm tra lại.");
                request.getRequestDispatcher("/page/login.jsp").forward(request, response);
                return;
            }
        } else {
            request.setAttribute("error", "Vui lòng nhập đúng định dạng Email hoặc Số điện thoại.");
            request.getRequestDispatcher("/page/login.jsp").forward(request, response);
            return;
        }

        if (LoginAttemptService.isLocked(input)) {
            long remainingMillis = LoginAttemptService.getRemainingLockTime(input);
            long remainingMinutes = (remainingMillis / 1000) / 60;
            long remainingSeconds = (remainingMillis / 1000) % 60;
            String errorMsg = String.format("Tài khoản của bạn tạm thời bị khóa do nhập sai mật khẩu quá 5 lần. Vui lòng thử lại sau %d phút %d giây.", remainingMinutes, remainingSeconds);
            request.setAttribute("error", errorMsg);
            request.getRequestDispatcher("/page/login.jsp").forward(request, response);
            return;
        }
        AuthService authService = new AuthService();
        User user = authService.login(input, password);
        String ipAddress = request.getRemoteAddr();
        String userAgent = request.getHeader("User-Agent");
        String parsedUA = LoginHistory.parseUserAgent(userAgent);
        String location = LoginHistory.getIpLocation(ipAddress);
        LoginHistoryDAO loginHistoryDAO = new LoginHistoryDAO();
        if (user == null) {
            LoginAttemptService.failAttempt(input);
            User targetUser = new UserDAO().getUserByEmailOrPhone(input);
            LoginHistory failLog = new LoginHistory();
            if (targetUser != null) {
                failLog.setUserId(targetUser.getId());
                failLog.setUsername(targetUser.getUsername());
            } else {
                failLog.setUserId(null);
                failLog.setUsername(input);
            }
            failLog.setIpAddress(ipAddress);
            failLog.setUserAgent(parsedUA);
            failLog.setLocation(location);
            failLog.setStatus("Failure");
            loginHistoryDAO.insert(failLog);
            if (LoginAttemptService.isLocked(input)) {
                String msg = "Tài khoản của bạn đã bị khóa tạm thời trong 5 phút do nhập sai mật khẩu quá 5 lần.";
                request.setAttribute("error", msg);
            } else {
                String msg = "Thông tin đăng nhập chưa hợp lệ";
                request.setAttribute("error", msg);
            }
            request.getRequestDispatcher("/page/login.jsp").forward(request, response);
            return;
        }
        LoginAttemptService.successAttempt(input);
        if (!user.isStatus()) {
            LoginHistory lockedLog = new LoginHistory();
            lockedLog.setUserId(user.getId());
            lockedLog.setUsername(user.getUsername());
            lockedLog.setIpAddress(ipAddress);
            lockedLog.setUserAgent(parsedUA);
            lockedLog.setLocation(location);
            lockedLog.setStatus("Failure (Locked)");
            loginHistoryDAO.insert(lockedLog);
            String reason = user.getLockReason() != null ? user.getLockReason() : "Vi phạm chính sách.";
            request.setAttribute("lockedError", "Tài khoản bạn đã bị khoá");
            request.setAttribute("lockReason", reason);
            request.setAttribute("lockedUserId", user.getId());
            request.getRequestDispatcher("/page/login.jsp").forward(request, response);
            return;
        }
        LoginHistory successLog = new LoginHistory();
        successLog.setUserId(user.getId());
        successLog.setUsername(user.getUsername());
        successLog.setIpAddress(ipAddress);
        successLog.setUserAgent(parsedUA);
        successLog.setLocation(location);
        successLog.setStatus("Success");
        loginHistoryDAO.insert(successLog);
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        Carts sessionCart = (Carts) session.getAttribute("cart");
        CartService cartService = new CartService();
        cartService.syncCart(user.getId(), sessionCart);
        Carts dbCart = cartService.getCartForUser(user.getId());
        if (dbCart != null) {
            session.setAttribute("cart", dbCart);
        }
        response.sendRedirect(request.getContextPath() + "/home");
    }
}