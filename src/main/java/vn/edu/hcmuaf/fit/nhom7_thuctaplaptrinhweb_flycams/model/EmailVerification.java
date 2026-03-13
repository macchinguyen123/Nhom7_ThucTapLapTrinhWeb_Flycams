package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model;

import java.io.Serializable;
import java.util.Date;

public class EmailVerification implements Serializable {
    private int id;
    private int userId;
    private String token;
    private Date createdAt;
    private Date expiredAt;
}
