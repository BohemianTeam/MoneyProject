package vn.lmchanh.lib.widget.calendar.view;

import vn.lmchanh.lib.time.MCDateSpan;
import vn.lmchanh.lib.widget.R;
import vn.lmchanh.lib.widget.calendar.IOnDateCellClickListener;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.RadialGradient;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.View;
import android.widget.TextView;

public abstract class CalendarCellView extends TextView {
	// ======================================================================================

	protected boolean mIsSelected;
	protected boolean mHasEvent;
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
	
	public void setCellHasEvent(boolean hasEvent) {
		this.mHasEvent = hasEvent;
		if (this.mHasEvent) {
			int w = 4, h = 4;

			Config conf = Bitmap.Config.ARGB_8888; // see other conf types
			Bitmap bmp = Bitmap.createBitmap(w, h, conf); // this creates a MUTABLE bitmap
			Canvas canvas = new Canvas(bmp);
			Paint paint = new Paint();
	        paint.setStyle(Paint.Style.FILL_AND_STROKE);
	        paint.setColor(Color.BLUE);
	        paint.setStrokeWidth(3);
	        int r = 3;
	        canvas.drawCircle(this.getWidth() / 2 - r, this.getHeight() - r * 2, r, paint);
//			this.setBackgroundDrawable(new BitmapDrawable(bmp));
//	        this.setBackgroundResource(R.drawable.dot);
//			this.invalidate();
		}
	}

	@Override
	protected void onDraw(Canvas canvas) {
		super.onDraw(canvas);
		if (this.mHasEvent) {
			RadialGradient gradient = new RadialGradient(200, 200, 200, 0xFF00FF00,
		            0xFF0000FF, android.graphics.Shader.TileMode.CLAMP);
			
	        Paint paint = new Paint();
	        paint.setStyle(Paint.Style.FILL_AND_STROKE);
	        paint.setColor(Color.BLUE);
	        paint.setStrokeWidth(1);
	        paint.setDither(true);
	        paint.setShader(gradient);
	        
	        int r = 3;
	        canvas.drawCircle(this.getWidth() / 2 - r, this.getHeight() - r * 2, r, paint);
		}
	}
	
	// ======================================================================================
}
