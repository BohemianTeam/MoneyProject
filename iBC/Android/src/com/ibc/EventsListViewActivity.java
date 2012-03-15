package com.ibc;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.ibc.adapter.EventListAdapter;
import com.ibc.model.service.response.EventsResponse;
import com.ibc.service.ResultCode;
import com.ibc.service.Service;
import com.ibc.service.ServiceAction;
import com.ibc.service.ServiceListener;
import com.ibc.service.ServiceRespone;

public class EventsListViewActivity extends Activity implements TextWatcher{
	View _listviewHeader;
	EditText _search;
	Button _done;
	ListView _listView;
	EventListAdapter _adapter;
	boolean _isSearching;
	List<EventsResponse> list = new ArrayList<EventsResponse>();
	List<EventsResponse> listBySearch = new ArrayList<EventsResponse>();
	ProgressDialog _dialog;
	Service _service;
	ServiceListener _listener = new ServiceListener() {
		
		@SuppressWarnings("unchecked")
		@Override
		public void onComplete(Service service, ServiceRespone result) {
			if (result.getAction() == ServiceAction.ActionGetEvents) {
				
				if (result.getResultCode() == ResultCode.Success) {
					list = (List<EventsResponse>) result.getData();
					_adapter = new EventListAdapter(EventsListViewActivity.this, list, null, false);
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
			EventsResponse item;
			if (_isSearching) {
				item = listBySearch.get(position - _listView.getHeaderViewsCount());
			} else {
				item = list.get(position - _listView.getHeaderViewsCount());
			}
			Intent intent = new Intent(EventsListViewActivity.this, EventDetailActivity.class);
			intent.putExtra("e_code", item.eventCode);
			startActivity(intent);
		}
	};
	
	private boolean _needReturn;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.events);
		Intent intent = getIntent();
        String title = intent.getStringExtra("title");
        if(null != title) {
        	((TextView) findViewById(R.id.title)).setText(title.toUpperCase());
        } else {
        	((TextView) findViewById(R.id.title)).setText("ESPAIS");
        }
        
        _listviewHeader = LayoutInflater.from(this).inflate(R.layout.header_listview, null);
        _search = (EditText) _listviewHeader.findViewById(R.id.search);
        
        _done = (Button) _listviewHeader.findViewById(R.id.done);
        _done.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				InputMethodManager imm = (InputMethodManager)getSystemService(Context.INPUT_METHOD_SERVICE);
				imm.hideSoftInputFromWindow(_search.getWindowToken(), 0);
				_adapter = new EventListAdapter(EventsListViewActivity.this, list, null, false);
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
		
		
		_service = new Service(_listener);
		String date = intent.getStringExtra("date") == null ? "" : intent.getStringExtra("date");
		String filter = intent.getStringExtra("filter") == null ? "1" : intent.getStringExtra("filter");
		if (date != null && date.equalsIgnoreCase("")) {
			_service.getEvents(filter, getCurrentTimeString());
		} else {
			
			String yyyy = date.substring(0, 4);
			String splash = "/";
			String mm = date.substring(4, 6);
			String dd = date.substring(6, 8);
			
			String dateTitle = dd + splash + mm + splash + yyyy;
			
			((TextView) findViewById(R.id.title)).setText(dateTitle.toUpperCase());
			_needReturn = true;
			_service.getEvents(filter, date);
			
		}
		show();
		
	}
	
	public String getCurrentTimeString() {
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		Date date = new Date();
		return dateFormat.format(date);
	}
	
	private void show() {
		_dialog = ProgressDialog.show(this, "", getResources().getString(R.string.loading_events),true , true);
	}
	
	private void hide() {
		if (_dialog != null) {
			_dialog.dismiss();
		}
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		// TODO Auto-generated method stub
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			if (_needReturn) {
				setResult(RESULT_OK);
				finish();
			} else {
				finish();
				return true;
			}
		}
		return super.onKeyDown(keyCode, event);
	}

	@Override
	public void afterTextChanged(Editable s) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void beforeTextChanged(CharSequence s, int start, int count,
			int after) {
		// TODO Auto-generated method stub
		_isSearching = true;
	}

	@Override
	public void onTextChanged(CharSequence s, int start, int before, int count) {
		// TODO Auto-generated method stub
		_done.setVisibility(View.VISIBLE);
		listBySearch.clear();
		String text = _search.getText().toString();
		int len = text.length();
		for (EventsResponse v : list) {
			if (len <= v.eventTitle.length()) {
				if (text.equalsIgnoreCase(v.eventTitle.substring(0, len))) {
					listBySearch.add(v);
				} 
			}
		}
		
		for (EventsResponse v : list) {
			if (v.eventTitle.contains(text)) {
				listBySearch.add(v);
			}
		}
		
		_adapter = new EventListAdapter(EventsListViewActivity.this, listBySearch, null, false);
		_listView.setAdapter(_adapter);
	}
	
	
}
