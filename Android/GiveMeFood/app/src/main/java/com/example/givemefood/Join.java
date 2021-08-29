package com.example.givemefood;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.ListView;


import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QueryDocumentSnapshot;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;

public class Join extends AppCompatActivity {


    private FirebaseFirestore db;
    private final ArrayList<String> families = new ArrayList<>();
    List<String> familyIDs;

    ListView familyList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_join);

        Objects.requireNonNull(getSupportActionBar()).hide();

        db = FirebaseFirestore.getInstance();

        familyList = findViewById(R.id.foodList);

        familyList.setOnItemClickListener((adapterView, view, i, l) -> {

            Log.d("test", view.toString());

            Intent intent = new Intent(getBaseContext(), Family.class);
            intent.putExtra("Family_Name", families.get(i));
            intent.putExtra("Family_ID", familyIDs.get(i));
            startActivity(intent);

        });
    }

    @Override
    protected void onStart() {
        super.onStart();
        loadData();
    }

    public interface OnCompleteCallback {
        void onComplete(boolean success, DocumentSnapshot document);
    }


    void loadData() {
        families.clear();
        GoogleSignInAccount account = GoogleSignIn.getLastSignedInAccount(this);

        if (account == null) {
            return;
        }


        db.collection("users")
                .whereEqualTo("User_ID", account.getId())
                .get()
                .addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {

                        if (task.getResult().size() == 0) {
                            Log.d("Database", "User is in No Group");
                        } else {
                            for (QueryDocumentSnapshot document : task.getResult()) {
                                Log.d("Database", document.getId() + " => " + document.getData());

                                Map<String, Object> data = document.getData();

                                if (data.get("families") == null) {
                                    return;
                                }

                                familyIDs = (List<String>) data.get("families");

                                loadFamilies(familyIDs, (success, familiesDocument) -> {
                                    if (success) {
                                        if (familiesDocument.getString("Family_Name") != null) {
                                            families.add(familiesDocument.getString("Family_Name"));
                                            Log.d("Database", families.toString());


                                            String AdminID = familiesDocument.getString("Admin");
                                            String familyName = familiesDocument.getString("Family_Name");

                                            getImage(AdminID, (success1, memberDocument) -> {
                                                if (memberDocument.getString("User_PhotoURL") != null) {

                                                    String userURL = memberDocument.getString("User_PhotoURL");


                                                    ArrayList<Food> F = new ArrayList<>();
                                                    F.add(new Food(userURL, familyName, AdminID));

                                                    FoodAdapter FA = new FoodAdapter(this, F);
                                                    familyList.setAdapter(FA);

                                                }
                                            });

                                        }
                                    }

                                });


                            }
                        }
                    } else {
                        Log.d("Database", "Error getting documents: ", task.getException());
                    }
                });


    }


    void getImage(String id, Family.OnCompleteCallback callback) {
        db.collection("users")
                .document(id)
                .get().addOnCompleteListener(task -> {
            if (task.isSuccessful()) {
                DocumentSnapshot document = task.getResult();
                callback.onComplete(document.exists(), document);
            }


        }).addOnFailureListener(e -> Log.d("Family", e.toString()));
    }


    void loadFamilies(List<String> familyIDs, final OnCompleteCallback callback) {

        if (familyIDs == null) {
            return;

        }

        for (String familyID : familyIDs) {
            db.collection("groups")
                    .document(familyID)
                    .get().addOnCompleteListener(task -> {
                if (task.isSuccessful()) {
                    DocumentSnapshot document = task.getResult();
                    callback.onComplete(document.exists(), document);
                }

            });
        }


    }
}