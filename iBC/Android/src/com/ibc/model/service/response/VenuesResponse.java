package com.ibc.model.service.response;

import com.google.gson.annotations.SerializedName;

public class VenuesResponse {
	@SerializedName("vc")
	public String venuesCode;
	@SerializedName("vn")
	public String venuesName;
	@SerializedName("ct")
	public String city;
	@SerializedName("di")
	public String distance;
	@SerializedName("ic")
	public String icon;
}
