package vn.lmchanh.lib.time;

import java.util.Calendar;
import java.util.Date;

import android.os.Parcel;
import android.os.Parcelable;

public class MCDate implements Parcelable {
	// ========================================================================================================

	int year;
	int month;
	int week;
	int day;

	// ========================================================================================================

	public MCDate(Date date) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		this.setData(cal);
	}

	public MCDate(int day, int week, int month, int year) {
		this.setData(day, week, month, year);
	}

	public MCDate(Calendar calendar) {
		this.setData(calendar);
	}

	private void setData(Calendar cal) {
		this.setData(cal.get(Calendar.DAY_OF_MONTH),
				cal.get(Calendar.WEEK_OF_YEAR), cal.get(Calendar.MONTH),
				cal.get(Calendar.YEAR));
	}

	private void setData(int day, int week, int month, int year) {
		this.day = day;
		this.week = week;
		this.month = month;
		this.year = year;
	}

	// ========================================================================================================

	public int getYear() {
		return this.year;
	}

	public int getMonth() {
		return this.month;
	}

	public int getWeek() {
		return this.week;
	}

	public int getDay() {
		return this.day;
	}

	@Override
	public boolean equals(Object o) {
		if (o instanceof MCDate) {
			MCDate date = (MCDate) o;
			return (this.day == date.getDay())
					&& (this.month == date.getMonth())
					&& (this.year == date.getYear());
		} else {
			return super.equals(o);
		}
	}

	@Override
	public String toString() {
		return String.format("%d/%d/%d", this.day, this.month + 1, this.year);
	}

	public String toDisplayString() {
		return String.format("%d/%d/%d", this.month + 1, this.day, this.year);
	}

	public Calendar toCalendar() {
		Calendar cal = Calendar.getInstance();
		cal.set(this.year, this.month, this.day);
		return cal;
	}

	// ========================================================================================================

	protected MCDate(Parcel par) {
		this.year = par.readInt();
		this.month = par.readInt();
		this.week = par.readInt();
		this.day = par.readInt();
	}

	@Override
	public int describeContents() {
		return 0;
	}

	@Override
	public void writeToParcel(Parcel dest, int flags) {
		dest.writeInt(this.year);
		dest.writeInt(this.month);
		dest.writeInt(this.week);
		dest.writeInt(this.day);
	}

	public static final Parcelable.Creator<MCDate> CREATOR = new Parcelable.Creator<MCDate>() {
		public MCDate createFromParcel(Parcel in) {
			return new MCDate(in);
		}

		public MCDate[] newArray(int size) {
			return new MCDate[size];
		}
	};

	// ========================================================================================================
}
