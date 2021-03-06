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
import com.ibc.model.service.response.EventsResponse;
import com.ibc.util.Config;


public class EventRowHolder  {
	
	private Context _context;
	private View _root;
	private EventsResponse _data;
	
	private ImageView _img;
	private ProgressBar _progress;
	private TextView _title;
	private TextView _venueName;
	private TextView _dates;
	private TextView _price;
	
	private HttpURLConnection _connection;
	boolean _connecting;
	Bitmap _bitmap;
	private String _id;
	
	public EventRowHolder(Context context, View root) {
		_root = root;
		
		_context = context;
		
		_img = (ImageView) _root.findViewById(R.id.img);
		_title = (TextView) _root.findViewById(R.id.title);
		_venueName = (TextView) _root.findViewById(R.id.venueName);
		_price = (TextView) _root.findViewById(R.id.price);
		_dates = (TextView) _root.findViewById(R.id.dates);
		_progress = (ProgressBar) _root.findViewById(R.id.progress);
	}
	
	public void display(EventsResponse data) {
		_data = data;
		if (null != _data) {
			_title.setText(_data.eventTitle.toUpperCase());
			_venueName.setText(_data.venueName == null ? "" : _data.venueName);
			_price.setText(_data.price);
			_dates.setText(_data.date);

			getImage();
		}
	}
	
	private void getImage() {
		_id = _data.eventCode;
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
						Config.URL_IMAGE + _data.icon, "" });
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
