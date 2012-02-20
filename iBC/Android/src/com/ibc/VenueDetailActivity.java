package com.ibc;

import com.ibc.adapter.EventListAdapter;
import com.ibc.model.service.response.VenueResponse;
import com.ibc.service.ResultCode;
import com.ibc.service.Service;
import com.ibc.service.ServiceAction;
import com.ibc.service.ServiceListener;
import com.ibc.service.ServiceRespone;
import com.ibc.view.VenueAvatar;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

public class VenueDetailActivity extends Activity {
	
	public static final String TAG = "VenueDetailActivity";
	ProgressDialog _dialog;
	Service _service;
	ServiceListener _listener = new ServiceListener() {
		
		@Override
		public void onComplete(Service service, ServiceRespone result) {
			if (result.getAction() == ServiceAction.ActionGetVenue) {
				
				if (result.getResultCode() == ResultCode.Success) {
					VenueResponse venue = (VenueResponse) result.getData();
					displayView(venue);
				}
				hide();
			}
		}
	};
	
	View _navigationBar;
	TextView _venueName;
	TextView _desc;
	TextView _address;
	TextView _phone;
	TextView _email;
	TextView _url;
	ListView _eventList;
	VenueAvatar _avatar;
	LinearLayout _layoutImg;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.venue_detail);
		
		inflatViews();
		
		Intent intent = getIntent();
		String v_code = intent.getStringExtra("v_code");
		if (v_code != null && !v_code.isEmpty()) {
			_service = new Service(_listener);
			_service.getVenue(v_code);
			show();
		}
	}
	
	private void displayView(VenueResponse venue) {
		_venueName.setText(venue.venueName == null ? "" : venue.venueName);
		_desc.setText(venue.venueDescription == null ? "" : venue.venueDescription);
		_address.setText(venue.address == null ? "" : venue.address);
		_phone.setText(venue.phoneNumber == null ? "" : venue.phoneNumber);
		_email.setText(venue.email == null ? "" : venue.email);
		_url.setText(venue.webAddress == null ? "" : venue.webAddress);
		_avatar.getImage(venue);
	}
	
	private void inflatViews() {
		_navigationBar = (View) findViewById(R.id.navigation_bar);
		_navigationBar.findViewById(R.id.btnBack).setVisibility(View.VISIBLE);
		_navigationBar.findViewById(R.id.button_starred).setVisibility(View.VISIBLE);
		
		_venueName = (TextView) findViewById(R.id.venue_name);
		_desc = (TextView) findViewById(R.id.description);
		_address = (TextView) findViewById(R.id.address);
		_phone = (TextView) findViewById(R.id.venue_phone);
		_email = (TextView) findViewById(R.id.venue_email);
		_url = (TextView) findViewById(R.id.venue_url);
		_avatar = (VenueAvatar) findViewById(R.id.venue_avatar);
		_eventList = (ListView) findViewById(R.id.event_list);
		_layoutImg = (LinearLayout) findViewById(R.id.layout_img);
	}
	
	public void onGoToInfoBlocksClicked(View v) {
		Log.d(TAG, "on go to info clicked");
	}
	
	public void onGoToMapClicked(View v) {
		Log.d(TAG, "on go to map clicked");
	}
	
	private void show() {
		_dialog = ProgressDialog.show(this, "", "Loading ...",true , true);
	}
	
	private void hide() {
		if (_dialog != null) {
			_dialog.dismiss();
		}
	}
}
