package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model;

import java.io.Serializable;
import java.util.Date;

public class Payments implements Serializable {
    private int id;
    private int orderId;
    private boolean status;
    private Date createdAt;
}
