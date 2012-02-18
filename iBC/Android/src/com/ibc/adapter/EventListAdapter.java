package com.ibc.adapter;

import java.util.List;

import com.ibc.R;
import com.ibc.model.service.response.EventsResponse;
import com.ibc.model.service.response.VenuesResponse;
import com.ibc.view.EventRowHolder;
import com.ibc.view.VenueRowHolder;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

public class EventListAdapter extends BaseAdapter {
	
	Context _context;
	List<EventsResponse> _data;
	List<VenuesResponse> _venues;
	boolean _isVenue;
	public EventListAdapter(Context context, List<EventsResponse> list,List<VenuesResponse> venues, boolean isVenue) {
		_context = context;
		
		_isVenue = isVenue;
		if (_isVenue) {
			_venues = venues;
		} else {
			_data = list;
		}
	}
	
	@Override
	public int getCount() {
		if (_isVenue) {
			if (_venues == null || _venues.size() == 0) {
				return 0;
			} else {
				return _venues.size();
			}
		} else {
			if (_data == null || _data.size() == 0) {
				return 0;
			} else {
				return _data.size();
			}
		}
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		if (_isVenue) {
			return _venues.get(position);
		} else {
			return _data.get(position);
		}
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}
	
	private View getEventView() {
		if (_isVenue) {
			View v = LayoutInflater.from(_context).inflate(R.layout.venue_list_view_item, null);
			v.findViewById(R.id.venue_header).setVisibility(View.GONE);
			return v;
		} else {
			View vv = LayoutInflater.from(_context).inflate(R.layout.event_list_view_item, null);
			vv.findViewById(R.id.header).setVisibility(View.GONE);
			return vv;
		}
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		convertView = getEventView();
		if (_isVenue) {
			VenueRowHolder vRowHolder;
			VenuesResponse vn = (VenuesResponse) getItem(position);
			vRowHolder = new VenueRowHolder(convertView, vn, _context);
			vRowHolder.display();
			convertView.setTag(vRowHolder);
			return convertView;
		} else {
			EventRowHolder eRowHolder;
			EventsResponse ev = (EventsResponse) getItem(position);
			
			eRowHolder = new EventRowHolder(_context, convertView, ev);
			eRowHolder.display();
			convertView.setTag(eRowHolder);
			return convertView;
		}
	}

}
