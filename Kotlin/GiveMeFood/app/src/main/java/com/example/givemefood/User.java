package com.example.givemefood;

import com.google.android.gms.auth.api.signin.GoogleSignInAccount;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

public class User {

    private Map<String, Object> userdata = new HashMap<>();


    public User(GoogleSignInAccount account) {
        userdata.put("User_Name", account.getDisplayName());
        userdata.put("Fist_Name", account.getGivenName());
        userdata.put("Last_Name", account.getFamilyName());
        userdata.put("User_Email", account.getEmail());
        userdata.put("User_ID", account.getId());
        userdata.put("User_PhotoURL", account.getPhotoUrl().toString());
    }

    public Map<String, Object> getData() {
        return userdata;
    }

}
