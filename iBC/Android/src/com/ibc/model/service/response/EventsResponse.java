package com.ibc.model.service.response;

import com.google.gson.annotations.SerializedName;

public class EventsResponse {
	@SerializedName("ec")
	public String eventCode;
	
	@SerializedName("et")
	public String eventTitle;
	
	@SerializedName("vn")
	public String venueName;
	
	@SerializedName("dt")
	public String date;
	
	@SerializedName("pr")
	public String price;
	
	@SerializedName("ic")
	public String icon;
	
}
