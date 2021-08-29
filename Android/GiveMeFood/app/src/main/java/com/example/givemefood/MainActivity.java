package com.example.givemefood;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.common.SignInButton;
import com.google.android.gms.common.api.ApiException;

import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.GoogleAuthProvider;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FieldValue;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QueryDocumentSnapshot;

import java.util.ArrayList;
import java.util.Map;
import java.util.Objects;

public class MainActivity extends AppCompatActivity {


    private Button yourGroupsButton;
    private GoogleSignInClient mGoogleSignInClient;
    private FirebaseAuth mAuth;
    private SignInButton signInButton;
    private Button signOutButton;
    private FirebaseFirestore db;

    private ActivityResultLauncher<Intent> startActivityForResult;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        yourGroupsButton = findViewById(R.id.yourGroupsButton);
        Button createButton = findViewById(R.id.createButton);
        signInButton = findViewById(R.id.sign_in_button);
        signOutButton = findViewById(R.id.sign_out_button);


        GoogleSignInOptions gso = new GoogleSignInOptions
                .Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                .requestIdToken("296002394629-uk2uhng8mesc5ctr2k3bourjipfqqjlb.apps.googleusercontent.com")
                .requestEmail()
                .build();

        mAuth = FirebaseAuth.getInstance();
        mGoogleSignInClient = GoogleSignIn.getClient(this, gso);

        db = FirebaseFirestore.getInstance();

        startActivityForResult = registerForActivityResult(
                new ActivityResultContracts.StartActivityForResult(),
                result -> {
                    Intent data = result.getData();
                    Task<GoogleSignInAccount> task = GoogleSignIn.getSignedInAccountFromIntent(data);
                    handleSignInResult(task);
                }
        );

        yourGroupsButton.setOnClickListener(view -> openJoin());

        createButton.setOnClickListener(view -> openCreate());

        signInButton.setOnClickListener(v -> signIn());

