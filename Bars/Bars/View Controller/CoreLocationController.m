//
//  CoreLocationController.m
//  Bars
//
//  Created by Cuccku on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreLocationController.h"

@implementation CoreLocationController
@synthesize locMgr = _locMgr;
@synthesize delegate = _delegate;

- (id) init {
    self = [super init];
    if (self) {
        self.locMgr = [[CLLocationManager alloc] init];
        self.locMgr.delegate = self;
        self.locMgr.distanceFilter = kCLDistanceFilterNone;
        self.locMgr.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    return self;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (newLocation) {
        if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {  // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
            [self.delegate locationUpdate:newLocation];
        }
        [manager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {
        [manager stopUpdatingLocation];
		[self.delegate locationError:error];
	}
}

- (void)dealloc {
	[self.locMgr release];
	[super dealloc];
}
@end
