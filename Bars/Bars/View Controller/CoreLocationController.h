//
//  CoreLocationController.h
//  Bars
//
//  Created by Cuccku on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@protocol CoreLocationControllerDelegate
@required
- (void) locationUpdate:(CLLocation *) location;
- (void) locationError:(NSError *) error;
@end

@interface CoreLocationController : NSObject <CLLocationManagerDelegate>{
    CLLocationManager       *_locMgr;
    id                      _delegate;
}
@property (nonatomic, retain) CLLocationManager *locMgr;
@property (nonatomic, assign) id delegate;
@end
