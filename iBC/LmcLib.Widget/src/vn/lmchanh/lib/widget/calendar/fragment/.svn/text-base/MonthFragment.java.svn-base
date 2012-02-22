package vn.lmchanh.lib.widget.calendar.fragment;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;

import vn.lmchanh.lib.time.MCMonth;
import vn.lmchanh.lib.widget.calendar.view.CalendarCellView;
import vn.lmchanh.lib.widget.calendar.view.MonthCellView;
import android.content.Context;
import android.view.View;
import android.widget.LinearLayout;

public class MonthFragment extends CalendarFragment {
	// ======================================================================================

	private static class MonthView extends CalendarView {
		public MonthView(View root, Calendar calendar,
				ArrayList<MonthCellView> cells) {
			super(root, calendar, cells);
		}

		@Override
		public String getHeader() {
			return new SimpleDateFormat("yyyy").format(currentCalendar
					.getTime());
		}
	}

	// ======================================================================================

	public MonthFragment(Context context) {
		super(context);
	}

	@Override
	public void onCreate() {
		super.onCreate();
	}

	// ======================================================================================

	@Override
	protected CalendarView createPreviousCalendar(Calendar time) {
		Calendar previous = (Calendar) time.clone();
		previous.set(Calendar.DATE, 1);
		previous.set(Calendar.MONTH, 0);
		previous.add(Calendar.YEAR, -1);
		return this.createCalendar(previous);
	}

	@Override
	protected CalendarView createNextCalendar(Calendar time) {
		Calendar next = (Calendar) time.clone();
		next.set(Calendar.DATE, 1);
		next.set(Calendar.MONTH, 0);
		next.add(Calendar.YEAR, 1);
		return this.createCalendar(next);
	}

	@Override
	protected CalendarView createCalendar(Calendar time) {
		// -------------------------------------------------------------------

		ArrayList<LinearLayout> monthRows = new ArrayList<LinearLayout>();
		ArrayList<MonthCellView> cells = new ArrayList<MonthCellView>();

		LinearLayout view = super.createCalendar();

		for (int i = 0; i < 4; i++) {
			LinearLayout cellRow = createCalendarRow(true);
			view.addView(cellRow);
			monthRows.add(cellRow);

			for (int j = 0; j < 3; j++) {
				MonthCellView cell = new MonthCellView(this.mContext);
				cell.setDateCellClickListener(this);
				cells.add(cell);
				cellRow.addView(cell);
			}
		}

		// -------------------------------------------------------------------

		Calendar cal = (Calendar) time.clone();

		for (CalendarCellView cell : cells) {
			cell.setDate(new MCMonth(cal));
			cell.setCellSelected(this.mSelectDates.contains(cell.getTime()));
			cell.invalidate();
			cal.add(Calendar.MONTH, 1);
		}

		// -------------------------------------------------------------------

		return new MonthView(view, time, cells);

		// -------------------------------------------------------------------
	}

	@Override
	protected Calendar getDefaultCalendar() {
		Calendar cal = Calendar.getInstance();
		cal.setFirstDayOfWeek(Calendar.MONDAY);
		cal.set(Calendar.DATE, 1);
		cal.set(Calendar.MONTH, 0);
		return cal;
	}

	// ======================================================================================
}