        signOutButton.setOnClickListener(v -> signOut());

    }

    @Override
    protected void onStart() {
        super.onStart();
        GoogleSignInAccount account = GoogleSignIn.getLastSignedInAccount(this);

        checkForInvites(account);

        updateUI(account);

    }

    void checkForInvites(GoogleSignInAccount account) {
        if (account == null) {
            return;
        }

        User user = new User(account);
        Map<String, Object> userdata = user.getData();

        db.collection("pendingInvites")
                .whereEqualTo("User_Email", userdata.get("User_Email"))
                .get()
                .addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        if (task.getResult().size() == 0) {
                            Log.d("Invites", "No pending Invites");
                        } else {
                            for (QueryDocumentSnapshot document : task.getResult()) {
                                Log.d("Invites", "Invited to " + document.getData());

                                String familyID = (String) document.get("Family_ID");
                                Log.d("Invites", "Family ID " + familyID);

                                DocumentReference docRef = db.collection("users").document((String) Objects.requireNonNull(userdata.get("User_ID")));

                                db.collection("users")
                                        .document((String) Objects.requireNonNull(userdata.get("User_ID")))
                                        .get().addOnCompleteListener(task1 -> {
                                    if (task1.isSuccessful()) {
                                        DocumentSnapshot document1 = task1.getResult();

                                        ArrayList<String> families = (ArrayList<String>) document1.get("families");


                                        if (families == null) {
                                            Log.d("Invites", "No Family yet");
                                            joinFamily(docRef, familyID, document, Objects.requireNonNull(userdata.get("User_ID")).toString());

                                        } else {

                                            if (families.contains(familyID)) {
                                                Log.d("Invites", "Already in Family");
                                                document.getReference().delete();
                                            } else {
                                                Log.d("Invites", "Not in Family yet");
                                                joinFamily(docRef, familyID, document, Objects.requireNonNull(userdata.get("User_ID")).toString());
                                            }

                                        }


                                    }


                                });
                            }
                        }
                    } else {
                        Log.d("Invites", "Error getting documents: ", task.getException());
                    }
                });

    }

    void joinFamily(DocumentReference docRef, String familyID, QueryDocumentSnapshot document, String userID) {
        Task<Void> future = docRef.update("families", FieldValue.arrayUnion(familyID)
        );

        future
                .addOnCompleteListener(task -> {
                    Log.d("Database", "Added Family To User");
                    document.getReference().delete();
                    Log.d("Database", "Deleted Invite");
                })
                .addOnFailureListener(e -> Log.d("Database", "Error Adding Family To User"));


        DocumentReference familyRef = db.collection("groups").document(familyID);
        Task<Void> future1 = familyRef.update("Members", FieldValue.arrayUnion(userID)
        );

        future1.addOnCompleteListener(task -> Log.d("Database", "Added Member To Family"))
                .addOnFailureListener(e -> Log.d("Database", "Error Adding Member to Family"));


    }

    private void signIn() {
        Intent signInIntent = mGoogleSignInClient.getSignInIntent();
        startActivityForResult.launch(signInIntent);
    }

    private void signOut() {
        FirebaseAuth.getInstance().signOut();
        mGoogleSignInClient.signOut()
                .addOnCompleteListener(this, task -> {
                    updateUI(null);
                    Toast.makeText(MainActivity.this, "Logged Out", Toast.LENGTH_SHORT).show();
                });

    }

    public void openJoin() {
        GoogleSignInAccount acc = GoogleSignIn.getLastSignedInAccount(this);

        if (acc != null) {
            Intent intent = new Intent(this, Join.class);
            startActivity(intent);
        } else {
            signIn();
        }
    }

    public void openCreate() {
        GoogleSignInAccount acc = GoogleSignIn.getLastSignedInAccount(this);

        if (acc != null) {
            Intent intent = new Intent(this, Create.class);
            startActivity(intent);
        } else {
            signIn();
        }
    }


    private void handleSignInResult(Task<GoogleSignInAccount> completedTask) {
        try {
            GoogleSignInAccount account = completedTask.getResult(ApiException.class);

            Log.d("FirebaseAuth", "firebaseAuthWithGoogle:" + account.getId());
            firebaseAuthWithGoogle(account.getIdToken());
            updateUI(account);

            addNewUserToDB(account);

            Toast.makeText(MainActivity.this, "Logged In", Toast.LENGTH_SHORT).show();


        } catch (ApiException e) {
            Log.i("Google", "signInResult:failed code=" + e.getStatusCode());
            updateUI(null);
        }
    }

    private void firebaseAuthWithGoogle(String idToken) {
        AuthCredential credential = GoogleAuthProvider.getCredential(idToken, null);
        mAuth.signInWithCredential(credential)
                .addOnCompleteListener(this, task -> {
                    if (task.isSuccessful()) {
                        Log.i("Firebase", "signInWithCredential:success");
                    } else {
                        Log.w("Firebase", "signInWithCredential:failure", task.getException());
                    }
                });
    }

    private void addNewUserToDB(GoogleSignInAccount account) {
        User user = new User(account);
        Map<String, Object> userdata = user.getData();

        db.collection("users")
                .whereEqualTo("User_ID", userdata.get("User_ID"))
                .get()
                .addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        if (task.getResult().size() == 0) {
                            Log.d("Database", "User added " + userdata.toString());
                            db.collection("users").document((String) Objects.requireNonNull(userdata.get("User_ID"))).set(userdata);

                        } else {
                            Log.d("Database", "User already exists");
                        }
                    } else {
                        Log.d("Database", "Error getting documents: ", task.getException());
                    }
                });


    }

    private void updateUI(GoogleSignInAccount acc) {
        if (acc != null) {
            signInButton.setVisibility(View.GONE);
            signOutButton.setVisibility(View.VISIBLE);
            yourGroupsButton.setText(String.format("%s's Groups", acc.getGivenName()));
        } else {
            signInButton.setVisibility(View.VISIBLE);
            signOutButton.setVisibility(View.GONE);
            yourGroupsButton.setText(R.string.notLoggedInText);
        }
    }
}