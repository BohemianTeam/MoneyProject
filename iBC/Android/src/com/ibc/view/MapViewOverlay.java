package com.ibc.view;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Point;
import android.graphics.RectF;
import android.text.Html;
import android.view.MotionEvent;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapView;
import com.google.android.maps.Overlay;
import com.ibc.R;
import com.ibc.model.Maplocation;
import com.ibc.model.service.response.VenueResponse;

public class MapViewOverlay extends Overlay{
	
	private Bitmap bubbleIcon, shadowIcon;
	private Maplocation selectedMaplocation;
	
	private Maplocation _location;
	
	private Bitmap _whiteArrow;
	private Paint	innerPaint, borderPaint, textPaint;
	private boolean _isDrawing;
	private boolean _isDrawIcon;
	
	@Override
	public void draw(Canvas canvas, MapView mapView, boolean shadow) {
		if (!_isDrawIcon) {
			drawMapLocations(canvas, mapView, shadow);
		}
		if (selectedMaplocation != null) {
			if (!_isDrawing) {
				drawInfoWindow(canvas, mapView, shadow);
				_isDrawing = true;
			}
		}
	}
	
	private void drawInfoWindow(Canvas canvas, MapView mapView, boolean shadow) {
	//  First determine the screen coordinates of the selected MapLocation
		Point selDestinationOffset = new Point();
		mapView.getProjection().toPixels(_location.getPoint(), selDestinationOffset);
    	
    	//  Setup the info window with the right size & location
		int INFO_WINDOW_WIDTH = 320;
		int INFO_WINDOW_HEIGHT = 75;
		RectF infoWindowRect = new RectF(0,0,INFO_WINDOW_WIDTH,INFO_WINDOW_HEIGHT);				
		int infoWindowOffsetX = selDestinationOffset.x - INFO_WINDOW_WIDTH / 2;
		int infoWindowOffsetY = selDestinationOffset.y - INFO_WINDOW_HEIGHT - bubbleIcon.getHeight();
		infoWindowRect.offset(0, 0);
		canvas.translate(infoWindowOffsetX, infoWindowOffsetY);
		//  Draw inner info window
		canvas.drawRoundRect(infoWindowRect, 5, 5, getInnerPaint());
		
		VenueResponse venue = _location.getVenue();
		//  Draw the MapLocation's name
		int NAME_OFFSET_X = 10;
		int NAME_OFFSET_Y = 25;
		canvas.drawText(venue.venueName,NAME_OFFSET_X,NAME_OFFSET_Y,getBorderPaint());
		
		int ADD_OFFSET_X = 10;
		int ADD_OFFSET_Y = 60;
		
		String address = venue.address == null ? "" : Html.fromHtml(venue.address).toString();
		canvas.drawText(address, ADD_OFFSET_X, ADD_OFFSET_Y, getTextPaint());
		
		String di = venue.di == null ? "" : venue.di;
		canvas.drawText(di, INFO_WINDOW_WIDTH - 2 * _whiteArrow.getWidth() - di.length() * 10, (INFO_WINDOW_HEIGHT) / 2 + 5, getTextPaint());
		
		canvas.drawBitmap(_whiteArrow , INFO_WINDOW_WIDTH - _whiteArrow.getWidth() - 10, (INFO_WINDOW_HEIGHT - _whiteArrow.getHeight()) / 2, null);
		
	}

	@Override
	public boolean onTouchEvent(MotionEvent e, MapView mapView) {
		// TODO Auto-generated method stub
		_isDrawIcon = false;
		mapView.invalidate();
		return super.onTouchEvent(e, mapView);
	}

	@Override
	public boolean onTap(GeoPoint p, MapView mapView) {
		// Store whether prior popup was displayed so we can call invalidate() &
		// remove it if necessary.
		boolean isRemovePriorPopup = selectedMaplocation != null;
		// Next test whether a new popup should be displayed
		selectedMaplocation = getHitMapLocation(mapView, p);
		// Next test whether a new popup should be displayed
		if (isRemovePriorPopup || selectedMaplocation != null) {
			_isDrawing = false;
			_isDrawIcon = false;
			mapView.invalidate();
			
		}

		// Lastly return true if we handled this onTap()
		return selectedMaplocation != null;
	}
	
	
	private Maplocation getHitMapLocation(MapView mapView, GeoPoint p) {
		// Track which MapLocation was hit...if any
		Maplocation hitMapLocation = null;

		RectF hitTestRecr = new RectF();
		Point screenCoords = new Point();

		// Translate the MapLocation's lat/long coordinates to screen
		// coordinates
		mapView.getProjection().toPixels(_location.getPoint(), screenCoords);

		// Create a 'hit' testing Rectangle w/size and coordinates of our icon
		// Set the 'hit' testing Rectangle with the size and coordinates of our
		// on screen icon
		hitTestRecr.set(-bubbleIcon.getWidth() / 2, -bubbleIcon.getHeight(), bubbleIcon.getWidth() / 2, 0);
		hitTestRecr.offset(screenCoords.x, screenCoords.y);

		// Finally test for a match between our 'hit' Rectangle and the location
		// clicked by the user
		mapView.getProjection().toPixels(p, screenCoords);
		if (hitTestRecr.contains(screenCoords.x, screenCoords.y)) {
			hitMapLocation = _location;
		}

		// Lastly clear the newMouseSelection as it has now been processed
		p = null;

		return hitMapLocation;
	}

	private void drawMapLocations(Canvas canvas, MapView	mapView, boolean shadow) {
		Point screenCoords = new Point();
		mapView.getProjection().toPixels(_location.getPoint(), screenCoords);
    	//  Only offset the shadow in the y-axis as the shadow is angled so the base is at x=0; 
    	canvas.drawBitmap(shadowIcon, screenCoords.x, screenCoords.y - shadowIcon.getHeight(), null);
		canvas.drawBitmap(bubbleIcon, screenCoords.x - bubbleIcon.getWidth() / 2, screenCoords.y - bubbleIcon.getHeight(), null);
    }
	
	public MapViewOverlay(Maplocation location , MapLocationViewer mapLocationViewer) {
		bubbleIcon = BitmapFactory.decodeResource(mapLocationViewer.getResources(),R.drawable.bubble);
		shadowIcon = BitmapFactory.decodeResource(mapLocationViewer.getResources(),R.drawable.shadow);
		_whiteArrow = BitmapFactory.decodeResource(mapLocationViewer.getResources(), R.drawable.white_accessory);
		
		_location = location;
	}
	
	public Paint getInnerPaint() {
		if (innerPaint == null) {
			innerPaint = new Paint();
			innerPaint.setARGB(150, 75, 75, 75); // gray
			innerPaint.setAntiAlias(true);
		}
		return innerPaint;
	}

	public Paint getBorderPaint() {
		if (borderPaint == null) {
			borderPaint = new Paint();
			borderPaint.setARGB(255, 255, 255, 255);
			borderPaint.setAntiAlias(true);
			borderPaint.setTextSize(18);
		}
		return borderPaint;
	}

	public Paint getTextPaint() {
		if (textPaint == null) {
			textPaint = new Paint();
			textPaint.setARGB(255, 255, 255, 255);
			textPaint.setAntiAlias(true);
			textPaint.setTextSize(16);
		}
		return textPaint;
	}
}
