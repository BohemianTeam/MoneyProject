package vn.lmchanh.lib.time;

import java.util.Calendar;

public class MCMonth extends MCDateSpan {
	//======================================================================================
	
	public MCMonth(Calendar date) {
		super();
		
		Calendar start = (Calendar) date.clone();
		Calendar end = (Calendar) date.clone();

		start.set(Calendar.DATE, start.getActualMinimum(Calendar.DATE));
		end.set(Calendar.DATE, end.getActualMaximum(Calendar.DATE));
		
		this.mStartDate = new MCDate(start);
		this.mEndDate = new MCDate(end);
	}
	
	//======================================================================================
	
	public int getMonth() {
		return this.mStartDate.month;
	}
	
	public int getYear() {
		return this.mStartDate.year;
	}
	
	//======================================================================================
}
