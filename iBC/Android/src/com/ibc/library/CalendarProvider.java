package com.ibc.library;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.text.format.DateUtils;

import com.ibc.iBCApplication;

public class CalendarProvider {

	private static CalendarProvider _instance;
	private static Context _context;
	private static String CALENDER_URI = "content://calendar/calendars";

	public static CalendarProvider sharedInstance() {
		if (_instance == null) {
			_instance = new CalendarProvider();
			_context = iBCApplication.sharedInstance();
			if (Integer.parseInt(Build.VERSION.SDK) < 14) {
				CALENDER_URI = "content://com.android.calendar/calendars";
			}
		}

		return _instance;
	}

	public boolean hasCalendar() {
		String[] projection = { "_id", "displayName" };
		String selection = "selected = 1";
		String[] selectionArgs = null;
		String sortOrder = null;
		Cursor cursor = _context.getContentResolver().query( Uri.parse(CALENDER_URI), projection, selection, selectionArgs, sortOrder);
		if (cursor != null && cursor.moveToFirst()) {
			int nameColumn = cursor.getColumnIndex("name");
			int idColumn = cursor.getColumnIndex("_id");
			String[] calNames = new String[cursor.getCount()];
			int[] calIds = new int[cursor.getCount()];
			for (int i = 0; i < calNames.length; i++) {
				calIds[i] = cursor.getInt(idColumn);
				calNames[i] = cursor.getString(nameColumn);
				System.out.println(calNames[i]);

				cursor.moveToNext();
			}
			cursor.close();
			if (calIds.length > 0) {
				// WE'RE SAFE HERE TO DO ANY FURTHER WORK
			}
		}
		if (cursor != null) {
			return (cursor.getCount() != 0);
		} else {
			return false;
		}
	}
	
	public void insertEvent(int cal_id) {

		// set the content value
		ContentValues cv = new ContentValues();

		// make sure you add it to the right calendar
		cv.put("calendar_id", cal_id);

		// set the title of the event
		cv.put("title", "demon's birthday");

		// set the description of the event
		cv.put("description", "Time to celebrate demon's birthday.");

		// set the event's physical location
		cv.put("eventLocation", "Nucam, Barcelona");

		// set the start and end time
		// note: you're going to need to convert the desired date into milliseconds
		cv.put("dtstart", System.currentTimeMillis());
		cv.put("dtend", System.currentTimeMillis() + DateUtils.DAY_IN_MILLIS);

		// let the calendar know whether this event goes on all day or not
		// true = 1, false = 0
		cv.put("allDay", 1);

		// let the calendar know whether an alarm should go off for this event
		cv.put("hasAlarm", 1);

		// once desired fields are set, insert it into the table
		_context.getContentResolver().insert(Uri.parse("content://calendar/events"), cv);
	}
}
