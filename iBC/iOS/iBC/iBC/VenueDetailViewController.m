//
//  VenueDetailViewController.m
//  iBC
//
//  Created by bohemian on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VenueDetailViewController.h"
#import "VenuesObj.h"
#import "ImgDownloaderView.h"
#import "Util.h"
#import "MapViewController.h"
#import "CJSONDeserializer.h"

#define ROW_VENUE_DETAIL 4
#define WIDTH_ADDRESS_VENUE 130
@implementation VenueDetailViewController
@synthesize venueCode;
@synthesize imageDownloadsInProgress;

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
    imageDownloadsInProgress = [[NSMutableDictionary alloc] init];
    
    isGoDetailPage = NO;
    //check is starred
    isStarred = [Util isStarred:venueCode];
    NSLog(@"isStarred: %d", isStarred);
    
    // Custom initialization
    venueDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain];
    venueDetailTable.dataSource = self;
    venueDetailTable.delegate = self;
    venueDetailTable.autoresizesSubviews = YES;
    venueDetailTable.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:venueDetailTable];
    
    //create starred button
    btnStarred = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnStarred setFrame:CGRectMake(0, 0, 56, 65)];
    [btnStarred setImage:[UIImage imageNamed:@"unstarred"] forState:UIControlStateNormal];
    [btnStarred setImage:[UIImage imageNamed:@"starred"] forState:UIControlStateSelected];
    [btnStarred addTarget:self action:@selector(btnStarredPressed) forControlEvents:UIControlEventTouchUpInside];
    [btnStarred setSelected:isStarred];
    [btnStarred setEnabled:NO];
    
    UIBarButtonItem *btnBarStarred = [[UIBarButtonItem alloc] initWithCustomView:btnStarred];
    self.navigationItem.rightBarButtonItem = btnBarStarred;
    
    //init service
    service = [[Service alloc] init];
    service.delegate = self;
    service.canShowAlert = YES;
    service.canShowLoading = YES;
    
    //get data
    haveData = NO;
    [self getDataFromServer];

    [btnBarStarred release];
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
    [service stop];
    [service release];
    [imageDownloadsInProgress release];
    [venueRoomList release];
    [venueDetailTable release];
    [venueCode release];
    [super dealloc];
}
#pragma mark - Event methods
- (void)btnStarredPressed
{
    NSLog(@"starred pressed: %d", isStarred);
    
    NSString *stt = (isStarred == YES)?OFF:ON;
    [self setStarredStatus:stt];
}

