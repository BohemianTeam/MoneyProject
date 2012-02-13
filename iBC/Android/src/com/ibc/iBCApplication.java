package com.ibc;

import java.util.HashMap;
import java.util.Map;

import com.ibc.util.Config;
import com.ibc.util.Util;

import android.app.Application;

public class iBCApplication extends Application {

	private static iBCApplication _instance = null;
	private final HashMap<Object,Object> _data = new HashMap<Object,Object>();
	
	private Map<String, String> _paramsWithSecurityParams = new HashMap<String, String>();
	
	@Override
	public void onCreate() {
		// TODO Auto-generated method stub
		super.onCreate();
		_paramsWithSecurityParams.put("i", Config.KinectiaAppId);
		_paramsWithSecurityParams.put("d", Util.getCurrentTimeString());
		_paramsWithSecurityParams.put("h", Util.hashStringParameter());
		
		System.out.println("onCreate Application");
	}
	
	public iBCApplication() {
		super();
		_instance = this;
	}
	
	public static iBCApplication sharedInstance() {
		return _instance;
	}
	
	public Map<String, String> getServiceParams() {
		return _paramsWithSecurityParams;
	}
	
	public void putData(Object key, Object value) {
		_data.put(key, value);
	}

	public void removeData(Object key) {
		_data.remove(key);
	}

	public Object getData(Object key) {
		return _data.get(key);
	}
}
