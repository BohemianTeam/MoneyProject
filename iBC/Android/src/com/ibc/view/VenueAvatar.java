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
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;

import com.ibc.R;
import com.ibc.model.service.response.VenueResponse;
import com.ibc.util.Config;

public class VenueAvatar extends RelativeLayout {

	private Context _context;
	private View _root;
	private ImageView _img;
	private ProgressBar _progress;
	
	private HttpURLConnection _connection;
	boolean _connecting;
	Bitmap _bitmap;
	private String _id;
	
	public VenueAvatar(Context context) {
		super(context);
		init(context);
	}

	public VenueAvatar(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		init(context);
	}

	public VenueAvatar(Context context, AttributeSet attrs) {
		super(context, attrs);
		init(context);
	}
	
	private void init(Context context) {
		_context = context;
		_root = LayoutInflater.from(_context).inflate(R.layout.venue_avatar, null);
		_img = (ImageView) _root.findViewById(R.id.venue_img);
		_progress = (ProgressBar) _root.findViewById(R.id.progress);
	}
	
	public void getImage(VenueResponse data) {
		_id = data.venueCode;
		String dir = _context.getCacheDir() + "/" + _id + "_vn.png";
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
						Config.URL_IMAGE + data.icon, "" });
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
					String dir = _context.getCacheDir() + "/" + _id + "_vn.png";
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
