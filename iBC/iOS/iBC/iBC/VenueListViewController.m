//
//  VenueListViewController.m
//  iBC
//
//  Created by bohemian on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VenueListViewController.h"
#import "Util.h"
#import "Service.h"
#import "VenuesObj.h"
#import "CJSONDeserializer.h"
#import "VenueViewCell.h"
@implementation VenueListViewController
@synthesize imageDownloadsInProgress;

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
        venueTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain];
        venueTable.dataSource = self;
        venueTable.delegate = self;
        venueTable.autoresizesSubviews = YES;
        venueTable.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self.view addSubview:venueTable];
        
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)dealloc
{
    [venueTable release];
    [venuesList release];
    [imageDownloadsInProgress release];
    [super dealloc];
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
    
    //test
    [srv getVenueList:@"41.385756~2.164129"];
}
#pragma mark - tableview delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [venuesList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return VENUE_CELL_HEIGHT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(haveData == NO)
        return nil;
    
    static NSString *VenuesCell = @"VenuesCell";
    VenueViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VenuesCell];
    if (cell == nil) {
        cell = [[[VenueViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VenuesCell] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    VenuesObj *obj = [venuesList objectAtIndex:indexPath.row];
    [cell setupData:obj];
    if(!obj.imgLogo){
        if (venueTable.dragging == NO && venueTable.decelerating == NO)
        {
            [self startIconDownload:obj forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        cell.imgViewLogo.image = [UIImage imageNamed:@"venueTest.jpg"];
    }else{
        cell.imgViewLogo.image = obj.imgLogo;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - servide delegate
- (void) mServiceGetStarredSucces:(Service *) service responses:(id) response {
    NSLog(@"API mServiceGetInstIDSucces : success");
    
    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
    NSArray *resArray = [jsonDeserializer deserializeAsArray:(NSData*)response error:nil];
    for (NSDictionary *dict in resArray) {
        VenuesObj *obj = [[VenuesObj alloc] iniWithDictionary:dict];
        [venuesList addObject:obj];
        
        [obj release];
    }
    
    //end loading
    [Util hideLoading];
    haveData = YES;
    [venueTable reloadData];
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
    if ([venuesList count] > 0)
    {
        NSLog(@"loadImagesForOnscreenRows");
        NSArray *visiblePaths = [venueTable indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            VenuesObj *venueObj = [venuesList objectAtIndex:indexPath.row];
            if(!venueObj.imgLogo)
                [self startIconDownload:venueObj forIndexPath:indexPath];
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
        VenueViewCell *cell = (VenueViewCell*)[venueTable cellForRowAtIndexPath:indexPath];
        cell.imgViewLogo.image = ((VenuesObj*)[venuesList objectAtIndex:indexPath.row]).imgLogo;
    }
    
    [venueTable reloadData];
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
