package com.ibc.adapter;

import java.util.ArrayList;

import com.ibc.EventsListViewActivity;
import com.ibc.StarredActivity;
import com.ibc.SubMenuActivity;
import com.ibc.VenusListViewActivity;
import com.ibc.model.MenuItemData;
import com.ibc.view.ListMenuRowHolder;

import android.content.Context;
import android.content.Intent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;

public class MenuListAdapter extends BaseAdapter implements OnItemClickListener{
	ArrayList<MenuItemData> mDatas = new ArrayList<MenuItemData>();
	Context mContext;
	public MenuListAdapter(ArrayList<MenuItemData> datas, Context context) {
		mDatas = datas;
		mContext = context;
		
	}
	
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		if (mDatas == null || mDatas.isEmpty()) {
			return 0;
		} else {
			return mDatas.size();
		}
	}

	@Override
	public MenuItemData getItem(int position) {
		// TODO Auto-generated method stub
		return mDatas.get(position);
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		ListMenuRowHolder rowHolder = new ListMenuRowHolder(mContext);
		rowHolder.setData(getItem(position), ((position % 2) == 0));
		return rowHolder;
	}
	
	/**
	 * 	Goto view «Events Menu»

		Goto view «Venue List»

		Goto view «Main Calendar»

		Goto view «Venue List w.Distances»

		Goto view «Starred»
	 */
	
	@Override
	public void onItemClick(AdapterView<?> adapterView, View view, int position, long id) {
		// TODO Auto-generated method stub
		MenuItemData data = mDatas.get(position);
		if (position == 0) {
			Intent intent = new Intent(mContext, EventsListViewActivity.class);
			intent.putExtra("title", data.mTitle);
			mContext.startActivity(intent);
		} else if (position == 1 ) {
			Intent intent = new Intent(mContext, VenusListViewActivity.class);
			intent.putExtra("title", data.mTitle);
			intent.putExtra("lat", 41.385756);
			intent.putExtra("lon", 2.164129);
			mContext.startActivity(intent);
		} else if (position == 2) {
			Intent intent = new Intent(mContext, SubMenuActivity.class);
			intent.putExtra("title", data.mTitle);
			mContext.startActivity(intent);
		} else if (position == 3) {
			Intent intent = new Intent(mContext, VenusListViewActivity.class);
			intent.putExtra("title", data.mTitle);
			mContext.startActivity(intent);
		} else if (position == 4) {
			Intent intent = new Intent(mContext, StarredActivity.class);
			intent.putExtra("title", data.mTitle);
			mContext.startActivity(intent);
		}
	}

}
