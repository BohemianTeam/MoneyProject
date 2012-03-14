package com.ibc;

import java.util.List;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.webkit.WebView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.ibc.model.service.response.EventResponse;
import com.ibc.model.service.response.InfoBlocksResponse;
import com.ibc.model.service.response.StarredListResponse;
import com.ibc.model.service.response.VenueResponse;
import com.ibc.service.ResultCode;
import com.ibc.service.Service;
import com.ibc.service.ServiceAction;
import com.ibc.service.ServiceListener;
import com.ibc.service.ServiceRespone;
import com.ibc.view.EventAvatar;
import com.ibc.view.VenueAvatar;

public class InfoBlocsDetailActivity extends Activity {
	
	EventAvatar _avatar;
	View _navigationBar;
	TextView _title;
	TextView _name;
	TextView _date;
	TextView _price;
	TextView _dramatic;
	TextView _infoTitle;
	WebView _infoDesc;
	
	TextView _venueName;
	TextView _venueDesc;
	VenueAvatar _vnavatar;
	
	LinearLayout _eventInfo;
	LinearLayout _venueInfo;
	
	EventResponse _event;
	InfoBlocksResponse _info;
	
	VenueResponse _venue;
	
	boolean isStarred = false;
	boolean isVenue;
	ProgressDialog _dialog;
	Service _service;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.info_blocks_view);
		inflateView();
		IBCApplication app = IBCApplication.sharedInstance();
		Intent intent = getIntent();
		isVenue = intent.getBooleanExtra("isvenue", false);
		if (isVenue) {
			if (app.getData("venue") != null && app.getData("infoblocs") != null) {
				_venue = (VenueResponse) app.getData("venue");
				_info = (InfoBlocksResponse) app.getData("infoblocs");
			}
		} else {
			if (app.getData("event") != null && app.getData("infoblocs") != null) {
				_event = (EventResponse) app.getData("event");
				_info = (InfoBlocksResponse) app.getData("infoblocs");
			}
		}
		
		displayView(_event, _info, _venue);
	}
	
	private void displayView(EventResponse event, InfoBlocksResponse ibr, VenueResponse venue) {
		
		if (isVenue) {
			_venueInfo.setVisibility(View.VISIBLE);
			_eventInfo.setVisibility(View.GONE);
			if(_venue != null) {
				String title = venue.venueName;
				if(null != title) {
		        	((TextView) findViewById(R.id.title)).setText(title.toUpperCase());
		        }
				setNavigationBar(venue);
				_vnavatar.getImage(_venue);
				_venueName.setText(venue.venueName == null ? "" : venue.venueName);
				_venueDesc.setText(venue.venueDescription == null ? "" : venue.venueDescription);
			}
		} else {
			_venueInfo.setVisibility(View.GONE);
			_eventInfo.setVisibility(View.VISIBLE);
			if (_event != null) {
				((TextView) findViewById(R.id.title)).setText(event.eventTitle);
				setNavigationBar(event);
				_avatar.getImage(event);
				_title.setText(event.eventTitle == null ? "" : event.eventTitle);
				_name.setText(event.venueName == null ? "" : event.venueName);
				_date.setText(event.dates == null ? "" : event.dates);
				_price.setText(event.price == null ? "" : event.price);
				_dramatic.setText(event.genre == null ? "" : event.genre);
			}
		}
		
		_infoTitle.setText(ibr.title == null ? "" : ibr.title.toUpperCase());
		_infoDesc.getSettings().setJavaScriptEnabled(true);
		String html = ibr.description == null? "" : ibr.description;
		String mime = "text/html";
		String encoding = "utf-8";
		_infoDesc.loadDataWithBaseURL(null, html, mime, encoding, null);
	}
	
	private void setNavigationBar(VenueResponse venue) {
		IBCApplication app = IBCApplication.sharedInstance();
		if (app.getList() != null) {
			List<StarredListResponse> list = app.getList();
			for (StarredListResponse response : list) {
				if (response.code.equalsIgnoreCase(_venue.venueCode)) {
					isStarred = true;
					_navigationBar.findViewById(R.id.button_starred).setBackgroundResource(R.drawable.starred);
					break;
				}
			}
		}
	}
	
	private void setNavigationBar(EventResponse event) {
		IBCApplication app = IBCApplication.sharedInstance();
		if (app.getList() != null) {
			List<StarredListResponse> list = app.getList();
			for (StarredListResponse response : list) {
				if (response.code.equalsIgnoreCase(_event.eventCode)) {
					isStarred = true;
					_navigationBar.findViewById(R.id.button_starred).setBackgroundResource(R.drawable.starred);
					break;
				}
			}
		}
	}
	
	private void inflateView() {
		_avatar = (EventAvatar) findViewById(R.id.event_avatar);
		_dramatic = (TextView) findViewById(R.id.dramatic);
		_date = (TextView) findViewById(R.id.dates);
		_price = (TextView) findViewById(R.id.price);
		_title = (TextView) findViewById(R.id.event_title);
		_name = (TextView) findViewById(R.id.event_name);
		_navigationBar = findViewById(R.id.navigation_bar);
		_navigationBar.findViewById(R.id.button_starred).setVisibility(View.VISIBLE);
		_infoTitle = (TextView) findViewById(R.id.info_title);
		_infoDesc = (WebView) findViewById(R.id.info_description);
		
		_venueName = (TextView) findViewById(R.id.venue_name);
		_venueDesc = (TextView) findViewById(R.id.description);
		_vnavatar = (VenueAvatar) findViewById(R.id.venue_avatar);
		
		_eventInfo = (LinearLayout) findViewById(R.id.event_info);
		_venueInfo = (LinearLayout) findViewById(R.id.venue_info);
	}
	
	ServiceListener _listener = new ServiceListener() {
		
		@Override
		public void onComplete(Service service, ServiceRespone result) {
			if (result.getAction() == ServiceAction.ActionSetStarred) {
				if (result.getResultCode() == ResultCode.Success) {
					boolean ok = (Boolean) result.getData();
					if (ok) {
						List<StarredListResponse> list = IBCApplication.sharedInstance().getList();
						isStarred = !isStarred;
						if (isStarred) {
							_navigationBar.findViewById(R.id.button_starred).setBackgroundResource(R.drawable.starred);
							
							StarredListResponse response = new StarredListResponse();
							response.code = _event.eventCode;
							list.add(response);
						} else {
							_navigationBar.findViewById(R.id.button_starred).setBackgroundResource(R.drawable.unstarred);
							for (StarredListResponse response : list) {
								if (response.code.equalsIgnoreCase(_event.eventCode)) {
									list.remove(response);
									break;
								}
							}
						}
					}
				}
				
				hide();
			}
		}
	};
	
	public void onStarredClicked(View v) {
		_service.stop();
		if (isVenue) {
			_service.setStarred(_venue.venueCode, isStarred == true ? "off" : "on");
		} else {
			_service.setStarred(_event.eventCode, isStarred == true ? "off" : "on");
		}
		show();
	}
	
	public void onBuyClicked(View v) {
		if (_event.buyURL.trim().length() > 0) {
			this.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(_event.buyURL)));
		}
	}
	
	private void show() {
		_dialog = ProgressDialog.show(this, "", getString(R.string.loading),true , true);
	}
	
	private void hide() {
		if (_dialog != null) {
			_dialog.dismiss();
		}
	}
}
