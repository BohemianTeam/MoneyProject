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
		_service = new Service(_listener);
		_service.getEvents("1", getCurrentTimeString());
		show();
	}
	
	public String getCurrentTimeString() {
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		Date date = new Date();
		return dateFormat.format(date);
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
