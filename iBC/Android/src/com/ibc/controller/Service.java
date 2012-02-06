package com.ibc.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Map;
import java.util.zip.GZIPInputStream;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import com.ibc.util.Util;

public class Service implements Runnable {

	private Thread _thread;
	private ServiceAction _action;
	private Service _service;
	private ServiceListener _listener;
	private HttpURLConnection _connection;
	private Map<String, String> _params;
	private boolean _isGet;
	private boolean _connecting;
	private String _actionUri;
	private boolean _isBitMap;

	private final Handler _handler = new Handler() {

		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			_listener.onComplete(_service, (ServiceRespone) msg.obj);
		}
	};

	public Service() {
		this(null);
	}

	public Service(ServiceListener listener) {
		_action = ServiceAction.ActionNone;
		_listener = listener;
		_service = this;
		_connecting = false;
		_isBitMap = false;
	}

	public boolean request(String url, Map<String, String> params, boolean isGet) {
		return request(url, params, isGet, false);
	}

	public boolean request(String url, Map<String, String> params,
			boolean isGet, boolean isBitmap) {
		if (_connecting) {
			return false;
		}
		_connecting = true;
		_actionUri = url;
		_params = params;
		_isGet = isGet;
		_isBitMap = isBitmap;
		_thread = new Thread(this);
		_thread.start();
		return true;
	}

	public boolean isConnecting() {
		return _connecting;
	}

	@Override
	public void run() {
		String urlString = _actionUri;
		String data = getParamsString(_params);
		if (_isGet) {
			if (data != null || data != "") {
				urlString = urlString + "?" + data;
			}
		}
		Log.d("Service", "Url request : " + urlString);
		try {
			URL url = new URL(urlString);
			_connection = (HttpURLConnection) url.openConnection();
			_connection.setRequestMethod(_isGet ? "GET" : "POST");
			_connection.setDoInput(true);

			if (!_isGet) {
				Log.d("Service", "Params:" + data);
				_connection.setDoOutput(true);
				try {
					OutputStream out = new BufferedOutputStream(
							_connection.getOutputStream());
					out.write(data.getBytes());
					out.flush();
					out.close();
				} catch (IOException e) {
					throw e;
				}
			}
			int httpCode = _connection.getResponseCode();
			Log.d("Service", "code=" + httpCode);
			if (httpCode == HttpURLConnection.HTTP_OK) {
				InputStream in;
				if (_connection.getHeaderField("Content-encoding") != null
						&& _connection.getHeaderField("Content-encoding")
								.trim().toLowerCase().equals("gzip")) {
					in = new GZIPInputStream(_connection.getInputStream());
				} else {
					in = new BufferedInputStream(_connection.getInputStream());
				}
				if (_isBitMap) {
					Bitmap bm = BitmapFactory.decodeStream(in);
					dispatchResult(bm);
				} else {
					String result = Util.convertStreamToString(in);
					dispatchResult(result.toString());
				}
			} else if (httpCode == HttpURLConnection.HTTP_NOT_FOUND) {
				processError(ResultCode.Failed);
			} else if (httpCode == HttpURLConnection.HTTP_SERVER_ERROR) {
				processError(ResultCode.ServerError);
			} else {
				processError(ResultCode.NetworkError);
			}
		} catch (Exception e) {
			e.printStackTrace();
			processError(ResultCode.NetworkError);
		} finally {
			clearUp();
		}
	}

	private void clearUp() {
		_action = ServiceAction.ActionNone;
		if (_connection != null) {
			try {
				_connection.disconnect();
			} catch (Exception ex) {
			}
			_connection = null;
		}
		_connecting = false;
		Log.d("Service", "StopService");
	}

	private void processError(ResultCode failed) {
		Message msg = _handler.obtainMessage(0, new ServiceRespone(_action,
				null, failed));
		_handler.sendMessage(msg);
	}

	private void dispatchResult(String result) {
		if (_listener == null || _action == ServiceAction.ActionNone
				|| !_connecting)
			return;
		Log.d("Service", result);

		ServiceAction act = _action;
		Object resObj = null;
		ServiceRespone response = null;
		if (act == ServiceAction.ActionNone) {
			resObj = result;
		} else {
			DataParser parser = new DataParser();
			boolean isOK = parser.parse(result, DataType.XML);
			if (isOK) {
				switch (act) {
				
				default:
					break;
				}
			}
		}
		if (resObj == null) {
			response = new ServiceRespone(_action, resObj, ResultCode.Failed);
		} else {
			response = new ServiceRespone(_action, resObj);
		}
		stop();

		Message msg = _handler.obtainMessage(0, response);
		_handler.sendMessage(msg);
	}

	private void dispatchResult(Bitmap result) {
		if (_listener == null || _action == ServiceAction.ActionNone
				|| !_connecting)
			return;
		ServiceAction act = _action;
		ServiceRespone response = null;

		if (result == null) {
			response = new ServiceRespone(act, null, ResultCode.Failed);
		} else {
			response = new ServiceRespone(act, result);
		}
		stop();
		Message msg = _handler.obtainMessage(0, response);
		_handler.sendMessage(msg);
	}

	public void stop() {
		clearUp();
	}

	private String getParamsString(Map<String, String> params) {
		if (params == null)
			return null;
		String ret = "";
		for (String key : params.keySet()) {
			String value = params.get(key);
			ret += key + "=" + URLEncoder.encode(value) + "&";
		}
		return ret;
	}
}
