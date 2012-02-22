package com.ibc.view;

import com.ibc.R;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class EventRow extends RelativeLayout {

	private TextView _title;
	private int _position;
	private ImageView _even;
	private ImageView _odd;
	private View _root;
	
	public EventRow(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		init(context);
	}

	public EventRow(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		// TODO Auto-generated constructor stub
		init(context);
	}

	public EventRow(Context context, AttributeSet attrs) {
		super(context, attrs);
		// TODO Auto-generated constructor stub
		init(context);
	}

	private void init(Context context) {
		// TODO Auto-generated method stub
		_root = LayoutInflater.from(context).inflate(R.layout.event_row, this);
		_title = (TextView) _root.findViewById(R.id.title);
		_even = (ImageView) _root.findViewById(R.id.bg2);
		_odd = (ImageView) _root.findViewById(R.id.bg);
	}
	
	public void setItemViewType(String title , int pos) {
		_position = pos;
		if (_position % 2 == 0) {
			_even.setVisibility(VISIBLE);
			_odd.setVisibility(INVISIBLE);
		} else {
			_odd.setVisibility(VISIBLE);
			_even.setVisibility(INVISIBLE);
		}
		
		if (title != null) {
			_title.setText(title);
		}
	}
}
