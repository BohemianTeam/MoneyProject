package com.ibc.controller;

import java.io.IOException;
import java.util.List;
import java.util.Locale;
import java.util.Timer;
import java.util.TimerTask;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.location.Address;
import android.location.Criteria;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Handler;
import android.provider.Settings;

import com.ibc.model.GPSInfo;

public class GPSService {
	LocationManager _locManager;
	LocationListener _locListener;
	public GPSServiceListener _listener;
	GPSInfo _gpsInfo;
	Context _context;
	boolean _gpsTimeout = false;
	Timer _gpsTimer = new Timer();

	public GPSService(Context context , GPSServiceListener listener) {
		this._context = context;
		this._listener = listener;
		
	}
	
	public void getGSP() {
		String provider = Settings.Secure.getString(_context.getContentResolver(),Settings.Secure.LOCATION_PROVIDERS_ALLOWED);
		if (provider == null || provider.equalsIgnoreCase("")) {
			Criteria criteria = new Criteria();
			criteria.setAccuracy(Criteria.ACCURACY_FINE);
			criteria.setPowerRequirement(Criteria.POWER_MEDIUM);
			_locManager = (LocationManager) _context.getSystemService(Context.LOCATION_SERVICE);
			_locManager.getBestProvider(criteria, true);
			_locListener = new MyLocationListener();
			_locManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0, 0, _locListener);
			_gpsTimeout = false;
			_gpsTimer.schedule(new GPSTimer(false), 5 * 1000);
		} else {
			Criteria criteria = new Criteria();
			criteria.setAccuracy(Criteria.ACCURACY_FINE);
			criteria.setPowerRequirement(Criteria.POWER_MEDIUM);
			_locManager = (LocationManager) _context.getSystemService(Context.LOCATION_SERVICE);
			_locManager.getBestProvider(criteria, true);
			_locListener = new MyLocationListener();
			_locManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, _locListener);
			_gpsTimeout = false;
			_gpsTimer.schedule(new GPSTimer(true), 5 * 1000);
		}
	}
	
	public interface GPSServiceListener {
		public void onGetGPSSuccess(GPSInfo gpsInfo);
		public void onGetGPSFail();
	}

	public class MyLocationListener implements LocationListener {

		@Override
		public void onLocationChanged(Location loc) {
			_gpsTimer.cancel();
			if (loc != null) {
				_gpsInfo = new GPSInfo();
				_gpsInfo.setLat(loc.getLatitude());
				_gpsInfo.setLng(loc.getLongitude());
				_locManager.removeUpdates(this);
				Geocoder geocoder = new Geocoder(_context, Locale.getDefault());
				try {
					List<Address> addresses = geocoder.getFromLocation(
							_gpsInfo.getLat(), _gpsInfo.getLng(), 1);
					if (addresses.size() > 0) {
						Address address = addresses.get(0);
						String info = "";
						for (int i = 0; i < address.getMaxAddressLineIndex(); i++)
							info += address.getAddressLine(i) + ",";
						_gpsInfo.setInfo(info);
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
				_listener.onGetGPSSuccess(_gpsInfo);
			} else {
				_locManager.removeUpdates(this);
				_listener.onGetGPSFail();
			}

		}

		@Override
		public void onProviderDisabled(String provider) {
			showError();
		}

		@Override
		public void onProviderEnabled(String provider) {

		}

		@Override
		public void onStatusChanged(String provider, int status, Bundle extras) {

		}
	}

	Handler timerHandler = new Handler();

	class GPSTimer extends TimerTask {
		boolean _isGSPProvider;
		public GPSTimer(boolean isGPSProvider) {
			_isGSPProvider = isGPSProvider;
		}
		private Runnable runnable = new Runnable() {
			public void run() {
				if (_gpsTimeout == false) {
					Location loc = null;
					if (_isGSPProvider) {
						loc = _locManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
					} else {
						loc = _locManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
					}
					if (loc != null) {
						_gpsInfo = new GPSInfo();
						_gpsInfo.setLat(loc.getLatitude());
						_gpsInfo.setLng(loc.getLongitude());
						_locManager.removeUpdates(_locListener);
						Geocoder geocoder = new Geocoder(_context, Locale.getDefault());
						try {
							List<Address> addresses = geocoder.getFromLocation(_gpsInfo.getLat(), _gpsInfo.getLng(), 1);
							if (addresses.size() > 0) {
								Address address = addresses.get(0);
								String info = "";
								for (int i = 0; i < address.getMaxAddressLineIndex(); i++) {
									info += address.getAddressLine(i) + ",";
								}
								_gpsInfo.setInfo(info);
							}
						} catch (IOException e) {
							e.printStackTrace();
						}
						_listener.onGetGPSSuccess(_gpsInfo);
					} else {
						_locManager.removeUpdates(_locListener);
						_listener.onGetGPSFail();
					}
				} else {
					_listener.onGetGPSFail();
					_locManager.removeUpdates(_locListener);
				}
			}
		};

		@Override
		public void run() {
			timerHandler.post(runnable);
		}
	}

	public void showError() {
		if (!(_context instanceof Activity)) {
			return;
		}
		AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(
				_context);
		alertDialogBuilder.setMessage("Application alows your GSP service.Could you alow this?")
				.setCancelable(false)
				.setPositiveButton("OK", new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int id) {
						Intent callGPSSettingIntent = new Intent(
								android.provider.Settings.ACTION_LOCATION_SOURCE_SETTINGS);
						_context.startActivity(callGPSSettingIntent);
					}
				});
		alertDialogBuilder.setNegativeButton("Cancel",
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int id) {
						dialog.cancel();
					}
				});
		AlertDialog alert = alertDialogBuilder.create();
		alert.show();
	}
}
