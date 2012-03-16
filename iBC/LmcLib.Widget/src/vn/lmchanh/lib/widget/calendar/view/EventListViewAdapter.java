package vn.lmchanh.lib.widget.calendar.view;

import java.util.ArrayList;
import java.util.List;

import vn.lmchanh.lib.widget.R;
import vn.lmchanh.lib.widget.calendar.model.Event;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

public class EventListViewAdapter extends BaseAdapter {
	
	private List<Event> _list = new ArrayList<Event>();
	private Context _context;
	
	public EventListViewAdapter(Context context, List<Event> list) {
		_context = context;
		_list = list;
	}
	
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		if (_list == null || _list.size() <= 0) {
			return 0;
		} else {
			return _list.size();
		}
	}

	@Override
	public Event getItem(int position) {
		// TODO Auto-generated method stub
		return _list.get(position);
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		// TODO Auto-generated method stub
		View rowView = convertView;
		EventRowViewHolder viewHolder;
		if (rowView == null) {
			rowView = LayoutInflater.from(_context).inflate(R.layout.event_row_view, null);
			viewHolder = new EventRowViewHolder(rowView);
			rowView.setTag(viewHolder);
		} else {
			viewHolder = (EventRowViewHolder) rowView.getTag();
		}
		Event event = getItem(position);
		viewHolder.setRowData(event);
		return rowView;
	}

}
