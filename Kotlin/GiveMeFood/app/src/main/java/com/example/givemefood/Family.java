package com.example.givemefood;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

public class Family extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_family);

        String Family_Name = getIntent().getStringExtra("Family_Name");
        String Family_ID = getIntent().getStringExtra("Family_ID");

        Toast.makeText(Family.this, Family_ID+" " + Family_Name, Toast.LENGTH_SHORT).show();
    }
}