#pragma mark - custom cell
- (CGFloat)heightForDescriptionCell
{
    CGFloat cellHeight = HEIGHT_VENUE_LOGO + 10;
    CGFloat currentHeight = 5;
 
    //count height of lbName
    //set name
    float nameWidth = WIDTH_VIEW - WIDTH_VENUE_LOGO - 20;
    CGSize maximumLabelSize = CGSizeMake(nameWidth,9999);
    UIFont *lbNameFont = [UIFont fontWithName:@"Arial" size:16];

    CGSize size = [Util sizeOfText:[venueObj getName]
                          withFont:lbNameFont 
                 constrainedToSize:maximumLabelSize 
                     lineBreakMode:UILineBreakModeWordWrap];
    
    currentHeight += size.height;
    
    lbNameFont = [UIFont fontWithName:@"Arial" size:12];
    
    size = [Util sizeOfText:[venueObj getDescription]
                          withFont:lbNameFont 
                 constrainedToSize:maximumLabelSize 
                     lineBreakMode:UILineBreakModeWordWrap];
    
    currentHeight += size.height;
    
    if(currentHeight > cellHeight)
        return currentHeight + 10;
    
    return cellHeight;
}
- (CGFloat)createDescriptionCell:(UITableViewCell*)cell
{
    //set logo
    NSURL *logoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_IMG_URL, [venueObj getLogoUrl]]];
    UIImage *logoImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:logoUrl]];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:logoImg];
    [logoView setFrame:CGRectMake(5, 5, WIDTH_VENUE_LOGO, HEIGHT_VENUE_LOGO)];
    [cell addSubview:logoView];
    [logoView release];
    
    //set name
    float nameWidth = WIDTH_VIEW - WIDTH_VENUE_LOGO - 20;
    CGSize maximumLabelSize = CGSizeMake(nameWidth,9999);
    UILabel *lbName = [[UILabel alloc] init];
    lbName.numberOfLines = 0;
    lbName.text = [venueObj getName];
    lbName.textColor = UIColorFromRGB(0x53a8cc);
    lbName.lineBreakMode = UILineBreakModeWordWrap;
    lbName.font = [UIFont fontWithName:@"Arial" size:16];
    CGSize size = [Util sizeOfText:lbName.text 
                          withFont:lbName.font 
                 constrainedToSize:maximumLabelSize 
                     lineBreakMode:lbName.lineBreakMode];
    [lbName setFrame:CGRectMake(WIDTH_VENUE_LOGO+20, 5, nameWidth, size.height)];
    [cell addSubview:lbName];
    [lbName release];
    
    //set description
    CGFloat cellHeight = size.height + 5;
    
    UILabel *lbDes = [[UILabel alloc] init];
    lbDes.numberOfLines = 0;
    lbDes.text = [venueObj getDescription];
    lbDes.textColor = UIColorFromRGB(0x53a8cc);
    lbDes.lineBreakMode = UILineBreakModeWordWrap;
    lbDes.font = [UIFont fontWithName:@"Arial" size:12];
    size = [Util sizeOfText:lbDes.text 
                   withFont:lbDes.font 
          constrainedToSize:maximumLabelSize 
              lineBreakMode:lbDes.lineBreakMode];
    [lbDes setFrame:CGRectMake(WIDTH_VENUE_LOGO+20, cellHeight, nameWidth, size.height)];
    [cell addSubview:lbDes];
    [lbDes release];
    
    
    cellHeight += size.height;
    
    if(cellHeight > HEIGHT_VENUE_LOGO + 10)
        return cellHeight + 10;
    
    return HEIGHT_VENUE_LOGO + 10;
}
- (CGFloat)createAddressCell:(UITableViewCell*)cell
{
    UIView *bgColor = [[UIView alloc] init];
    bgColor.backgroundColor = UIColorFromRGB(0x53a8cc);
    [cell addSubview:bgColor];
    

    //set address
    CGSize maximumLabelSize = CGSizeMake(WIDTH_ADDRESS_VENUE,9999);
    UILabel *lbAddress = [[UILabel alloc] init];
    lbAddress.backgroundColor = [UIColor clearColor];
    lbAddress.numberOfLines = 0;
    lbAddress.textAlignment = UITextAlignmentLeft;
    lbAddress.text = [venueObj getAddress];//@"C/ Villarroel, 87\n08011 Barcelona";//
    NSLog(@"---==: %@", [venueObj getAddress]);
    lbAddress.textColor = [UIColor whiteColor];
    lbAddress.lineBreakMode = UILineBreakModeWordWrap;
    lbAddress.font = [UIFont fontWithName:@"Arial" size:14];
    CGSize size = [Util sizeOfText:lbAddress.text 
                          withFont:lbAddress.font 
                 constrainedToSize:maximumLabelSize 
                     lineBreakMode:lbAddress.lineBreakMode];
    [lbAddress setFrame:CGRectMake((WIDTH_ADDRESS_VENUE - size.width)/2, 5, WIDTH_ADDRESS_VENUE, size.height)];
    [cell addSubview:lbAddress];
    [lbAddress release];
    
    //set map button
    CGFloat heightCell = size.height + 5;
    UIButton *btnMapView = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnMapImg = [UIImage imageNamed:@"venue_mapa"];
    [btnMapView setImage:btnMapImg forState:UIControlStateNormal];    
    [btnMapView setFrame:CGRectMake((WIDTH_ADDRESS_VENUE - btnMapImg.size.width)/2, heightCell, btnMapImg.size.width, btnMapImg.size.height)];
    [cell addSubview:btnMapView];
    
    heightCell += btnMapView.frame.size.height + 5;
    
    CGFloat width = WIDTH_VIEW - WIDTH_ADDRESS_VENUE - 10;
    //set lb phone number
    UILabel *lbPhone = [[UILabel alloc] init];
    lbPhone.backgroundColor = [UIColor clearColor];
    lbPhone.text = [NSString stringWithFormat:@"Tel: %@", [venueObj getPhone]];
    lbPhone.textColor = [UIColor whiteColor];
    lbPhone.font = [UIFont fontWithName:@"Arial" size:14];
    [lbPhone setFrame:CGRectMake(WIDTH_VIEW - width, 5,width, 15)];
    [cell addSubview:lbPhone];
    [lbPhone release];
    
    //set lb email
    UILabel *lbEmail = [[UILabel alloc] init];
    lbEmail.backgroundColor = [UIColor clearColor];
    lbEmail.text = [venueObj getEmail];
    lbEmail.textColor = [UIColor whiteColor];
    lbEmail.font = [UIFont fontWithName:@"Arial" size:14];
    [lbEmail setFrame:CGRectMake(WIDTH_VIEW - width, 20,width, 15)];
    [cell addSubview:lbEmail];
    [lbEmail release];
    
    //set lb web
    UILabel *lbWeb = [[UILabel alloc] init];
    lbWeb.backgroundColor = [UIColor clearColor];
    lbWeb.text = [venueObj getWeb];
    lbWeb.textColor = [UIColor whiteColor];
    lbWeb.font = [UIFont fontWithName:@"Arial" size:14];
    [lbWeb setFrame:CGRectMake(WIDTH_VIEW - width, 35,width, 15)];
    [cell addSubview:lbWeb];
    [lbWeb release];
    
    //set divider
    UILabel *divider = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_ADDRESS_VENUE, 0, 1, heightCell)];
    [cell addSubview:divider];
    [divider release];
    
    //set background color
    [bgColor setFrame:CGRectMake(0, 0, 320, heightCell)];
    [bgColor release];
    return heightCell;
    
}

