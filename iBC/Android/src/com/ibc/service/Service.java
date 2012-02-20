package com.ibc.service;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;
import java.util.zip.GZIPInputStream;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import com.ibc.iBCApplication;
import com.ibc.util.Config;
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
	private boolean _includeDid;

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
		_includeDid = true;
	}
	/**
	 * Service Method
	 */
	
	
	public void getStatus() {
		_action = ServiceAction.ActionGetStatus;
		
		request("/getStatus/", new HashMap<String, String>(iBCApplication.sharedInstance().getServiceParams()));
	}
	
	public void getVenues(String lat,String lon) {
		_action = ServiceAction.ActionGetVenues;
		
		Map<String, String> params = new HashMap<String, String>(iBCApplication.sharedInstance().getServiceParams());
		String c = lat + "~" + lon;
		params.put("c", c);
		
		request("/getVenues/", params);
	}
	
	public void getVenue(String venueCode) {
		_action = ServiceAction.ActionGetVenue;
		
		Map<String, String> params = new HashMap<String, String>(iBCApplication.sharedInstance().getServiceParams());
		params.put("vc", venueCode);
		
		request("/getVenue/", params);
	}
	
	public void getEvents(String f,String dt) {
		_action = ServiceAction.ActionGetEvents;
		
		Map<String, String> params = new HashMap<String, String>(iBCApplication.sharedInstance().getServiceParams());
		
		params.put("f", f);
		params.put("dt", dt);
		
		request("/getEvents/", params);
	}
	
	public void getEvent(String eventCode) {
		_action = ServiceAction.ActionGetEvent;
		
		Map<String, String> params = new HashMap<String, String>(iBCApplication.sharedInstance().getServiceParams());
		params.put("ec", eventCode);
		
		request("/getEvent/", params);
	}
	
	public void getEventSessions(String eventCode) {
		_action = ServiceAction.ActionGetEventSessions;
		
		Map<String, String> params = new HashMap<String, String>(iBCApplication.sharedInstance().getServiceParams());
		params.put("ec", eventCode);
		
		request("/getEventSessions/", params);
	}
	
	public void getInstID() {
		_action = ServiceAction.ActionGetInstID;
		
		iBCApplication app = iBCApplication.sharedInstance();
		
		Map<String, String> params = app.getServiceParams();
		params.put("a", app.appVersion());
		params.put("r", app.screenResolution());
		params.put("v", app.osVersion());
		params.put("p", app.deviceType());
		
		request("/getInstID/", params);
	}
	
	public void getStarredList() {
		_action = ServiceAction.ActionGetStarredList;
		
		Map<String, String> params = iBCApplication.sharedInstance().getDiffServiceParams();
		
		request("/getStarredList/", params);
	}
	
	public void getStarred() {
		_action = ServiceAction.ActionGetStarred;
		
		Map<String, String> params = new HashMap<String, String>(iBCApplication.sharedInstance().getDiffServiceParams());
		
		request("/getStarred/", params);
	}
	
	/**
	 * Service Processing
	 * 
	 */
	
	public boolean request(String url, Map<String, String> params) {
		return request(url, params, true, true, false);
	}
	
	public boolean request(String url, Map<String, String> params,boolean includeDid, boolean isGet) {
		return request(url, params, includeDid, isGet, false);
	}

	public boolean request(String url, Map<String, String> params,boolean includeDid,
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
		if (_includeDid) {
			urlString = Config.URL + urlString;
		}
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
			boolean isOK = parser.parse(result, DataType.JSON);
			if (isOK) {
				switch (act) {
				case ActionGetStatus:
					resObj = parser.getStatusResponse();
					break;
				case ActionGetVenues:
					resObj = parser.getVenuesResponse(result);
					break;
				case ActionGetVenue:
					resObj = parser.getVenueResponse(result);
					break;
				case ActionGetEvents:
					resObj = parser.getEventsReponse(result);
					break;
				case ActionGetEvent:
					resObj = parser.getEventResponse(result);
					break;
				case ActionGetEventSessions:
					resObj = result;
					break;
				case ActionGetStarredList:
					resObj = parser.getStarredList(result);
					break;
				case ActionGetStarred:
					resObj = parser.getStarred(result);
					break;
				case ActionGetInstID:
					resObj = parser.getInstID(result);
					break;
				default:
					break;
				}
			} else {
				boolean isSuccess = parser.parse(result, DataType.XML);
				if (isSuccess) {
					switch (act) {
					
					}
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
