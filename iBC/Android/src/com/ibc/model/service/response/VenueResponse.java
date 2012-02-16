package com.ibc.model.service.response;

import java.util.List;

import com.google.gson.annotations.SerializedName;

public class VenueResponse implements Cloneable{
	
	public Object clone() {
		try {
			return super.clone();
		} catch (CloneNotSupportedException e) {
			return null;
		}
	}
	
	@SerializedName("vc")
	public String venueCode;
	
	@SerializedName("vn")
	public String venueName;
	
	@SerializedName("ds")
	public String venueDescription;
	
	@SerializedName("ad")
	public String address;
	
	@SerializedName("ph")
	public String phoneNumber;
	
	@SerializedName("em")
	public String email;
	
	@SerializedName("url")
	public String webAddress;
	
	@SerializedName("cd")
	public String cordinates;
	
	@SerializedName("di")
	public String di;
	
	@SerializedName("ic")
	public String icon;
	
	public List<ImageResponse> imgs;
	
	public List<VideoResponse> vids;
	
	@SerializedName("sh")
	public String shareContent;
	
	public List<InfoBlocksResponse> ib;
	
	public List<VenueRoomResponse> vr;
}
