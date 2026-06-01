package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Banner;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.BannerService;

import java.io.IOException;
import java.util.stream.Collectors;

@WebServlet(name = "BannerSortServlet", value = "/admin/banner-sort")
public class BannerSortServlet extends HttpServlet {
    private final BannerService bannerService = new BannerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getReader().lines().collect(Collectors.joining());
        Gson gson = new Gson();
        Banner[] items = gson.fromJson(json, Banner[].class);
        for (Banner item : items) {
            bannerService.updateSortOrder(item.getId(), item.getOrderIndex());  }
        resp.setStatus(HttpServletResponse.SC_OK);
    }
}