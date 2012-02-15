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
		
		List<VenuesResponse> venues = (List<VenuesResponse>) iBCApplication.sharedInstance().getData("venues");
		List<EventsResponse> events = (List<EventsResponse>) iBCApplication.sharedInstance().getData("events");
		show();
		if (venues != null) { 
			for (VenuesResponse venuesResponse : venues) {
				String venueCode = venuesResponse.venuesCode;
//				System.out.println(venueCode);
				add(venueCode, true);
			}
		}
		if (events != null) {
			for (EventsResponse eventsResponse : events) {
				String eventCode = eventsResponse.eventCode;
//				System.out.println(eventsResponse.eventCode);
				add(eventCode, false);
			}
		}
//		buildVenuesList();
//		buildEventsList();
		buildStarredList();
	}
	
	private synchronized void runnext(boolean isVenue) {
		if (_queue.isEmpty()) {
			hide();
			return ;
		} else {
			String code = _queue.keySet().iterator().next();
			_currentlyRunning = _queue.remove(code);
			System.out.println(code);
			if (isVenue) {
				_currentlyRunning.getVenue(code);
			} else {
				_currentlyRunning.getEvent(code);
			}
			
		}
	}
	
	private synchronized void add(String venueCode, boolean isVenue) {
		System.out.println("code put : " + venueCode);
		_queue.put(venueCode, new Service(_listener));
//		if (_currentlyRunning != null) {
			System.out.println("running :" + venueCode);
			runnext(isVenue);
			
//		}
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
	
	private void buildStarredList() {
		StarredListAdapter adapter = new StarredListAdapter(events, venues, this);
		_listView.setAdapter(adapter);
	}
	
}
