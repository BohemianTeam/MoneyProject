package com.ibc;

import android.os.Bundle;
import android.widget.TextView;

import com.google.android.maps.MapActivity;
import com.ibc.model.Maplocation;
import com.ibc.model.service.response.VenueResponse;
import com.ibc.view.MapLocationViewer;
import com.ibc.view.MapViewOverlay;

public class AddressActivity extends MapActivity {

	private VenueResponse _venue;
	private MapLocationViewer _mapViewer;
	private TextView _phone;
	private TextView _email;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.address_view);
		_venue = (VenueResponse) iBCApplication.sharedInstance().getData("venue");
		String title = _venue.venueName;
		if(null != title) {
        	((TextView) findViewById(R.id.title)).setText(title);
        }
		
		_phone = (TextView) findViewById(R.id.phone);
		_email = (TextView) findViewById(R.id.email);
		_mapViewer = (MapLocationViewer) findViewById(R.id.mapview);
		
		iBCApplication app = iBCApplication.sharedInstance();
		if (app.getData("lat") != null && app.getData("lon") != null) {
			double lat = (Double) app.getData("lat");
			double lon = (Double) app.getData("lon");
			Maplocation maplocation = new Maplocation(_venue, lat, lon);
			
			MapViewOverlay overlay = new MapViewOverlay(maplocation, _mapViewer);
			_mapViewer.getMapView().getOverlays().add(overlay);
			_mapViewer.getMapView().getController().setCenter(maplocation.getPoint());
		} 
		_phone.setText(_venue.phoneNumber == null ? "" : _venue.phoneNumber);
		_email.setText(_venue.email == null ? "" : _venue.email);
	}

	@Override
	protected boolean isRouteDisplayed() {
		return false;
	}

}
