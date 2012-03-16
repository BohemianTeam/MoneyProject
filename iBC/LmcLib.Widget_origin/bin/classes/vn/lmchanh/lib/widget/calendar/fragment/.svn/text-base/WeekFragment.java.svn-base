package vn.lmchanh.lib.widget.calendar.fragment;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;

import vn.lmchanh.lib.time.MCWeek;
import vn.lmchanh.lib.widget.calendar.view.CalendarCellView;
import vn.lmchanh.lib.widget.calendar.view.WeekCellView;
import android.content.Context;
import android.view.View;
import android.widget.LinearLayout;

public class WeekFragment extends CalendarFragment {
	// ======================================================================================

	private static class WeekView extends CalendarView {
		public WeekView(View root, Calendar calendar,
				ArrayList<WeekCellView> cells) {
			super(root, calendar, cells);
		}

		@Override
		public String getHeader() {
			return new SimpleDateFormat("MMMM yyyy").format(currentCalendar
					.getTime());
		}
	}
	
	// ======================================================================================
	
	public WeekFragment(Context context) {
		super(context);
	}

	@Override
	public void onCreate() {
		super.onCreate();
	}

	// ======================================================================================

	@Override
	protected CalendarView createPreviousCalendar(Calendar cal) {
		Calendar previous = (Calendar) cal.clone();
		previous.add(Calendar.MONTH, -1);
		return this.createCalendar(previous);
	}

	@Override
	protected CalendarView createNextCalendar(Calendar cal) {
		Calendar next = (Calendar) cal.clone();
		next.add(Calendar.MONTH, 1);
		return this.createCalendar(next);
	}

	@Override
	protected CalendarView createCalendar(Calendar time) {
		//-------------------------------------------------------------------

		ArrayList<WeekCellView> cells = new ArrayList<WeekCellView>();

		LinearLayout view = super.createCalendar();
		
		for (int i = 0; i < 6; i++) {
			WeekCellView cell = new WeekCellView(mContext);
			cell.setDateCellClickListener(this);
			cells.add(cell);
			view.addView(cell);
		}

		//-------------------------------------------------------------------
		
		Calendar start = (Calendar) time.clone();

		for (CalendarCellView weekCell : cells) {
			weekCell.setVisibility(View.INVISIBLE);
		}

		for (CalendarCellView weekCell : cells) {
			Calendar end = (Calendar) start.clone();
			while ((end.get(Calendar.DAY_OF_WEEK) != Calendar.SUNDAY)
					&& (end.get(Calendar.DATE) < end
							.getActualMaximum(Calendar.DATE))) {
				end.add(Calendar.DAY_OF_WEEK, 1);
			}

			weekCell.setDate(new MCWeek(start, end));
			weekCell.setVisibility(View.VISIBLE);
			weekCell.setCellSelected(this.mSelectDates.contains(weekCell
					.getTime()));

			if (end.get(Calendar.DATE) < start.getActualMaximum(Calendar.DATE)) {
				start.set(Calendar.DATE, end.get(Calendar.DATE) + 1);
			} else {
				break;
			}
		}

		//-------------------------------------------------------------------
		
		return new WeekView(view, time, cells);
		
		//-------------------------------------------------------------------
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
