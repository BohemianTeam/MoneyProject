package com.ibc.controller;

import twitter4j.Twitter;
import twitter4j.TwitterFactory;
import twitter4j.http.AccessToken;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.preference.PreferenceManager;

import com.ibc.share.facebook.Facebook;
import com.ibc.util.Config;

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

	// ------------------------FACE BOOK---------------------------
	public boolean saveFacebook(Facebook facebook) {
		Editor editor = _context.getSharedPreferences("FACEBOOK",
				Context.MODE_PRIVATE).edit();
		editor.putString("facebook_token", facebook.getAccessToken());
		editor.putLong("expires", facebook.getAccessExpires());
		return editor.commit();
	}

	public void clearFacebook() {
		Editor editor = _context.getSharedPreferences("FACEBOOK",
				Context.MODE_PRIVATE).edit();
		editor.clear();
		editor.commit();
	}

	public Facebook loadFacebook() {
		SharedPreferences savedSession = _context.getSharedPreferences(
				"FACEBOOK", Context.MODE_PRIVATE);
		Facebook facebook = new Facebook(Config.FACEBOOK_APPID);
		facebook.setAccessToken(savedSession.getString("facebook_token", null));
		facebook.setAccessExpires(savedSession.getLong("expires", 0));
		if (facebook.isSessionValid())
			return facebook;
		else
			return null;
	}

	// ------------------------------TWITTER-------------------------------
	public Twitter loadTwitter() {
		Twitter _twitter = new TwitterFactory().getInstance();
		_twitter.setOAuthConsumer(Config.TWITTER_CONSUMER_KEY,
				Config.TWITTER_CONSUMER_SECRET);

		AccessToken accessToken = loadTwitterToken();
		if (accessToken == null)
			return null;

		_twitter.setOAuthAccessToken(accessToken);
		return _twitter;
	}

	public boolean saveTwitterToken(AccessToken token) {
		Editor editor = _context.getSharedPreferences("TWITTER",
				Context.MODE_PRIVATE).edit();
		editor.putString("twitter_key", token.getToken());
		editor.putString("twitter_secret", token.getTokenSecret());
		return editor.commit();
	}

	public AccessToken loadTwitterToken() {
		SharedPreferences savedSession = _context.getSharedPreferences(
				"TWITTER", Context.MODE_PRIVATE);
		String key = savedSession.getString("twitter_key", "");
		String secret = savedSession.getString("twitter_secret", "");
		if (key == "" || secret == "") {
			return null;
		}
		return new AccessToken(key, secret);
	}

	public void clearTwitter() {
		Editor editor = _context.getSharedPreferences("TWITTER",
				Context.MODE_PRIVATE).edit();
		editor.clear();
		editor.commit();
	}

	public void saveMessage(String msg) {
		_editor = _sharedPreferences.edit();
		_editor.putString("msg", msg);
		_editor.commit();
	}

	public String getMessage() {
		return _sharedPreferences.getString("msg", "");
	}


}