- (CGFloat)getHeightForVideoCell
{
    return HEIGHT_IMG_VIDEO + 5;
}
- (void)createVideoCell:(UITableViewCell*)cell
{
    NSArray *imgs = [venueObj getImgs];
    CGFloat xPos = 5;

    if(imgs != nil)
    {
        UIScrollView *cellScroll = [[UIScrollView alloc] initWithFrame:cell.frame];
        [cell addSubview:cellScroll];
        int index = 0;
        for(NSDictionary *imgInfo in imgs){
            NSString *urlStr = [NSString stringWithFormat:@"%@%@", API_IMG_URL, [imgInfo objectForKey:@"t"]];
            ImgDownloaderView *imgView = [[ImgDownloaderView alloc] init];
            imgView.backgroundColor = [UIColor redColor];
            [imgView setFrame:CGRectMake(xPos, 5, WIDTH_IMG_VIDEO, HEIGHT_IMG_VIDEO)];
            xPos += WIDTH_IMG_VIDEO + 5;
            
            [cellScroll addSubview:imgView];
            [self startDownload:urlStr imgView:imgView forIndexPath:[NSIndexPath indexPathWithIndex:index]];
            [imgView release];
            
            index++;
        }
        cellScroll.contentSize = CGSizeMake(xPos, cell.frame.size.height);
        [cellScroll release];
    }
}
- (CGFloat)createInfoCell:(UITableViewCell*)cell
{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //background
    UIView *bgColor = [[UIView alloc] init];
    bgColor.backgroundColor = UIColorFromRGB(0xc4e1ee);
    [cell addSubview:bgColor];  
    [bgColor setFrame:CGRectMake(0, 0, 320, 40)];
    [bgColor release];
    
    //add
    UILabel *lb = [[UILabel alloc] init];
    lb.text = @"XARXES SOCIALS";
    lb.backgroundColor = [UIColor clearColor];
    lb.textColor = UIColorFromRGB(0x266a86);
    lb.font = [UIFont boldSystemFontOfSize:16];
    [lb setFrame:CGRectMake(5, 0, 300, 40)];
    [cell addSubview:lb];
    [lb release];
    return 50;
}
#pragma mark - tableview delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(haveData == NO)
        return 0;
    if(section == 1)
        return 5;//[venueRoomList count];
    
    return ROW_VENUE_DETAIL;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"height");
    if(haveData == NO)
        return 0;
    if(indexPath.section == 0 && indexPath.row == 0){
        return [self heightForDescriptionCell];
    }
    if(indexPath.section == 0 && indexPath.row == 1){
        static NSString *AddrCell = @"AddCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddrCell];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddrCell] autorelease];
        }
        return [self createAddressCell:cell];
    }
    if(indexPath.section == 0 && indexPath.row == 2){
        return [self getHeightForVideoCell];
    }
    if(indexPath.section == 0 && indexPath.row == 3){
        static NSString *InfoCell = @"InfoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InfoCell];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InfoCell] autorelease];
        }
        return [self createInfoCell:cell];
    }
    return EVENT_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
        return SECTION_HEIGHT;
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImage *headerImg = nil;
    if(section == 1){
        headerImg = [UIImage imageNamed:@"EventsTitle"];
        
        UIImageView *headerView = [[[UIImageView alloc] initWithImage:headerImg] autorelease];
        [headerView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, headerImg.size.height)];
        
        return headerView;
    }
    
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell have data");
    static NSString *EventsCell = @"EventsCell";
    static NSString *DesCell = @"DesCell";
    static NSString *AddrCell = @"AddCell";
    static NSString *VideoCell = @"VideoCell";
    static NSString *InfoCell = @"InfoCell";
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DesCell];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DesCell] autorelease];
            
            NSLog(@"%f",[self createDescriptionCell:cell]);
        }

        return cell;
    }
    if(indexPath.section == 0 && indexPath.row == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddrCell];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddrCell] autorelease];
            
            [self createAddressCell:cell];
        }

        return cell;
    }
    if(indexPath.section == 0 && indexPath.row == 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoCell];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VideoCell] autorelease];
            
            [self createVideoCell:cell];
        }
        
        return cell;
    }
    if(indexPath.section == 0 && indexPath.row == 3)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InfoCell];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InfoCell] autorelease];
            
            [self createInfoCell:cell];
        }
        
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventsCell];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventsCell] autorelease];
        }
        
        cell.textLabel.text = @"event";
        return cell;
    }
        
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    isGoDetailPage = YES;
    if(indexPath.section == 0 && indexPath.row == 1)
    {
        MapViewController *mapView = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
        mapView.title = [venueObj getName];
        mapView.locaStr = [venueObj getCoordinates];
        
        [self.navigationController pushViewController:mapView animated:YES];
        [mapView.btnEmail setTitle:[venueObj getEmail] forState:UIControlStateNormal];
        [mapView.btnPhoneNumber setTitle:[venueObj getPhone] forState:UIControlStateNormal];
        [mapView release];
    }
}
#pragma mark - Service methods
- (void)getDataFromServer
{
    //show loading
    [Util showLoading:self.view];

    [service getVenueDetail:venueCode];
}

