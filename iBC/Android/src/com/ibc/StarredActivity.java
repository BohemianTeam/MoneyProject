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
	
	@SuppressWarnings("unchecked")
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
		show();
	}

	@SuppressWarnings("unchecked")
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
//		if (_currentlyRunning != null) {
			System.out.println("add :" + venueCode);
			runnext(isVenue);
			
//		}
	}
	
	ServiceListener _listener = new ServiceListener() {
		
		@Override
		public void onComplete(Service service, ServiceRespone result) {
			increase++;
			
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
			}
			if (increase == total) {
				buildStarredList();
				hide();
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
	/*
	private void buildVenuesList() {
		
		VenueResponse venue = new VenueResponse();
		venue.venueName = "ESPAL 1";
		venue.venueCode = "1234";
		venue.icon = "/icon";
		venue.address = "Ciutat Villa,Barcelona";
		venues.add(venue);
		VenueResponse vn = (VenueResponse) venue.clone();
		venue.venueName = "ESPAL 2";
		venue.address = "Ciutat Villa,Barcelona";
		venues.add(vn);
	}
	
	private void buildEventsList() {
		
		EventResponse event = new EventResponse();
		event.eventCode = "111";
		event.eventTitle = "BABEL(WORDS)";
		event.icon = "/icon";
		event.venueName = "Mercat de ies Flors";
		event.dates = "15.04.11 - 17.04.11";
		event.price = "16 Û";
		events.add(event);
		EventResponse ev = (EventResponse) event.clone();
		ev.eventTitle = "DESCLASSIFICATS";
		ev.venueName = "La Villarroel";
		ev.dates = "12.03.11 - 08.05.11";
		ev.price = "De 22 a 26 Û";
		events.add(ev);
	}
	*/
	private void buildStarredList() {
		StarredListAdapter adapter = new StarredListAdapter(events, venues, this);
		_listView.setAdapter(adapter);
	}
	
}
