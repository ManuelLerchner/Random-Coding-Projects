package com.example.givemefood;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;


import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QueryDocumentSnapshot;
import com.google.firebase.firestore.QuerySnapshot;

import java.util.ArrayList;
import java.util.List;

public class Join extends AppCompatActivity {


    private FirebaseFirestore db;
    private ArrayList<String> families = new ArrayList<>();
    List<String> familyIDs;

    ListView familyList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_join);

        getSupportActionBar().hide();

        db = FirebaseFirestore.getInstance();

        familyList = findViewById(R.id.foodList);

        familyList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {

                Log.d("test", view.toString());


                Intent intent = new Intent(getBaseContext(), Family.class);
                intent.putExtra("Family_Name", families.get(i));
                intent.putExtra("Family_ID", familyIDs.get(i));
                startActivity(intent);

            }
        });
    }

    @Override
    protected void onStart() {
        super.onStart();
        loadData();
        families.clear();
    }

    public interface OnCompleteCallback {
        void onComplete(boolean success, DocumentSnapshot document);
    }


    void loadData() {
        GoogleSignInAccount account = GoogleSignIn.getLastSignedInAccount(this);


        db.collection("users")
                .whereEqualTo("User_ID", account.getId())
                .get()
                .addOnCompleteListener(new OnCompleteListener<QuerySnapshot>() {
                    @Override
                    public void onComplete(@NonNull Task<QuerySnapshot> task) {
                        if (task.isSuccessful()) {

                            if (task.getResult().size() == 0) {
                                Log.d("Database", "User is in No Group");
                            } else {
                                for (QueryDocumentSnapshot document : task.getResult()) {
                                    Log.d("Database", document.getId() + " => " + document.getData());

                                    familyIDs = (List<String>) document.getData().get("families");


                                    loadFamilies(familyIDs, new OnCompleteCallback() {
                                        @Override
                                        public void onComplete(boolean success, DocumentSnapshot document) {
                                            if (document.getString("Family_Name") != null) {
                                                families.add(document.getString("Family_Name").toString());
                                                Log.d("Database", families.toString());

                                                 ArrayAdapter<String> arrayAdapter = new ArrayAdapter<String>(Join.this, android.R.layout.simple_list_item_1, families);

                                                familyList.setAdapter(arrayAdapter);
                                            }

                                        }
                                    });


                                }
                            }
                        } else {
                            Log.d("Database", "Error getting documents: ", task.getException());
                        }
                    }
                });


    }


    void loadFamilies(List<String> familyIDs, final OnCompleteCallback callback) {

        if (familyIDs == null) {
            return;

        }

        for (String familyID : familyIDs) {
            db.collection("groups")
                    .document(familyID)
                    .get().addOnCompleteListener(new OnCompleteListener<DocumentSnapshot>() {
                @Override
                public void onComplete(@NonNull Task<DocumentSnapshot> task) {
                    if (task.isSuccessful()) {
                        DocumentSnapshot document = task.getResult();
                        callback.onComplete(document.exists(), document);
                    }

                }

            });
        }


    }
}