package com.ibc.share.twitter;
/*package com.gnt.mobion_music.share.twitter;

import com.gnt.mobion_music.R;
import com.gnt.mobion_music.data.GNMusic;
import oauth.signpost.OAuthProvider;
import oauth.signpost.commonshttp.CommonsHttpOAuthConsumer;
import oauth.signpost.exception.OAuthCommunicationException;
import oauth.signpost.exception.OAuthExpectationFailedException;
import oauth.signpost.exception.OAuthMessageSignerException;
import oauth.signpost.exception.OAuthNotAuthorizedException;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.http.AccessToken;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.net.Uri;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

public class TwitterEditActivity extends Activity {
	// Define constain
	public static final String REQUEST_URL = "http://api.twitter.com/oauth/request_token";
	public static final String ACCESS_TOKEN_URL = "http://twitter.com/oauth/access_token";
	public static final String AUTH_URL = "http://twitter.com/oauth/authorize";
	public static final String CALLBACK_URL = "MobionMusic://twitter";

	// Property
	TextView _textUserName;
	TextView _textNumChar;
	EditText _editMessage;
	Button _sendButton;
	Button _cancelButton;
	Twitter _twitter;
	CommonsHttpOAuthConsumer _consumer;
	OAuthProvider _provider;
	AlertDialog _alertDialog;
	String _message;
	GNMusic _song;
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		View v = getLayoutInflater().inflate(R.layout.twitter_view, null);
		setContentView(v);
		setupUI();
		Uri uri = this.getIntent().getData();
		if (uri != null && uri.toString().startsWith(CALLBACK_URL)) {
			String _verifier = uri.getQueryParameter("oauth_verifier");
			String _accessToken = uri.getQueryParameter("oauth_token");
			try {
				_provider = TwitterActivity.provider;
				_consumer = TwitterActivity.consumer;
				_provider.retrieveAccessToken(_consumer, _verifier);
				String accessKey = _consumer.getToken();
				String accessSecret = _consumer.getTokenSecret();
				AccessToken at = new AccessToken(accessKey, accessSecret);
				_twitter = TwitterActivity.twitter;
				_twitter.setOAuthAccessToken(at);
				String username = _twitter.verifyCredentials().getName();
				_textUserName.setText(username);

			} catch (OAuthMessageSignerException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (OAuthNotAuthorizedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (OAuthExpectationFailedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (OAuthCommunicationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				Toast.makeText(this, e.getMessage(), Toast.LENGTH_LONG).show();
			}
		}

	}

	public void setupUI() {
		_textUserName = (TextView) findViewById(R.id.twitter_usename);
		_textNumChar = (TextView) findViewById(R.id.twitter_numchar);
		_editMessage = (EditText) findViewById(R.id.twitter_message);
		_message = TwitterActivity._message;
		_editMessage.setText(_message);
		_song = TwitterActivity._song;
		_editMessage.requestFocus();
		_editMessage.addTextChangedListener(new TextWatcher() {
			@Override
			public void onTextChanged(CharSequence s, int start, int before,
					int count) {
				// TODO Auto-generated method stub
				_textNumChar.setText(String.valueOf(_message.length() - s.length()));
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
				// TODO Auto-generated method stub
				_textNumChar.setText(String.valueOf(_message.length() - s.length()));
			}

			@Override
			public void afterTextChanged(Editable s) {
				// TODO Auto-generated method stub

			}
		});
		_sendButton = (Button) findViewById(R.id.twitter_buttonSend);
		_sendButton.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				String mess = _editMessage.getText().toString();
				if (mess.length() > 0) {
					try {
						_twitter.updateStatus(mess, 0);
						finish();
					} catch (TwitterException e) {
						_alertDialog.show();
					}
				} else {
					finish();
				}
			}
		});
		_cancelButton = (Button) findViewById(R.id.twitter_buttonCancel);
		_cancelButton.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				finish();
			}
		});
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setTitle("Error");
		builder.setMessage("Unable to update status");
		builder.setCancelable(true);
		_alertDialog = builder.create();
		_alertDialog.setButton("OK", new DialogInterface.OnClickListener() {

			@Override
			public void onClick(DialogInterface dialog, int which) {
				// TODO Auto-generated method stub
				_alertDialog.dismiss();
				finish();
			}
		});
	}
}*/
