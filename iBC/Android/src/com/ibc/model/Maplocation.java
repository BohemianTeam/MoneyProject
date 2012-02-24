package com.ibc.model;

import com.google.android.maps.GeoPoint;
import com.ibc.model.service.response.VenueResponse;

public class Maplocation {
	private GeoPoint	point;
	private VenueResponse venue;
	
	public VenueResponse getVenue() {
		return venue;
	}

	public void setVenue(VenueResponse venue) {
		this.venue = venue;
	}

	public Maplocation() {
		
	}
	
	public Maplocation(VenueResponse venue,double latitude, double longitude) {
		point = new GeoPoint((int) (latitude * 1e6), (int) (longitude * 1e6));
		this.venue = venue;
	}

	public GeoPoint getPoint() {
		return point;
	}
	
	public void setPoint(int lat,int lon) {
		point = new GeoPoint(lat, lon);
	}

}
