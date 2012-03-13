//
//  EventCalendarView.m
//  iBC
//
//  Created by bohemian on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventCalendarView.h"
#import "KalViewController.h"
#import "EventDataSource.H"
#import "Util.h"
#import "CJSONDeserializer.h"

@implementation EventCalendarView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"init");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        service = [[Service alloc] init];
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
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
    [super viewDidAppear:YES];
    //[self.navigationController pushViewController:kal animated:YES];
    
    if(haveData)
        [self.navigationController popViewControllerAnimated:NO];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView
//{
//    eventCode = @"ER0000054";
//    /*
//     *    Kal Initialization
//     *
//     * When the calendar is first displayed to the user, Kal will automatically select today's date.
//     * If your application requires an arbitrary starting date, use -[KalViewController initWithSelectedDate:]
//     * instead of -[KalViewController init].
//     */
//    NSLog(@"loadview");
////    if(haveData){
////        kal = [[KalViewController alloc] init];
////        kal.title = @"NativeCal";
////        
////        dataSource = [[EventDataSource alloc] init];
////        kal.dataSource = dataSource;
////        
////        //[self.navigationController pushViewController:kal animated:YES];
////    }else{
////        [self getDataFromServer];
////    }
//    
//    //[self getDataFromServer];
//}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    NSLog(@"view did load");
    eventCode = @"ER0000023";
    [super viewDidLoad];

    kal = [[KalViewController alloc] init];
    kal.title = @"Test Event Calendar";
 
    //[self.navigationController pushViewController:kal animated:YES];

    [self getDataFromServer];
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
    [eventCode release];
    [eventSessionArray release];
    [service stop];
    [service release];
    [dataSource release];
    [kal release];
    [super dealloc];
}
#pragma mark - Service methods
- (void)getDataFromServer
{
    //show loading
    [Util showLoading:self.view];

    service.delegate = self;
    service.canShowAlert = YES;
    service.canShowLoading = YES;
    
    //
    [service getEventSessions:eventCode];

}
- (void)abc
{
    dataSource = [[EventDataSource alloc] initWithDatas:eventSessionArray];
    kal.dataSource = dataSource;
    kal.delegate = dataSource;
    [self.navigationController pushViewController:kal animated:YES];
}
#pragma mark - servide delegate 
- (void) mServiceGetEventSessionsSucces:(Service *) service responses:(id) response {
    NSLog(@"API mServiceGetEventSessionsSucces : success");
    
    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
    NSArray *resultDict = (NSArray*)[jsonDeserializer deserializeAsArray:(NSData*)response error:nil];
    
    eventSessionArray = [[NSMutableArray alloc] initWithArray:resultDict];
    
    haveData = YES;
    [Util hideLoading];
    
    [self abc];
}

- (void) mService:(Service *) service didFailWithError:(NSError *) error {
    
}

@end
