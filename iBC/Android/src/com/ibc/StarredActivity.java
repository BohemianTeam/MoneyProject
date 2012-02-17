package com.ibc;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.widget.ListView;
import android.widget.TextView;

import com.ibc.adapter.StarredListAdapter;
import com.ibc.model.service.response.EventResponse;
import com.ibc.model.service.response.EventsResponse;
import com.ibc.model.service.response.StarredResponse;
import com.ibc.model.service.response.VenueResponse;
import com.ibc.model.service.response.VenuesResponse;
import com.ibc.service.ResultCode;
import com.ibc.service.Service;
import com.ibc.service.ServiceAction;
import com.ibc.service.ServiceListener;
import com.ibc.service.ServiceRespone;

public class StarredActivity extends Activity{
	
	ListView _listView;
	
	List<EventResponse> events = new ArrayList<EventResponse>();
	List<VenueResponse> venues = new ArrayList<VenueResponse>();
	ProgressDialog _dialog;
	
	Map<String, Service> _queue;
	Service _currentlyRunning;
	
	int increase = 0;
	int total = 0;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.starred);
		Intent intent = getIntent();
        String title = intent.getStringExtra("title");
        if(null != title) {
        	((TextView) findViewById(R.id.title)).setText(title);
        }
        _queue = new LinkedHashMap<String, Service>();
		_listView = (ListView) findViewById(R.id.list);
		
		Service service = new Service(_listener);
		service.getStarred();
		show();
		/*
		StarredResponse response = (StarredResponse) iBCApplication.sharedInstance().getData("starred");
		if (response != null) {
			List<VenuesResponse> venues = response.venues;
			List<EventsResponse> events = response.events;
			
			if (venues.size() == 0 && events.size() == 0) {
				Service service = new Service(_listener);
				service.getStarred();
				show();
			} else {
				Service service = new Service(_listener);
				service.getEventSessions(events.get(1).eventCode);
				StarredListAdapter adapter = new StarredListAdapter(events, venues, this);
				_listView.setAdapter(adapter);
			}
		}
		
		List<String> venueCodes =  (List<String>) iBCApplication.sharedInstance().getData("venue_codes");
		List<String> eventCodes =  (List<String>) iBCApplication.sharedInstance().getData("event_codes");
		
		if (venueCodes !=null && eventCodes != null) {
			total = venueCodes.size() + eventCodes.size();
			for (String code : venueCodes) {
				add(code, true);
			}
			for (String code : eventCodes) {
				add(code, false);
			}
		} else {
			buildByCorrectInstID();
		}
		*/
//		show();
	}

	@SuppressWarnings({ "unchecked", "unused" })
	private void buildByCorrectInstID() {
		List<VenuesResponse> venues = (List<VenuesResponse>) iBCApplication.sharedInstance().getData("venues");
		List<EventsResponse> events = (List<EventsResponse>) iBCApplication.sharedInstance().getData("events");
		total = 0;
		if (venues != null && 4 > venues.size()) {
			
			total += venues.size();
		} else {
			total += 4;
		}
		if (4 > events.size()) {
			total += events.size();
		} else {
			total += 4;
		}
		if (venues != null) { 
			for (int i = 0;i < total / 2;i++) {
			VenuesResponse venuesResponse = venues.get(i);
				String venueCode = venuesResponse.venuesCode;
				add(venueCode, true);
			}
		}
		if (events != null) {
			for (int i = 0; i < total / 2; i++) {
				EventsResponse eventsResponse = events.get(i);
				String eventCode = eventsResponse.eventCode;
				add(eventCode, false);
			}
		}
	}
	
	private synchronized void runnext(boolean isVenue) {
		if (_queue.isEmpty()) {
			hide();
			return ;
		} else {
			String code = _queue.keySet().iterator().next();
			_currentlyRunning = _queue.remove(code);
			
			if (isVenue) {
				_currentlyRunning.getVenue(code);
			} else {
				_currentlyRunning.getEvent(code);
			}
			
			System.out.println("running : " +code);
		}
	}
	
	private synchronized void add(String venueCode, boolean isVenue) {
		System.out.println("code put : " + venueCode);
		_queue.put(venueCode, new Service(_listener));
		System.out.println("add :" + venueCode);
		runnext(isVenue);
	}

	ServiceListener _listener = new ServiceListener() {
		
		@Override
		public void onComplete(Service service, ServiceRespone result) {
			
			if (result.getAction() == ServiceAction.ActionGetVenue) {
				if (result.getResultCode() == ResultCode.Success) {
					VenueResponse data = (VenueResponse) result.getData();
					venues.add(data);
				}
			} else if (result.getAction() == ServiceAction.ActionGetEvent) {
				if (result.getResultCode() == ResultCode.Success) {
					EventResponse data = (EventResponse) result.getData();
					events.add(data);
				}
			} else if (result.getAction() == ServiceAction.ActionGetStarred) {
				
				if (result.getResultCode() == ResultCode.Success) {
					StarredResponse response = (StarredResponse) result.getData();
					if (response != null) {
						List<VenuesResponse> venues = response.venues;
						List<EventsResponse> events = response.events;
						StarredListAdapter adapter = new StarredListAdapter(events, venues, StarredActivity.this);
						_listView.setAdapter(adapter);
					}
				}
				hide();
			}
			if (result.getAction() == ServiceAction.ActionGetEvent || result.getAction() == ServiceAction.ActionGetVenue) {
				increase++;
				if (increase == total) {
					buildStarredList();
					hide();
				}
			}
			
		}
	};
	
	private void show() {
    	_dialog = ProgressDialog.show(this, "", "Loading...", true, true);
    }
    
    private void hide() {
    	if (null != _dialog) {
    		_dialog.dismiss();
    	}
    }

	private void buildStarredList() {
//		StarredListAdapter adapter = new StarredListAdapter(events, venues, this);
//		_listView.setAdapter(adapter);
	}
	
}
