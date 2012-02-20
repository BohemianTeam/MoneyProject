package com.ibc.model.service.response;

import java.util.List;

import com.google.gson.annotations.SerializedName;

public class VenueRoomResponse {
	@SerializedName("n")
	public String name;

	public List<EventResponse> events;
}
