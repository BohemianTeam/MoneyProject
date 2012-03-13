package com.ibc.adapter;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.AdapterView.OnItemClickListener;

import com.ibc.EventDetailActivity;
import com.ibc.EventsListViewActivity;
import com.ibc.R;
import com.ibc.model.VenueRoomEventData;
import com.ibc.model.service.response.EventsResponse;
import com.ibc.model.service.response.VenueRoomResponse;
import com.ibc.view.VenueRoomRowHolder;

public class VenueRoomListAdapter extends BaseAdapter implements OnItemClickListener{
	
	public static final int VIEW_TYPE_CONTENT = 0;
	public static final int VIEW_TYPE_HEADER = VIEW_TYPE_CONTENT + 1;
	
	private List<VenueRoomResponse> _data = new ArrayList<VenueRoomResponse>();
	private List<VenueRoomEventData> _rowData = new ArrayList<VenueRoomEventData>();
	private Context _context;
	
	public VenueRoomListAdapter(Context context, List<VenueRoomResponse> list) {
		_context = context;
		_data = list;
		_rowData = parserData();
	}
	
	private List<VenueRoomEventData> parserData() {
		List<VenueRoomEventData> list = new ArrayList<VenueRoomEventData>();
		for (VenueRoomResponse room : _data) {
			if (room.events != null) {
				for (EventsResponse event : room.events) {
					VenueRoomEventData data = new VenueRoomEventData(room.name, event);
					list.add(data);
				}
			}
		}
		return list;
	}
	
	@Override
	public int getCount() {
		if (_rowData == null || _rowData.size() == 0) {
			return 0;
		} else {
			return _rowData.size();
		}
	}

	@Override
	public VenueRoomEventData getItem(int position) {
		return _rowData.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		convertView = getViewForType(getItemViewType(position));
		VenueRoomEventData data = getItem(position);
		VenueRoomRowHolder holder = new VenueRoomRowHolder(convertView, data, _context);
		holder.display();
		convertView.setTag(holder);
		return convertView;
	}

	@Override
	public int getItemViewType(int position) {
		int itemtype = VIEW_TYPE_CONTENT;
		if (isStartGroup(position)) {
			itemtype = VIEW_TYPE_HEADER;
			return itemtype;
		}
		return itemtype;
	}
	
	private View getViewForType(int type) {
		View view = LayoutInflater.from(_context).inflate(R.layout.venue_room_item, null);
		if (type == VIEW_TYPE_CONTENT) {
			view.findViewById(R.id.header).setVisibility(View.GONE);
		} else if (type == VIEW_TYPE_HEADER) {
			view.findViewById(R.id.header).setVisibility(View.VISIBLE);
		}
		return view;
	}
	
	private boolean isStartGroup(int position) {
		if (position <= 0) {
			return true;
		}
		VenueRoomEventData prev = _rowData.get(position - 1);
		VenueRoomEventData curr = _rowData.get(position);
		char prevHeader = prev._venueRoomName.charAt(0);
		char currHeader = curr._venueRoomName.charAt(0);
		if (prevHeader != currHeader) {
			return true;
		}
		return false;
	}

	@Override
	public void onItemClick(AdapterView<?> adapter, View view, int position, long id) {
		EventsResponse item = _rowData.get(position)._event;
		if (_context instanceof Activity) {
			Intent intent = new Intent(_context, EventDetailActivity.class);
			intent.putExtra("e_code", item.eventCode);
			_context.startActivity(intent);
		}
	}
}
