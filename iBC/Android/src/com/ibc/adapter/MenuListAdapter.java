package com.ibc.adapter;

import java.util.ArrayList;

import com.ibc.StarredActivity;
import com.ibc.SubMenuActivity;
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

	@Override
	public void onItemClick(AdapterView<?> adapterView, View view, int position, long id) {
		// TODO Auto-generated method stub
		if (position == mDatas.size() - 1) {
			MenuItemData data = mDatas.get(position);
			Intent intent = new Intent(mContext, StarredActivity.class);
			intent.putExtra("title", data.mTitle);
			mContext.startActivity(intent);
		} else {
			MenuItemData data = mDatas.get(position);
			Intent intent = new Intent(mContext, SubMenuActivity.class);
			intent.putExtra("title", data.mTitle);
			mContext.startActivity(intent);
		}
	}

}
