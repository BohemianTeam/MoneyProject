//
//  StarredListViewController.m
//  iBC
//
//  Created by bohemian on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StarredListViewController.h"
#import "Service.h"
#import "ResponseObj.h"
#import "Util.h"
#import "VenuesObj.h"
#import "EventsObj.h"
#import "VenueViewCell.h"
#import "EventViewCell.h"
#import "config.h"
#import "ImageDownloader.h"
#import "VenueDetailViewController.h"
#import "EventDetailViewController.h"

#define VENUES_SECTION 0
#define EVENTS_SECTION 1
@implementation StarredListViewController
@synthesize imageDownloadsInProgress;
#pragma mark - View Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id) initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.title = [title retain];
        isGoDetailPage = NO;
        // Custom initialization
        starredTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStylePlain];
        starredTable.dataSource = self;
        starredTable.delegate = self;
        starredTable.autoresizesSubviews = YES;
        starredTable.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self.view addSubview:starredTable];
        
        //init service
        service = [[Service alloc] init];
        service.delegate = self;
        service.canShowAlert = YES;
        service.canShowLoading = YES;
        
        //get data
        haveData = NO;
        [self getDataFromServer];
        self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");
    
    if(!isGoDetailPage)
    {
        [service stop];
        
        NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
        [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    isGoDetailPage = NO;
}
- (void)dealloc
{
    [service stop];
    [service release];
    [imageDownloadsInProgress release];
    [starredTable release];
    [eventsList release];
    [venuesList release];
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - 

- (void)getDataFromServer
{
    //show loading
    [Util showLoading:self.view];
    Service *srv = [[Service alloc] init];
    srv.delegate = self;
    srv.canShowAlert = YES;
    srv.canShowLoading = YES;
    
    [srv getStarred];
    [srv release];
}
#pragma mark - tableview delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == VENUES_SECTION)
        return [venuesList count];
    
    return [eventsList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == VENUES_SECTION)
        return VENUE_CELL_HEIGHT;
    return EVENT_CELL_HEIGHT;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEIGHT;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImage *headerImg = nil;
    if(section == 0)
        headerImg = [UIImage imageNamed:@"VenueTitle"];
    else
        headerImg = [UIImage imageNamed:@"EventsTitle"];

    UIImageView *headerView = [[[UIImageView alloc] initWithImage:headerImg] autorelease];
    [headerView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, headerImg.size.height)];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(haveData == NO)
        return nil;
    static NSString *VenuesCell = @"VenuesCell";
    static NSString *EventsCell = @"EventsCell";

    if(indexPath.section == VENUES_SECTION){
        VenueViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VenuesCell];
        if (cell == nil) {
            cell = [[[VenueViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VenuesCell] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        VenuesObj *obj = [venuesList objectAtIndex:indexPath.row];
        [cell setupData:obj];
        if(!obj.imgLogo){
            if (starredTable.dragging == NO && starredTable.decelerating == NO)
            {
                [self startIconDownload:obj forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.imgViewLogo.image = [UIImage imageNamed:@"VenuePlaceholder"];
        }else{
            cell.imgViewLogo.image = obj.imgLogo;
        }
        
        return cell;
    }else{
        EventViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventsCell];
        if (cell == nil) {
            cell = [[[EventViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventsCell] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        EventsObj *obj = [eventsList objectAtIndex:indexPath.row];
        [cell setupData:obj];
        
        if(!obj.imgLogo){
            if (starredTable.dragging == NO && starredTable.decelerating == NO)
            {
                [self startIconDownload:obj forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.imgViewLogo.image = [UIImage imageNamed:@"EventPlaceholder"];
        }else{
            cell.imgViewLogo.image = obj.imgLogo;
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    isGoDetailPage = YES;
    if(indexPath.section == 0)
    {
        VenuesObj *venueObj = [venuesList objectAtIndex:indexPath.row];
        
        VenueDetailViewController *venueDetailVC = [[VenueDetailViewController alloc] init];
        venueDetailVC.venueCode = [venueObj getVenueCode];
        [self.navigationController pushViewController:venueDetailVC animated:YES];
        
        [venueDetailVC release];
    }else{
        isGoDetailPage = YES;
        EventsObj *eventObj = [eventsList objectAtIndex:indexPath.row];
        
        EventDetailViewController *eventDetailVC = [[EventDetailViewController alloc] init];
        eventDetailVC.eventCode = [eventObj getCode];
        [self.navigationController pushViewController:eventDetailVC animated:YES];
        
        [eventDetailVC release];
    }
}
#pragma mark - servide delegate
- (void) mServiceGetStarredSucces:(Service *) service responses:(id) response {
    NSLog(@"API mServiceGetInstIDSucces : success");
    
    ResponseObj *resObj = [[ResponseObj alloc] initWithDataResponse:(NSData*)response];
    //get venues
    NSArray *venues = (NSArray*)[resObj getObjectForKey:VenuesArray];
    if(venues != nil){
        venuesList = [[NSMutableArray alloc] init];
        for(NSDictionary *dict in venues)
        {
            VenuesObj *obj = [[VenuesObj alloc] iniWithDictionary:dict];
            [venuesList addObject:obj];

            [obj release];
        }
    }
    
    //get events
    NSArray *events = (NSArray*)[resObj getObjectForKey:EventsArray];
    if(events != nil){
        eventsList = [[NSMutableArray alloc] init];
        for(NSDictionary *dict in events)
        {
            EventsObj *obj = [[EventsObj alloc] iniWithDictionary:dict];
            [eventsList addObject:obj];

            [obj release];
        }
    }

    //end loading
    [Util hideLoading];
    haveData = YES;
    [starredTable reloadData];
    
}

- (void) mService:(Service *) service didFailWithError:(NSError *) error {
    
}
#pragma mark - Table cell image support

- (void)startIconDownload:(id)otherObj forIndexPath:(NSIndexPath*)indexPath
{
    ImageDownloader *imgDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imgDownloader == nil) 
    {
        imgDownloader = [[ImageDownloader alloc] init];
        imgDownloader.delegate = self;
        imgDownloader.setImgDelegate = otherObj;
        [imageDownloadsInProgress setObject:imgDownloader forKey:indexPath];
        
        NSString *url = [((ResponseObj*)otherObj) getObjectForKey:Logo];
        [imgDownloader startDownloadWithUrl:[NSString stringWithFormat:@"%@%@", API_IMG_URL, url]];
        [imgDownloader release];
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([venuesList count] > 0 || [eventsList count] > 0)
    {
        NSLog(@"loadImagesForOnscreenRows");
        NSArray *visiblePaths = [starredTable indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            if(indexPath.section == VENUES_SECTION){
                VenuesObj *venueObj = [venuesList objectAtIndex:indexPath.row];
                if(!venueObj.imgLogo)
                    [self startIconDownload:venueObj forIndexPath:indexPath];
            }else{
                EventsObj *eventObj = [eventsList objectAtIndex:indexPath.row];
                if(!eventObj.imgLogo)
                    [self startIconDownload:eventObj forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    NSLog(@"appImageDidLoad");
    ImageDownloader *imgDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imgDownloader != nil)
    {
        if(indexPath.section == VENUES_SECTION){
            VenueViewCell *cell = (VenueViewCell*)[starredTable cellForRowAtIndexPath:indexPath];
            cell.imgViewLogo.image = ((VenuesObj*)[venuesList objectAtIndex:indexPath.row]).imgLogo;
        }
        else{
            EventViewCell *cell = (EventViewCell*)[starredTable cellForRowAtIndexPath:indexPath];
            cell.imgViewLogo.image = ((EventsObj*)[eventsList objectAtIndex:indexPath.row]).imgLogo;
        }
    }
    
    [starredTable reloadData];
}

#pragma mark - Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}
@end
