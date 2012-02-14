package com.ibc.model.service.response;

import com.google.gson.annotations.SerializedName;

public class VideoResponse {
	@SerializedName("u")
	public String url;
	@SerializedName("c")
	public String caption;
}
