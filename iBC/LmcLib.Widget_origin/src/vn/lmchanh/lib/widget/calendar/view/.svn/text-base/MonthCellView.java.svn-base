package vn.lmchanh.lib.widget.calendar.view;

import java.security.InvalidParameterException;
import java.util.ArrayList;

import vn.lmchanh.lib.time.MCDateSpan;
import vn.lmchanh.lib.time.MCMonth;
import vn.lmchanh.lib.widget.R;
import android.content.Context;
import android.util.AttributeSet;
import android.view.ViewGroup.LayoutParams;
import android.widget.LinearLayout;

public class MonthCellView extends CalendarCellView {
	// ======================================================================================
	
	private static ArrayList<String> MONTH_LABELS = null;
	
	// ======================================================================================	
	
	public MonthCellView(Context context) {
		super(context);
		this.initLabels();
	}

	public MonthCellView(Context context, AttributeSet atts) {
		super(context, atts);
		this.initLabels();
	}

	public MonthCellView(Context context, AttributeSet atts, int defStyle) {
		super(context, atts, defStyle);
		this.initLabels();
	}

	// ======================================================================================

	@Override
	protected void initStyle() {
		super.initStyle();
		
		LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(0,
				LayoutParams.FILL_PARENT);
		params.weight = 1;
		params.setMargins(1, 1, 1, 1);
		this.setLayoutParams(params);
	}
	
	private void initLabels(){
		if(MONTH_LABELS == null){
			MONTH_LABELS = new ArrayList<String>();
			MONTH_LABELS.add(getResources().getString(R.string.cal_jan));
			MONTH_LABELS.add(getResources().getString(R.string.cal_feb));
			MONTH_LABELS.add(getResources().getString(R.string.cal_mar));
			MONTH_LABELS.add(getResources().getString(R.string.cal_apr));
			MONTH_LABELS.add(getResources().getString(R.string.cal_may));
			MONTH_LABELS.add(getResources().getString(R.string.cal_jun));
			MONTH_LABELS.add(getResources().getString(R.string.cal_jul));
			MONTH_LABELS.add(getResources().getString(R.string.cal_aug));
			MONTH_LABELS.add(getResources().getString(R.string.cal_sep));
			MONTH_LABELS.add(getResources().getString(R.string.cal_oct));
			MONTH_LABELS.add(getResources().getString(R.string.cal_nov));
			MONTH_LABELS.add(getResources().getString(R.string.cal_dec));
		}
	}

	@Override
	public void setDate(MCDateSpan date) {
		if (!(date instanceof MCMonth)) {
			throw new InvalidParameterException();
		}

		super.setDate(date);
		this.setText(formatString((MCMonth) date));
	}

	private String formatString(MCMonth date) {
		return MONTH_LABELS.get(date.getMonth());
	}

	// ======================================================================================
}
