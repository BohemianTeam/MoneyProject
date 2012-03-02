//
//  MapViewController.m
//  iBC
//
//  Created by bohemian on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "MapViewController.h"
#import "MyLocaAnnotation.h"
@implementation MapViewController
@synthesize mapView;
@synthesize btnEmail;
@synthesize btnPhoneNumber;
@synthesize locaStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    NSArray *splits = [locaStr componentsSeparatedByString:@"~"];
    NSString *lat = [splits objectAtIndex:0];
    NSString *lon = [splits objectAtIndex:1];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [lat doubleValue];
    zoomLocation.longitude = [lon doubleValue];
    
    //specify the region to display. Given a center point and a given width/height (use half a mile here)
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.1*METERS_PER_MILE, 0.1*METERS_PER_MILE);
    //Before sending the region on to the mapview, must to trim the region a bit into 
    //what can actually fit on the green (using method regionThatFits of mapView)
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:YES];
    mapView.delegate = self;
    
    MyLocaAnnotation *myLoca = [[MyLocaAnnotation alloc] initWithName:self.title address:@"" coordinate:zoomLocation];
    [mapView addAnnotation:myLoca];

    [myLoca release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)dealloc
{
    [locaStr release];
    [btnEmail release];
    [btnPhoneNumber release];
    [mapView release];
    [super dealloc];
}

#pragma - MKMapview delegate
-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation 
{
    NSLog(@"---Annotation delegate");
    MKPinAnnotationView *pinView = nil; 
    if(annotation != mapView.userLocation) 
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) pinView = [[[MKPinAnnotationView alloc]
                                          initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
        
        pinView.pinColor = MKPinAnnotationColorRed; 
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
    } 
    else {
        [mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
}
@end
