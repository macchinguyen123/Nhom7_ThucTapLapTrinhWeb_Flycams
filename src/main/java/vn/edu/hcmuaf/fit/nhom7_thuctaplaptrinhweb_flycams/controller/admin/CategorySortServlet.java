package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model.Categories;
import vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service.CategoryService;

import java.io.IOException;
import java.util.stream.Collectors;

@WebServlet(name = "CategorySortServlet", value = "/admin/category-sort")
public class CategorySortServlet extends HttpServlet {
    private CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String json = req.getReader().lines().collect(Collectors.joining());
        Gson gson = new Gson();
        Categories[] items = gson.fromJson(json, Categories[].class);
        for (Categories item : items) {
            categoryService.updateCategorySort(item.getId(), item.getSortOrder());
        }
        resp.setStatus(HttpServletResponse.SC_OK);
    }
}