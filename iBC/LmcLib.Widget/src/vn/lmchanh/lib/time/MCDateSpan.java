package vn.lmchanh.lib.time;

import java.util.Calendar;

import android.os.Parcel;
import android.os.Parcelable;

public class MCDateSpan implements Parcelable {
	// ========================================================================================================

	public static MCDateSpan getCurrentMonth() {
		return new MCMonth(Calendar.getInstance());
	}

	public static MCDateSpan allTime() {
		Calendar start = Calendar.getInstance();
		Calendar end = Calendar.getInstance();
		start.set(1900, 0, 1);
		end.set(2999, 11, 31);

		return new MCDateSpan(start, end);
	}

	protected MCDate mStartDate;
	protected MCDate mEndDate;

	// ========================================================================================================

	public MCDateSpan() {

	}

	public MCDateSpan(Calendar date) {
		this.mStartDate = new MCDate(date);
		this.mEndDate = new MCDate(date);
	}

	public MCDateSpan(Calendar startDate, Calendar endDate) {
		this.mStartDate = new MCDate(startDate);
		this.mEndDate = new MCDate(endDate);
	}

	public MCDateSpan(MCDate start, MCDate end) {
		this.mStartDate = start;
		this.mEndDate = end;
	}

	// ========================================================================================================

	public MCDate getStart() {
		return this.mStartDate;
	}

	public MCDate getEnd() {
		return this.mEndDate;
	}

	@Override
	public boolean equals(Object o) {
		if (o instanceof MCDateSpan) {
			MCDateSpan date = (MCDateSpan) o;
			return this.mStartDate.equals(date.getStart())
					&& this.mEndDate.equals(date.getEnd());
		} else {
			return super.equals(o);
		}
	}

	@Override
	public String toString() {
		return String.format("%s-%s", this.mStartDate.toString(),
				this.mEndDate.toString());
	}

	public String toDisplayString() {
		return String.format("%s-%s", this.mStartDate.toDisplayString(),
				this.mEndDate.toDisplayString());
	}

	// ========================================================================================================

	public MCDateSpan(Parcel par) {
		this.mStartDate = new MCDate(par);
		this.mEndDate = new MCDate(par);
	}

	@Override
	public int describeContents() {
		return 0;
	}

	@Override
	public void writeToParcel(Parcel dest, int flags) {
		this.mStartDate.writeToParcel(dest, flags);
		this.mEndDate.writeToParcel(dest, flags);
	}

	public static final Parcelable.Creator<MCDateSpan> CREATOR = new Parcelable.Creator<MCDateSpan>() {
		public MCDateSpan createFromParcel(Parcel in) {
			return new MCDateSpan(in);
		}

		public MCDateSpan[] newArray(int size) {
			return new MCDateSpan[size];
		}
	};

	// ========================================================================================================
}
