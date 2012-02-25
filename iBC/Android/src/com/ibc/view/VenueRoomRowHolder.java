package com.ibc.view;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.view.View;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.ibc.R;
import com.ibc.model.VenueRoomEventData;
import com.ibc.util.Config;

public class VenueRoomRowHolder {

	View _root;
	VenueRoomEventData _data;
	
	TextView _roomName;
	private ImageView _img;
	private ProgressBar _progress;
	private TextView _title;
	private TextView _venueName;
	private TextView _dates;
	private TextView _price;
	
	private Context _context;
	
	private HttpURLConnection _connection;
	boolean _connecting;
	Bitmap _bitmap;
	private String _id;
	
	public VenueRoomRowHolder(View root, VenueRoomEventData event, Context context) {
		_root = root;
		_data = event;
		_context = context;
		
		_roomName = (TextView) _root.findViewById(R.id.room_name);
		_img = (ImageView) _root.findViewById(R.id.img);
		_title = (TextView) _root.findViewById(R.id.title);
		_venueName = (TextView) _root.findViewById(R.id.venueName);
		_price = (TextView) _root.findViewById(R.id.price);
		_dates = (TextView) _root.findViewById(R.id.dates);
		_progress = (ProgressBar) _root.findViewById(R.id.progress);
	}
	
	public void display() {
		if (null != _data) {
			_title.setText(_data._event.eventTitle);
			_venueName.setText(_data._event.venueName == null ? "" : _data._event.venueName);
			_price.setText(_data._event.price);
			_dates.setText(_data._event.dates);
			
			_roomName.setText(_data._venueRoomName);
			
			getImage();
		}
	}
	
	private void getImage() {
		_id = _data._event.eventCode;
		String dir = _context.getCacheDir() + "/" + _id + "_ev.png";
		File file = new File(dir);
		if (file.exists()) {
			BitmapFactory.Options options = new BitmapFactory.Options();
			_bitmap = BitmapFactory.decodeFile(dir);
			_img.setImageBitmap(BitmapFactory.decodeFile(dir,options));
			_progress.setVisibility(View.INVISIBLE);
		} else {
			if (_connecting) {
				return;
			} else {
				_connecting = true;
				new DownloadTask().execute(new String[] {
						Config.URL_IMAGE + _data._event.icon, "" });
			}
		}
	}
	
	/**
	 * 
	 * Get image processing
	 */
	
	public boolean isConnecting() {
		return _connecting;
	}

	private void cleanUp() {
		if (_connection != null) {
			try {
				_connection.disconnect();
			} catch (Exception ex) {
			}
			_connection = null;
		}
		_connecting = false;
	}
	
	
	protected void finalize() throws Throwable {
		if (_connecting)
			cleanUp();
		super.finalize();
	}
	
	public class DownloadTask extends AsyncTask<String, Void, Bitmap> {
		// SEND REQUEST
		@Override
		protected Bitmap doInBackground(String... urls) {
			// TODO Auto-generated method stub
			try {
				URL url = new URL(urls[0]);
				_connection = (HttpURLConnection) url.openConnection();
				_connection.setRequestMethod("GET");
				_connection.setDoInput(true);
				_connection.setDoOutput(true);
				int httpCode = _connection.getResponseCode();
				if (httpCode == HttpURLConnection.HTTP_OK) {
					InputStream in = new BufferedInputStream(
							_connection.getInputStream());
					return BitmapFactory.decodeStream(in);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				cleanUp();
			}
			return null;
		}

		@Override
		protected void onPostExecute(Bitmap buff) {
			super.onPostExecute(buff);
			if (_progress != null) {
				_progress.setVisibility(View.INVISIBLE);
			}
			if (buff != null) {
				try {
					String dir = _context.getCacheDir() + "/" + _id + "_ev.png";
					FileOutputStream out = new FileOutputStream(dir);
					buff.compress(Bitmap.CompressFormat.PNG, 100, out);
					out.flush();
					out.close();
					Drawable drawable = new BitmapDrawable(buff);
					_img.setBackgroundDrawable(drawable);
					
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					cleanUp();
				}

			}
		}
	}
}
