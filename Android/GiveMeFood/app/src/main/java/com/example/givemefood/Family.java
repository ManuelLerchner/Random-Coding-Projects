package com.example.givemefood;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.os.Bundle;
import android.util.Log;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FieldPath;
import com.google.firebase.firestore.FieldValue;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.Random;

public class Family extends AppCompatActivity {

    private FirebaseFirestore db;
    private String Family_ID;

    private TextView familyGroupName;
    private ListView foodList;
    private EditText addItemField;

    private FoodAdapter mAdapter;


    private final ArrayList<Food> foods = new ArrayList<>();
    private final ArrayList<Member> members = new ArrayList<>();


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_family);
        Objects.requireNonNull(getSupportActionBar()).hide();


        db = FirebaseFirestore.getInstance();

        familyGroupName = findViewById(R.id.familyGroupName);

        Button submitItem = findViewById(R.id.submitItem);
        addItemField = findViewById(R.id.addItemField);

        Button inviteButton = findViewById(R.id.inviteButton);

        foodList = findViewById(R.id.foodList);

        Button leaveButton = findViewById(R.id.leaveButton);

        Button randomButton = findViewById(R.id.randomButton);


        submitItem.setOnClickListener(view -> submit());
        inviteButton.setOnClickListener(view -> invite());
        leaveButton.setOnClickListener(view -> leave());
        randomButton.setOnClickListener(view -> random());

        foodList.setOnItemClickListener((adapterView, view, i, l) ->
                Toast.makeText(Family.this, "Hold to remove: \"" + foods.get(i).foodName + "\"", Toast.LENGTH_SHORT).show());

        foodList.setOnItemLongClickListener((adapterView, view, i, l) -> {
            removeFood(i);
            return false;
        });


    }

    void removeFood(int index) {
        Log.d("Food", String.valueOf(index));

        DocumentReference familyRef = db.collection("groups").document(Family_ID);

        Food toRemove = foods.get(index);

        Map<String, Object> food = new HashMap<>();
        food.put("name", toRemove.foodName);
        food.put("user", toRemove.user);

        Log.d("Food", food.toString());

        Task<Void> future = familyRef.update(FieldPath.of("food"), FieldValue.arrayRemove(food)
        );

        foods.remove(index);

        mAdapter = new FoodAdapter(Family.this, foods);
        foodList.setAdapter(mAdapter);

        future
                .addOnCompleteListener(task -> {
                    Log.d("Food", "Removed Food");
                    loadFood();
                })
                .addOnFailureListener(e -> Log.d("Food", "Error Removing Food"));

    }

    void random() {

        int length = foods.size();
        Random r = new Random();
        int index = r.nextInt(length);
        Log.d("Random", String.valueOf(index));
        Food f = foods.get(index);

        Toast toast = Toast.makeText(Family.this, f.foodName, Toast.LENGTH_SHORT);


        LinearLayout toastLayout = (LinearLayout) toast.getView();
        toastLayout.getBackground().setColorFilter(Color.parseColor("#3e4757"), PorterDuff.Mode.SRC_IN);

        TextView toastTV = (TextView) toastLayout.getChildAt(0);
        toastTV.setTextSize(30);

        toastTV.setTextColor(Color.parseColor("#ffffff"));

        toast.show();

    }

    void leave() {

        GoogleSignInAccount account = GoogleSignIn.getLastSignedInAccount(this);

        if (account == null) {
            return;
        }


        User U = new User(account);
        Map<String, Object> userdata = U.getData();

        leaveFamily(Family_ID, (String) userdata.get("User_ID"));
    }

    void leaveFamily(String familyID, String userID) {

        DocumentReference familyRef = db.collection("groups").document(familyID);


        Task<Void> future = familyRef.update("Members", FieldValue.arrayRemove(userID)
        );

        future
                .addOnCompleteListener(task -> Log.d("Family", "Removed Member"))
                .addOnFailureListener(e -> Log.d("Family", "Error Removing Member"));


        DocumentReference userRef = db.collection("users").document(userID);
        Task<Void> future1 = userRef.update("families", FieldValue.arrayRemove(familyID)
        );

        future1
                .addOnCompleteListener(task -> {
                    Log.d("User", "Removed Family");

                    Intent intent = new Intent(getBaseContext(), Join.class);
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                    startActivity(intent);

                    Toast.makeText(Family.this, "Left Family", Toast.LENGTH_LONG).show();

                })
                .addOnFailureListener(e -> Log.d("User", "Error Removing Family"));


    }


    void invite() {
        Intent intent = new Intent(getBaseContext(), Invite.class);
        intent.putExtra("Family_ID", Family_ID);
        startActivity(intent);

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

        loadFood();
        loadMembers();
    }


    void loadFood() {

        foods.clear();
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

                            Food F = new Food(document1.getString("User_PhotoURL"), name, document1.getString("User_ID"));
                            foods.add(F);

                            mAdapter = new FoodAdapter(Family.this, foods);
                            foodList.setAdapter(mAdapter);


                        }

                    });
                }


            }

        });


    }

    void loadMembers() {
        members.clear();
        db.collection("groups")
                .document(Family_ID)
                .get().addOnCompleteListener(task -> {
            if (task.isSuccessful()) {
                DocumentSnapshot document = task.getResult();
                ArrayList<String> memberList = (ArrayList<String>) document.get("Members");


                if (memberList == null) {
                    return;
                }


                for (String userID : memberList) {


                    getImage(userID, (success, memberDocument) -> {
                        if (memberDocument.getString("User_PhotoURL") != null) {

                            Member M = new Member(memberDocument.getString("User_PhotoURL"), memberDocument.getString("First_Name"));

                            members.add(M);


                            MembersAdapter mAdapter = new MembersAdapter(members);
                            RecyclerView recyclerView = findViewById(R.id.familyMembersList);

                            LinearLayoutManager mLayoutManager = new LinearLayoutManager(getApplicationContext());
                            mLayoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
                            recyclerView.setLayoutManager(mLayoutManager);
                            recyclerView.setAdapter(mAdapter);

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