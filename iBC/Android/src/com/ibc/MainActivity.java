package com.ibc;

import java.util.ArrayList;

import com.ibc.adapter.MenuListAdapter;
import com.ibc.controller.ResultCode;
import com.ibc.controller.Service;
import com.ibc.controller.ServiceAction;
import com.ibc.controller.ServiceListener;
import com.ibc.controller.ServiceRespone;
import com.ibc.model.MenuItemData;

import android.app.Activity;
import android.app.ProgressDialog;
import android.os.Bundle;
import android.widget.ListView;

public class MainActivity extends Activity {
	
	ArrayList<MenuItemData> mMenuList = new ArrayList<MenuItemData>();
	ListView mListView;
	Service mSVGetStatus;
	ProgressDialog _dialog;
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        initMenu();
        mListView = (ListView) findViewById(R.id.list);
        MenuListAdapter adapter = new MenuListAdapter(mMenuList, this);
        mListView.setAdapter(adapter);
        mListView.setOnItemClickListener(adapter);
        
        mSVGetStatus = new Service(_listener);
        mSVGetStatus.getStatus();
        show();
    }
    
    private void show() {
    	_dialog = ProgressDialog.show(this, "", "Loading...", true, true);
    }
    
    private void hide() {
    	if (null != _dialog) {
    		_dialog.dismiss();
    	}
    }
    
    private void initMenu() {
    	MenuItemData data = new MenuItemData("ESPECTACLES", getResources().getDrawable(R.drawable.v01_bt01));
    	MenuItemData data1 = new MenuItemData("ESPAIS", getResources().getDrawable(R.drawable.v01_bt02));
    	MenuItemData data2 = new MenuItemData("AGENDA", getResources().getDrawable(R.drawable.v01_bt03));
    	MenuItemData data3 = new MenuItemData("A PROP", getResources().getDrawable(R.drawable.v01_bt04));
    	MenuItemData data4 = new MenuItemData("FAVORITS", getResources().getDrawable(R.drawable.v01_bt05));
    	
    	mMenuList.add(data);
    	mMenuList.add(data1);
    	mMenuList.add(data2);
    	mMenuList.add(data3);
    	mMenuList.add(data4);
    }
    
    private ServiceListener _listener = new ServiceListener() {
		
		@Override
		public void onComplete(Service service, ServiceRespone result) {
			if (result.getAction() == ServiceAction.ActionGetStatus) {
				hide();
				if (result.getResultCode() == ResultCode.Success) {
					String status = (String) result.getData();
					System.out.println(status);
				} else {
					System.out.println(result.getResultCode());
				}
			}
		}
	};
}