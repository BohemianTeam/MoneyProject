package com.ibc.model.service.response;

import com.google.gson.annotations.SerializedName;

public class EventSessionsResponse {
	
	@SerializedName("id")
	public String sessionCode;
	
	@SerializedName("itdate")
	public String date;
	
	@SerializedName("detail")
	public String detail;

}
