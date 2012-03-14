package com.ibc.share;

import java.io.IOException;
import java.net.MalformedURLException;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.ibc.share.facebook.DialogError;
import com.ibc.share.facebook.Facebook;
import com.ibc.share.facebook.Facebook.DialogListener;
import com.ibc.share.facebook.FacebookError;
import com.ibc.util.Config;

public class ShareFacebookActivity extends Activity {

	 Facebook facebook = new Facebook(Config.FACEBOOK_APPID); // Application ID of your app at facebook
	 boolean isLoggedIn = false;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		
		//Implementing SSO
        facebook.authorize(this, new String[]{"publish_stream"}, new DialogListener(){

			@Override
			public void onComplete(Bundle values) {
				//control comes here if the login was successful
//				Facebook.TOKEN is the key by which the value of access token is stored in the Bundle called 'values'
				Log.d("COMPLETE","AUTH COMPLETE. VALUES: "+values.size());
				Log.d("AUTH TOKEN","== "+values.getString(Facebook.TOKEN));
				updateStatus(values.getString(Facebook.TOKEN));
			}

			@Override
			public void onFacebookError(FacebookError e) {
				Log.d("FACEBOOK ERROR","FB ERROR. MSG: "+e.getMessage()+", CAUSE: "+e.getCause());
			}

			@Override
			public void onError(DialogError e) {
				Log.e("ERROR","AUTH ERROR. MSG: "+e.getMessage()+", CAUSE: "+e.getCause());
			}

			@Override
			public void onCancel() {
				Log.d("CANCELLED","AUTH CANCELLED");
			}
		});
	}
	
	//updating Status
    public void updateStatus(String accessToken){
    	try {
			Bundle bundle = new Bundle();
			bundle.putString("message", "IBC very attractive."); //'message' tells facebook that you're updating your status
			bundle.putString(Facebook.TOKEN,accessToken);
			//tells facebook that you're performing this action on the authenticated users wall, thus 
//			it becomes an update. POST tells that the method being used is POST
			String response = facebook.request("me/feed",bundle,"POST");
			Log.d("UPDATE RESPONSE",""+response);
		} catch (MalformedURLException e) {
			Log.e("MALFORMED URL",""+e.getMessage());
		} catch (IOException e) {
			Log.e("IOEX",""+e.getMessage());
		}
    }
    
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        Log.d("onActivityResult","onActivityResult");
        facebook.authorizeCallback(requestCode, resultCode, data);
    }

}
