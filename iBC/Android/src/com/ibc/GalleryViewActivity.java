package com.ibc;

import java.util.List;

import android.app.Activity;
import android.os.Bundle;

import com.ibc.model.service.response.ImageResponse;
import com.ibc.view.HorizontalPager;
import com.ibc.view.ZoomImageView;

public class GalleryViewActivity extends Activity{

	List<ImageResponse> imgsResponse;
	HorizontalPager pager;
	int totalPage;
	@SuppressWarnings("unchecked")
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.gallery_view);
		pager = (HorizontalPager) findViewById(R.id.pager);
		pager.setOnScreenSwitchListener(listener);
		
		if (IBCApplication.sharedInstance().getData("imgs") != null) {
			imgsResponse = (List<ImageResponse>) IBCApplication.sharedInstance().getData("imgs");
			totalPage = imgsResponse.size();
		}
		
		pager.removeAllViews();
		
		for (int i = 0;i < totalPage;i++) {
			ImageResponse ir = imgsResponse.get(i);
			
			ZoomImageView img = new ZoomImageView(this);
			img.getImage(ir.imagePath);
			
			pager.addView(img);
		}
	}
	
	HorizontalPager.OnScreenSwitchListener listener = new HorizontalPager.OnScreenSwitchListener() {
		
		@Override
		public void onScreenSwitched(int screen) {
			System.out.println("screen = " + screen);
		}
	};
}
