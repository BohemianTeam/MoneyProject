package com.ibc.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.RelativeLayout;
import android.widget.VideoView;

import com.ibc.R;

public class MyVideoView extends RelativeLayout {

	private View _root;
	
	public MyVideoView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		init(context);
	}

	public MyVideoView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		// TODO Auto-generated constructor stub
		init(context);
	}

	public MyVideoView(Context context, AttributeSet attrs) {
		super(context, attrs);
		// TODO Auto-generated constructor stub
		init(context);
	}

	private void init(Context context) {
		// TODO Auto-generated method stub
		_root = LayoutInflater.from(context).inflate(R.layout.video_view, this);
	}

	public VideoView getVideoView() {
		return (VideoView) _root.findViewById(R.id.myvideoview);
	}
}
