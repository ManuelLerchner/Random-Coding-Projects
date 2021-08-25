package com.example.givemefood;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class MainActivity extends AppCompatActivity {


    private Button joinButton;
    private Button createButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);


        joinButton = findViewById(R.id.joinButton1);
        createButton = findViewById(R.id.createButton);

        joinButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openJoin();
            }
        });


    }

    public void openJoin() {
        Intent intent = new Intent(this, Join.class);
        startActivity(intent);
    }
}