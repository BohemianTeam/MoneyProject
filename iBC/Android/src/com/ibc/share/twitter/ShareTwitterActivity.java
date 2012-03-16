package com.ibc.share.twitter;

import oauth.signpost.OAuth;
import oauth.signpost.OAuthProvider;
import oauth.signpost.basic.DefaultOAuthProvider;
import oauth.signpost.commonshttp.CommonsHttpOAuthConsumer;
import oauth.signpost.exception.OAuthCommunicationException;
import oauth.signpost.exception.OAuthExpectationFailedException;
import oauth.signpost.exception.OAuthMessageSignerException;
import oauth.signpost.exception.OAuthNotAuthorizedException;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.http.AccessToken;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

import com.ibc.IBCApplication;
import com.ibc.R;
import com.ibc.controller.SharedPreferencesManager;
import com.ibc.util.Config;

public class ShareTwitterActivity extends Activity{
	Button _cancelButton;
	TextView _textNumChar;
	Button _postButton;
	EditText _editMessage;
	ImageButton _editChannelButton;
	ImageButton _showKeyboardButton;
	TextView _textChannel;
	ImageButton _infoButton;
	TextView _textTwitterUsename;
	String _shareBody;
	AlertDialog _alertEdit;
	EditText _editChannel;
	boolean isShowKeyboard;
	Twitter _twitter;
	SharedPreferencesManager _shareManager;
	ProgressDialog _dialogMobionLoading;
	AlertDialog _alertHelp;
	
	private static final String CONSUMER_KEY = Config.TWITTER_CONSUMER_KEY;//"LCfn3GpUGNBtsZ2ExZtAQ";//
	private static final String CONSUMER_SECRET = Config.TWITTER_CONSUMER_SECRET;//"Hz7VpIRagXVayjRRhd3NqqzdIw1YZtHcbZekpKXE";//

	private static String ACCESS_KEY = null;
	private static String ACCESS_SECRET = null;

	private static final String REQUEST_URL = "http://twitter.com/oauth/request_token";
	private static final String ACCESS_TOKEN_URL = "http://twitter.com/oauth/access_token";
	private static final String AUTH_URL = "http://twitter.com/oauth/authorize";
	private static final String CALLBACK_URL = "OauthTwitter://twitt";	//"http://www.shoutz.com/twitter";
	
