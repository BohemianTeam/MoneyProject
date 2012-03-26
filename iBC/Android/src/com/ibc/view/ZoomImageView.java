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
import android.graphics.drawable.Drawable;
import android.os.AsyncTask;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;

import com.ibc.R;
import com.ibc.util.Config;


public class ZoomImageView extends RelativeLayout {
	
	private long lastTouchTime = -1;
	
	@Override
	public boolean onTouchEvent(MotionEvent event) {
		switch (event.getAction()) {
		case MotionEvent.ACTION_DOWN:
			long thistime = System.currentTimeMillis();
			if (thistime - lastTouchTime < 250) {
		
			} else {
				lastTouchTime = thistime;
			}
			break;
		case MotionEvent.ACTION_UP:
			
			break;
		default:
			break;
		}
		
		return true;
	}
	

	private Context _context;
	private View _root;
	private TouchImageView _img;
	private ProgressBar _progress;
	
	private HttpURLConnection _connection;
	private boolean _connecting;
	private String _imgURL;
	
	public ZoomImageView(Context context) {
		super(context);
		init(context);
	}

	public ZoomImageView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		init(context);
	}

	public ZoomImageView(Context context, AttributeSet attrs) {
		super(context, attrs);
		init(context);
	}
	
	public void setImageViewDimension(int w, int h) {
		LayoutParams params = (LayoutParams) _img.getLayoutParams();
		params.width = w;//63 * 4;
		params.height = h;//49 * 4;
		params.setMargins(0, 0, 0, 0);
		_img.setLayoutParams(params);
	}
	
	private void init(Context context) {
		_context = context;
		_root = LayoutInflater.from(_context).inflate(R.layout.zoom_image_view, this);
		_img = (TouchImageView) _root.findViewById(R.id.venue_img);
		_img.setMaxZoom(4f);
		setImageViewDimension(LayoutParams.FILL_PARENT, LayoutParams.FILL_PARENT);
		
		_progress = (ProgressBar) _root.findViewById(R.id.progress);
	}
	
	public TouchImageView getImageView() {
		return _img;
	}
	
	public ProgressBar getProgress() {
		return _progress;
	}
	
	public Drawable getImageDrawable() {
		return _img.getBackground();
	}
	
	public void getImage(String url) {
		this.getImage(url, true);
	}
	
	public void getImage(String url, boolean includeId) {
		String path = url.substring(0, url.length() - 4);
		path = path.replaceAll("/", "_");
		_imgURL = path;
		String dir = _context.getCacheDir() + "/" + path + "_vn.png";
		File file = new File(dir);
		if (file.exists()) {
			BitmapFactory.Options options = new BitmapFactory.Options();
			_img.setImageBitmap(BitmapFactory.decodeFile(dir,options));
			_progress.setVisibility(View.INVISIBLE);
		} else {
			if (_connecting) {
				return;
			} else {
				_connecting = true;
				if (includeId) {
					new DownloadTask().execute(new String[] {Config.URL_IMAGE + url, "" });
				} else {
					new DownloadTask().execute(new String[] {url, "" });
				}
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
					String dir = _context.getCacheDir() + "/" + _imgURL + "_vn.png";
					FileOutputStream out = new FileOutputStream(dir);
					buff.compress(Bitmap.CompressFormat.PNG, 100, out);
					out.flush();
					out.close();
					
					_img.setImageBitmap(buff);
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					cleanUp();
				}

			}
		}
	}
}