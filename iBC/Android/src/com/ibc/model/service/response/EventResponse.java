package com.ibc.model.service.response;

import java.util.List;

import com.google.gson.annotations.SerializedName;

public class EventResponse implements Cloneable{
	
	public Object clone() {
		try {
			return super.clone();
		} catch (CloneNotSupportedException e) {
			return null;
		}
	}
	
	@SerializedName("ec")
	public String eventCode;
	
	@SerializedName("et")
	public String eventTitle;
	
	@SerializedName("vn")
	public String venueName;
	
	@SerializedName("vc")
	public String venueCode;
	
	@SerializedName("dt")
	public String dates;
	
	@SerializedName("pr")
	public String price;
	
	@SerializedName("ic")
	public String icon;
	
	@SerializedName("gn")
	public String genre;
	
	@SerializedName("sy")
	public String synopsis;
	
	@SerializedName("sh")
	public String sharedContent;
	
	@SerializedName("buyUrl")
	public String buyURL;
	
	@SerializedName("cal")
	public boolean showCalendar;
	
	
	
	public List<ImageResponse> imgs;
	public List<VideoResponse> vids;
	public List<InfoBlocksResponse> ib;
}
