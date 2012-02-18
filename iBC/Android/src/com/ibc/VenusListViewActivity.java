package com.ibc;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.widget.ListView;
import android.widget.TextView;

import com.ibc.adapter.EventListAdapter;
import com.ibc.model.service.response.VenuesResponse;
import com.ibc.service.ResultCode;
import com.ibc.service.Service;
import com.ibc.service.ServiceAction;
import com.ibc.service.ServiceListener;
import com.ibc.service.ServiceRespone;

public class VenusListViewActivity extends Activity {
	
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
		_service = new Service(_listener);
		_service.getVenues("41.385756", "2.164129");
		show();
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
