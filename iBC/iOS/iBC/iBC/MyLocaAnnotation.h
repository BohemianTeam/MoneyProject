//
//  MyLocaAnnotation.h
//  CrimePlotter
//
//  Created by bohemian on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.

/*======= To use annotations there are there steps below==========
    1. Create a class that implements the MKAnnotation protocol.This means it
 needs to return a title, subtitle, and coordinate. You can store other information
 on there if you want too.
    2. For every location you want marked on the map, create one of these classes and 
 add it to the mapView with the addAnnotation method.
    3. Mark the view controller as the map view's delegate, and for each annotation 
 you added it will call a method on the view controller called mapView:viewForAnnotation. 
 Your job jn this method is to return a subclass of MKAnnotationView to present as a visual 
 indicator of the annotation. There's a built-in one called MKPinAnnotationView that we'll 
 be using in this tutorial
 
  ================================================================*/
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyLocaAnnotation : NSObject<MKAnnotation>{
    NSString                *_name;
    NSString                *_address;
    CLLocationCoordinate2D  _coordinate;
}

@property(copy) NSString *name;
@property(copy) NSString *address;
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

@end
