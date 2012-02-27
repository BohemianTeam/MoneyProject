//
//  MapViewController.h
//  Bars
//
//  Created by Cuong Tran on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface AddressAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	
	NSString *mTitle;
	NSString *mSubTitle;
}
@end

@interface MapViewController : UIViewController <MKMapViewDelegate> {
    MKMapView               *_mapView;
    
    NSString                *_address;
    AddressAnnotation       *_addAnnotation;
}

- (id) initWithAddress:(NSString *)address;

@end
