package com.ibc.share.twitter;

import oauth.signpost.OAuthProvider;
import oauth.signpost.basic.DefaultOAuthProvider;
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
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.ibc.IBCApplication;
import com.ibc.R;
import com.ibc.controller.SharedPreferencesManager;
import com.ibc.util.Config;

public class TwitterActivity extends Activity {
	// Define constain
	public static final String TWITTER_KEY_LOGIN = "twitter_key_login";
	public static final String REQUEST_URL = "http://api.twitter.com/oauth/request_token";
	public static final String ACCESS_TOKEN_URL = "http://twitter.com/oauth/access_token";
	public static final String AUTH_URL = "http://twitter.com/oauth/authorize";
	public static final String CALLBACK_URL = "http://IBC.twitter.com";
	// Property
	AndroidOAuthSignpostClient client;
	public static CommonsHttpOAuthConsumer consumer = new CommonsHttpOAuthConsumer(
			Config.TWITTER_CONSUMER_KEY, Config.TWITTER_CONSUMER_SECRET);
	public static OAuthProvider provider = new DefaultOAuthProvider(
			REQUEST_URL, ACCESS_TOKEN_URL, AUTH_URL);

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		new OAuthRequestTokenTask(this, consumer, provider).execute();
	}
	protected boolean flag = false;
	@Override
	protected void onResume(){
		super.onResume();
		if(flag)
			end();
		flag = true;
		
	}
	private class OAuthRequestTokenTask extends AsyncTask<Void, Void, Void> {
		private Context _context;
		private CommonsHttpOAuthConsumer _consumer;
		private OAuthProvider _provider;

		public OAuthRequestTokenTask(Context context,
				CommonsHttpOAuthConsumer consumer, OAuthProvider provider) {
			// TODO Auto-generated constructor stub
			_context = context;
			_consumer = consumer;
			_provider = provider;
		}

		@Override
		protected Void doInBackground(Void... arg0) {
			try {
				// TODO Auto-generated method stub
				final String url = _provider.retrieveRequestToken(_consumer,
						CALLBACK_URL);
				Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url))
						.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP
								| Intent.FLAG_ACTIVITY_NO_HISTORY
								| Intent.FLAG_FROM_BACKGROUND);
				_context.startActivity(intent);
			} catch (Exception e) {
				Log.e("a", "Error during OAUth retrieve request token", e);
			}
			return null;

		}
	}
	
	private Twitter twitter = null;
	private String ScreenName = null;
	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		flag = false;
		Uri uri = intent.getData();
		if (uri != null && uri.toString().startsWith(CALLBACK_URL)) {
			String _verifier = uri.getQueryParameter("oauth_verifier");
			// String _accessToken = uri.getQueryParameter("oauth_token");
			try {
				provider.retrieveAccessToken(consumer, _verifier);
				String accessKey = consumer.getToken();
				String accessSecret = consumer.getTokenSecret();
				AccessToken at = new AccessToken(accessKey, accessSecret);
				SharedPreferencesManager shareManager = new SharedPreferencesManager(
						this);
				shareManager.saveTwitterToken(at);
				twitter = shareManager.loadTwitter();
				IBCApplication app = (IBCApplication) getApplication();
				app.putData(TWITTER_KEY_LOGIN, true);
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
			
			//startActivity(new Intent(this, AutoTweetActivity.class));
		}

		if (twitter != null) {

			try {
				ScreenName = getString(R.string.TwitterScreenName);
				if (!twitter.existsFriendship(twitter.getScreenName(),
						ScreenName)) {
					AlertDialog.Builder builder = new AlertDialog.Builder(this);
					builder.setTitle(getString(R.string.TwitterFollowingTittle));
					builder.setCancelable(false)
							.setPositiveButton(
									getString(R.string.Ok),
									new DialogInterface.OnClickListener() {
										public void onClick(
												DialogInterface dialog,
												int which) {
											// here you can add functions
											try {
												twitter.createFriendship(ScreenName);
												end();
											} catch (TwitterException e) {
												// TODO Auto-generated catch
												// block
												e.printStackTrace();
											}
										}
									})
							.setNegativeButton(
									getString(R.string.Cancel),
									new DialogInterface.OnClickListener() {
										public void onClick(
												DialogInterface dialog,
												int which) {
											// here you can add functions
											end();
										}
									});
					builder.setMessage(String.format(getString(R.string.TwitterFollowingMessage), ScreenName));
					builder.create().show();
				}
				else{
					end();
				}
			} catch (IllegalStateException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (TwitterException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
		else{
			Log.d("s", "twitter = null");
			end();
		}
		
	}
	private void end(){
		finish();
	}

}
