package com.ibc;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.ListView;
import android.widget.TextView;

import com.ibc.adapter.MenuListAdapter;
import com.ibc.model.MenuItemData;

public class SubMenuActivity extends Activity {
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
        	((TextView) findViewById(R.id.title)).setText(title);
        }
        
        initMenu();
        mListView = (ListView) findViewById(R.id.list);
        MenuListAdapter adapter = new MenuListAdapter(mMenuList, this);
        mListView.setAdapter(adapter);
//        mListView.setOnItemClickListener(adapter);
    }
    
    private void initMenu() {
    	MenuItemData data = new MenuItemData("EN CARTELL", getResources().getDrawable(R.drawable.v02_bt01));
    	MenuItemData data1 = new MenuItemData("PROPERAMENT", getResources().getDrawable(R.drawable.v02_bt02));
    	MenuItemData data2 = new MenuItemData("́LTIMA OPORTUNITAT", getResources().getDrawable(R.drawable.v02_bt03));

    	
    	mMenuList.add(data);
    	mMenuList.add(data1);
    	mMenuList.add(data2);
    }
}
