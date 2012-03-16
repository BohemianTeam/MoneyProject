package vn.lmchanh.lib.widget.calendar.view;

import java.security.InvalidParameterException;

import vn.lmchanh.lib.time.MCDateSpan;
import vn.lmchanh.lib.time.MCDay;
import android.content.Context;
import android.util.AttributeSet;
import android.view.ViewGroup.LayoutParams;
import android.widget.LinearLayout;

public class DayCellView extends CalendarCellView {
	// ======================================================================================

	public DayCellView(Context context) {
		super(context);
	}

	public DayCellView(Context context, AttributeSet atts) {
		super(context, atts);
	}

	public DayCellView(Context context, AttributeSet atts, int defStyle) {
		super(context, atts, defStyle);
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

	@Override
	public void setDate(MCDateSpan date) {
		if (!(date instanceof MCDay)) {
			throw new InvalidParameterException();
		}

		super.setDate(date);
		this.mIsSelected = false;
		this.setText(formatString((MCDay) date));
	}

	private String formatString(MCDay date) {
		return Integer.toString(date.getDay());
	}

	// ======================================================================================
}
