package com.ibc.model;

import com.ibc.model.service.response.EventResponse;

public class VenueRoomEventData {
	
	public String  _venueRoomName;
	public EventResponse _event;
	
	public VenueRoomEventData(String name, EventResponse event) {
		_venueRoomName = name;
		_event = event;
	}
}
