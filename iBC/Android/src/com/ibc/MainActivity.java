package com.ibc;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import vn.lmchanh.lib.time.MCDateSpan;
import vn.lmchanh.lib.widget.calendar.CalendarActivity;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.TextView;

import com.ibc.adapter.MenuListAdapter;
import com.ibc.model.MenuItemData;
import com.ibc.model.service.response.EventsResponse;
import com.ibc.model.service.response.StarredListResponse;
import com.ibc.model.service.response.StarredResponse;
import com.ibc.model.service.response.VenuesResponse;
import com.ibc.service.ResultCode;
import com.ibc.service.Service;
import com.ibc.service.ServiceAction;
import com.ibc.service.ServiceListener;
import com.ibc.service.ServiceRespone;

public class MainActivity extends Activity implements OnItemClickListener{

	private ArrayList<MenuItemData> mMenuList = new ArrayList<MenuItemData>();
	private ListView mListView;
	private Service _service;
	private ProgressDialog _dialog;
	
	private static final int REQUEST_CODE_CALENDAR = 0;
	private static final int REQUEST_CODE_REOPEN_CALENDAR = REQUEST_CODE_CALENDAR + 1;
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		String title = getResources().getString(R.string.main_title);
		if(null != title) {
        	((TextView) findViewById(R.id.title)).setText(title);
        }
		initMenu();
		mListView = (ListView) findViewById(R.id.list);
		MenuListAdapter adapter = new MenuListAdapter(mMenuList, this);
		mListView.setAdapter(adapter);
		mListView.setOnItemClickListener(MainActivity.this);
		
	}
	
	@SuppressWarnings("unused")
	private void show() {
		_dialog = ProgressDialog.show(this, "", "Loading...", true, true);
	}

	private void hide() {
		if (null != _dialog) {
			_dialog.dismiss();
		}
	}

	private void initMenu() {
		MenuItemData data = new MenuItemData("ESPECTACLES", getResources()
				.getDrawable(R.drawable.v01_bt01));
		MenuItemData data1 = new MenuItemData("ESPAIS", getResources()
				.getDrawable(R.drawable.v01_bt02));
		MenuItemData data2 = new MenuItemData("AGENDA", getResources()
				.getDrawable(R.drawable.v01_bt03));
		MenuItemData data3 = new MenuItemData("A PROP", getResources()
				.getDrawable(R.drawable.v01_bt04));
		MenuItemData data4 = new MenuItemData("FAVORITS", getResources()
				.getDrawable(R.drawable.v01_bt05));

		mMenuList.add(data);
		mMenuList.add(data1);
		mMenuList.add(data2);
		mMenuList.add(data3);
		mMenuList.add(data4);
	}

	@SuppressWarnings("unused")
	private ServiceListener _listener = new ServiceListener() {

		@SuppressWarnings("unchecked")
		@Override
		public void onComplete(Service service, ServiceRespone result) {
			hide();
			if (result.getAction() == ServiceAction.ActionGetVenues) {
				if (result.getResultCode() == ResultCode.Success) {
					List<VenuesResponse> status = (List<VenuesResponse>) result
							.getData();
					iBCApplication.sharedInstance().putData("venues", status);
					//
//					Service sv = new Service(_listener);
//					sv.getEvents("1", getCurrentTimeString());
				} else {
					System.out.println(result.getResultCode());
				}
			} else if (result.getAction() == ServiceAction.ActionGetEvents) {
				hide();
				if (result.getResultCode() == ResultCode.Success) {
					List<EventsResponse> data = (List<EventsResponse>) result
							.getData();
					iBCApplication.sharedInstance().putData("events", data);
				}
			} else if (result.getAction() == ServiceAction.ActionGetStarred) {
				if (result.getResultCode() == ResultCode.Success) {
					StarredResponse response = (StarredResponse) result
							.getData();
					iBCApplication.sharedInstance()
							.putData("starred", response);
				}
			} else if (result.getAction() == ServiceAction.ActionGetStarredList) {
				if (result.getResultCode() == ResultCode.Success) {
					if (null == result.getData()) {
						Service svGetVenues = new Service(_listener);
						svGetVenues.getVenues("41.385756", "2.164129");
					} else {
						List<StarredListResponse> list = (List<StarredListResponse>) result
								.getData();
						List<String> venueCodes = new ArrayList<String>();
						List<String> eventCodes = new ArrayList<String>();
						for (StarredListResponse starredResponse : list) {
							String code = starredResponse.code;
							if (code.charAt(0) == 'V') {
								venueCodes.add(code);
							} else {
								eventCodes.add(code);
							}
						}

						iBCApplication.sharedInstance().putData("venue_codes",
								venueCodes);
						iBCApplication.sharedInstance().putData("event_codes",
								eventCodes);

						ExtensionList exl = new ExtensionList();
						exl.add("b");
						exl.add("c");
						exl.add("a");
						System.out.println(exl.toString());
						exl.sort();
						System.out.println(exl.toString());
					}

				}
			}
		}
	};

	@SuppressWarnings("serial")
	public class ExtensionList extends ArrayList<String> {

		public void sort() { // or import static java.util.Collections.sort;
			Collections.sort(this);
		}

		public String first() {
			return this.get(0);
		}

		public String last() {
			return this.get(this.size() - 1);
		}
		/*
		 * public void toPolar(double x, double y, {double, double => void }
		 * rThetaReceiver) {
		 * 
		 * }
		 */
		// void a() default {System.out.println("a")};
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			// create builder for alert dialog
			AlertDialog.Builder builder = new AlertDialog.Builder(this);
			builder.setMessage("Do you want to exit?")
					.setCancelable(false)
					.setPositiveButton("Yes",
							new DialogInterface.OnClickListener() {

								@Override
								public void onClick(DialogInterface dialog,
										int which) {
									// MainActivity.this.moveTaskToBack(true);
									MainActivity.this.finish();
								}
							});
			// set No button click
			builder.setNegativeButton("No",
					new DialogInterface.OnClickListener() {

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.cancel();
						}
					});
			// create alet dialog
			AlertDialog alert = builder.create();
			alert.show();
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}

	@Override
	public void onItemClick(AdapterView<?> adapterView, View view, int position, long id) {
		// TODO Auto-generated method stub
		MenuItemData data = ((MenuListAdapter) mListView.getAdapter()).getItem(position);
		if (position == 0) {
			Intent intent = new Intent(this, EventsListViewActivity.class);
			intent.putExtra("title", data.mTitle);
			this.startActivity(intent);
		} else if (position == 1 ) {
			Intent intent = new Intent(this, VenusListViewActivity.class);
			intent.putExtra("title", data.mTitle);
			iBCApplication application = iBCApplication.sharedInstance();
			application.putData("lat", 41.385756);
			application.putData("lon", 2.164129);

			this.startActivity(intent);
		} else if (position == 2) {
	        /*
			CalendarProvider provider = CalendarProvider.sharedInstance();
	        boolean hasCalendar = provider.hasCalendar();
	        if (hasCalendar) {
				Intent i = new Intent();
				i.setComponent(ComponentName.unflattenFromString("com.android.calendar/com.android.calendar.AgendaActivity"));
				mContext.startActivity(i);
	        } else {
	        	AlertDialog.Builder builder = new Builder(mContext);
	        	builder.setMessage("Don't provider agenda calendar");
	        	builder.setTitle("Alert");
	        	AlertDialog dialog = builder.create();
	        	dialog.show();
	        }
	        */
			/*
			Intent intent = new Intent(Intent.ACTION_EDIT);  

			intent.setType("vnd.android.cursor.item/event");

			intent.putExtra("title", "Demon Hunter");

			intent.putExtra("description", "Are there demon nearby?");

			intent.putExtra("beginTime", System.currentTimeMillis());

			intent.putExtra("endTime", System.currentTimeMillis() + 1800 * 1000);
			*/
	        Intent intent = CalendarActivity.createCalendarIntent(this, true, false, false, true, true);
	        startActivityForResult(intent, REQUEST_CODE_CALENDAR);
//			Intent intent = new Intent(mContext, SubMenuActivity.class);
//			intent.putExtra("title", data.mTitle);
		} else if (position == 3) {
			Intent intent = new Intent(this, VenusListViewActivity.class);
			intent.putExtra("title", data.mTitle);
			intent.putExtra("need_get_gps", true);
			this.startActivity(intent);
		} else if (position == 4) {
			Intent intent = new Intent(this, StarredActivity.class);
			intent.putExtra("title", data.mTitle);
			this.startActivity(intent);
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		super.onActivityResult(requestCode, resultCode, data);
		
		if (requestCode == REQUEST_CODE_CALENDAR) {
			if (resultCode == RESULT_OK) {
				ArrayList<MCDateSpan> times = data.getParcelableArrayListExtra(CalendarActivity.DATA_TIMES);
				if (times != null && times.size() > 0) {
					MCDateSpan date = times.get(0);
					Intent intent = new Intent(this, EventsListViewActivity.class);
					intent.putExtra("date", date.toEventDisplayString());
					this.startActivityForResult(intent, REQUEST_CODE_REOPEN_CALENDAR);
				}
			}
		} else if (requestCode == REQUEST_CODE_REOPEN_CALENDAR) {
			if (resultCode == RESULT_OK) {
				Intent intent = CalendarActivity.createCalendarIntent(this, true, false, false, true, true);
				intent.putExtra("title", "ESPAIS");
		        startActivityForResult(intent, REQUEST_CODE_CALENDAR);
			}
		}
	}
	
	
}