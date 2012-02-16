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

#define VENUES_SECTION 0
#define EVENTS_SECTION 1
@implementation StarredListViewController

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
        
        // Custom initialization
        starredTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain];
        starredTable.dataSource = self;
        starredTable.delegate = self;
        
        [self.view addSubview:starredTable];
        
        //get data
        haveData = NO;
        [self getDataFromServer];    
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
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
    NSLog(@"-->%d", indexPath.row);
    if(indexPath.section == VENUES_SECTION){
        VenueViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VenuesCell];
        if (cell == nil) {
            cell = [[[VenueViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VenuesCell] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setupData:[venuesList objectAtIndex:indexPath.row]];
        
        return cell;
    }else{
        EventViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventsCell];
        if (cell == nil) {
            cell = [[[EventViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventsCell] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setupData:[eventsList objectAtIndex:indexPath.row]];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
            [venuesList addObject:obj];
            [obj release];
        }
    }
    
    //get events
    NSArray *events = (NSArray*)[resObj getObjectForKey:@"e"];
    if(events != nil){
        eventsList = [[NSMutableArray alloc] init];
        for(NSDictionary *dict in events)
        {
            EventsObj *obj = [[EventsObj alloc] iniWithDictionary:dict];
            [eventsList addObject:obj];
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

- (void)startIconDownload:(ResponseObj *)otherObj forIndexImg:(NSString*)indexImg
{
    ImageDownloader *imgDownloader = [imageDownloadsInProgress objectForKey:indexImg];
    if (imgDownloader == nil) 
    {
        imgDownloader = [[ImageDownloader alloc] init];
        imgDownloader.otherObj = otherObj;
        imgDownloader.indexImageOnRowTable = indexImg;
        imgDownloader.delegate = self;
        [imageDownloadsInProgress setObject:imgDownloader forKey:indexImg];
        [imgDownloader startDownload];
        [imgDownloader release];
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.otherArray count] > 0)
    {
        NSArray *visiblePaths = [self.responseTable indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            NSInteger index = indexPath.row;
            
            OtherResponseObj *obj = [self.otherArray objectAtIndex:index];
            
            if (!obj.imgKeyFrame) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:obj forIndexImg:[NSString stringWithFormat:@"%d",index]];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSString *)indexImg
{
    NSInteger row = [indexImg integerValue];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    ImageDownloader *imgDownloader = [imageDownloadsInProgress objectForKey:indexImg];
    if (imgDownloader != nil)
    {
        OtherResponseViewCell *cell = (OtherResponseViewCell*)[self.responseTable cellForRowAtIndexPath:indexPath];
        // Display the newly loaded image
        cell.imgVideo.image = imgDownloader.otherObj.imgKeyFrame;
    }
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
