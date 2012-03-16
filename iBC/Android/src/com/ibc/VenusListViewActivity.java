package com.ibc;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.EditText;
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

public class VenusListViewActivity extends Activity implements OnScrollListener, TextWatcher{
	static final String TAG = "VenuesListViewAct";
	GPSService _gpsService;
	ListView _listView;
	View _listviewHeader;
	EditText _search;
	Button _done;
	EventListAdapter _adapter;
	List<VenuesResponse> list = new ArrayList<VenuesResponse>();
	List<VenuesResponse> listBySearch = new ArrayList<VenuesResponse>();
	ProgressDialog _dialog;
	Service _service;
	boolean _loadMore;
	boolean _isSearching;
	
	@Override
	public void onScroll(AbsListView view, int firstVisibleItem,
			int visibleItemCount, int totalItemCount) {
		_loadMore = firstVisibleItem + visibleItemCount >= totalItemCount;
		if (_loadMore) {
			System.out.println("load more");
//			_adapter.getCount() += _adapter.rowOfPage;
		}
	}

	@Override
	public void onScrollStateChanged(AbsListView view, int scrollState) {
		
	}
	
	ServiceListener _listener = new ServiceListener() {
		
		@SuppressWarnings("unchecked")
		@Override
		public void onComplete(Service service, ServiceRespone result) {
			if (result.getAction() == ServiceAction.ActionGetVenues) {
				
				if (result.getResultCode() == ResultCode.Success) {
					list = (List<VenuesResponse>) result.getData();
					/*
					if (_orderedAlphabet) {
						list = Util.sortBy(SortFilter.Name, list);
					} else {
						list = Util.sortBy(SortFilter.Distance, list);
					}
					*/
					
					_adapter = new EventListAdapter(VenusListViewActivity.this, null, list, true, _orderedAlphabet);
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
			VenuesResponse item = null;
			if (_isSearching) {
				item = listBySearch.get(position - _listView.getHeaderViewsCount());
			} else {
				item = list.get(position - _listView.getHeaderViewsCount());
			}
			Intent intent = new Intent(VenusListViewActivity.this, VenueDetailActivity.class);
			intent.putExtra("v_code", item.venuesCode);
			intent.putExtra("di", item.distance);
			VenusListViewActivity.this.startActivity(intent);
		}
	};
	
	double _lat;
	double _lon;
	boolean _orderedAlphabet;
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
        _orderedAlphabet = intent.getBooleanExtra("ordered_alphabet", false);
        
        _listviewHeader = LayoutInflater.from(this).inflate(R.layout.header_listview, null);
        _search = (EditText) _listviewHeader.findViewById(R.id.search);
        
        _done = (Button) _listviewHeader.findViewById(R.id.done);
        _done.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
				imm.hideSoftInputFromWindow(_search.getWindowToken(), 0);
				_adapter = new EventListAdapter(VenusListViewActivity.this, null, list, true, _orderedAlphabet);
				_listView.setAdapter(_adapter);
				_done.setVisibility(View.GONE);
				_search.setText("");
				_isSearching = false;
			}
		});
		
        _search.addTextChangedListener(this);
		_listView = (ListView) findViewById(R.id.list);
		
		if (_listView.getHeaderViewsCount() == 0) {
			_listView.addHeaderView(_listviewHeader);
		}
		
		_gpsService = new GPSService(this, _gpsServiceListener);
		_service = new Service(_listener);
		
		boolean needGetGPS = intent.getBooleanExtra("need_get_gps", false);
		if (needGetGPS) {
			_gpsService.getCurrentLocation();
			show(true);
		} else {
			IBCApplication app = IBCApplication.sharedInstance();
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
				if (_orderedAlphabet) {
					_service.getVenues();
				} else {
					_service.getVenues(slat, slon);
				}
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
			IBCApplication app = IBCApplication.sharedInstance();
			app.putData("lat", _lat);
			app.putData("lon", _lon);
			String lat = String.valueOf(gpsInfo.getLat());
			String lon = String.valueOf(gpsInfo.getLng());
			if (_orderedAlphabet) {
				_service.getVenues();
			} else {
				_service.getVenues(lat, lon);
			}
			Log.d(TAG, "Get GPS Success with lat : " + lat + "; lon : " + lon + " address :" + gpsInfo.getInfo());
		}
		
		@Override
		public void onGetGPSFail() {
			Log.d(TAG, "get GPS Failed");
			hide();
			show(false);
			_lat = 41.385756;
			_lon = 2.164129;
			IBCApplication app = IBCApplication.sharedInstance();
			app.putData("lat", _lat);
			app.putData("lon", _lon);
			if (_orderedAlphabet) {
				_service.getVenues();
			} else {
				_service.getVenues("41.385756", "2.164129");
			}
		}
	};
	
	private void show(boolean isGetGPS) {
		if (isGetGPS) {
			_dialog = ProgressDialog.show(this, "", getString(R.string.loading_gps));
		} else {
			_dialog = ProgressDialog.show(this, "", getString(R.string.loading_venues),true , true);
		}
	}
	
	private void hide() {
		if (_dialog != null) {
			_dialog.dismiss();
		}
	}

	@Override
	public void afterTextChanged(Editable s) {
		
	}

	@Override
	public void beforeTextChanged(CharSequence s, int start, int count,
			int after) {
		_isSearching = true;
	}

	@Override
	public void onTextChanged(CharSequence s, int start, int before, int count) {
		_done.setVisibility(View.VISIBLE);
		listBySearch.clear();
		String text = _search.getText().toString();
		int len = text.length();
		for (VenuesResponse v : list) {
			if (len <= v.venuesName.length()) {
				if (text.equalsIgnoreCase(v.venuesName.substring(0, len))) {
					listBySearch.add(v);
				}
			}
			
		}
		
		for (VenuesResponse v : list) {
			if (v.venuesName.contains(text)) {
				listBySearch.add(v);
			}
		}
		
		_adapter = new EventListAdapter(VenusListViewActivity.this, null, listBySearch, true, _orderedAlphabet);
		_listView.setAdapter(_adapter);
	}

}
