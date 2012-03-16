package com.ibc;

import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.ContextMenu;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.google.android.maps.MapActivity;
import com.ibc.model.Maplocation;
import com.ibc.model.service.response.VenueResponse;
import com.ibc.share.ShareFacebookActivity;
import com.ibc.share.twitter.ShareTwitterActivity;
import com.ibc.view.MapLocationViewer;
import com.ibc.view.MapViewOverlay;

public class AddressActivity extends MapActivity {

	private VenueResponse _venue;
	private MapLocationViewer _mapViewer;
	private Button _phone;
	private Button _email;
	private Button _share;
	double lat = 0.0;
	double lon = 0.0;
	
	private static final int FB_MENU_ITEM = Menu.FIRST;
	private static final int TW_MENU_ITEM = FB_MENU_ITEM + 1;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		setContentView(R.layout.address_view);
		_venue = (VenueResponse) IBCApplication.sharedInstance().getData("venue");
		String title = _venue.venueName;
		if(null != title) {
        	((TextView) findViewById(R.id.title)).setText(title.toUpperCase());
        }
		
		_phone = (Button) findViewById(R.id.phone);
		_email = (Button) findViewById(R.id.email);
		_share = (Button) findViewById(R.id.share);
		registerForContextMenu(_share);
		
		_mapViewer = (MapLocationViewer) findViewById(R.id.mapview);
		
		IBCApplication app = IBCApplication.sharedInstance();
		if (app.getData("lat") != null && app.getData("lon") != null) {
			lat = (Double) app.getData("lat");
			lon = (Double) app.getData("lon");
			Maplocation maplocation = new Maplocation(_venue, lat, lon);
			
			MapViewOverlay overlay = new MapViewOverlay(maplocation, _mapViewer);
			_mapViewer.getMapView().getOverlays().add(overlay);
			_mapViewer.getMapView().getController().setCenter(maplocation.getPoint());
			_mapViewer.setPressed(false);
		} 
		_phone.setText(_venue.phoneNumber == null ? "" : _venue.phoneNumber);
		_email.setText(_venue.email == null ? "" : _venue.email);
		
		if (_venue.phoneNumber == null || _venue.phoneNumber.trim().length() <= 0) {
			_phone.setVisibility(View.GONE);
		}
		
		if (_venue.email == null || _venue.email.trim().length() <= 0) {
			_email.setVisibility(View.GONE);
		}
	}
	
	@Override
	public void onCreateContextMenu(ContextMenu menu, View v, ContextMenuInfo menuInfo) {
		super.onCreateContextMenu(menu, v, menuInfo);
		if (v == _share) {
			System.out.println("onCreateContextMenu");
			menu.setHeaderTitle("Share Via");
			menu.add(0, FB_MENU_ITEM, 0, "Facebook");
			menu.add(0, TW_MENU_ITEM, 0, "Twitter");
		}
	} 
	
	@Override
	public boolean onContextItemSelected(MenuItem item) {
		if (item.getTitle() == "Facebook") {
			startActivity(new Intent(AddressActivity.this, ShareFacebookActivity.class));
		} else if (item.getTitle() == "Twitter") {
			
		} else {
			return false;
		}
		return true;
	}
	
	public void onShareClicked(View v) {
		new AlertDialog.Builder(this).setTitle("IBC")
        .setMessage("Do you want to share via ?")
        .setPositiveButton("Facebook", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
            	startActivity(new Intent(AddressActivity.this, ShareFacebookActivity.class));
            }
        })
        .setNeutralButton("Twitter", new DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				startActivity(new Intent(AddressActivity.this, ShareTwitterActivity.class));	
			}
		}) 
		.setNegativeButton("Cancel", null)
        .create()
        .show();
	}
	
	@Override
	protected boolean isRouteDisplayed() {
		return false;
	}
	
	public void onRouteClicked(View v) {
		//final Intent myIntent = new Intent(android.content.Intent.ACTION_VIEW, Uri.parse("geo:" + lat + "," + lon + "?z=16"));
        //startActivity(myIntent);
        String[] cor = _venue.cordinates.split("~");
        double des_lat = Double.parseDouble(cor[0]);
        double des_lon = Double.parseDouble(cor[1]);
        
        Intent i = new Intent(Intent.ACTION_VIEW, Uri.parse("http://maps.google.com/maps?saddr="+lat+","+lon+"&daddr="+des_lat+","+des_lon));
        startActivity(i);
	}
	
	public void onAddAddressClicked(View v) {
		new AlertDialog.Builder(this).setTitle("IBC")
        .setMessage("Do you want to add Address by?")
        .setPositiveButton("Create New Contact", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
            	Intent intent = new Intent(AddressActivity.this, ContactAdderActivity.class);
            	if (!_phone.getText().toString().isEmpty()) {
            		intent.putExtra("phone", _phone.getText().toString());
            	}
            	
            	if (!_email.getText().toString().isEmpty()) {
            		intent.putExtra("email", _email.getText().toString());
        		}
            	
            	AddressActivity.this.startActivity(intent);
            }
        })
        .setNeutralButton("Add to exists Contact", new DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				
			}
		}) 
		.setNegativeButton("Cancel", null)
        .create()
        .show();
		/*
		int backRefIndex = 0;

		ArrayList<ContentProviderOperation> op_list = new ArrayList<ContentProviderOperation>();
		op_list.add(ContentProviderOperation.newInsert(RawContacts.CONTENT_URI).withValue(RawContacts.ACCOUNT_TYPE, null).withValue(RawContacts.ACCOUNT_NAME, null).build());      
		op_list.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI).withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, backRefIndex).withValue(ContactsContract.Data.MIMETYPE,ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE).withValue(ContactsContract.CommonDataKinds.StructuredName.DISPLAY_NAME, "My Name").build());
		
		if (!_phone.getText().toString().isEmpty()) {
			op_list.add(ContentProviderOperation.newInsert(Data.CONTENT_URI).withValueBackReference(Data.RAW_CONTACT_ID,backRefIndex).withValue(Phone.MIMETYPE,Phone.CONTENT_ITEM_TYPE).withValue(Phone.NUMBER,"1234567890").withValue(Phone.TYPE,Phone.TYPE_MOBILE).withValue(Phone.TYPE, Phone.TYPE_WORK).build());
		}
		
		if (!_email.getText().toString().isEmpty()) {
		}
		
		try {
		    ContentProviderResult[] result = this.getContentResolver().applyBatch(ContactsContract.AUTHORITY, op_list);
		    
		} catch (OperationApplicationException exp) {
		    exp.printStackTrace();
		} catch (RemoteException exp) {
		    exp.printStackTrace();
		}
		*/
	}
	
	public void onPhoneClicked(View v) {
		if (!_phone.getText().toString().isEmpty()) {
			try {
				System.out.println(_phone.getText().toString());
		        Intent callIntent = new Intent(Intent.ACTION_CALL);
		        callIntent.setData(Uri.parse("tel:" + _phone.getText().toString()));
		        startActivity(callIntent);
		    } catch (ActivityNotFoundException activityException) {
		         Log.e("activity not found", "Call failed." + activityException.getMessage());
		    }
			
		}
	}
	
	public void onEmailClicked(View v) {
		if (!_email.getText().toString().isEmpty()) {
			Intent emailIntent = new Intent(Intent.ACTION_SEND);
			emailIntent.setType("text/plain");
			emailIntent.putExtra(android.content.Intent.EXTRA_EMAIL, new String[]{ _email.getText().toString()});
			startActivity(Intent.createChooser(emailIntent, "Send mail..."));
		}
	}
}
