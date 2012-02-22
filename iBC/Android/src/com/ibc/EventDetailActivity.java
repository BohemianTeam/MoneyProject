package com.ibc;

import java.util.List;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.ibc.model.service.response.EventResponse;
import com.ibc.model.service.response.EventsResponse;
import com.ibc.model.service.response.ImageResponse;
import com.ibc.model.service.response.InfoBlocksResponse;
import com.ibc.model.service.response.StarredResponse;
import com.ibc.service.ResultCode;
import com.ibc.service.Service;
import com.ibc.service.ServiceAction;
import com.ibc.service.ServiceListener;
import com.ibc.service.ServiceRespone;
import com.ibc.view.EventAvatar;
import com.ibc.view.EventRow;
import com.ibc.view.ImageItem;

public class EventDetailActivity extends Activity {

	ProgressDialog _dialog;
	Service _service;
	ServiceListener _listener = new ServiceListener() {
		
		@Override
		public void onComplete(Service service, ServiceRespone result) {
			if (result.getAction() == ServiceAction.ActionGetEvent) {
				
				if (result.getResultCode() == ResultCode.Success) {
					EventResponse event = (EventResponse) result.getData();
					
					String title = event.eventTitle;
					if(null != title) {
			        	((TextView) findViewById(R.id.title)).setText(title);
			        }
					displayView(event);
				}
				
				hide();
			}
		}
	};
	
	EventAvatar _avatar;
	View _navigationBar;
	LinearLayout _llVideo;
	LinearLayout _llRow;
	TextView _title;
	TextView _name;
	TextView _date;
	TextView _price;
	TextView _dramatic;
//	ListView _list;
	TextView _desc;
	
	private void displayView(EventResponse event) {
		setNavigationBar(event);
		_avatar.getImage(event);
		_title.setText(event.eventTitle == null ? "" : event.eventTitle);
		_name.setText(event.venueName == null ? "" : event.venueName);
		_date.setText(event.dates == null ? "" : event.dates);
		_price.setText(event.price == null ? "" : event.price);
		_dramatic.setText(event.genre == null ? "" : event.genre);
		_desc.setText(event.synopsis == null ? "" : Html.fromHtml(event.synopsis));
		
		inflateImageLayout(event);
		inflateRowItem(event);
	}
	
	private void setNavigationBar(EventResponse event) {
		iBCApplication app = iBCApplication.sharedInstance();
		if (app.getData("starred") != null) {
			StarredResponse response = (StarredResponse) app.getData("starred");
			List<EventsResponse> list = response.events;
			for (EventsResponse e : list) {
				if (event.eventCode.equalsIgnoreCase(e.eventCode)) {
					_navigationBar.findViewById(R.id.button_starred).setBackgroundResource(R.drawable.starred);
					break;
				}
			}
		}
	}
	
	private void inflateRowItem(EventResponse event) {
		_llRow.removeAllViews();
		List<InfoBlocksResponse> ibs = event.ib;
		if (ibs != null && ibs.size() > 0) {
			for (int i = 0;i < ibs.size();i++) {
				InfoBlocksResponse ib = ibs.get(i);
				EventRow row = new EventRow(this);
				row.setItemViewType(ib.title, i);
				_llRow.addView(row);
			}
		} else {
			//using test data
			for (int i = 0;i < 6;i++) {
				EventRow row = new EventRow(this);
				row.setItemViewType("PREMISS " + i, i);
				_llRow.addView(row);
			}
		}
		
	}

	private void inflateImageLayout(EventResponse event) {
		_llVideo.removeAllViews();

		if (event.imgs != null) {
			for (ImageResponse img : event.imgs) {
				ImageItem item = new ImageItem(this);
				item.getImage(img.thumbPath);
				_llVideo.addView(item);
			}
		}
		/*
		if (event.vids != null) {
			for (VideoResponse video : event.vids) {
				MyVideoView videoView = new MyVideoView(this);
				videoView.getVideoView().setVideoPath(video.url);
				_llVideo.addView(videoView);
			}
		}
		*/
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.event_detail);
		
		inflateView();
		
		Intent intent = getIntent();
		String code = intent.getStringExtra("e_code");
		if (code != null) {
			_service = new Service(_listener);
			_service.getEvent(code);
			show();
		}
	}
	
	private void inflateView() {
		
		_avatar = (EventAvatar) findViewById(R.id.event_avatar);
		_llVideo = (LinearLayout) findViewById(R.id.ll_video);
//		_list = (ListView) findViewById(R.id.list);
		_desc = (TextView) findViewById(R.id.event_desc);
		_dramatic = (TextView) findViewById(R.id.dramatic);
		_date = (TextView) findViewById(R.id.dates);
		_price = (TextView) findViewById(R.id.price);
		_title = (TextView) findViewById(R.id.event_title);
		_name = (TextView) findViewById(R.id.event_name);
		_navigationBar = findViewById(R.id.navigation_bar);
		_navigationBar.findViewById(R.id.button_starred).setVisibility(View.VISIBLE);
		_llRow = (LinearLayout) findViewById(R.id.layout_row);
	}
	
	public void onBuyClicked(View v) {
		System.out.println("on buy clicked");
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
