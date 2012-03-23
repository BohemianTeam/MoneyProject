package com.ibc.view;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.provider.BaseColumns;
import android.provider.MediaStore.Audio.Albums;
import android.provider.MediaStore.Audio.Artists;
import android.util.AttributeSet;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;

import com.ibc.R;
import com.ibc.util.Config;
import com.ibc.util.Util;

public class SDAlbumCoverArt extends ImageView implements OnClickListener {

	Context _context;
	public long _id;
	long _artistId;
	boolean _isCreateReflected;
	String _artist;
	String _song;
	
	private HttpURLConnection _connection;
	private boolean _connecting;
	private String _imgURL;
	
	public SDAlbumCoverArt(Context context) {
		super(context);
		_context = context;
		setScaleType(ScaleType.FIT_XY);
		setImageResource(R.drawable.loading);
	}

	public SDAlbumCoverArt(Context context, boolean isCreateReflected) {
		super(context);
		_context = context;
		_isCreateReflected = isCreateReflected;
		setScaleType(ScaleType.MATRIX);
		float scale = context.getResources().getDisplayMetrics().density;
		CoverFlow.LayoutParams layoutParam = new CoverFlow.LayoutParams(
				(int) (280 * scale), (int) (280 * scale));
		setLayoutParams(layoutParam);

		setImageResource(R.drawable.loading);

	}

	public SDAlbumCoverArt(Context context, AttributeSet attrs) {
		super(context, attrs);
		_context = context;
		setScaleType(ScaleType.FIT_XY);
		setImageResource(R.drawable.loading);
	}
	
	public void getCoverArt(String url) {
		String path = url.substring(0, url.length() - 4);
		path = path.replaceAll("/", "_");
		_imgURL = path;
		String dir = _context.getCacheDir() + "/" + path + "_vn.png";
		File file = new File(dir);
		if (file.exists()) {
			BitmapFactory.Options options = new BitmapFactory.Options();
			Bitmap bitmap = BitmapFactory.decodeFile(dir, options);
			if (bitmap != null) {
				if (_isCreateReflected) {
					Bitmap refrectBitmap = Util.createReflectedImages(bitmap);
					bitmap.recycle();
					setImage(refrectBitmap);
				} else {
					setImage(bitmap);
				}
			} 
		} else {
			if (_connecting) {
				return;
			} else {
				_connecting = true;
				new DownloadTask().execute(new String[] {Config.URL_IMAGE + url, "" });
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
			if (buff != null) {
				try {
					String dir = _context.getCacheDir() + "/" + _imgURL + "_vn.png";
					FileOutputStream out = new FileOutputStream(dir);
					buff.compress(Bitmap.CompressFormat.PNG, 100, out);
					out.flush();
					out.close();
					System.out.println(dir);
					if (_isCreateReflected) {
						Bitmap refrectBitmap = Util.createReflectedImages(buff);
						buff.recycle();
						setImage(refrectBitmap);
					} else {
						setImage(buff);
					}
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
					cleanUp();
				}

			}
		}
	}
	
	public void getCoverArt(long id) {
		_id = id;
		Thread _thread = new Thread(new Runnable() {
			@Override
			public void run() {
				// TODO Auto-generated method stub

				String dir = _context.getCacheDir() + "/" + _id + "_ab.png";
				File file = new File(dir);
				if (file.exists()) {
					Bitmap bitmap = BitmapFactory.decodeFile(dir);
					if (bitmap != null) {
						if (_isCreateReflected) {
							Bitmap refrectBitmap = Util
									.createReflectedImages(bitmap);
							bitmap.recycle();
							setImage(refrectBitmap);
						} else {
							setImage(bitmap);
						}
					} 
				} else {
					Uri sArtworkUri = Uri
							.parse("content://media/external/audio/albumart");
					Uri uri = ContentUris.withAppendedId(sArtworkUri, _id);
					ContentResolver res = _context.getContentResolver();
					try {
						InputStream in = res.openInputStream(uri);
						Bitmap bitmap = BitmapFactory.decodeStream(in);
						FileOutputStream fos = new FileOutputStream(dir);
						bitmap.compress(CompressFormat.PNG, 100, fos);
						fos.close();
						if (_isCreateReflected) {
							Bitmap refrectBitmap = Util
									.createReflectedImages(bitmap);
							bitmap.recycle();
							setImage(refrectBitmap);
						} else {
							setImage(bitmap);
						}
						in.close();
					} catch (Exception e) {
						
						e.printStackTrace();
					} 
				}
			}
		});
		_thread.start();
	}

	
	public void getCoverArt(long id,String song, String artist) {
		_id = id;
		_artist = artist;
		_song = song;
		Thread _thread = new Thread(new Runnable() {
			@Override
			public void run() {
				// TODO Auto-generated method stub

				String dir = _context.getCacheDir() + "/" + _id + "_ab.png";
				File file = new File(dir);
				if (file.exists()) {
					Bitmap bitmap = BitmapFactory.decodeFile(dir);
					if (bitmap != null) {
						if (_isCreateReflected) {
							Bitmap refrectBitmap = Util
									.createReflectedImages(bitmap, _song, _artist);
							bitmap.recycle();
							setImage(refrectBitmap);
						} else {
							setImage(bitmap);
						}
					} else {
						Bitmap deBitmap = BitmapFactory.decodeResource(getResources(),
								R.drawable.loading);
						Bitmap refrectBitmap = Util.createReflectedImages(deBitmap, _song, _artist);
						deBitmap.recycle();
						setImage(refrectBitmap);
					}
				} else {
					Uri sArtworkUri = Uri
							.parse("content://media/external/audio/albumart");
					Uri uri = ContentUris.withAppendedId(sArtworkUri, _id);
					ContentResolver res = _context.getContentResolver();
					try {
						InputStream in = res.openInputStream(uri);
						Bitmap bitmap = BitmapFactory.decodeStream(in);
						FileOutputStream fos = new FileOutputStream(dir);
						bitmap.compress(CompressFormat.PNG, 100, fos);
						fos.close();
						if (_isCreateReflected) {
							Bitmap refrectBitmap = Util
									.createReflectedImages(bitmap, _song, _artist);
							bitmap.recycle();
							setImage(refrectBitmap);
						} else {
							setImage(bitmap);
						}
						in.close();
					} catch (Exception e) {
						Bitmap deBitmap = BitmapFactory.decodeResource(getResources(),
								R.drawable.loading);
						Bitmap refrectBitmap = Util.createReflectedImages(deBitmap, _song, _artist);
						deBitmap.recycle();
						setImage(refrectBitmap);
						e.printStackTrace();
					} 
				}
			}
		});
		_thread.start();
	}

	public void getArtistCoverArt(long id) {
		ContentResolver contentResolver = _context.getContentResolver();
		Cursor c = contentResolver.query(
				Artists.Albums.getContentUri("external", id), null, null, null,
				Albums.DEFAULT_SORT_ORDER);
		if (c != null) {
			try {
				if (c.moveToNext()) {
					long albumId = c.getLong(c.getColumnIndex(BaseColumns._ID));
					getCoverArt(albumId);
				}
				c.close();
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			}
		}
	}

	public void setImage(final Bitmap bitmap) {
		post(new Runnable() {
			@Override
			public void run() {
				setImageBitmap(bitmap);
			}
		});
	}

	public void getPlaylistCover(long id) {

	}

	@Override
	public void onClick(View v) {
		
	}
	
}
