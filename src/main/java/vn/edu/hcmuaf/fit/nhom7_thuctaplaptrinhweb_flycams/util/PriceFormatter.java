package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util;

import java.text.DecimalFormat;

public class PriceFormatter {
    private static final DecimalFormat formatter = new DecimalFormat("#,###");

    public String format(long price) {
        return formatter.format(price);
    }

    public String format(double price) {
        return formatter.format(price);
    }
}
