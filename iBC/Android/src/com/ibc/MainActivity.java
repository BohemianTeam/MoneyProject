package com.ibc;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import android.app.Activity;
import android.app.ProgressDialog;
import android.os.Bundle;
import android.widget.ListView;

import com.ibc.adapter.MenuListAdapter;
import com.ibc.controller.ResultCode;
import com.ibc.controller.Service;
import com.ibc.controller.ServiceAction;
import com.ibc.controller.ServiceListener;
import com.ibc.controller.ServiceRespone;
import com.ibc.model.MenuItemData;
import com.ibc.model.service.response.StatusResponse;
import com.ibc.model.service.response.VenueResponse;
import com.ibc.model.service.response.VenuesResponse;

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
        mSVGetStatus.getVenues("41.385756", "2.164129");
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
			hide();
			if (result.getAction() == ServiceAction.ActionGetStatus) {
				if (result.getResultCode() == ResultCode.Success) {
					StatusResponse status = (StatusResponse) result.getData();
					System.out.println("status = " + status.getMindt());
				} else {
					System.out.println(result.getResultCode());
				}
			} else if (result.getAction() == ServiceAction.ActionGetVenues) {
				if (result.getResultCode() == ResultCode.Success) {
					@SuppressWarnings("unchecked")
					List<VenuesResponse> status = (List<VenuesResponse>) result.getData();
					System.out.println("status = " + status.get(0).venuesName);
					
					Service sv = new Service(_listener);
					sv.getVenue(status.get(0).venuesCode);
					show();
				} else {
					System.out.println(result.getResultCode());
				}
			} else if (result.getAction() == ServiceAction.ActionGetVenue) {
				hide();
				if (result.getResultCode() == ResultCode.Success) {
					@SuppressWarnings("unused")
					VenueResponse response = (VenueResponse) result.getData();
					//Extension methods 
					ExtensionList list = new ExtensionList();
					list.add("b");
					list.add("c");
					list.add("a");
					System.out.println(list.toString());
					list.sort();
					System.out.println(list.toString());
				}
			}
		}
	};
	
	@SuppressWarnings("serial")
	public class ExtensionList extends ArrayList<String> {

		public void sort() { //or import static java.util.Collections.sort;
			Collections.sort(this);
		}
		
		public String first() {
			return this.get(0);
		}
		
		public String last() {
			return this.get(this.size() - 1);
		}
		/*
		public void toPolar(double x, double y, {double, double => void } rThetaReceiver) {
			
		}
		*/
		//void a() default {System.out.println("a")};
	}
}