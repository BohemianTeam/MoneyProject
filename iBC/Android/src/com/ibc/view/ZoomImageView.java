package com.ibc.view;

import java.io.BufferedInputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;

import com.ibc.R;
import com.ibc.util.Config;
import com.nikkoaiello.mobile.android.PinchImageView;


public class ZoomImageView extends RelativeLayout {
	
	private long lastTouchTime = -1;
	
	@Override
	public boolean onTouchEvent(MotionEvent event) {
		
		if (event.getAction() == MotionEvent.ACTION_DOWN) {
			long thistime = System.currentTimeMillis();
			if (thistime - lastTouchTime < 250) {
				if (_img.getScale() == PinchImageView.MAX_SCALE) {
					_img.zoomMin();
				} else {
					_img.zoomMax();
				}
			} else {
				lastTouchTime = thistime;
			}
		}
		
		return super.onTouchEvent(event);
		
	}
	

	private Context _context;
	private View _root;
	private PinchImageView _img;
	private ImageView _videoIcon;
	private ProgressBar _progress;
	
	private HttpURLConnection _connection;
	private boolean _connecting;
	private String _videoURL;
	
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
		_img = (PinchImageView) _root.findViewById(R.id.venue_img);
		_videoIcon = (ImageView) _root.findViewById(R.id.video_icon);
		_videoIcon.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				if (_context instanceof Activity) {
					/*
					Intent intent = new Intent(_context, VideoPlayerActivity.class);
					intent.putExtra("path", _videoURL);
					_context.startActivity(intent);
					*/
					_context.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(_videoURL)));
				}
			}
		});
		_progress = (ProgressBar) _root.findViewById(R.id.progress);
	}
	
	public void setVideoIconVisible() {
		_videoIcon.setVisibility(VISIBLE);
	}
	
	public void setVideoURL(String url) {
		_videoURL = url;
	}
	
	public ImageView getImageView() {
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