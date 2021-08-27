package com.example.givemefood;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FieldValue;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QueryDocumentSnapshot;
import com.google.firebase.firestore.QuerySnapshot;
import com.google.firestore.v1.WriteResult;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class Create extends AppCompatActivity {

    private View createFamily;
    private EditText familyName;

    private FirebaseFirestore db;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create);
        getSupportActionBar().hide();

        createFamily = findViewById(R.id.createNewFamily);
        familyName = findViewById(R.id.familyName);

        db = FirebaseFirestore.getInstance();

        createFamily.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                createNewGroup();
            }
        });


    }

    void createNewGroup() {

        String Family_Name = familyName.getText().toString();

        if (Family_Name == "") {
            return;
        }

        GoogleSignInAccount account = GoogleSignIn.getLastSignedInAccount(this);

        User Admin = new User(account);
        Map<String, Object> userdata = Admin.getData();

        Map<String, Object> Family = new HashMap<>();
        Family.put("Family_Name", Family_Name);
        Family.put("Admin", userdata.get("User_ID"));
        Family.put("Created_At", FieldValue.serverTimestamp());

        //Add family
        db.collection("groups")
                .add(Family)
                .addOnSuccessListener(new OnSuccessListener<DocumentReference>() {
                    @Override
                    public void onSuccess(DocumentReference documentReference) {
                        Log.d("Database", "Group Added with ID: " + documentReference.getId());
                        addFamilyToUser(userdata, documentReference.getId());
                        familyName.setText("");


                        InputMethodManager imm = (InputMethodManager) getSystemService(Activity.INPUT_METHOD_SERVICE);
                        imm.toggleSoftInput(InputMethodManager.HIDE_IMPLICIT_ONLY, 0);

                        Toast.makeText(Create.this, "Created Group", Toast.LENGTH_LONG).show();

                    }
                })
                .addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        Log.d("Database", "Error adding document", e);
                    }
                });


    }

    void addFamilyToUser(Map<String, Object> userdata, String familyID) {
        DocumentReference docRef = db.collection("users").document(userdata.get("User_ID").toString());

        Task<Void> future = docRef.update("families", FieldValue.arrayUnion(familyID)
        );

        future.addOnCompleteListener(new OnCompleteListener<Void>() {
            @Override
            public void onComplete(@NonNull Task<Void> task) {
                Log.d("Database", "Added Family To User");
            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                Log.d("Database", "Error Adding Family To User");
            }
        });


    }
}