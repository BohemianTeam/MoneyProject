package vn.lmchanh.lib.widget.calendar;

import java.util.ArrayList;

import vn.lmchanh.lib.time.MCDateSpan;

public interface IOnTimesSelectedListener {
	void onSelect(ArrayList<MCDateSpan> times);
}
