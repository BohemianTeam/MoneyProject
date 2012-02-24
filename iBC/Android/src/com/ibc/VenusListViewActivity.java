package com.ibc;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.TextView;

import com.ibc.adapter.EventListAdapter;
import com.ibc.controller.GPSService;
import com.ibc.controller.GPSService.GPSServiceListener;
import com.ibc.model.GPSInfo;
import com.ibc.model.service.response.VenuesResponse;
import com.ibc.service.ResultCode;
import com.ibc.service.Service;
import com.ibc.service.ServiceAction;
import com.ibc.service.ServiceListener;
import com.ibc.service.ServiceRespone;

public class VenusListViewActivity extends Activity {
	static final String TAG = "VenuesListViewAct";
	GPSService _gpsService;
	ListView _listView;
	EventListAdapter _adapter;
	List<VenuesResponse> list = new ArrayList<VenuesResponse>();
	ProgressDialog _dialog;
	Service _service;
	ServiceListener _listener = new ServiceListener() {
		
		@SuppressWarnings("unchecked")
		@Override
		public void onComplete(Service service, ServiceRespone result) {
			if (result.getAction() == ServiceAction.ActionGetVenues) {
				
				if (result.getResultCode() == ResultCode.Success) {
					list = (List<VenuesResponse>) result.getData();
					_adapter = new EventListAdapter(VenusListViewActivity.this, null, list, true);
					_listView.setAdapter(_adapter);
					_listView.setOnItemClickListener(_onItemClickListener);
					hide();
				} else {
					hide();
				}
			}
		}
	};
	
	OnItemClickListener _onItemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> adapter, View view, int position,
				long id) {
			// TODO Auto-generated method stub
			VenuesResponse item = list.get(position);
			Intent intent = new Intent(VenusListViewActivity.this, VenueDetailActivity.class);
			intent.putExtra("v_code", item.venuesCode);
			intent.putExtra("di", item.distance);
			VenusListViewActivity.this.startActivity(intent);
		}
	};
	
	double _lat;
	double _lon;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.events);
		Intent intent = getIntent();
        String title = intent.getStringExtra("title");
        if(null != title) {
        	((TextView) findViewById(R.id.title)).setText(title);
        }
		_listView = (ListView) findViewById(R.id.list);
		_gpsService = new GPSService(this, _gpsServiceListener);
		_service = new Service(_listener);
		
		boolean needGetGPS = intent.getBooleanExtra("need_get_gps", false);
		if (needGetGPS) {
			_gpsService.getCurrentLocation();
			show(true);
		} else {
			iBCApplication app = iBCApplication.sharedInstance();
			if (app.getData("lat") != null && app.getData("lon") != null) {
				_lat = (Double) app.getData("lat");
				_lon = (Double) app.getData("lon");
			}
			if (_lon == 0 || _lat == 0) {
				_gpsService.getCurrentLocation();
				show(true);
			} else {
				app.putData("lat", _lat);
				app.putData("lon", _lon);
				String slat = String.valueOf(_lat);
				String slon = String.valueOf(_lon);
				_service.getVenues(slat, slon);
				show(false);
			}
		}
	}
	
	GPSServiceListener _gpsServiceListener = new GPSServiceListener() {
		
		@Override
		public void onGetGPSSuccess(GPSInfo gpsInfo) {
			hide();
			show(false);
			_lat = gpsInfo.getLat();
			_lon = gpsInfo.getLng();
			iBCApplication app = iBCApplication.sharedInstance();
			app.putData("lat", _lat);
			app.putData("lon", _lon);
			String lat = String.valueOf(gpsInfo.getLat());
			String lon = String.valueOf(gpsInfo.getLng());
			_service.getVenues(lat, lon);
			Log.d(TAG, "Get GPS Success with lat : " + lat + "; lon : " + lon + " address :" + gpsInfo.getInfo());
		}
		
		@Override
		public void onGetGPSFail() {
			Log.d(TAG, "get GPS Failed");
			hide();
			show(false);
			_lat = 41.385756;
			_lon = 2.164129;
			_service.getVenues("41.385756", "2.164129");
		}
	};
	
	private void show(boolean isGetGPS) {
		if (isGetGPS) {
			_dialog = ProgressDialog.show(this, "", "Get GPS ...");
		} else {
			_dialog = ProgressDialog.show(this, "", "Loading Venues...",true , true);
		}
	}
	
	private void hide() {
		if (_dialog != null) {
			_dialog.dismiss();
		}
	}
}
