package vn.lmchanh.lib.widget.calendar.fragment;

import java.util.ArrayList;
import java.util.Calendar;

import vn.lmchanh.lib.time.MCDateSpan;
import vn.lmchanh.lib.widget.R;
import vn.lmchanh.lib.widget.calendar.IOnDateCellClickListener;
import vn.lmchanh.lib.widget.calendar.IOnTimesSelectedListener;
import vn.lmchanh.lib.widget.calendar.view.CalendarCellView;
import vn.lmchanh.lib.widget.fragment.MCFragment;
import vn.lmchanh.lib.widget.workspace.Workspace;
import vn.lmchanh.lib.widget.workspace.Workspace.OnScreenChangeListener;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.TextView;

public abstract class CalendarFragment extends MCFragment implements
		IOnDateCellClickListener, OnScreenChangeListener, OnClickListener {
	// ======================================================================================

	protected static abstract class CalendarView {
		public ArrayList<CalendarCellView> cells;
		public View rootView;
		public Calendar currentCalendar;

		public CalendarView(View root, Calendar calendar,
				ArrayList<? extends CalendarCellView> cells) {
			this.rootView = root;
			this.currentCalendar = calendar;
			this.cells = new ArrayList<CalendarCellView>();
			this.cells.addAll(cells);
		}

		public abstract String getHeader();
	}

	// ======================================================================================

	protected ArrayList<CalendarView> mCalendars;
	protected ArrayList<MCDateSpan> mSelectDates;
	protected ArrayList<MCDateSpan> mEventSessionDates;
	protected boolean isSingleSelection;
	protected boolean isShowEvent;
	
	protected Workspace mCalendarHost;
	protected TextView mHeaderText;

	protected IOnTimesSelectedListener mTimeSelectListener;
	
	protected IScreenChangeListener mScreenChangeListener;
	// ======================================================================================

	protected CalendarFragment(Context context) {
		super(context);
	}

	@Override
	public void onCreate() {
		this.mSelectDates = new ArrayList<MCDateSpan>();
		//default highlight current day
		MCDateSpan dateSpan = new MCDateSpan(Calendar.getInstance());
		this.mSelectDates.add(dateSpan);
		this.mCalendars = new ArrayList<CalendarFragment.CalendarView>();
		this.isSingleSelection = false;
		
		this.mEventSessionDates = new ArrayList<MCDateSpan>();
	}

	public void initCalendar() {
		Calendar cal = this.getDefaultCalendar();

		CalendarView current = this.createCalendar(cal);
		CalendarView previous = this.createPreviousCalendar(cal);
		CalendarView next = this.createNextCalendar(cal);

		this.mCalendars.add(previous);
		this.mCalendars.add(current);
		this.mCalendars.add(next);

		this.mCalendarHost.addView(current.rootView);
		this.mCalendarHost.addViewToFront(previous.rootView);
		this.mCalendarHost.addViewToBack(next.rootView);

		this.mCalendarHost.setOnScreenChangeListener(this);
	}

	@Override
	public View getView() {
		LayoutInflater inflater = LayoutInflater.from(this.mContext);

		LinearLayout layout = (LinearLayout) inflater.inflate(
				R.layout.cal_fragment, null);

		this.mHeaderText = (TextView) layout
				.findViewById(R.id.text_current_month);
		((ImageButton) layout.findViewById(R.id.btn_previous))
				.setOnClickListener(this);
		((ImageButton) layout.findViewById(R.id.btn_next))
				.setOnClickListener(this);
		((Button) layout.findViewById(R.id.btn_OK)).setOnClickListener(this);
		//hide select button
		((Button) layout.findViewById(R.id.btn_OK)).setVisibility(View.INVISIBLE);
		
		this.mCalendarHost = (Workspace) layout
				.findViewById(R.id.workspace_calendar);

		return layout;
	}

	public CalendarFragment setSingleSelection(boolean singleSelection) {
		this.isSingleSelection = singleSelection;
		return this;
	}
	
	public void setShowEvent(boolean isShowEvent) {
		this.isShowEvent = isShowEvent;
//		return this;
	}
	// ======================================================================================

	private CalendarView getCurrentCalendar() {
		return this.mCalendars.get(1);
	}

	private void updateHeader() {
		this.mHeaderText.setText(this.getCurrentCalendar().getHeader());
	}

	public void setSelected(ArrayList<MCDateSpan> times) {
		if (times != null)
			this.mSelectDates = times;
	}

	public ArrayList<MCDateSpan> getSelectedDates() {
		return this.mSelectDates;
	}

	public void clearSelected() {
		this.mSelectDates.clear();

		for (CalendarView calendar : this.mCalendars) {
			for (CalendarCellView cell : calendar.cells) {
				cell.setCellSelected(false);
			}
		}
	}
	
	public void setEventSessions(ArrayList<MCDateSpan> times) {
		clearHasEvent();
		if (times != null) {
			this.mEventSessionDates = times;
			setCellHasEvent();
		}
	}
	
	public ArrayList<MCDateSpan> getEventSessionsDates() {
		return this.mEventSessionDates;
	}
	
	public void clearHasEvent() {
//		if (this.mCalendars.size() == 0) {
//			this.initCalendar();
//		}
		this.mEventSessionDates.clear();
		for (CalendarView calendar : this.mCalendars) {
			for (CalendarCellView cell : calendar.cells) {
				cell.setCellHasEvent(false);
			}
		}
	}
	
	public void setCellHasEvent() {

		for (CalendarView calendar : this.mCalendars) {
			for (CalendarCellView cell : calendar.cells) {
				if (this.mEventSessionDates.contains(cell.getTime())) {
					cell.setCellHasEvent(true);
				}
			}
		}
	}
	
	public void setOnTimeSelectListener(IOnTimesSelectedListener listener) {
		this.mTimeSelectListener = listener;
	}
	
	public void setOnScreenChangedListener(IScreenChangeListener listener) {
		this.mScreenChangeListener = listener;
	}
	
	@Override
	public void OnClick(MCDateSpan dateSpan, CalendarCellView caller) {
		if (this.isSingleSelection) {
			this.clearSelected();
//			this.clearHasEvent();
			if (!this.mSelectDates.contains(dateSpan)) {
				this.mSelectDates.add(dateSpan);
				caller.setCellSelected(true);
//				caller.setCellHasEvent(true);
			}
		} else {
			if (this.mSelectDates.contains(dateSpan)) {
				this.mSelectDates.remove(dateSpan);
				caller.setCellSelected(false);
			} else {
				this.mSelectDates.add(dateSpan);
				caller.setCellSelected(true);
			}
		}
		if (this.mTimeSelectListener != null) {
//			if (this.isShowEvent) {
			this.mTimeSelectListener.onSelect(this.mSelectDates);
//			} else {
//				this.mTimeSelectListener.onSelect(this.mEventSessionDates);
//			}
		}

	}

	@Override
	public void onScreenChanged(final View newScreen, int newScreenIndex) {
		if (newScreenIndex == 0) {
			this.mCalendars.remove(this.mCalendars.size() - 1);
			this.mCalendarHost.removeViewFromBack();

			Calendar cal = this.mCalendars.get(0).currentCalendar;
			CalendarView newPrevious = this.createPreviousCalendar(cal);

			this.mCalendars.add(0, newPrevious);
			this.mCalendarHost.addViewToFront(newPrevious.rootView);
		} else if (newScreenIndex == this.mCalendars.size() - 1) {
			this.mCalendars.remove(0);
			this.mCalendarHost.removeViewFromFront();

			Calendar cal = this.mCalendars.get(this.mCalendars.size() - 1).currentCalendar;
			CalendarView newNext = this.createNextCalendar(cal);

			this.mCalendars.add(newNext);
			this.mCalendarHost.addViewToBack(newNext.rootView);
		}

		this.updateHeader();
		
		//update event view
		setCellHasEvent();
		this.mScreenChangeListener.onScreenChanged();
	}

	@Override
	public void onScreenChanging(View newScreen, int newScreenIndex) {

	}

	@Override
	public void onClick(View v) {
		
		if (v.getId() == R.id.btn_previous) {
			this.mCalendarHost.scrollLeft();
//			clearHasEvent();
			setCellHasEvent();
		} else if (v.getId() == R.id.btn_next) {
			this.mCalendarHost.scrollRight();
//			clearHasEvent();
			setCellHasEvent();
		} else if (v.getId() == R.id.btn_OK) {
			if (this.mTimeSelectListener != null) {
				this.mTimeSelectListener.onSelect(this.mSelectDates);
			}
		}
		this.mScreenChangeListener.onScreenChanged();
	}

	protected abstract Calendar getDefaultCalendar();

	protected abstract CalendarView createPreviousCalendar(Calendar time);

	protected abstract CalendarView createNextCalendar(Calendar time);

	protected abstract CalendarView createCalendar(Calendar time);

	// ======================================================================================

	protected LinearLayout createCalendar() {
		LinearLayout calendar = new LinearLayout(this.mContext);
		LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
				LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT);
		calendar.setLayoutParams(params);
		calendar.setOrientation(LinearLayout.VERTICAL);
		return calendar;
	}

	protected LinearLayout createCalendarRow(boolean full) {
		LinearLayout row = new LinearLayout(this.mContext);
		LinearLayout.LayoutParams params;

		if (full) {
			params = new LinearLayout.LayoutParams(LayoutParams.FILL_PARENT, 0);
			params.weight = 1;
		} else {
			params = new LinearLayout.LayoutParams(LayoutParams.FILL_PARENT,
					LayoutParams.WRAP_CONTENT);
		}

		row.setLayoutParams(params);
		return row;
	}

	// ======================================================================================
	public interface IScreenChangeListener {
		public void onScreenChanged();
	}
}
