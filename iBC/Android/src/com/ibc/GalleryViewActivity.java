package com.ibc;

import java.util.List;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;

import com.ibc.model.service.response.ImageResponse;
import com.ibc.view.HorizontalPager;
import com.ibc.view.TouchImageView.TouchImageViewDelegate;
import com.ibc.view.ZoomImageView;

public class GalleryViewActivity extends Activity {

	private List<ImageResponse> imgsResponse;
	private HorizontalPager pager;
	private int totalPage;
	private int mCurrentPage;
	
	LinearLayout mBottomLayout;
	
//	SDPlayerCoverFlow coverFlow;
	@SuppressWarnings("unchecked")
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.gallery_view);
		
		Intent intent = getIntent();
		mCurrentPage = intent.getIntExtra("position", 0);
		
		mBottomLayout = (LinearLayout) findViewById(R.id.bottom_layout);
		pager = (HorizontalPager) findViewById(R.id.pager);
		pager.setOnScreenSwitchListener(listener);
		
		if (IBCApplication.sharedInstance().getData("imgs") != null) {
			imgsResponse = (List<ImageResponse>) IBCApplication.sharedInstance().getData("imgs");
			totalPage = imgsResponse.size();
		}
		
//		coverFlow = (SDPlayerCoverFlow) findViewById(R.id.player_coverflow);
//		coverFlow.setSpacing(0);
//		SDPlayerCoverFlowAdapter adapter = new SDPlayerCoverFlowAdapter(this, imgsResponse);
//		coverFlow.setAdapter(adapter);
//		coverFlow.setSelection(0, true);
		
		pager.removeAllViews();
		
		for (int i = 0;i < totalPage;i++) {
			ImageResponse ir = imgsResponse.get(i);
			
			ZoomImageView img = new ZoomImageView(this);
			img.getImageView().delegate = mDelegate;
			img.getImage(ir.imagePath);
			
			pager.addView(img);
		}
		
		pager.setCurrentScreen(mCurrentPage, true);
		
	}
	
	TouchImageViewDelegate mDelegate = new TouchImageViewDelegate() {
		
		@Override
		public void onTouchEventStateChanged(boolean visible) {
			mBottomLayout.setVisibility(visible? View.VISIBLE : View.INVISIBLE);
		}
	};
	
	HorizontalPager.OnScreenSwitchListener listener = new HorizontalPager.OnScreenSwitchListener() {
		
		@Override
		public void onScreenSwitched(int screen) {
			mCurrentPage = screen;
			System.out.println("current screen = " + screen);
			pager.setCurrentScreen(mCurrentPage, true);
		}
	};
	
	public void onArrowLeftClicked(View v) {
		if (mCurrentPage > 0) {
			mCurrentPage -= 1;
		} else {
			mCurrentPage = 0;
		}
		
		pager.setCurrentScreen(mCurrentPage, true);
	}
	
	public void onArrowRightClicked(View v) {
		if (mCurrentPage < totalPage) {
			mCurrentPage += 1;
		} else {
			mCurrentPage = totalPage;
		}
		
		pager.setCurrentScreen(mCurrentPage, true);
	}

}
