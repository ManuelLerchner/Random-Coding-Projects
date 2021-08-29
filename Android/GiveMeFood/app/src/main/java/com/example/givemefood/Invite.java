package com.example.givemefood;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.google.firebase.firestore.FirebaseFirestore;

import java.util.HashMap;
import java.util.Map;

public class Invite extends AppCompatActivity {

    private String Family_ID;
    private EditText email;
    private FirebaseFirestore db;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_invite);

        Button submit = findViewById(R.id.submitInviteButton);
        email = findViewById(R.id.email);

        db = FirebaseFirestore.getInstance();

        submit.setOnClickListener(view -> invite());


    }

    void invite() {

        String userEmail = email.getText().toString();

        if (userEmail.equals("")) {
            return;
        }

        Map<String, Object> Invite = new HashMap<>();
        Invite.put("User_Email", userEmail);
        Invite.put("Family_ID", Family_ID);


        db.collection("pendingInvites")
                .add(Invite)
                .addOnSuccessListener(documentReference -> {


                    Log.d("Database", "Invite Added with ID: " + documentReference.getId());
                    email.setText("");


                    Toast.makeText(Invite.this, "Invited User", Toast.LENGTH_LONG).show();

                })
                .addOnFailureListener(e -> Log.d("Database", "Error adding document", e));

    }

    @Override
    protected void onStart() {
        super.onStart();


        Family_ID = getIntent().getStringExtra("Family_ID");


        Log.d("Invite", Family_ID);
    }
}