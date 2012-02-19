package com.ibc;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
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
					hide();
				} else {
					hide();
				}
			}
		}
	};
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
		double lat = intent.getDoubleExtra("lat", -1);
		double lon = intent.getDoubleExtra("lon", -1);
		if (lat == lon && lon == -1) {
			_gpsService.getGSP();
			show(true);
		} else {
			String slat = String.valueOf(lat);
			String slon = String.valueOf(lon);
			_service.getVenues(slat, slon);
			show(false);
		}
	}
	
	GPSServiceListener _gpsServiceListener = new GPSServiceListener() {
		
		@Override
		public void onGetGPSSuccess(GPSInfo gpsInfo) {
			hide();
			show(false);
			String lat = String.valueOf(gpsInfo.getLat());
			String lon = String.valueOf(gpsInfo.getLng());
			_service.getVenues(lat, lon);
			Log.d(TAG, "Get GPS Success with lat : " + lat + "; lon : " + lon);
		}
		
		@Override
		public void onGetGPSFail() {
			Log.d(TAG, "get GPS Failed");
			hide();
			show(false);
			_service.getVenues("41.385756", "2.164129");
		}
	};
	
	private void show(boolean isGetGPS) {
		if (isGetGPS) {
			_dialog = ProgressDialog.show(this, "", "Get GPS ...",true , true);
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
