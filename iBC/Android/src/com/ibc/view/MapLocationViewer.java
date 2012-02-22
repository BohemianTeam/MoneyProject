package com.ibc.view;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.LinearLayout;

import com.google.android.maps.MapView;
import com.ibc.R;

public class MapLocationViewer extends LinearLayout {

	Context _context;
	private MapView _mapView;
	public MapLocationViewer(Context context) {
		super(context);
		init(context);
	}

	public MapLocationViewer(Context context, AttributeSet attrs) {
		super(context, attrs);
		init(context);
	}
	
	private void init(Context context) {
		_context = context;
		setOrientation(LinearLayout.VERTICAL);
		setLayoutParams(new LinearLayout.LayoutParams(android.view.ViewGroup.LayoutParams.FILL_PARENT,android.view.ViewGroup.LayoutParams.FILL_PARENT));

		_mapView = new MapView(getContext(),"0_CaK9g9NQHB8LmHq564xMiIWt2La3dpx7XjULg");
		_mapView.setEnabled(true);
		_mapView.setClickable(true);
		_mapView.setBackgroundResource(R.drawable.white_round_rect);
		addView(_mapView);
		
		_mapView.getController().setZoom(16);
	}
	
	public MapView getMapView() {
		return this._mapView;
	}
}
