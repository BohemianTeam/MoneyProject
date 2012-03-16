package vn.lmchanh.lib.widget.calendar.view;

import vn.lmchanh.lib.widget.R;
import vn.lmchanh.lib.widget.calendar.model.Event;
import android.view.View;
import android.widget.TextView;
public class EventRowViewHolder {
	
	private View _root;
	private TextView _time;
	private TextView _title;
	
	public EventRowViewHolder(View root) {
		_root = root;
		_time = (TextView) _root.findViewById(R.id.event_time);
		_title = (TextView) _root.findViewById(R.id.event_title);
	}
	
	public void setRowData(Event event) {
		_time.setText(event._time);
		_title.setText(event._title);
	}
}
