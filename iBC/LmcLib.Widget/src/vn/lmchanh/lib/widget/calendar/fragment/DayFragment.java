package vn.lmchanh.lib.widget.calendar.fragment;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;

import vn.lmchanh.lib.time.MCDay;
import vn.lmchanh.lib.widget.R;
import vn.lmchanh.lib.widget.calendar.view.DayCellView;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

public class DayFragment extends CalendarFragment {
	// ======================================================================================
	
	private static class DayView extends CalendarView {
		public DayView(View root, Calendar calendar,
				ArrayList<DayCellView> cells) {
			super(root, calendar, cells);
		}

		@Override
		public String getHeader() {
			return new SimpleDateFormat("MMMM yyyy").format(currentCalendar
					.getTime());
		}
	}

	// ======================================================================================

	public DayFragment(Context context) {
		super(context);
//		this.getDefaultCalendar();
//		this.isShowEvent = false;
	}
	
//	public DayFragment(Context context, boolean isShowEvent) {
//		super(context);
//		this.isShowEvent = isShowEvent;
//	}
	
	@Override
	public void onCreate() {
		super.onCreate();
	}

	// ======================================================================================

	private LinearLayout createHeader() {
		LayoutInflater inflater = LayoutInflater.from(mContext);
		LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(0,
				(int) (mContext.getResources()
						.getDimension(R.dimen.cal_day_header_height)));
		params.weight = 1;

		LinearLayout header = createCalendarRow(false);
		header.setBackgroundResource(R.drawable.cal_week_header_bg);

		String[] headers = new String[] { mContext.getString(R.string.cal_mon),
				mContext.getString(R.string.cal_tue),
				mContext.getString(R.string.cal_wed),
				mContext.getString(R.string.cal_thu),
				mContext.getString(R.string.cal_fri),
				mContext.getString(R.string.cal_sat),
				mContext.getString(R.string.cal_sun) };

		for (int i = 0; i < 7; i++) {
			TextView textView = (TextView) inflater.inflate(
					R.layout.cal_text_week_header, null);
			textView.setLayoutParams(params);
			textView.setText(headers[i]);
			header.addView(textView);
		}

		return header;
	}

	@Override
	protected CalendarView createPreviousCalendar(Calendar cal) {
		Calendar previous = (Calendar) cal.clone();
		previous.set(Calendar.DATE, 1);
		previous.add(Calendar.MONTH, -1);
		return this.createCalendar(previous);
	}

	@Override
	protected CalendarView createNextCalendar(Calendar cal) {
		Calendar previous = (Calendar) cal.clone();
		previous.set(Calendar.DATE, 1);
		previous.add(Calendar.MONTH, 1);
		return this.createCalendar(previous);
	}

	@Override
	protected CalendarView createCalendar(Calendar time) {
		// -------------------------------------------------------------------

		ArrayList<LinearLayout> dayRows = new ArrayList<LinearLayout>();
		ArrayList<DayCellView> cells = new ArrayList<DayCellView>();

		LinearLayout view = this.createCalendar();

		view.addView(this.createHeader());

		for (int i = 0; i < 6; i++) {
			LinearLayout cellRow = createCalendarRow(true);
			view.addView(cellRow);
			dayRows.add(cellRow);

			for (int j = 0; j < 7; j++) {
				DayCellView cell = new DayCellView(mContext);
				cell.setDateCellClickListener(this);
				cells.add(cell);
				cellRow.addView(cell);
			}
		}

		// -------------------------------------------------------------------

		Calendar cal = (Calendar) time.clone();

		while (cal.get(Calendar.DAY_OF_WEEK) != Calendar.MONDAY) {
			cal.add(Calendar.DATE, -1);
		}

		for (LinearLayout row : dayRows) {
			for (int i = 0; i < row.getChildCount(); i++) {
				DayCellView cell = (DayCellView) row.getChildAt(i);
				cell.setDate(new MCDay(cal));
				boolean active = false;
				if (this.isShowEvent) {
					if (this.mSelectDates.size() > 0) {
						if (this.mSelectDates.get(0).getStart().getMonth() > cal.get(Calendar.MONTH)) {
							active = false;
						} else if (this.mSelectDates.get(0).getStart().getMonth() < cal.get(Calendar.MONTH)) {
							active = cal.get(Calendar.MONTH) == time
									.get(Calendar.MONTH);
						} else {
							if (cal.get(Calendar.MONTH) == time.get(Calendar.MONTH)) {
								if (cell.getTime().getStart().getDay() < this.mSelectDates.get(0).getStart().getDay()) {
									active = false;
								} else {
									active = true;
								}
							}
						}
					}
				} else {
					active = cal.get(Calendar.MONTH) == time
							.get(Calendar.MONTH);
				}
				
				cell.setActive(active);

				if (active) {
					cell.setCellSelected(this.mSelectDates.contains(cell
							.getTime()));
				}

				cell.invalidate();

				cal.add(Calendar.DATE, 1);
			}
		}

		// -------------------------------------------------------------------

		return new DayView(view, time, cells);

		// -------------------------------------------------------------------
	}

	@Override
	protected Calendar getDefaultCalendar() {
		Calendar cal = Calendar.getInstance();
		cal.setFirstDayOfWeek(Calendar.MONDAY);
		cal.set(Calendar.DATE, 1);
		return cal;
	}

	// ======================================================================================
}
