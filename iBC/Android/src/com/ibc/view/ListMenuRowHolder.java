package com.ibc.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.ibc.R;
import com.ibc.model.MenuItemData;

public class ListMenuRowHolder extends RelativeLayout{

	ImageView mButton;
	TextView mTitle;
	ImageView mBG;
	ImageView mBackground;
	public static final String EVEN_ROW_COLOR = "C4E1EE";
	public static final String ODD_ROW_COLOR = "9ACDE2";
	public ListMenuRowHolder(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		inflateView(context);
	}

	public ListMenuRowHolder(Context context, AttributeSet attrs) {
		super(context, attrs);
		// TODO Auto-generated constructor stub
		inflateView(context);
	}
	 
	private void inflateView(Context context) {
		LayoutInflater.from(context).inflate(R.layout.menu_item_view, this);
		
		mButton = (ImageView) findViewById(R.id.button);
		mTitle = (TextView) findViewById(R.id.title);
		mBG = (ImageView) findViewById(R.id.bg2);
		mBackground = (ImageView) findViewById(R.id.bg);
	}
	
	public void setData(MenuItemData data, boolean isEven) {
		mButton.setBackgroundDrawable(data.mLabel);
		mTitle.setText(data.mTitle);
		if (isEven) {
			mBG.setVisibility(View.INVISIBLE);
			mBackground.setVisibility(View.VISIBLE);
		} else {
			mBG.setVisibility(View.VISIBLE);
			mBackground.setVisibility(View.INVISIBLE);
		}
	}
}
