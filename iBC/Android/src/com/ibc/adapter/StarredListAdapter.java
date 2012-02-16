package com.ibc.adapter;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import com.ibc.R;
import com.ibc.model.service.response.EventsResponse;
import com.ibc.model.service.response.VenuesResponse;
import com.ibc.view.EventRowHolder;
import com.ibc.view.VenueRowHolder;

public class StarredListAdapter extends BaseAdapter {

	private List<EventsResponse> _events = new ArrayList<EventsResponse>();
	private List<VenuesResponse> _venues = new ArrayList<VenuesResponse>();
	private Context _context;
	public static final int ITEM_TYPE_VENUES_HAS_HEADER = 0;
	public static final int ITEM_TYPE_VENUES_CONTENT = ITEM_TYPE_VENUES_HAS_HEADER + 1;
	public static final int ITEM_TYPE_EVENTS_HAS_HEADER = ITEM_TYPE_VENUES_CONTENT + 1;
	public static final int ITEM_TYPE_EVENTS_CONTENT = ITEM_TYPE_EVENTS_HAS_HEADER + 1;
	
	public  StarredListAdapter(List<EventsResponse> events, List<VenuesResponse> venues, Context context) {
		_events = events;
		_venues = venues;
		_context = context;
	}
	
	@Override
	public int getCount() {
		if (null == _events && null == _venues) {
			return 0;
		} else {
			return _events.size() + _venues.size();
		}
	}

	@Override
	public Object getItem(int position) {
		if (position < _venues.size() && position >= 0) {
			return _venues.get(position);
		} else {
			return _events.get(position - _venues.size());
		}
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		Object object = getItem(position);
		VenueRowHolder vnRowHolder;
		EventRowHolder evRowHolder;
		convertView = getViewForType(getItemViewType(position));
		if (object instanceof VenuesResponse) {
			VenuesResponse data = (VenuesResponse) object;
			vnRowHolder = new VenueRowHolder(convertView, data, _context);
			vnRowHolder.display();
			convertView.setTag(vnRowHolder);
		} else if (object instanceof EventsResponse){
			EventsResponse data = (EventsResponse) object;
			evRowHolder = new EventRowHolder(_context, convertView, data);
			evRowHolder.display();
			convertView.setTag(evRowHolder);
		}

		return convertView;
	}

	@Override
	public int getItemViewType(int position) {
		int itemType = ITEM_TYPE_EVENTS_CONTENT;
		if (isStartVenueGroup(position)) {
			itemType = ITEM_TYPE_VENUES_HAS_HEADER;
		} else if (isStartEventGroup(position)) {
			itemType = ITEM_TYPE_EVENTS_HAS_HEADER;
		} else if (isVenue(position)) {
			itemType = ITEM_TYPE_VENUES_CONTENT;
		}
		return itemType;
	}
	
	private boolean isStartVenueGroup(int position) {
		if (position <= 0) {
			return true;
		}
		return false;
	}
	
	private boolean isStartEventGroup(int position) {
		if (position == _venues.size()) {
			return true;
		}
		return false;
	}
	
	private boolean isVenue(int position) {
		Object object = getItem(position);
		if (object instanceof VenuesResponse) {
			return true;
		}
		return false;
	}
	
	private View getViewForType(int type) {
		View v = LayoutInflater.from(_context).inflate(R.layout.venue_list_view_item, null);
		View vv = LayoutInflater.from(_context).inflate(R.layout.event_list_view_item, null);
		if (type == ITEM_TYPE_VENUES_HAS_HEADER) {
			return v;
		} else if (type == ITEM_TYPE_VENUES_CONTENT) {
			v.findViewById(R.id.venue_header).setVisibility(View.GONE);
			return v;
		} else if (type == ITEM_TYPE_EVENTS_HAS_HEADER) {
			return vv;
		} else if (type == ITEM_TYPE_EVENTS_CONTENT) {
			vv.findViewById(R.id.header).setVisibility(View.GONE);
			return vv;
		}
		return v;
	}
}
