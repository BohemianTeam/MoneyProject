package vn.lmchanh.lib.time;

import java.security.InvalidParameterException;
import java.util.Calendar;

public class MCWeek extends MCDateSpan {
	//======================================================================================
	
	public MCWeek(Calendar start, Calendar end) {
		super();

		if ((start.get(Calendar.YEAR) != end.get(Calendar.YEAR))
				|| (start.get(Calendar.MONTH) != end.get(Calendar.MONTH))
				|| (start.get(Calendar.WEEK_OF_YEAR) != end
						.get(Calendar.WEEK_OF_YEAR))) {
			throw new InvalidParameterException();
		}

		this.mStartDate = new MCDate(start);
		this.mEndDate = new MCDate(end);
	}
	
	//======================================================================================

	public int getWeek() {
		return this.mStartDate.getWeek();
	}

	public int getMonth() {
		return this.mStartDate.getMonth();
	}

	public int getYear() {
		return this.mStartDate.getYear();
	}
	
	//======================================================================================
}
