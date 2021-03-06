package com.ibc.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import com.ibc.model.MenuItemData;
import com.ibc.view.ListMenuRowHolder;

public class MenuListAdapter extends BaseAdapter {
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
		
		ListMenuRowHolder rowHolder = new ListMenuRowHolder(mContext);
		rowHolder.setData(getItem(position), ((position % 2) == 0));
		
		return rowHolder;
	}

}
