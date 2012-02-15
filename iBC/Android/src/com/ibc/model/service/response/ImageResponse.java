package com.ibc.model.service.response;

import com.google.gson.annotations.SerializedName;

public class ImageResponse {
	@SerializedName("u")
	public String imagePath;
	@SerializedName("t")
	public String thumbPath;
	@SerializedName("c")
	public String caption;
}
