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

import androidx.annotation.LayoutRes;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.bumptech.glide.Glide;

public class FoodAdapter extends ArrayAdapter<Food> {


    private Context mContext;
    private List<Food> moviesList = new ArrayList<>();

    public FoodAdapter(@NonNull Context context, @LayoutRes ArrayList<Food> list) {
        super(context, 0, list);
        mContext = context;
        moviesList = list;
    }

    public FoodAdapter(@NonNull Context context, int resource) {
        super(context, resource);
    }

    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        View listItem = convertView;
        if (listItem == null)
            listItem = LayoutInflater.from(mContext).inflate(R.layout.list_item, parent, false);

        Food currentFood = moviesList.get(position);

        ImageView image = (ImageView) listItem.findViewById(R.id.imageView_poster);
        Glide.with(listItem).load(currentFood.imageUrl).into(image);

        TextView name = (TextView) listItem.findViewById(R.id.textView_name);
        name.setText(currentFood.foodName);


        return listItem;
    }
}
