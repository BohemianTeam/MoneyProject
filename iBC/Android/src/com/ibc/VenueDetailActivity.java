package com.ibc;

import java.util.List;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.ibc.adapter.VenueRoomListAdapter;
import com.ibc.controller.GPSService;
import com.ibc.controller.GPSService.GPSServiceListener;
import com.ibc.model.GPSInfo;
import com.ibc.model.service.response.ImageResponse;
import com.ibc.model.service.response.InfoBlocksResponse;
import com.ibc.model.service.response.StarredListResponse;
import com.ibc.model.service.response.VenueResponse;
import com.ibc.model.service.response.VideoResponse;
import com.ibc.service.ResultCode;
import com.ibc.service.Service;
import com.ibc.service.ServiceAction;
import com.ibc.service.ServiceListener;
import com.ibc.service.ServiceRespone;
import com.ibc.util.Config;
import com.ibc.util.Util;
import com.ibc.view.EventRow;
import com.ibc.view.ImageItem;
import com.ibc.view.VenueAvatar;

public class VenueDetailActivity extends Activity {
	
	public static final String TAG = "VenueDetailActivity";
	ProgressDialog _dialog;
	Service _service;
	VenueResponse _venue;
	ServiceListener _listener = new ServiceListener() {
		
		@Override
		public void onComplete(Service service, ServiceRespone result) {
			if (result.getAction() == ServiceAction.ActionGetVenue) {
				
				if (result.getResultCode() == ResultCode.Success) {
					VenueResponse venue = (VenueResponse) result.getData();
					if (venue.di == null || venue.di.equals("null")) {
						venue.di = VenueDetailActivity.this.getIntent().getStringExtra("di");
					}
					_venue = venue;
					String title = venue.venueName;
					if(null != title) {
			        	((TextView) findViewById(R.id.title)).setText(title);
			        }
					displayView(venue);
					
					if (venue.vr != null && venue.vr.size() > 0) {
						if (venue.vr.get(0).events.size() > 0) {
							VenueRoomListAdapter adapter = new VenueRoomListAdapter(VenueDetailActivity.this, venue.vr);
							_eventList.setAdapter(adapter);
							_eventList.setOnItemClickListener(adapter);
							_listHeader.setVisibility(View.GONE);
						} else {
							if (venue.vr.get(0).name != null) {
								_listHeader.setVisibility(View.VISIBLE);
								_roomName.setText(venue.vr.get(0).name);
							}
						}
					} else {
					}
				}
				hide();
			} else if (result.getAction() == ServiceAction.ActionSetStarred) {
				if (result.getResultCode() == ResultCode.Success) {
					boolean ok = (Boolean) result.getData();
					if (ok) {
						List<StarredListResponse> list = IBCApplication.sharedInstance().getList();
						isStarred = !isStarred;
						if (isStarred) {
							_navigationBar.findViewById(R.id.button_starred).setBackgroundResource(R.drawable.starred);
							
							StarredListResponse response = new StarredListResponse();
							response.code = _venue.venueCode;
							list.add(response);
						} else {
							_navigationBar.findViewById(R.id.button_starred).setBackgroundResource(R.drawable.unstarred);
							for (StarredListResponse response : list) {
								if (response.code.equalsIgnoreCase(_venue.venueCode)) {
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
	LinearLayout _listHeader;
	TextView _roomName;
	LinearLayout _llInfoblocs;
	
	boolean isStarred = false;
	
	double _lat;
	double _lon;
	
	private GPSServiceListener _gpsServiceListener = new GPSServiceListener() {
		
		@Override
		public void onGetGPSSuccess(GPSInfo gpsInfo) {
			_lat = gpsInfo.getLat();
			_lon = gpsInfo.getLng();
			IBCApplication app = IBCApplication.sharedInstance();
			app.putData("lat", _lat);
			app.putData("lon", _lon);
			
			Intent intent = VenueDetailActivity.this.getIntent();
			String v_code = intent.getStringExtra("v_code");
			if (v_code != null ) {
				_service = new Service(_listener);
				_service.getVenue(v_code);
			}
		}
		
		@Override
		public void onGetGPSFail() {
			_lat = 41.385756;
			_lon = 2.164129;
			IBCApplication app = IBCApplication.sharedInstance();
			app.putData("lat", _lat);
			app.putData("lon", _lon);
			
			Intent intent = VenueDetailActivity.this.getIntent();
			String v_code = intent.getStringExtra("v_code");
			if (v_code != null ) {
				_service = new Service(_listener);
				_service.getVenue(v_code);
			}
		}
	};
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.venue_detail);
		
		inflatViews();
		IBCApplication app = IBCApplication.sharedInstance();
		if (app.getData("lat") == null && app.getData("lon") == null) {
			GPSService gpsService = new GPSService(app, _gpsServiceListener );
			gpsService.getCurrentLocation();
			show();
		} else {
			Intent intent = getIntent();
			String v_code = intent.getStringExtra("v_code");
			if (v_code != null ) {
				_service = new Service(_listener);
				_service.getVenue(v_code);
				show();
			}
		}
		
	}
	
	private void displayView(VenueResponse venue) {
		setNavigationBar(venue);
		_venueName.setText(venue.venueName == null ? "" : venue.venueName);
		_desc.setText(venue.venueDescription == null ? "" : venue.venueDescription);
		String address = venue.address == null ? "" : venue.address;
		_address.setText(Html.fromHtml(address));
		_phone.setText(venue.phoneNumber == null ? "" : venue.phoneNumber);
		_email.setText(venue.email == null ? "" : venue.email);
		_url.setText(venue.webAddress == null ? "" : venue.webAddress);
		_avatar.getImage(venue);
		inflatImageLayout(venue);
		inflateInfoblocs(venue);
	}
	
	private void inflatImageLayout(VenueResponse venue) {
		_layoutImg.removeAllViews();
		
		if (venue.imgs != null) {
			for (ImageResponse img : venue.imgs) {
				ImageItem item = new ImageItem(this);
				item.getImage(img.thumbPath);
				_layoutImg.addView(item);
			}
		}
		
		if (venue.vids != null && venue.vids.size() > 0) {
			for (VideoResponse video : venue.vids) {
				String id = Util.youtubeIdByURL(video.url);
				if (id.trim().length() > 0) {
					ImageItem item = new ImageItem(this);
					item.setVideoIconVisible();
					item.setVideoURL(video.url);
					String imgURL = String.format(Config.YOUTUBE_IMG_URL, id);
					item.getImage(imgURL, false);
					_layoutImg.addView(item);
				}
			}
		}
	}
	
	private void inflateInfoblocs(VenueResponse venue) {
		_llInfoblocs.removeAllViews();
		List<InfoBlocksResponse> ibs = venue.ib;
		
		if (ibs != null) {
			for (int i = 0;i < ibs.size();i++) {
				final InfoBlocksResponse ib = ibs.get(i);
				final EventRow row = new EventRow(this);
				row.setItemViewType(ib.title.toUpperCase(), i);
				row.setTag(i);
				row.setOnClickListener(new OnClickListener() {
					
					@Override
					public void onClick(View v) {
						IBCApplication app = IBCApplication.sharedInstance();
						app.putData("venue", _venue);
						app.putData("infoblocs", ib);
						Intent intent = new Intent(VenueDetailActivity.this, InfoBlocsDetailActivity.class);
						intent.putExtra("isvenue", true);
						startActivity(intent);
					}
				});
				_llInfoblocs.addView(row);
			}
		}
	}
	
	private void inflatViews() {
		_navigationBar = (View) findViewById(R.id.navigation_bar);
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
		_listHeader = (LinearLayout) findViewById(R.id.header_list);
		_roomName = (TextView) findViewById(R.id.room_name);
		_llInfoblocs = (LinearLayout) findViewById(R.id.layout_row);
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
	
	public void onGoToMapClicked(View v) {
		IBCApplication.sharedInstance().putData("venue", _venue);
		Intent intent = new Intent(this, AddressActivity.class);
		startActivity(intent);
	}
	
	public void onStarredClicked(View v) {
		_service.stop();
		_service.setStarred(_venue.venueCode, isStarred == true ? "off" : "on");
		show();
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
