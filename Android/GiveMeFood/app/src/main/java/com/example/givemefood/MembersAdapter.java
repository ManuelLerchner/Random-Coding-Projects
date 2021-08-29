package com.example.givemefood;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.List;

public class MembersAdapter extends RecyclerView.Adapter<MembersAdapter.MyViewHolder> {
    private final List<Member> memberList;

    static class MyViewHolder extends RecyclerView.ViewHolder {
        TextView name;
        ImageView image;

        MyViewHolder(View view) {
            super(view);
            name = view.findViewById(R.id.name);
            image = view.findViewById(R.id.image);
        }
    }

    public MembersAdapter(List<Member> memberList) {
        this.memberList = memberList;
    }

    @NonNull
    @Override
    public MyViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View itemView = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.list_member, parent, false);
        return new MyViewHolder(itemView);
    }

    @Override
    public void onBindViewHolder(MyViewHolder holder, int position) {
        Member currMember = memberList.get(position);

        Glide.with(holder.itemView).load(currMember.userUrl).into(holder.image);

        holder.name.setText(currMember.name);

    }

    @Override
    public int getItemCount() {
        return memberList.size();
    }
}


