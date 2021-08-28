package com.example.gibmiressen

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log.d
import android.widget.ArrayAdapter
import com.example.gibmiressen.databinding.ActivityMainBinding
import java.util.ArrayList
import android.R
import android.view.View
import android.widget.ListView
import android.widget.SeekBar
import android.widget.SeekBar.OnSeekBarChangeListener
import kotlin.random.Random
import com.google.android.material.slider.Slider

import androidx.annotation.NonNull


class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)


        var button = binding.button
        var slider = binding.slider
        var number = binding.number
        var currentMax = binding.currentMax



        slider.setOnSeekBarChangeListener(object : OnSeekBarChangeListener {
            override fun onProgressChanged(
                seek: SeekBar,
                progress: Int, fromUser: Boolean
            ) {
                currentMax.text = progress.toString();
            }

            override fun onStartTrackingTouch(p0: SeekBar?) {
            }

            override fun onStopTrackingTouch(p0: SeekBar?) {
            }


        });


        button.setOnClickListener {
            var r = Random.nextInt(0, slider.progress+1)
            d("a", slider.progress.toString())
            number.text = r.toString()

        }


    }
}