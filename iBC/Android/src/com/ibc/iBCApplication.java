package com.ibc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.app.Application;
import android.content.pm.PackageManager.NameNotFoundException;
import android.provider.Settings;

import com.ibc.controller.SharedPreferencesManager;
import com.ibc.model.service.response.StarredListResponse;
import com.ibc.model.service.response.StarredResponse;
import com.ibc.util.Config;
import com.ibc.util.Util;

public class IBCApplication extends Application {

	private static IBCApplication _instance = null;
	private final HashMap<Object,Object> _data = new HashMap<Object,Object>();
	
	private Map<String, String> _paramsWithSecurityParams = new HashMap<String, String>();
	private Map<String, String> _diffParamsWithSecurityParams = new HashMap<String, String>();
	private SharedPreferencesManager _sharedManager;
	private StarredResponse _starredResponse;
	private List<StarredListResponse> list = new ArrayList<StarredListResponse>();
	
	public List<StarredListResponse> getList() {
		return list;
	}

	public void setList(List<StarredListResponse> list) {
		this.list = list;
	}

	@Override
	public void onCreate() {
		// TODO Auto-generated method stub
		super.onCreate();
		
		_paramsWithSecurityParams.put("i", Config.KinectiaAppId);
		_paramsWithSecurityParams.put("d", Util.getCurrentTimeString());
		_paramsWithSecurityParams.put("h", Util.hashStringParameter());
		
		_diffParamsWithSecurityParams.put("i", Config.KinectiaAppId);
		_sharedManager = new SharedPreferencesManager(getApplicationContext());
		String d = _sharedManager.loadInstID();
		if (null != d) {
			_diffParamsWithSecurityParams.put("d", d);
			String h = Util.hashMac(d + Config.KinectiaAppId);
			_diffParamsWithSecurityParams.put("h", h);
		}
		System.out.println("onCreate Application");
	}
	
	public IBCApplication() {
		super();
		_instance = this;
	}
	
	public static IBCApplication sharedInstance() {
		return _instance;
	}
	
	public synchronized Map<String, String> getServiceParams() {
		return _paramsWithSecurityParams;
	}
	
	public Map<String, String> getDiffServiceParams() {
		return _diffParamsWithSecurityParams;
	}
	
	public void setDiffParams(Map<String, String> map) {
		_diffParamsWithSecurityParams = map;
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
	
	public void setStarredResponse(StarredResponse response) {
		_starredResponse = response;
	}
	
	public StarredResponse getStarredResponse() {
		return _starredResponse;
	}
	
    public String appVersion() {
    	String version;
    	try {
    		version = getPackageManager().getPackageInfo(getApplicationInfo().packageName, 0).versionName;
        }
    	catch (NameNotFoundException e) {
        	e.printStackTrace();
        	version = "Not Found";
        }
        return version;
    }
    
    public String deviceId() {
		String deviceId = Settings.System.getString(getContentResolver(), Settings.System.ANDROID_ID);
        return deviceId;
    }

    public String osVersion() {
    	String osVer = android.os.Build.VERSION.RELEASE;
        return osVer;
    }

    public String deviceType() {
    	String model = "android";
        return model;
    }

    public String model() {
    	String model = android.os.Build.MODEL;
    	return model;
    }

    public String hardware() {
    	String hardware = android.os.Build.TYPE;
        return hardware;
    }
    
    public String screenResolution() {
    	String sr = "480x800";
    	return sr;
    }
    
    public SharedPreferencesManager getSharedPreferencesManager() {
    	return _sharedManager;
    }
}
