package com.ibc;

import java.util.List;

import android.app.Activity;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Gallery;
import android.widget.ImageView;

import com.ibc.model.service.response.ImageResponse;
import com.ibc.view.ImageItem;

public class GalleryViewActivity extends Activity{

	Gallery _gallery;
	ImageItem _img;
	List<ImageResponse> imgsResponse;
	
	@SuppressWarnings("unchecked")
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.gallery_view);
		_gallery = (Gallery) findViewById(R.id.Gallery01);
		_img = (ImageItem) findViewById(R.id.ImageView01);
		
		if (IBCApplication.sharedInstance().getData("imgs") != null) {
			imgsResponse = (List<ImageResponse>) IBCApplication.sharedInstance().getData("imgs");
		}
		
		_gallery.setAdapter(new ImageAdapter(this));
		_gallery.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> adapterView, View view, int position,
					long id) {
				ImageResponse imageResponse = imgsResponse.get(position);
				_img.getImage(imageResponse.thumbPath);
			}
		});
	}
	
	public class ImageAdapter extends BaseAdapter {

		private Context _context;
		private int imageBackground;
		public ImageAdapter(Context ctx) {
			_context = ctx;
			
			TypedArray ta = obtainStyledAttributes(R.styleable.Gallery1);
		    imageBackground = ta.getResourceId(R.styleable.Gallery1_android_galleryItemBackground, 1);
		    ta.recycle();
		}
		
		@Override
		public int getCount() {
			// TODO Auto-generated method stub
			if (imgsResponse == null || imgsResponse.size() <= 0) {
				return 0;
			} else {
				return imgsResponse.size();
			}
		}

		@Override
		public ImageResponse getItem(int position) {
			// TODO Auto-generated method stub
			return imgsResponse.get(position);
		}

		@Override
		public long getItemId(int position) {
			// TODO Auto-generated method stub
			return position;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			// TODO Auto-generated method stub
			ImageResponse response = getItem(position);
			ImageItem item = new ImageItem(_context);
			item.getImage(response.thumbPath);
			item.setTag(item.getImageDrawable());
			item.setLayoutParams(new Gallery.LayoutParams(150,120));
			return item;
		}
		
	}
}
