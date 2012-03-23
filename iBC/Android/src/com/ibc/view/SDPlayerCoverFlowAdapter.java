package com.ibc.view;

import java.util.List;

import com.ibc.model.service.response.ImageResponse;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

public class SDPlayerCoverFlowAdapter extends BaseAdapter {
	int mGalleryItemBackground;
	private SDAlbumCoverArt[] mImages;
	List<ImageResponse> _imgs;
	Context _context;
	public SDPlayerCoverFlowAdapter(Context context, List<ImageResponse> list) {
		_imgs = list;
		_context = context;
		mImages = new SDAlbumCoverArt[list.size()];
	}

	@Override
	public int getCount() {
		return mImages.length;
	}

	@Override
	public ImageResponse getItem(int position) {
		return _imgs.get(position);
	}

	@Override
	public long getItemId(int position) {
		if( _imgs.get(position) != null)
			return position;
		return -1;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {

		if(mImages[position] == null) {
			mImages[position] = new SDAlbumCoverArt(_context, true);
			ImageResponse iRes = getItem(position);
			mImages[position].getCoverArt(iRes.imagePath);
		}
		return mImages[position];
		
	}
	/**
	 * Returns the size (0.0f to 1.0f) of the views depending on the 'offset' to
	 * the center.
	 */
	public float getScale(boolean focused, int offset) {
		/* Formula: 1 / (2 ^ offset) */
		return Math.max(0, 1.0f / (float) Math.pow(2, Math.abs(offset)));
	}

}
