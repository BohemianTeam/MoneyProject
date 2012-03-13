//
//  MapViewController.h
//  iBC
//
//  Created by bohemian on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MapViewController : UIViewController<MKMapViewDelegate>
{
    IBOutlet MKMapView              *mapView;
    IBOutlet UIButton               *btnPhoneNumber;
    IBOutlet UIButton               *btnEmail;
    
    NSString                        *locaStr;
    
}
@property(nonatomic, retain)MKMapView           *mapView;
@property(nonatomic, retain)UIButton            *btnPhoneNumber;
@property(nonatomic, retain)UIButton            *btnEmail;
@property(nonatomic, retain)NSString            *locaStr;
@end