	private static CommonsHttpOAuthConsumer _consumer = new CommonsHttpOAuthConsumer(
			CONSUMER_KEY, CONSUMER_SECRET);
	private static OAuthProvider _provider = new DefaultOAuthProvider(
			REQUEST_URL, ACCESS_TOKEN_URL, AUTH_URL);
	
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.twitter_view);
		String title = "Share to twitter";
		((TextView) findViewById(R.id.title)).setText(title.toUpperCase());
		_shareManager = new SharedPreferencesManager(this);
		inflateView();
	}
	
	private void inflateView() {
		_cancelButton = (Button) findViewById(R.id.twitter_buttonCancel);
		_cancelButton.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				finish();
			}
		});
		_postButton = (Button) findViewById(R.id.twitter_buttonSend);
		_postButton.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				postMessage();
			}
		});
		
		_textNumChar = (TextView) findViewById(R.id.twitter_numchar);
		_textNumChar.setText(String.valueOf(140));
		_editMessage = (EditText) findViewById(R.id.twitter_message);
		_editMessage.setImeOptions(EditorInfo.IME_ACTION_DONE);
		_editMessage.addTextChangedListener(new TextWatcher() {
			@Override
			public void onTextChanged(CharSequence s, int start, int before,
					int count) {
				_textNumChar.setText(String.valueOf(140 - s.length()));
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
				_textNumChar.setText(String.valueOf(s.length()));
			}

			@Override
			public void afterTextChanged(Editable s) {

			}
		});
		_textTwitterUsename = (TextView) findViewById(R.id.twitter_usename);
	}
	private static String _verifier = "";	
	protected void onResume() {
		super.onResume();
		Uri uri = this.getIntent().getData();
		if (uri != null && uri.toString().startsWith(CALLBACK_URL)) {
			_verifier = uri.getQueryParameter(OAuth.OAUTH_VERIFIER);
			try {
				_provider.retrieveAccessToken(_consumer, _verifier);
				ACCESS_KEY = _consumer.getToken();
				ACCESS_SECRET = _consumer.getTokenSecret();				
				AccessToken at = new AccessToken(ACCESS_KEY, ACCESS_SECRET);
				twitter4j.Twitter twitter = new TwitterFactory().getInstance();
				twitter.setOAuthConsumer(CONSUMER_KEY, CONSUMER_SECRET);
				twitter.setOAuthAccessToken(at);
				// create a tweet
				String tweet = _shareManager.getMessage();
				// send the tweet
				if (!tweet.isEmpty()) {
					twitter.updateStatus(tweet);
				}
				
				
			} catch (OAuthMessageSignerException e) {
				e.printStackTrace();
			} catch (OAuthNotAuthorizedException e) {
				e.printStackTrace();
			} catch (OAuthExpectationFailedException e) {
				e.printStackTrace();
			} catch (OAuthCommunicationException e) {
				e.printStackTrace();
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			System.out.println("setup twitter");
			setupTwitter();
		}
	}
	
	private void setupTwitter() {
		IBCApplication app = (IBCApplication) getApplication();
		String key = TwitterActivity.TWITTER_KEY_LOGIN;
		if (app.getData(key) != null) {
			app.removeData(key);
		}
		AccessToken accessToken = _shareManager.loadTwitterToken();
		if (accessToken == null) {
			_textTwitterUsename.setText("");
		} else {
			_twitter = _shareManager.loadTwitter();
			String username;
			try {
				username = _twitter.verifyCredentials().getName();
				_textTwitterUsename.setText(username);
			} catch (TwitterException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	private String limitContent(String message, String extra) {
		String result = message;
		String mark = "\"";
		int limit = (140 - extra.length());
		if (result.length() > limit) {
			result = result.substring(0, limit - (3 + mark.length()));
			result += ("..." + mark);
		}
		result += extra;
		Log.v("Post Tweet", result);
		return result;
	}
	
	private void postMessage() {
		postTwitter();
	}
	String bodyShare;
	public void postTwitter() {
		bodyShare = _editMessage.getText().toString();
		String extra = "";
		bodyShare = limitContent(bodyShare, extra);
		_shareManager.saveMessage(bodyShare);
		final ProgressDialog _dialog = ProgressDialog.show(this, "",
				getString(R.string.TwitterWaitingPostMsg), true, true);
		final Runnable returnRes = new Runnable() {
			@Override
			public void run() {
				_dialog.dismiss();
				finish();
			}
		};
		Runnable runable = new Runnable() {
			@Override
			public void run() {
				try {
					_twitter = _shareManager.loadTwitter();
					if (_twitter != null) {
						_twitter.updateStatus(bodyShare, 0);
					} else {
						try {
							String authURL = _provider.retrieveRequestToken(_consumer,
									CALLBACK_URL);
							Log.d("OAuthTwitter", authURL);
							startActivity(new Intent(Intent.ACTION_VIEW, Uri
									.parse(authURL)));
						} catch (OAuthMessageSignerException e) {
							e.printStackTrace();
						} catch (OAuthNotAuthorizedException e) {
							e.printStackTrace();
						} catch (OAuthExpectationFailedException e) {
							e.printStackTrace();
						} catch (OAuthCommunicationException e) {
							e.printStackTrace();
						}
					}
				} catch (TwitterException e) {
					e.printStackTrace();
				}
				runOnUiThread(returnRes);
			}
		};
		Thread thread = new Thread(null, runable, "Loading Twitter");
		thread.start();
	}
}
