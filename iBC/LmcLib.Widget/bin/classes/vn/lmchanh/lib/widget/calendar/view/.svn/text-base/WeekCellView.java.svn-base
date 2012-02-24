package vn.lmchanh.lib.widget.calendar.view;

import java.security.InvalidParameterException;

import vn.lmchanh.lib.time.MCDateSpan;
import vn.lmchanh.lib.time.MCWeek;
import vn.lmchanh.lib.widget.R;
import android.content.Context;
import android.util.AttributeSet;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;

public class WeekCellView extends CalendarCellView {
	// ======================================================================================

	private enum WeekType {
		FULL_WEEK, FIRST_HALF, LAST_HALF
	}

	// ======================================================================================

	public WeekCellView(Context context) {
		super(context);
	}

	public WeekCellView(Context context, AttributeSet atts) {
		super(context, atts);
	}

	public WeekCellView(Context context, AttributeSet atts, int defStyle) {
		super(context, atts, defStyle);
	}

	// ======================================================================================

	@Override
	protected void initStyle() {
		super.initStyle();
		
		LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
				LayoutParams.FILL_PARENT, 0);
		params.weight = 1;
		params.setMargins(1, 1, 1, 1);
		this.setLayoutParams(params);
	}

	@Override
	public void setDate(MCDateSpan date) {
		if (!(date instanceof MCWeek)) {
			throw new InvalidParameterException();
		}

		super.setDate(date);
		this.setText(formatString((MCWeek) date));
	}

	private String formatString(MCWeek date) {
		String weekNumber = "";

		switch (this.getWeekType(date)) {
		case FULL_WEEK:
			weekNumber = Integer.toString(date.getWeek());
			break;
		case FIRST_HALF:
			weekNumber = Integer.toString(date.getWeek()) + "a";
			break;
		case LAST_HALF:
			weekNumber = Integer.toString(date.getWeek()) + "b";
			break;
		}
		return String.format("%s %s (%d/%d - %d/%d)",
				getResources().getString(R.string.cal_week), weekNumber, date
						.getStart().getDay(), date.getMonth() + 1, date
						.getEnd().getDay(), date.getMonth() + 1);
	}

	private WeekType getWeekType(MCDateSpan date) {
		return (date.getEnd().getDay() - date.getStart().getDay() < 6) ? (date
				.getStart().getDay() == 1 ? WeekType.LAST_HALF
				: WeekType.FIRST_HALF) : WeekType.FULL_WEEK;
	}

	// ======================================================================================
}
