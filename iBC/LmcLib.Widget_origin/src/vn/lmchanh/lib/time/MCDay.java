package vn.lmchanh.lib.time;

import java.util.Calendar;

public class MCDay extends MCDateSpan {	
	//======================================================================================
	
	public MCDay(Calendar date) {
		super(date);
	}
	
	//======================================================================================
	
	public int getDay(){
		return this.getStart().day;
	}

	public int getMonth() {
		return this.getStart().month;
	}
	
	public int getYear() {
		return this.getYear();
	}
	
	//======================================================================================
}
