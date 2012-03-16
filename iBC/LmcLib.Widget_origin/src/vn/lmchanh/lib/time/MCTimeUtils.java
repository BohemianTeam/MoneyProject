package vn.lmchanh.lib.time;

import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.Calendar;

public class MCTimeUtils {
	public static Calendar fromMilisecond(long miliseconds) {
		Calendar cal = Calendar.getInstance();
		cal.setTimeInMillis(miliseconds);
		return cal;
	}

	public static final long SECOND = 1000;
	public static final long MINUTE = 60 * 1000;
	public static final long HOUR = 60 * 60 * 1000;
	public static final long DAY = 24 * 60 * 60 * 1000;

	public static final SimpleDateFormat FORMAT = new SimpleDateFormat(
			"mmm - dd HH:mm");
	public static final SimpleDateFormat FULL_FORMAT = new SimpleDateFormat(
			"yyyy - mmm - dd HH:mm");

	public static String formatTimeAgo(long time) {
		long diff = System.currentTimeMillis() - time;

		long day = diff / DAY;
		if (day > 0) {
			if (day > 5) {
				Date date = new Date(time);
				if (date.getYear() != Calendar.getInstance().getTime()
						.getYear()) {
					return FULL_FORMAT.format(date);
				} else {
					return FORMAT.format(date);
				}
			} else {
				return day + (day == 1 ? " day ago" : " days ago");
			}
		}

		long hour = diff / HOUR;
		if (hour > 0) {
			return hour + (hour == 1 ? " hour ago" : " hours ago");
		}

		long minute = diff / MINUTE;
		if (minute > 0) {
			return minute + (minute == 1 ? " minute ago" : " minutes ago");
		}

		return "Just now";
	}
}
