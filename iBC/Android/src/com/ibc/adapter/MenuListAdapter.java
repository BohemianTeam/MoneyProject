package com.ibc.adapter;

import java.util.ArrayList;

import vn.lmchanh.lib.widget.calendar.CalendarActivity;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;

import com.ibc.EventsListViewActivity;
import com.ibc.StarredActivity;
import com.ibc.VenusListViewActivity;
import com.ibc.iBCApplication;
import com.ibc.model.MenuItemData;
import com.ibc.view.ListMenuRowHolder;

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
			iBCApplication application = iBCApplication.sharedInstance();
			application.putData("lat", 41.385756);
			application.putData("lon", 2.164129);

			mContext.startActivity(intent);
		} else if (position == 2) {
	        /*
			CalendarProvider provider = CalendarProvider.sharedInstance();
	        boolean hasCalendar = provider.hasCalendar();
	        if (hasCalendar) {
				Intent i = new Intent();
				i.setComponent(ComponentName.unflattenFromString("com.android.calendar/com.android.calendar.AgendaActivity"));
				mContext.startActivity(i);
	        } else {
	        	AlertDialog.Builder builder = new Builder(mContext);
	        	builder.setMessage("Don't provider agenda calendar");
	        	builder.setTitle("Alert");
	        	AlertDialog dialog = builder.create();
	        	dialog.show();
	        }
	        */
			/*
			Intent intent = new Intent(Intent.ACTION_EDIT);  

			intent.setType("vnd.android.cursor.item/event");

			intent.putExtra("title", "Demon Hunter");

			intent.putExtra("description", "Are there demon nearby?");

			intent.putExtra("beginTime", System.currentTimeMillis());

			intent.putExtra("endTime", System.currentTimeMillis() + 1800 * 1000);
			*/
	        Intent intent = CalendarActivity.createCalendarIntent((Activity) mContext, true, false, false, true);
//			Intent intent = new Intent(mContext, SubMenuActivity.class);
//			intent.putExtra("title", data.mTitle);
			mContext.startActivity(intent);
		} else if (position == 3) {
			Intent intent = new Intent(mContext, VenusListViewActivity.class);
			intent.putExtra("title", data.mTitle);
			intent.putExtra("need_get_gps", true);
			mContext.startActivity(intent);
		} else if (position == 4) {
			Intent intent = new Intent(mContext, StarredActivity.class);
			intent.putExtra("title", data.mTitle);
			mContext.startActivity(intent);
		}
	}

}
