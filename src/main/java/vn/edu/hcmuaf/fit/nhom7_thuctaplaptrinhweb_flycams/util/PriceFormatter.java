package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.util;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;

public class PriceFormatter {
    private static final DecimalFormat formatter;
    static {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols();
        symbols.setGroupingSeparator('.');
        symbols.setDecimalSeparator(',');
        formatter = new DecimalFormat("#,###", symbols);
    }

    public String format(long price) {
        return formatter.format(price);
    }

    public String format(double price) {
        return formatter.format(price);
    }
}
