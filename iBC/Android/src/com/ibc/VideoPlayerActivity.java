/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements. See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership. The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.ibc;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnCancelListener;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.graphics.PixelFormat;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaPlayer.OnErrorListener;
import android.media.MediaPlayer.OnPreparedListener;
import android.net.Uri;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.util.Log;
import android.view.Gravity;
import android.widget.MediaController;
import android.widget.Toast;
import android.widget.VideoView;

public class VideoPlayerActivity extends Activity implements OnErrorListener,
		OnCompletionListener, OnPreparedListener {
	private static final String TAG = "VideoPlayerAct";
	private String path = "invalid";
	private VideoView mVideoView;
	private String current;
	private ProgressDialog mDialog;
	public static final String RESULT_NETWORK_ERROR = "NETWORK_ERROR";
	public static final String RESULT_EMPTY_PATH = "EMPTY_URL_PATH";
	public static final String RESULT_READ_BUFF_ERROR = "READ_BUFF_ERROR";
	public static final String RESULT_PLAY_ERROR = "PLAY_ERROR";
	private boolean isFinish = false;
	private int count = 0;

	private CountDownTimer timer = new CountDownTimer(60000, 1000) {

		@Override
		public void onTick(long millisUntilFinished) {
			count++;
			if (count == 10) {
				if (mDialog.isShowing()) {
					showToast("Network too slow.Please wait...");
				}
			}

		}

		@Override
		public void onFinish() {
			timer.cancel();
			if (mDialog.isShowing()) {
				mDialog.dismiss();
			}
			showToast("Network time out");
			Intent intent = new Intent(RESULT_NETWORK_ERROR);
			sendBroadcast(intent);
			finish();
		}
	};

	@Override
	public void onCreate(Bundle icicle) {
		super.onCreate(icicle);
		setContentView(R.layout.video);

        //extract the path from the bundle
        Bundle extras = getIntent().getExtras();
        path = extras.getString("path");

        //switch to landscape mode
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

		mVideoView = (VideoView) findViewById(R.id.surface_view);
		mVideoView.setOnErrorListener(this);
		mVideoView.setOnCompletionListener(this);
		mVideoView.setOnPreparedListener(this);
		getWindow().setFormat(PixelFormat.TRANSPARENT);
		timer.start();
		runOnUiThread(new Runnable() {
			public void run() {
				playVideo();
			}
		});
	}

	private void showDialog() {
		mDialog = ProgressDialog.show(this, "", "Loading ...", true, true,
				new OnCancelListener() {

					@Override
					public void onCancel(DialogInterface dialog) {
						// TODO Auto-generated method stub
						if(timer!=null)
							timer.cancel();
						if (!isFinish)
							VideoPlayerActivity.this.finish();
						else
							isFinish = false;
					}
				});

	}

	private void hideDialog() {
		isFinish = true;
		if (mDialog.isShowing()) {
			mDialog.dismiss();
			timer.cancel();
		}

	}

	private void showToast(String msg) {
		Toast toast = Toast.makeText(VideoPlayerActivity.this, msg, Toast.LENGTH_LONG);
		toast.setGravity(Gravity.BOTTOM, toast.getXOffset() / 2,
				toast.getYOffset() / 2);
		toast.show();
	}

	private void playVideo() {

		showDialog();
		try {
			Log.v(TAG, "path: " + path);
			if (path == null || path.length() == 0) {
				showToast("File URL/path is empty");
				Intent intent = new Intent(RESULT_EMPTY_PATH);
				sendBroadcast(intent);
			} else {
				// If the path has not changed, just start the media player
				if (path.equals(current) && mVideoView != null) {
					mVideoView.start();
					mVideoView.requestFocus();
					return;
				}

				current = path;

				mVideoView.setMediaController(new MediaController(
						VideoPlayerActivity.this));
				mVideoView.requestFocus();
				Runnable r = new Runnable() {
					public void run() {
						mVideoView.setVideoURI(Uri.parse(path));
						mVideoView.start();
					}
				};
				new Thread(r).start();

			}
		} catch (Exception e) {
			hideDialog();
			Log.e(TAG, "error: " + e.getMessage(), e);
			Intent intent = new Intent(RESULT_PLAY_ERROR);
			sendBroadcast(intent);
			if (mVideoView != null) {
				mVideoView.stopPlayback();
			}
			VideoPlayerActivity.this.finish();
		}
	}

	@Override
	public void onPrepared(MediaPlayer mp) {
		VideoPlayerActivity.this.setResult(RESULT_OK);
		hideDialog();
		timer.cancel();
	}

	@Override
	public void onCompletion(MediaPlayer mp) {
		finish();
	}

	@Override
	public boolean onError(MediaPlayer mp, int what, int extra) {
		if (what == MediaPlayer.MEDIA_ERROR_SERVER_DIED) {
			showToast("Network time out");
			Intent intent = new Intent(RESULT_NETWORK_ERROR);
			sendBroadcast(intent);
			finish();
		} else {
			Intent intent = new Intent(RESULT_PLAY_ERROR);
			sendBroadcast(intent);
		}
		if (mVideoView != null) {
			mVideoView.stopPlayback();
		}
		return true;

	}

	@Override
	protected void onDestroy() {
		if(timer != null) {
			timer.cancel();
		}
		if(mDialog != null && mDialog.isShowing()) {
			mDialog.dismiss();
		}
		super.onDestroy();
	}
	
	
}
