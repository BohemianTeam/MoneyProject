package vn.lmchanh.lib.widget.calendar;

import java.util.ArrayList;

import vn.lmchanh.lib.time.MCDateSpan;
import vn.lmchanh.lib.widget.R;
import vn.lmchanh.lib.widget.calendar.fragment.CalendarFragment;
import vn.lmchanh.lib.widget.calendar.fragment.CalendarFragment.IScreenChangeListener;
import vn.lmchanh.lib.widget.calendar.fragment.DayFragment;
import vn.lmchanh.lib.widget.calendar.fragment.MonthFragment;
import vn.lmchanh.lib.widget.calendar.fragment.WeekFragment;
import vn.lmchanh.lib.widget.fragment.MCFragmentActivity;
import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.net.Uri;
import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

public class CalendarActivity extends MCFragmentActivity implements
		IOnTimesSelectedListener , IScreenChangeListener{
	// ======================================================================================

	public static Intent createCalendarIntent(Activity caller, boolean day,
			boolean week, boolean month, boolean singleChoice) {
		
		return createCalendarIntent(caller, day, week, month, singleChoice, false);
	}
	
	public static Intent createCalendarIntent(Activity caller, boolean day,
			boolean week, boolean month, boolean singleChoice, boolean event) {
		Intent intent = new Intent(caller, CalendarActivity.class);
		intent.putExtra("day", day);
		intent.putExtra("week", week);
		intent.putExtra("month", month);
		intent.putExtra("singleChoice", singleChoice);
		intent.putExtra("event", event);
		return intent;
	}
	
	// ======================================================================================

	public static String DATA_TIMES = "TIMES";
	public static final String EVENT_SESSIONS = "event_sessions";
	private final static int DAY = 101;
	private final static int WEEK = 102;
	private final static int MONTH = 103;

	private int currentCalendar;
	private boolean singleChoice;
	private boolean showEvent;
	
	private ArrayList<MCDateSpan> eventSessions;
	// ======================================================================================

	@Override
	protected void onSaveInstanceState(Bundle outState) {
//		super.onSaveInstanceState(outState);
//
//		String[] selected = createTimeStrings(((CalendarFragment) findFragmentById(R.id.layout_fragment_host))
//				.getSelectedDates());
//		outState.putInt("calendar", this.currentCalendar);
//		outState.putStringArray("selected", selected);
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		this.setContentView(R.layout.activity_calendar);

		boolean day = this.getIntent().getBooleanExtra("day", false);
		boolean week = this.getIntent().getBooleanExtra("week", false);
		boolean month = this.getIntent().getBooleanExtra("month", false);
		this.singleChoice = this.getIntent().getBooleanExtra("singleChoice",
				false);
		this.showEvent = this.getIntent().getBooleanExtra("event", false); 
		
		boolean isLandscape = getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE;

		if (day) {
			/*
			this.addMode(getString(R.string.cal_day), R.drawable.cal_ic_day,
					isLandscape).setOnClickListener(new View.OnClickListener() {
				@Override
				public void onClick(View v) {
					showCalendar(DAY, null);
				}
			});
			*/
			this.addEventView(isLandscape);
		}

		if (week) {
			this.addMode(getString(R.string.cal_week), R.drawable.cal_ic_week,
					isLandscape).setOnClickListener(new View.OnClickListener() {
				@Override
				public void onClick(View v) {
					showCalendar(WEEK, null);
				}
			});
		}

		if (month) {
			this.addMode(getString(R.string.cal_month),
					R.drawable.cal_ic_month, isLandscape).setOnClickListener(
					new View.OnClickListener() {
						@Override
						public void onClick(View v) {
							showCalendar(MONTH, null);
						}
					});
		}

		this.setResult(Activity.RESULT_CANCELED);

		if (savedInstanceState == null) {
			int calendar = -1;

			if (month) {
				calendar = MONTH;
			}
			if (week) {
				calendar = WEEK;
			}
			if (day) {
				calendar = DAY;
			}

			this.showCalendar(calendar, null);
		} else {
//			int calendar = savedInstanceState.getInt("calendar");
//			String[] selected = savedInstanceState.getStringArray("selected");
//
//			this.showCalendar(calendar, parseTime(selected));
		}
		
		
	}

	// ======================================================================================

	private void showCalendar(int calendar, ArrayList<MCDateSpan> selected) {
		this.currentCalendar = calendar;
		CalendarFragment fragment;

		switch (this.currentCalendar) {
		case DAY: {
			fragment = new DayFragment(this);
			break;
		}
		case WEEK: {
			fragment = new WeekFragment(this);
			break;
		}
		case MONTH: {
			fragment = new MonthFragment(this);
			break;
		}
		default: {
			fragment = null;
			break;
		}
		}
		fragment.setOnScreenChangedListener(this);
		fragment.setShowEvent(this.showEvent);
		fragment.setOnTimeSelectListener(this);
		fragment.setSelected(selected);
		fragment.setSingleSelection(this.singleChoice);
		replaceFragment(R.id.layout_fragment_host, fragment);
		fragment.initCalendar();
		
		if (this.showEvent == false) {
			Intent intent = this.getIntent();
			eventSessions = new ArrayList<MCDateSpan>();
			eventSessions = intent.getParcelableArrayListExtra(EVENT_SESSIONS);
			fragment.setEventSessions(eventSessions);
		}
		
	}

	private View addMode(String name, int resId, boolean isLandscape) {
		View view = getLayoutInflater().inflate(
				R.layout.cal_layout_time_type_selector, null);
		((TextView) view.findViewById(R.id.text_mode_name)).setText(name);
		((ImageView) view.findViewById(R.id.image_mode_icon))
				.setImageResource(resId);
		LinearLayout.LayoutParams params;

		if (isLandscape) {
			params = new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT, 0);
		} else {
			params = new LinearLayout.LayoutParams(0, LayoutParams.WRAP_CONTENT);
		}

		params.weight = 1;
		view.setLayoutParams(params);
		((ViewGroup) this.findViewById(R.id.layout_calendar_btn_host))
				.addView(view);
		return view;
	}
	
	private View addEventView(boolean isLandscape) {
		View view = getLayoutInflater().inflate(R.layout.event_session_view, null);
		mTextViewEventSession = (TextView) view.findViewById(R.id.event_session);
		mBuyButton = (Button) view.findViewById(R.id.button_buy);
		LinearLayout.LayoutParams params;

		if (isLandscape) {
			params = new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT, 0);
		} else {
			params = new LinearLayout.LayoutParams(0, LayoutParams.WRAP_CONTENT);
		}

		params.weight = 1;
		view.setLayoutParams(params);
		((ViewGroup) this.findViewById(R.id.layout_calendar_btn_host))
				.addView(view);
		return view;
	}
	
	@Override
	public void onSelect(ArrayList<MCDateSpan> times) {
		if (times.size() > 0) {
			
			if (this.showEvent) {
				Intent returnData = new Intent();
				returnData.putParcelableArrayListExtra(DATA_TIMES, times);
				this.setResult(Activity.RESULT_OK, returnData);
				this.finish();
			} else {
				mTextViewEventSession.setText("");
				for (final MCDateSpan date : this.eventSessions) {
					if (date.equals(times.get(0))) {
						mBuyButton.setOnClickListener(new OnClickListener() {
							
							@Override
							public void onClick(View v) {
								CalendarActivity.this.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(date.getBuyUrl())));
							}
						});
						if (mTextViewEventSession != null) {
							mTextViewEventSession.setText(Html.fromHtml(date.getEventSessionDetail()));
							if (date.getEventSessionDetail().equalsIgnoreCase("")) {
								mBuyButton.setVisibility(View.INVISIBLE);
							} else {
								mBuyButton.setVisibility(View.VISIBLE);
							}
							break;
						}
					} else {
						mBuyButton.setVisibility(View.INVISIBLE);
					}
				}
			}			
		}
	}
	
	TextView mTextViewEventSession;
	Button mBuyButton;
	
	// ======================================================================================

	@Override
	public void onScreenChanged() {
		mTextViewEventSession.setText("");
		mBuyButton.setVisibility(View.INVISIBLE);
	}
}
