package com.example.givemefood;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class Join extends AppCompatActivity {

    private Button createNewFamily;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_join);


        createNewFamily = findViewById(R.id.createNewFamily);

        createNewFamily.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                openCreate();
            }
        });

        getSupportActionBar().hide();

    }

    public void openCreate() {
        Intent intent = new Intent(this, Create.class);
        startActivity(intent);
    }


}