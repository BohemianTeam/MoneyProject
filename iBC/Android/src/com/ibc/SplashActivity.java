package com.ibc;

import java.util.List;
import java.util.Map;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.Window;
import android.view.WindowManager;

import com.ibc.model.service.response.InstIDResponse;
import com.ibc.model.service.response.StarredListResponse;
import com.ibc.model.service.response.StarredResponse;
import com.ibc.service.ResultCode;
import com.ibc.service.Service;
import com.ibc.service.ServiceAction;
import com.ibc.service.ServiceListener;
import com.ibc.service.ServiceRespone;
import com.ibc.util.Config;
import com.ibc.util.Util;

public class SplashActivity extends Activity {
    //for logging
    private static final String TAG = SplashActivity.class.getSimpleName();

    //use fullscreen mode for the splash branding?
    private final boolean fullscreen = true;
    //hiding the notification bar sometimes takes longer than 500ms
    //.. so keeping fullscreen=false is preferable for now?
    
    //force portrait mode?
    private final boolean forcePortraitMode = true;

    //store our asynchronous background task
    private ApplicationDataLoadingTask backgroundTask;

    //a simple selection routine
    private String targetActivity;

   @Override
    public void onCreate(Bundle savedInstanceState) {
        Log.d(TAG, "onCreate starting");
        super.onCreate(savedInstanceState);

        //remove title bar
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        
        //set fullscreen
        if (fullscreen) {
            getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        }

        //force portrait mode
        if (forcePortraitMode) {
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        }

        //set the layout to res/layouts/splash.xml
        setContentView(R.layout.splash);

        //default target for where the splash screen goes
        targetActivity = "MainActivity";

        //check if a target activity was specified
        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            if (extras.containsKey("targetActivity")) {
                targetActivity = extras.getString("targetActivity");
            }
        }
        if (!isOnline()) {
        	showAlertDialog();
        }
        //get inst id
		IBCApplication app = IBCApplication.sharedInstance();
		String id = app.getSharedPreferencesManager().loadInstID();
		if (id == null || id.isEmpty()) {
			Service service = new Service(_listener);
			service.getInstID();
		} else {
			//start loading the application data
	        backgroundTask = new ApplicationDataLoadingTask();
	        backgroundTask.execute();
		}

        Log.d(TAG, "onCreate ending");
    }
   
   private void showAlertDialog() {
	// create builder for alert dialog
		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setMessage(getResources().getString(R.string.AlertMessageNotConnect)).setTitle(getResources().getString(R.string.AlertTitleNotConnect))
				.setCancelable(false)
				.setPositiveButton(getResources().getString(R.string.ok),
						new DialogInterface.OnClickListener() {
		
							@Override
							public void onClick(DialogInterface dialog,
									int which) {
								// MainActivity.this.moveTaskToBack(true);
								SplashActivity.this.finish();
							}
						});
		// create alet dialog
		AlertDialog alert = builder.create();
		alert.show();
   }

   public boolean isOnline() {
	    ConnectivityManager cm =
	        (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
	    NetworkInfo netInfo = cm.getActiveNetworkInfo();
	    if (netInfo != null && netInfo.isConnectedOrConnecting()) {
	        return true;
	    }
	    return false;
	}
   
   ServiceListener _listener = new ServiceListener() {

		@SuppressWarnings("unchecked")
		@Override
		public void onComplete(Service service, ServiceRespone result) {
			
			if (result.getResultCode() != ResultCode.Success) {
				//start loading the application data
		        backgroundTask = new ApplicationDataLoadingTask();
		        backgroundTask.execute();
			} else {
				if (result.getAction() == ServiceAction.ActionGetInstID) {
					
					if (result.getResultCode() == ResultCode.Success) {
						InstIDResponse response = (InstIDResponse) result.getData();
						String d = response.instID;
						d = "823ab7fc7820d402";//for test
						
						IBCApplication app = IBCApplication.sharedInstance();
						
						app.getSharedPreferencesManager().saveInstID(d);
						Map<String, String> map = app.getDiffServiceParams();
						map.put("d", d);
						String h = Util.hashMac(d + Config.KinectiaAppId);
						map.put("h", h);
						app.setDiffParams(map);
						
						//save
						app.getSharedPreferencesManager().saveInstID(d);
						//get starred
						Service sv = new Service(_listener);
	//					sv.getStarred();
						sv.getStarredList();
					}
					
					
				} else if (result.getAction() == ServiceAction.ActionGetStarred) {
					if (result.getResultCode() == ResultCode.Success) {
						StarredResponse response = (StarredResponse) result
								.getData();
						IBCApplication.sharedInstance().setStarredResponse(response);
					}
					
					//start loading the application data
			        backgroundTask = new ApplicationDataLoadingTask();
			        backgroundTask.execute();
				} else if (result.getAction() == ServiceAction.ActionGetStarredList) {
					if (result.getResultCode() == ResultCode.Success) {
						List<StarredListResponse> list = (List<StarredListResponse>) result
								.getData();
						IBCApplication.sharedInstance().setList(list);
					}
					
					//start loading the application data
			        backgroundTask = new ApplicationDataLoadingTask();
			        backgroundTask.execute();
				}
			}
		}
	};
	
    @Override
    public void onResume() {
        Log.d(TAG, "onResume called");
        super.onResume();
    }

    @Override
    public void onStop() {
        Log.d(TAG, "onStop called");
        super.onStop();
        //finish();
    }

    @Override
    public void finish() {
        //cancel launch
    	if (backgroundTask != null) {
    		backgroundTask.cancel(true);
    	}
        super.finish();
    }

    public void startNextActivity() {
        Log.d(TAG, "startNextActivity called");

        //launch the next activity (or send back)
        Intent intent = null;
        if (targetActivity == "MainActivity") {
            intent = new Intent(this, MainActivity.class);
        }
        startActivity(intent);

        //we don't need this activity
        finish();
    }

    public class ApplicationDataLoadingTask extends AsyncTask<Void, Void, Void> {
    	
        protected void onPreExecute() {
            Log.d(TAG, "ApplicationDataLoadingTask::onPreExecute");
        }
    
        protected Void doInBackground(Void... params) {
            Log.d(TAG, "ApplicationDataLoadingTask::doInBackground");
            
            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            
            return null;
        }
    
        protected void onPostExecute(Void v) {
            Log.d(TAG, "ApplicationDataLoadingTask::onPostExecute");
            startNextActivity();
        }
    }
}
