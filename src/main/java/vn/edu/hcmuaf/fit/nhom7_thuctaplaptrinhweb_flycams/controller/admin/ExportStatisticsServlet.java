package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.DashboardService;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "ExportStatisticsServlet", value = "/admin/statistics/export")
public class ExportStatisticsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DashboardService dashboardService = new DashboardService();
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        java.time.LocalDate today = java.time.LocalDate.now();
        if (startDateStr == null || startDateStr.trim().isEmpty()) {
            startDateStr = today.withDayOfMonth(1).toString();
        }
        if (endDateStr == null || endDateStr.trim().isEmpty()) {
            endDateStr = today.toString();
        }
        List<Orders> ordersInRange = dashboardService.getOrdersInRange(startDateStr, endDateStr);
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"Bao_Cao_Thong_Ke_" + startDateStr + "_to_" + endDateStr + ".csv\"");
        try (PrintWriter writer = response.getWriter()) {
            writer.write("\ufeff");
            writer.println("Tóm Tắt Báo Cáo,");
            writer.println("Từ ngày:," + startDateStr);
            writer.println("Đến ngày:," + endDateStr);
            writer.println("Tổng số đơn hàng:," + dashboardService.getOrdersCountInRange(startDateStr, endDateStr));
            writer.println("Tổng doanh thu:," + String.format("%.0f", dashboardService.getRevenueInRange(startDateStr, endDateStr)) + " VNĐ");
            writer.println();
            writer.println("Danh Sách Đơn Hàng");
            writer.println("Mã Đơn Hàng,Khách Hàng,Ngày Đặt,Tổng Tiền,Trạng Thái");
            for (Orders o : ordersInRange) {
                String customerName = o.getCustomerName() != null ? o.getCustomerName().replace(",", " ") : "";
                String totalStr = String.format("%.0f", o.getTotalPrice());
                String line = String.format("#%d,%s,%s,%s,%s",
                        o.getId(),
                        customerName,
                        o.getCreatedAt() != null ? o.getCreatedAt().toString() : "",
                        totalStr,
                        o.getStatusLabel() != null ? o.getStatusLabel() : "");
                writer.println(line);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
