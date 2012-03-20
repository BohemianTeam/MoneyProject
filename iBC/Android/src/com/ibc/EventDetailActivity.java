package com.ibc;

import java.util.ArrayList;
import java.util.List;

import vn.lmchanh.lib.time.MCDate;
import vn.lmchanh.lib.time.MCDateSpan;
import vn.lmchanh.lib.widget.calendar.CalendarActivity;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.webkit.WebView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.ibc.model.service.response.EventResponse;
import com.ibc.model.service.response.EventSessionsResponse;
import com.ibc.model.service.response.ImageResponse;
import com.ibc.model.service.response.InfoBlocksResponse;
import com.ibc.model.service.response.StarredListResponse;
import com.ibc.model.service.response.VideoResponse;
import com.ibc.service.ResultCode;
import com.ibc.service.Service;
import com.ibc.service.ServiceAction;
import com.ibc.service.ServiceListener;
import com.ibc.service.ServiceRespone;
import com.ibc.util.Config;
import com.ibc.util.Util;
import com.ibc.view.EventAvatar;
import com.ibc.view.EventRow;
import com.ibc.view.ImageItem;

public class EventDetailActivity extends Activity {
	EventResponse _event;
	ProgressDialog _dialog;
	Service _service;
	ServiceListener _listener = new ServiceListener() {
		
		@SuppressWarnings("unchecked")
		@Override
		public void onComplete(Service service, ServiceRespone result) {
			if (result.getAction() == ServiceAction.ActionGetEvent) {
				
				if (result.getResultCode() == ResultCode.Success) {
					EventResponse event = (EventResponse) result.getData();
					_event = event;
					String title = event.eventTitle;
					if(null != title) {
			        	//((TextView) findViewById(R.id.title)).setText(title.toUpperCase());
			        }
					displayView(event);
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
			} else if (result.getAction() == ServiceAction.ActionGetEventSessions) {
				if (result.getResultCode() == ResultCode.Success) {
					List<EventSessionsResponse> list = (List<EventSessionsResponse>) result.getData();
					ArrayList<MCDateSpan> dates = new ArrayList<MCDateSpan>();
					for (EventSessionsResponse response : list) {
						MCDate st = Util.mcDateFromDateString(response.date);
						MCDate e = Util.mcDateFromDateString(response.date);
						MCDateSpan date = new MCDateSpan(st, e, response.sessionCode, response.detail, _event.buyURL);
						dates.add(date);
					}
					Intent intent = CalendarActivity.createCalendarIntent(EventDetailActivity.this, true, false, false, true, false);
					intent.putExtra(CalendarActivity.EVENT_SESSIONS, dates);
					EventDetailActivity.this.startActivity(intent);
				}
				
				hide();
			}
		}
	};
	
	EventAvatar _avatar;
	View _navigationBar;
	LinearLayout _llVideo;
	LinearLayout _llInfoblocs;
	TextView _title;
	TextView _name;
	TextView _date;
	TextView _price;
	TextView _dramatic;
//	ListView _list;
	WebView _desc;
	
	boolean isStarred = false;
	
	private void displayView(EventResponse event) {
		setNavigationBar(event);
		_avatar.getImage(event);
		_title.setText(event.eventTitle == null ? "" : event.eventTitle.toUpperCase());
		_name.setText(event.venueName == null ? "" : event.venueName);
		_date.setText(event.dates == null ? "" : event.dates);
		_price.setText(event.price == null ? "" : event.price);
		_dramatic.setText(event.genre == null ? "" : event.genre);
		String html = event.synopsis == null ? "" : event.synopsis;
		String mime = "text/html";
		String encoding = "utf-8";
		_desc.loadDataWithBaseURL(null, html, mime, encoding, null);
		
		inflateImageLayout(event);
		inflateInfoblocs(event);
		
		if (event.buyURL.trim().length() <= 0) {
			findViewById(R.id.compra).setVisibility(View.INVISIBLE);
		} else {
			findViewById(R.id.compra).setVisibility(View.VISIBLE);
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
	
	private void inflateInfoblocs(EventResponse event) {
		_llInfoblocs.removeAllViews();
		List<InfoBlocksResponse> ibs = event.ib;
		
		if (ibs != null) {
			if (_event.showCalendar ) {
				InfoBlocksResponse ibr = new InfoBlocksResponse();
				ibr.title = "HORARIS I PREUS";
				ibs.add(0, ibr);
			}
			for (int i = 0;i < ibs.size();i++) {
				final InfoBlocksResponse ib = ibs.get(i);
				final EventRow row = new EventRow(this);
				row.setItemViewType(ib.title.toUpperCase(), i);
				row.setTag(i);
				row.setOnClickListener(new OnClickListener() {
					
					@Override
					public void onClick(View v) {
						int tag = (Integer) row.getTag();
						if (_event.showCalendar && tag == 0) {
							_service.stop();
							_service.getEventSessions(_event.eventCode);
							show();
						} else {
							IBCApplication app = IBCApplication.sharedInstance();
							app.putData("event", _event);
							app.putData("infoblocs", ib);
							startActivity(new Intent(EventDetailActivity.this, InfoBlocsDetailActivity.class));
						}
					}
				});
				_llInfoblocs.addView(row);
			}
		}
		
	}

	private void inflateImageLayout(EventResponse event) {
		_llVideo.removeAllViews();

		if (event.imgs != null) {
			for (ImageResponse img : event.imgs) {
				ImageItem item = new ImageItem(this);
				item.getImage(img.thumbPath);
				item.setOnClickListener(new OnClickListener() {
					
					@Override
					public void onClick(View v) {
						Intent intent = new Intent(EventDetailActivity.this, GalleryViewActivity.class);
						IBCApplication app = IBCApplication.sharedInstance();
						app.putData("imgs", _event.imgs);
						startActivity(intent);
					}
				});
//				BitmapManager.INSTANCE.loadBitmap(Config.URL_IMAGE + img.thumbPath, item.getImageView(), item.getImageView().getWidth(), item.getImageView().getHeight());
//				BitmapManager.INSTANCE.setProgress(item.getProgress());
				_llVideo.addView(item);
			}
		}
		
		if (event.vids != null && event.vids.size() > 0) {
			for (VideoResponse video : event.vids) {
				String id = Util.youtubeIdByURL(video.url);
				if (id.trim().length() > 0) {
					ImageItem item = new ImageItem(this);
					item.setVideoIconVisible();
					item.setVideoURL(video.url);
					String imgURL = String.format(Config.YOUTUBE_IMG_URL, id);
					item.getImage(imgURL, false);
//					BitmapManager.INSTANCE.loadBitmap(imgURL, item.getImageView(), item.getImageView().getWidth(), item.getImageView().getHeight());
//					BitmapManager.INSTANCE.setProgress(item.getProgress());
					_llVideo.addView(item);
				}
			}
		}
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
		_desc = (WebView) findViewById(R.id.event_desc);
		_desc.getSettings().setDefaultFontSize(13);
		_dramatic = (TextView) findViewById(R.id.dramatic);
		_date = (TextView) findViewById(R.id.dates);
		_price = (TextView) findViewById(R.id.price);
		_title = (TextView) findViewById(R.id.event_title);
		_name = (TextView) findViewById(R.id.event_name);
		_navigationBar = findViewById(R.id.navigation_bar);
		_navigationBar.findViewById(R.id.button_starred).setVisibility(View.VISIBLE);
		_llInfoblocs = (LinearLayout) findViewById(R.id.layout_row);
	}
	
	public void onBuyClicked(View v) {
		if (_event.buyURL.trim().length() > 0) {
			this.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(_event.buyURL)));
		}
	}
		
	public void onStarredClicked(View v) {
		_service.stop();
		_service.setStarred(_event.eventCode, isStarred == true ? "off" : "on");
		show();
	}
	
	private void show() {
		_dialog = ProgressDialog.show(this, "", getResources().getString(R.string.loading),true , true);
	}
	
	private void hide() {
		if (_dialog != null) {
			_dialog.dismiss();
		}
	}
}
