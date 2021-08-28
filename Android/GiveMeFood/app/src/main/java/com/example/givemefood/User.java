package com.example.givemefood;

import com.google.android.gms.auth.api.signin.GoogleSignInAccount;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class User {

    private final Map<String, Object> userdata;


    public User(GoogleSignInAccount account) {
        userdata = new HashMap<>();
        userdata.put("User_Name", account.getDisplayName());
        userdata.put("Fist_Name", account.getGivenName());
        userdata.put("Last_Name", account.getFamilyName());
        userdata.put("User_Email", account.getEmail());
        userdata.put("User_ID", account.getId());
        userdata.put("User_PhotoURL", Objects.requireNonNull(account.getPhotoUrl()).toString());
    }

    public Map<String, Object> getData() {
        return userdata;
    }

}
