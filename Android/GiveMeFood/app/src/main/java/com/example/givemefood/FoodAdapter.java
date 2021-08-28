package com.example.givemefood;

import android.widget.ArrayAdapter;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bumptech.glide.Glide;

public class FoodAdapter extends ArrayAdapter<Food> {


    private final Context mContext;
    private final List<Food> foodList;

    public FoodAdapter(@NonNull Context context, ArrayList<Food> list) {
        super(context, 0, list);
        mContext = context;
        foodList = list;
    }

    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        View listItem = convertView;
        if (listItem == null)
            listItem = LayoutInflater.from(mContext).inflate(R.layout.list_item, parent, false);

        Food currentFood = foodList.get(position);

        ImageView image = listItem.findViewById(R.id.imageView_poster);
        Glide.with(listItem).load(currentFood.userUrl).into(image);

        TextView name = listItem.findViewById(R.id.textView_name);
        name.setText(currentFood.foodName);


        return listItem;
    }
}
