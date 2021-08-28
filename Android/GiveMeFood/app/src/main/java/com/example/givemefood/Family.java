package com.example.givemefood;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FieldValue;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class Family extends AppCompatActivity {

    private FirebaseFirestore db;
    private String Family_ID;

    private TextView familyGroupName;
    private ListView foodList;
    private EditText addItemField;

    private final ArrayList<Food> foods = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_family);


        db = FirebaseFirestore.getInstance();

        familyGroupName = findViewById(R.id.familyGroupName);

        Button submitItem = findViewById(R.id.submitItem);
        addItemField = findViewById(R.id.addItemField);

        foodList = findViewById(R.id.foodList);


        submitItem.setOnClickListener(view -> submit());


    }

    void submit() {
        String itemName = addItemField.getText().toString();
        if (itemName.equals("")) {
            return;
        }

        GoogleSignInAccount account = GoogleSignIn.getLastSignedInAccount(this);

        if (account == null) {
            return;
        }

        DocumentReference docRef = db.collection("groups").document(Family_ID);


        Map<String, Object> food = new HashMap<>();
        food.put("name", itemName);
        food.put("user", account.getId());


        Task<Void> future = docRef.update("food", FieldValue.arrayUnion(food)
        );


        future.addOnCompleteListener(task -> {
            Log.d("Database", "Added Food");
            loadFood();
            addItemField.setText("");
        }).addOnFailureListener(e -> Log.d("Database", "Error Adding Food" + e.toString()));


    }

    @Override
    protected void onStart() {
        super.onStart();

        String family_Name = getIntent().getStringExtra("Family_Name");
        Family_ID = getIntent().getStringExtra("Family_ID");

        familyGroupName.setText(family_Name);

        foods.clear();

        loadFood();
    }


    void loadFood() {

        db.collection("groups")
                .document(Family_ID)
                .get().addOnCompleteListener(task -> {
            if (task.isSuccessful()) {
                DocumentSnapshot document = task.getResult();
                ArrayList<Map<String, Object>> foodArrayList = (ArrayList<Map<String, Object>>) document.get("food");

                if (foodArrayList == null) {
                    return;
                }


                for (Map<String, Object> map : foodArrayList) {
                    Log.d("Family", map.toString());

                    String user = (String) map.get("user");
                    String name = (String) map.get("name");

                    getImage(user, (success, document1) -> {
                        if (document1.getString("User_PhotoURL") != null) {

                            Food F = new Food(document1.getString("User_PhotoURL"), name);
                            foods.add(F);

                            FoodAdapter mAdapter = new FoodAdapter(Family.this, foods);
                            foodList.setAdapter(mAdapter);
                        }

                    });
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
                .get().addOnCompleteListener(task -> {
            if (task.isSuccessful()) {
                DocumentSnapshot document = task.getResult();
                callback.onComplete(document.exists(), document);
            }


        }).addOnFailureListener(e -> Log.d("Family", e.toString()));
    }
}