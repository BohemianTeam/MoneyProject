package vn.lmchanh.lib.widget.calendar.view;

import vn.lmchanh.lib.time.MCDateSpan;
import vn.lmchanh.lib.widget.R;
import vn.lmchanh.lib.widget.calendar.IOnDateCellClickListener;
import android.content.Context;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.View;
import android.widget.TextView;

public abstract class CalendarCellView extends TextView {
	// ======================================================================================

	protected boolean mIsSelected;
	protected MCDateSpan mcDateSpan;
	protected IOnDateCellClickListener mClickListener;

	protected boolean isActive = true;

	// ======================================================================================

	public CalendarCellView(Context context) {
		super(context);
		this.init();
		this.initStyle();
	}

	public CalendarCellView(Context context, AttributeSet atts) {
		super(context, atts);
		this.init();
		this.initStyle();
	}

	public CalendarCellView(Context context, AttributeSet atts, int defStyle) {
		super(context, atts, defStyle);
		this.init();
		this.initStyle();
	}

	// ======================================================================================

	private void init() {
		this.mIsSelected = false;
		this.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				if (isActive && mClickListener != null) {
					mClickListener.OnClick(mcDateSpan, CalendarCellView.this);
				}
			}
		});
	}

	protected void initStyle() {
		this.setTextSize(getResources().getDimensionPixelSize(
				R.dimen.cal_cell_text_size));
		this.setTextColor(getResources().getColor(R.color.cal_cell_text_color));
		this.setBackgroundColor(getResources().getColor(R.color.cal_cell_bg));
		this.setGravity(Gravity.CENTER);
	}

	public void setDate(MCDateSpan date) {
		this.mcDateSpan = date;
	}

	public MCDateSpan getTime() {
		return this.mcDateSpan;
	}

	public void setActive(boolean active) {
		this.isActive = active;
		this.setBackgroundColor(this.isActive ? 0xffeeeeee : 0xffdddddd);
		this.setTextColor(this.isActive ? 0xff000000 : 0xffaaaaaa);
	}

	public void setDateCellClickListener(IOnDateCellClickListener listener) {
		this.mClickListener = listener;
	}

	public void setCellSelected(boolean selected) {
		this.mIsSelected = selected;
		this.setBackgroundColor(this.mIsSelected ? 0xffbbbbbb : 0xffeeeeee);
	}

	// ======================================================================================
}
