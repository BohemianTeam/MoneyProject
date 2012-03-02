package com.ibc;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.TextView;

import com.ibc.adapter.EventListAdapter;
import com.ibc.model.service.response.EventsResponse;
import com.ibc.service.ResultCode;
import com.ibc.service.Service;
import com.ibc.service.ServiceAction;
import com.ibc.service.ServiceListener;
import com.ibc.service.ServiceRespone;

public class EventsListViewActivity extends Activity{
	ListView _listView;
	EventListAdapter _adapter;
	List<EventsResponse> list = new ArrayList<EventsResponse>();
	ProgressDialog _dialog;
	Service _service;
	ServiceListener _listener = new ServiceListener() {
		
		@SuppressWarnings("unchecked")
		@Override
		public void onComplete(Service service, ServiceRespone result) {
			if (result.getAction() == ServiceAction.ActionGetEvents) {
				
				if (result.getResultCode() == ResultCode.Success) {
					list = (List<EventsResponse>) result.getData();
					_adapter = new EventListAdapter(EventsListViewActivity.this, list,null, false);
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
			EventsResponse item = list.get(position);
			Intent intent = new Intent(EventsListViewActivity.this, EventDetailActivity.class);
			intent.putExtra("e_code", item.eventCode);
			startActivity(intent);
		}
	};
	
	private boolean _needReturn;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.events);
		Intent intent = getIntent();
        String title = intent.getStringExtra("title");
        if(null != title) {
        	((TextView) findViewById(R.id.title)).setText(title);
        } else {
        	((TextView) findViewById(R.id.title)).setText("ESPAIS");
        }
		_listView = (ListView) findViewById(R.id.list);
		_service = new Service(_listener);
		String date = intent.getStringExtra("date") == null ? "" : intent.getStringExtra("date");
		if (date != null && date.equalsIgnoreCase("")) {
			_service.getEvents("1", getCurrentTimeString());
		} else {
			_needReturn = true;
			_service.getEvents("1", date);
		}
		show();
		
	}
	
	public String getCurrentTimeString() {
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		Date date = new Date();
		return dateFormat.format(date);
	}
	
	private void show() {
		_dialog = ProgressDialog.show(this, "", "Loading events...",true , true);
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
	
	
}
