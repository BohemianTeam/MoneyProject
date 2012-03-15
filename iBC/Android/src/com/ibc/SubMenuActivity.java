package com.ibc;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.TextView;

import com.ibc.adapter.MenuListAdapter;
import com.ibc.model.MenuItemData;

public class SubMenuActivity extends Activity implements OnItemClickListener{
	ArrayList<MenuItemData> mMenuList = new ArrayList<MenuItemData>();
	ListView mListView;
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        Intent intent = getIntent();
        String title = intent.getStringExtra("title");
        if(null != title) {
        	((TextView) findViewById(R.id.title)).setText(title.toUpperCase());
        }
        
        initMenu();
        mListView = (ListView) findViewById(R.id.list);
        MenuListAdapter adapter = new MenuListAdapter(mMenuList, this);
        mListView.setAdapter(adapter);
        mListView.setOnItemClickListener(this);
    }
    
    private void initMenu() {
    	MenuItemData data = new MenuItemData("EN CARTELL", getResources().getDrawable(R.drawable.v02_bt01));
    	MenuItemData data1 = new MenuItemData("PROPERAMENT", getResources().getDrawable(R.drawable.v02_bt02));
    	MenuItemData data2 = new MenuItemData(getResources().getString(R.string.u), getResources().getDrawable(R.drawable.v02_bt03));

    	
    	mMenuList.add(data);
    	mMenuList.add(data1);
    	mMenuList.add(data2);
    }

	@Override
	public void onItemClick(AdapterView<?> adapter, View view, int position, long id) {
		MenuItemData data = ((MenuListAdapter) mListView.getAdapter()).getItem(position);
		
		Intent intent = new Intent(this, EventsListViewActivity.class);
		intent.putExtra("title", data.mTitle);
		
		if (position == 0) {
			intent.putExtra("filter", "1");
		} else if (position == 1) {
			intent.putExtra("filter", "2");
		} else if (position == 2) {
			intent.putExtra("filter", "3");
		}
		
		this.startActivity(intent);
	}
}
