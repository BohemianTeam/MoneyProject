package com.ibc.share.twitter;

import java.util.Date;

import oauth.signpost.OAuth;
import oauth.signpost.OAuthProvider;
import oauth.signpost.basic.DefaultOAuthProvider;
import oauth.signpost.commonshttp.CommonsHttpOAuthConsumer;
import oauth.signpost.exception.OAuthCommunicationException;
import oauth.signpost.exception.OAuthExpectationFailedException;
import oauth.signpost.exception.OAuthMessageSignerException;
import oauth.signpost.exception.OAuthNotAuthorizedException;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.http.AccessToken;
import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.Toast;

import com.ibc.R;

public class ConnectTwitter extends Activity {

//	private static Twitter _jtwit;
//	private static String _accessToken;
	private static String _verifier = "";	

	@Override
	protected void onResume() {
		super.onResume();
		Uri uri = this.getIntent().getData();
		if (uri != null && uri.toString().startsWith(CALLBACK_URL)) {
			_verifier = uri.getQueryParameter(OAuth.OAUTH_VERIFIER);
//			_accessToken = uri.getQueryParameter("oauth_token");
			try {
				_provider.retrieveAccessToken(_consumer, _verifier);
				ACCESS_KEY = _consumer.getToken();
				ACCESS_SECRET = _consumer.getTokenSecret();				
				AccessToken at = new AccessToken(ACCESS_KEY, ACCESS_SECRET);
				twitter4j.Twitter twitter = new TwitterFactory().getInstance();
				twitter.setOAuthConsumer(CONSUMER_KEY, CONSUMER_SECRET);
				twitter.setOAuthAccessToken(at);
				// create a tweet
				Date d = new Date(System.currentTimeMillis());
				String tweet = "#OAuth working! " + d.toLocaleString();
				// send the tweet
				twitter.updateStatus(tweet);
				
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
			}
			catch (Exception e) {
                Log.e("ZZZZZ", e.getMessage());
                Toast.makeText(this, e.getMessage(), Toast.LENGTH_LONG).show();
			}
		}

	}

	//private static final String CONSUMER_KEY = Config.TWITTER_CONSUMER_KEY;//"LCfn3GpUGNBtsZ2ExZtAQ";//
	//private static final String CONSUMER_SECRET = Config.TWITTER_CONSUMER_SECRET;//"Hz7VpIRagXVayjRRhd3NqqzdIw1YZtHcbZekpKXE";//
	private static final String CONSUMER_KEY = "LCfn3GpUGNBtsZ2ExZtAQ";
		private static final String CONSUMER_SECRET = "Hz7VpIRagXVayjRRhd3NqqzdIw1YZtHcbZekpKXE";
		
	private static String ACCESS_KEY = null;
	private static String ACCESS_SECRET = null;

	private static final String REQUEST_URL = "http://twitter.com/oauth/request_token";
	private static final String ACCESS_TOKEN_URL = "http://twitter.com/oauth/access_token";
	private static final String AUTH_URL = "http://twitter.com/oauth/authorize";
	private static final String CALLBACK_URL = "OauthTwitter://twitt";	

	private static CommonsHttpOAuthConsumer _consumer = new CommonsHttpOAuthConsumer(
			CONSUMER_KEY, CONSUMER_SECRET);
	private static OAuthProvider _provider = new DefaultOAuthProvider(
			REQUEST_URL, ACCESS_TOKEN_URL, AUTH_URL);
	

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.twitter_layout);
		
		Button button = (Button) findViewById(R.id.btnConnect);
		button.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				try {
					/*
					ConfigurationBuilder configurationBuilder = new ConfigurationBuilder();

				     configurationBuilder.setOAuthConsumerKey(CONSUMER_KEY);
				     configurationBuilder.setOAuthConsumerSecret(CONSUMER_SECRET);
				     Configuration configuration = configurationBuilder.build();

				     Twitter twitter = new TwitterFactory(configuration).getInstance("trinhduchung266@gmail.com","duchung"); 

				     AccessToken token = twitter.getOAuthAccessToken();
				     System.out.println("Access Token " +token );

				     String name = token.getScreenName();
				     System.out.println("Screen Name" +name);
				     
				     Date d = new Date(System.currentTimeMillis());
				     String tweet = "working! " + d.toLocaleString();
				     twitter.updateStatus(tweet);
				     */
					String authURL = _provider.retrieveRequestToken(_consumer,
							CALLBACK_URL);
					Log.d("OAuthTwitter", authURL);
					startActivity(new Intent(Intent.ACTION_VIEW, Uri
							.parse(authURL)));
							
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
				}
			}
		});		
		Button btnLogin = (Button) findViewById(R.id.Button01);
		btnLogin.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				ACCESS_KEY = _consumer.getToken();
				ACCESS_SECRET = _consumer.getTokenSecret();
				
				AccessToken at = new AccessToken(ACCESS_KEY, ACCESS_SECRET);
				twitter4j.Twitter twitter = new TwitterFactory().getInstance();
				twitter.setOAuthConsumer(CONSUMER_KEY, CONSUMER_SECRET);
				twitter.setOAuthAccessToken(at);
				// create a tweet
				Date d = new Date(System.currentTimeMillis());
				String tweet = "#OAuth working! " + d.toLocaleString();
				// send the tweet
				try {
					System.out.println(tweet);
					twitter.updateStatus(tweet);
					
				} catch (TwitterException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		});
	}
}
