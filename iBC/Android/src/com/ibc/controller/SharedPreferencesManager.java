package com.ibc.controller;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.preference.PreferenceManager;

public class SharedPreferencesManager {
	private Context _context;
	private SharedPreferences _sharedPreferences;
	private Editor _editor;
	
	public static final String INST_ID = "ibc.inst_id";
	
	public SharedPreferencesManager(Context context) {
		_context = context;
		_sharedPreferences = PreferenceManager
				.getDefaultSharedPreferences(_context);
	}
	
	public void saveInstID(String id) {
		_editor = _sharedPreferences.edit();
		_editor.putString(INST_ID, id);
		_editor.commit();
	}
	
	public String loadInstID() {
		return _sharedPreferences.getString(INST_ID, null);
	}
	
	public SharedPreferences getPrefs() {
		return _sharedPreferences;
	}
}