- (void)setStarredStatus:(NSString*)status
{
    //show loading
    [Util showLoading:self.view];

    [service setStarred:venueCode status:status];

}

#pragma mark - servide delegate 
- (void) mServiceSetStarredSucces:(Service *) service responses:(id) response {
    NSLog(@"API mServiceSetStarredSucces : success");
    
    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
    NSDictionary *resultDict = (NSDictionary*)[jsonDeserializer deserializeAsDictionary:(NSData*)response error:nil];
    NSString *result = [[resultDict objectForKey:ResultRes] lowercaseString];
    
    if([result isEqual:OK]){
        if(isStarred){
            //remove starred
            [Util updateStarredList:venueCode status:0];
            [btnStarred setSelected:NO];
            
        }else{
            //add starred
            [Util updateStarredList:venueCode status:1];
            [btnStarred setSelected:YES];
        }
        
        isStarred = !isStarred;

    }
    
    [Util hideLoading];
}
- (void) mServiceGetVenueDetailSucces:(Service *) service responses:(id) response {
    NSLog(@"API mServiceGetVenueDetailSucces : success");
    
    venueObj = [[VenuesObj alloc] initWithDataResponse:response];
    
    haveData = TRUE;
    [venueDetailTable reloadData];
    [Util hideLoading];
    [btnStarred setEnabled:YES];
}

- (void) mService:(Service *) service didFailWithError:(NSError *) error {
    
}
#pragma mark - ImageDownloader
- (void)startDownload:(NSString*)imgUrl imgView:(ImgDownloaderView*)imgView forIndexPath:(NSIndexPath*)indexPath
{
    ImageDownloader *imgDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imgDownloader == nil) 
    {
        imgDownloader = [[ImageDownloader alloc] init];
        imgDownloader.delegate = self;
        imgDownloader.setImgDelegate = imgView;
        imgDownloader.indexPath = indexPath;
        [imageDownloadsInProgress setObject:imgDownloader forKey:indexPath];
        

        [imgDownloader startDownloadWithUrl:imgUrl];
        [imgDownloader release];
    }
}
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    NSLog(@"appImageDidLoad");

    [imageDownloadsInProgress removeObjectForKey:indexPath];

}
@end
