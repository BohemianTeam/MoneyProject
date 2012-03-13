package com.ibc.model;

import com.ibc.model.service.response.EventsResponse;

public class VenueRoomEventData {
	
	public String  _venueRoomName;
	public EventsResponse _event;
	
	public VenueRoomEventData(String name, EventsResponse event) {
		_venueRoomName = name;
		_event = event;
	}
}
