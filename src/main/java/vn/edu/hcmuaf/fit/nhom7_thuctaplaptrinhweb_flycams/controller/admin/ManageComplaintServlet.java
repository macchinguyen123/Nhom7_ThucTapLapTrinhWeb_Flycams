package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.dao.ComplaintDAO;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Complaint;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util.CsrfTokenUtil;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ManageComplaintServlet", value = "/admin/complaints")
public class ManageComplaintServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        CsrfTokenUtil.getOrCreate(session); ComplaintDAO dao = new ComplaintDAO();
        List<Complaint> complaints = dao.getAllComplaints();
        request.setAttribute("complaints", complaints);
        request.getRequestDispatcher("/page/admin/complaints-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            String idStr = request.getParameter("id");
            String statusStr = request.getParameter("status");
            String adminNote = request.getParameter("adminNote");
            if (idStr != null && statusStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    int status = Integer.parseInt(statusStr);
                    ComplaintDAO dao = new ComplaintDAO();
                    boolean success = dao.updateComplaintStatus(id, status, adminNote);
                    if (success) {
                        request.getSession().setAttribute("message", "Cập nhật trạng thái khiếu nại thành công.");
                    } else {
                        request.getSession().setAttribute("error", "Cập nhật thất bại.");
                    }
                } catch (NumberFormatException e) {
                    request.getSession().setAttribute("error", "Dữ liệu không hợp lệ.");
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/complaints");
    }
}