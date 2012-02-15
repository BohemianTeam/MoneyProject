package com.ibc;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import android.app.Activity;
import android.app.ProgressDialog;
import android.os.Bundle;
import android.widget.ListView;

import com.ibc.adapter.MenuListAdapter;
import com.ibc.model.MenuItemData;
import com.ibc.model.service.response.EventResponse;
import com.ibc.model.service.response.EventsResponse;
import com.ibc.model.service.response.StatusResponse;
import com.ibc.model.service.response.VenueResponse;
import com.ibc.model.service.response.VenuesResponse;
import com.ibc.service.ResultCode;
import com.ibc.service.Service;
import com.ibc.service.ServiceAction;
import com.ibc.service.ServiceListener;
import com.ibc.service.ServiceRespone;

public class MainActivity extends Activity {
	
	ArrayList<MenuItemData> mMenuList = new ArrayList<MenuItemData>();
	ListView mListView;
	Service _service;
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
        
        _service = new Service(_listener);
//        _service.getEvents("1", getCurrentTimeString());
        _service.getStarredList();
        show();
    }
    
    public String getCurrentTimeString() {
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		Date date = new Date();
		return dateFormat.format(date);
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
					iBCApplication.sharedInstance().putData("venues", status);
//					
					System.out.println("status = " + status.get(0).venuesName);
					
					Service sv = new Service(_listener);
					sv.getEvents("1", getCurrentTimeString());
				} else {
					System.out.println(result.getResultCode());
				}
			} else if (result.getAction() == ServiceAction.ActionGetVenue) {
				hide();
				if (result.getResultCode() == ResultCode.Success) {
					VenueResponse response = (VenueResponse) result.getData();
					if (null != response) {
						System.out.println(response.address + response.imgs.size());
					}
					Service s = new Service(_listener);
					s.getStarredList();
					//Extension methods 
					ExtensionList list = new ExtensionList();
					list.add("b");
					list.add("c");
					list.add("a");
					System.out.println(list.toString());
					list.sort();
					System.out.println(list.toString());
				}
			} else if (result.getAction() == ServiceAction.ActionGetEvents) {
				hide();
				if (result.getResultCode() == ResultCode.Success) {
					@SuppressWarnings("unchecked")
					List<EventsResponse> data = (List<EventsResponse>) result.getData();
					iBCApplication.sharedInstance().putData("events", data);
//					Service se = new Service(_listener);
//					se.getEvent(data.get(0).eventCode);
//					show();
				}
			} else if (result.getAction() == ServiceAction.ActionGetEvent) {
				hide();
				if (result.getResultCode() == ResultCode.Success) {
					EventResponse ev = (EventResponse) result.getData();
					System.out.println(ev.eventTitle);
				}
			} else if (result.getAction() == ServiceAction.ActionGetStarred) {
				if (result.getResultCode() == ResultCode.Success) {
					if (null == result.getData()) {
						
					}
					Service svGetVenues = new Service(_listener);
					svGetVenues.getVenues("41.385756", "2.164129");
				}
			} else if (result.getAction() == ServiceAction.ActionGetStarredList) {
				if (result.getResultCode() == ResultCode.Success) {
					if (null == result.getData()) {
						
					}
					Service svGetVenues = new Service(_listener);
					svGetVenues.getVenues("41.385756", "2.164129");
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