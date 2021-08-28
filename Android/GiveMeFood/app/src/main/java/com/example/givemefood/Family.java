package com.example.givemefood;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.CollectionReference;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FieldValue;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QueryDocumentSnapshot;
import com.google.firebase.firestore.SetOptions;

import org.w3c.dom.Text;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Family extends AppCompatActivity {

    private FirebaseFirestore db;
    private String Family_ID;
    private String Family_Name;

    private TextView familyGroupName;
    private ListView foodlist;
    private Button submitItem;
    private EditText addItemField;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_family);


        db = FirebaseFirestore.getInstance();

        familyGroupName = (TextView) findViewById(R.id.familyGroupName);

        submitItem = findViewById(R.id.submitItem);
        addItemField = findViewById(R.id.addItemField);

        foodlist = findViewById(R.id.foodList);


        submitItem.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                submit();
            }
        });

        foodlist.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
            }
        });

    }

    void submit() {
        String itemName = addItemField.getText().toString();
        if (itemName == "") {
            return;
        }

        GoogleSignInAccount account = GoogleSignIn.getLastSignedInAccount(this);

        DocumentReference docRef = db.collection("groups").document(Family_ID);


        Map<String, Object> food = new HashMap<>();
        food.put("name", itemName);
        food.put("user", account.getId());


        Task<Void> future = docRef.update("food", FieldValue.arrayUnion(food)
        );


        future.addOnCompleteListener(new OnCompleteListener<Void>() {
            @Override
            public void onComplete(@NonNull Task<Void> task) {
                Log.d("Database", "Added Food");
                loadFood();
                addItemField.setText("");
            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                Log.d("Database", "Error Adding Food" + e.toString());
            }
        });


    }

    @Override
    protected void onStart() {
        super.onStart();

        Family_Name = getIntent().getStringExtra("Family_Name");
        Family_ID = getIntent().getStringExtra("Family_ID");

        familyGroupName.setText(Family_Name);

        loadFood();
    }


    void loadFood() {

        db.collection("groups")
                .document(Family_ID)
                .get().addOnCompleteListener(new OnCompleteListener<DocumentSnapshot>() {
            @Override
            public void onComplete(@NonNull Task<DocumentSnapshot> task) {
                if (task.isSuccessful()) {
                    DocumentSnapshot document = task.getResult();
                    ArrayList<Map<String, Object>> foodArrayList = (ArrayList<Map<String, Object>>) document.get("food");

                    if (foodArrayList == null) {
                        return;
                    }
                    ArrayList<Food> foods = new ArrayList<>();


                    for (Map<String, Object> map : foodArrayList) {
                        Log.d("Family", map.toString());

                        getImage(map.get("user").toString(), new Family.OnCompleteCallback() {
                            @Override
                            public void onComplete(boolean success, DocumentSnapshot document) {
                                if (document.getString("User_PhotoURL") != null) {

                                    Food F = new Food(document.getString("User_PhotoURL"), map.get("name").toString());
                                    foods.add(F);

                                    FoodAdapter mAdapter = new FoodAdapter(Family.this, foods);
                                    foodlist.setAdapter(mAdapter);
                                }

                            }

                        });
                    }


                }

            }

        });


    }

    public interface OnCompleteCallback {
        void onComplete(boolean success, DocumentSnapshot document);
    }

    void getImage(String id, OnCompleteCallback callback) {
        db.collection("users")
                .document(id)
                .get().addOnCompleteListener(new OnCompleteListener<DocumentSnapshot>() {
            @Override
            public void onComplete(@NonNull Task<DocumentSnapshot> task) {
                if (task.isSuccessful()) {
                    DocumentSnapshot document = task.getResult();
                    callback.onComplete(document.exists(), document);
                }


            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(@NonNull Exception e) {
                Log.d("Family", e.toString());
            }
        });
    }
}