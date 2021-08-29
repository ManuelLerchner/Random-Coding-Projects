package com.example.givemefood;


import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FieldValue;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class Create extends AppCompatActivity {

    private EditText familyName;
    private FirebaseFirestore db;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create);
        Objects.requireNonNull(getSupportActionBar()).hide();

        View createFamily = findViewById(R.id.submitInviteButton);
        familyName = findViewById(R.id.familyName);

        db = FirebaseFirestore.getInstance();

        createFamily.setOnClickListener(view -> createNewGroup());


    }

    void createNewGroup() {

        String Family_Name = familyName.getText().toString();

        if (Family_Name.equals("")) {
            return;
        }

        GoogleSignInAccount account = GoogleSignIn.getLastSignedInAccount(this);

        if (account == null) {
            return;
        }

        User Admin = new User(account);
        Map<String, Object> userdata = Admin.getData();

        Map<String, Object> Family = new HashMap<>();
        Family.put("Family_Name", Family_Name);
        Family.put("Admin", userdata.get("User_ID"));
        Family.put("Created_At", FieldValue.serverTimestamp());
        Family.put("Members", FieldValue.arrayUnion(userdata.get("User_ID")));


        //Add family
        db.collection("groups")
                .add(Family)
                .addOnSuccessListener(documentReference -> {
                    Log.d("Database", "Group Added with ID: " + documentReference.getId());
                    addFamilyToUser(userdata, documentReference.getId());
                    familyName.setText("");


                    Toast.makeText(Create.this, "Created Group", Toast.LENGTH_LONG).show();

                })
                .addOnFailureListener(e -> Log.d("Database", "Error adding document", e));


    }

    void addFamilyToUser(Map<String, Object> userdata, String familyID) {
        DocumentReference docRef = db.collection("users").document((String) Objects.requireNonNull(userdata.get("User_ID")));

        Task<Void> future = docRef.update("families", FieldValue.arrayUnion(familyID)
        );

        future
                .addOnCompleteListener(task -> Log.d("Database", "Added Family To User"))
                .addOnFailureListener(e -> Log.d("Database", "Error Adding Family To User"));


    }
}