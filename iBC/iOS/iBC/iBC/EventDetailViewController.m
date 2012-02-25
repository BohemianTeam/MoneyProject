//
//  EventDetailViewController.m
//  iBC
//
//  Created by bohemian on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventDetailViewController.h"
#import "EventsObj.h"
#import "EventViewCell.h"
#import "InfoBlockViewCell.h"
#import "ImgDownloaderView.h"
#import "ImageDownloader.h"
#import "Util.h"
@implementation EventDetailViewController
@synthesize eventCode;
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
    // Custom initialization
    eventDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStylePlain];
    eventDetailTable.dataSource = self;
    eventDetailTable.delegate = self;
    eventDetailTable.autoresizesSubviews = YES;
    eventDetailTable.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:eventDetailTable];
    
    //create starred button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 56, 65)];
    [btn setImage:[UIImage imageNamed:@"unstarred"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"starred"] forState:UIControlStateSelected];
    
    UIBarButtonItem *btnStarred = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = btnStarred;
    //get data
    haveData = NO;
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
    [imageDownloadsInProgress release];
    [infoBlockList release];
    [eventDetailTable release];
    [eventCode release];
    [super dealloc];
}
#pragma mark - custom cell
- (CGFloat)heightForDescriptionCell
{
    CGFloat cellHeight = HEIGHT_EVENT_LOGO + 10;
    CGFloat currentHeight = 5;
 
    //count height of lbName
    //set name
    float width = WIDTH_VIEW - WIDTH_EVENT_LOGO - 20;
    CGSize maximumLabelSize = CGSizeMake(width,9999);
    UIFont *lbFont = [UIFont fontWithName:@"Arial" size:16];
    CGSize size = [Util sizeOfText:[eventObj getTitle]
                          withFont:lbFont 
                 constrainedToSize:maximumLabelSize 
                     lineBreakMode:UILineBreakModeWordWrap];
    
    currentHeight += size.height;
    
    lbFont = [UIFont fontWithName:@"Arial" size:14];
    size = [Util sizeOfText:[eventObj getName]
                          withFont:lbFont 
                 constrainedToSize:maximumLabelSize 
                     lineBreakMode:UILineBreakModeWordWrap];
    //update height
    currentHeight += size.height;
    
    width = WIDTH_VIEW/2 - WIDTH_EVENT_LOGO - 20;
    maximumLabelSize = CGSizeMake(width,9999);
    size = [Util sizeOfText:[eventObj getDates]
                   withFont:lbFont 
          constrainedToSize:maximumLabelSize 
              lineBreakMode:UILineBreakModeWordWrap];
    //update height
    currentHeight += size.height + 10;
    
    lbFont = [UIFont fontWithName:@"Arial" size:12];
    size = [Util sizeOfText:[eventObj getGenre]
                   withFont:lbFont 
          constrainedToSize:maximumLabelSize 
              lineBreakMode:UILineBreakModeWordWrap];
    //update height
    currentHeight += size.height;
    
    if(currentHeight > cellHeight)
        return currentHeight;
    
    return cellHeight;
}
- (CGFloat)createDescriptionCell:(UITableViewCell*)cell
{
    //set logo
    NSString *url = [NSString stringWithFormat:@"%@%@", API_IMG_URL, [eventObj getLogoUrl]];
    ImgDownloaderView *logoView = [[ImgDownloaderView alloc] init];
    [self startDownload:url imgView:logoView forIndexPath:[NSIndexPath indexPathWithIndex:-1]];
    [logoView setFrame:CGRectMake(10, 5, WIDTH_EVENT_LOGO, HEIGHT_EVENT_LOGO)];
    [cell addSubview:logoView];
    [logoView release];
    
    //set title
    float nameWidth = WIDTH_VIEW - WIDTH_EVENT_LOGO - 20;
    CGSize maximumLabelSize = CGSizeMake(nameWidth,9999);
    UILabel *lbTitle = [[UILabel alloc] init];
    lbTitle.numberOfLines = 0;
    lbTitle.text = [eventObj getTitle];
    lbTitle.textColor = UIColorFromRGB(0x53a8cc);
    lbTitle.lineBreakMode = UILineBreakModeWordWrap;
    lbTitle.font = [UIFont fontWithName:@"Arial" size:16];
    CGSize size = [Util sizeOfText:lbTitle.text 
                          withFont:lbTitle.font 
                 constrainedToSize:maximumLabelSize 
                     lineBreakMode:lbTitle.lineBreakMode];
    [lbTitle setFrame:CGRectMake(WIDTH_EVENT_LOGO+20, 5, nameWidth, size.height)];
    [cell addSubview:lbTitle];
    [lbTitle release];
    
    //set name
    CGFloat cellHeight = lbTitle.frame.origin.y + lbTitle.frame.size.height;

    UILabel *lbName = [[UILabel alloc] init];
    lbName.numberOfLines = 0;
    lbName.text = [eventObj getName];
    lbName.textColor = UIColorFromRGB(0x666666);
    lbName.lineBreakMode = UILineBreakModeWordWrap;
    lbName.font = [UIFont fontWithName:@"Arial" size:14];
    size = [Util sizeOfText:lbName.text 
                          withFont:lbName.font 
                 constrainedToSize:maximumLabelSize 
                     lineBreakMode:lbName.lineBreakMode];
    [lbName setFrame:CGRectMake(WIDTH_EVENT_LOGO+20, cellHeight, nameWidth, size.height)];
    [cell addSubview:lbName];
    [lbName release];
    
    //set dates
    nameWidth = WIDTH_VIEW/2 - WIDTH_EVENT_LOGO - 20;
    maximumLabelSize = CGSizeMake(nameWidth,9999);
    cellHeight += lbName.frame.size.height;
    
    UILabel *lbDate = [[UILabel alloc] init];
    lbDate.numberOfLines = 0;
    lbDate.text = [eventObj getDates];
    lbDate.textColor = UIColorFromRGB(0x666666);
    lbDate.lineBreakMode = UILineBreakModeWordWrap;
    lbDate.font = [UIFont fontWithName:@"Arial" size:14];
    size = [Util sizeOfText:lbDate.text 
                   withFont:lbDate.font 
          constrainedToSize:maximumLabelSize 
              lineBreakMode:lbDate.lineBreakMode];
    [lbDate setFrame:CGRectMake(WIDTH_EVENT_LOGO+20, cellHeight, nameWidth, size.height)];
    [cell addSubview:lbDate];
    [lbDate release];
    
    //set
    cellHeight += lbDate.frame.size.height + 10;
    UILabel *lbGenre = [[UILabel alloc] init];
    lbGenre.numberOfLines = 0;
    lbGenre.text = [eventObj getGenre];
    lbGenre.textColor = UIColorFromRGB(0x53a8cc);
    lbGenre.lineBreakMode = UILineBreakModeWordWrap;
    lbGenre.font = [UIFont fontWithName:@"Arial" size:12];
    size = [Util sizeOfText:lbGenre.text 
                   withFont:lbGenre.font 
          constrainedToSize:maximumLabelSize 
              lineBreakMode:lbGenre.lineBreakMode];
    [lbGenre setFrame:CGRectMake(WIDTH_EVENT_LOGO+20, cellHeight, nameWidth, size.height)];
    [cell addSubview:lbGenre];
    [lbGenre release];
    
    //set price
    cellHeight += lbGenre.frame.size.height;
    nameWidth = WIDTH_VIEW/2 - 10;
    
    UILabel *lbPrice = [[UILabel alloc] init];
    lbPrice.textAlignment = UITextAlignmentRight;
    lbPrice.text = [eventObj getPrice];
    lbPrice.textColor = UIColorFromRGB(0xCC3366);
    lbPrice.font = [UIFont fontWithName:@"Arial" size:14];
    [lbPrice setFrame:CGRectMake(WIDTH_VIEW/2, lbDate.frame.origin.y, nameWidth, 15)];
    [cell addSubview:lbPrice];
    [lbPrice release];
    
    //set buy button
    UIImage *imgBuy = [UIImage imageNamed:@"buybutton"];
    nameWidth = WIDTH_VIEW - 10 - imgBuy.size.width;
    UIButton *btnBuy = [[UIButton alloc] init];
    [btnBuy setImage:imgBuy forState:UIControlStateNormal];
    [btnBuy setFrame:CGRectMake(nameWidth, lbPrice.frame.origin.y + lbPrice.frame.size.height, imgBuy.size.width, imgBuy.size.height)];
    [cell addSubview:btnBuy];
    
    cellHeight = cellHeight >= btnBuy.frame.size.height ? cellHeight : btnBuy.frame.size.height;

    if(cellHeight > HEIGHT_EVENT_LOGO + 10)
        return cellHeight;
    
    return HEIGHT_EVENT_LOGO + 10;
}
- (CGFloat)heightForVideoCell
{
    CGFloat currentHeight = 5;
    
    //count height
    float width = WIDTH_VIEW - 20;
    CGSize maximumLabelSize = CGSizeMake(width,9999);
    UIFont *lbFont = [UIFont fontWithName:@"Arial" size:12];
    
    CGSize size = [Util sizeOfText:[NSString stringWithFormat:@"Durada: 1 h i 20 minuts aprox. (sense entreacte)"]
                          withFont:lbFont 
                 constrainedToSize:maximumLabelSize 
                     lineBreakMode:UILineBreakModeWordWrap];
    
    currentHeight += size.height + HEIGHT_IMG_VIDEO + 5;
    
    return currentHeight;
}
- (void)createVideoCell:(UITableViewCell*)cell
{
    NSArray *imgs = [eventObj getImgs];
    CGFloat xPos = 5;
    CGFloat height = 50;
    CGSize maximumLabelSize = CGSizeMake(WIDTH_VIEW - 20,9999);
    
    UILabel *lbDuration = [[UILabel alloc] init];
    lbDuration.numberOfLines = 0;
    lbDuration.text = [NSString stringWithFormat:@"Durada: 1 h i 20 minuts aprox. (sense entreacte)"];
    lbDuration.textColor = UIColorFromRGB(0x666666);
    lbDuration.lineBreakMode = UILineBreakModeWordWrap;
    lbDuration.font = [UIFont fontWithName:@"Arial" size:12];
    CGSize size = [Util sizeOfText:lbDuration.text 
                          withFont:lbDuration.font 
                 constrainedToSize:maximumLabelSize 
                     lineBreakMode:lbDuration.lineBreakMode];
    [lbDuration setFrame:CGRectMake(10, 5, WIDTH_VIEW-20, size.height)];
    [cell addSubview:lbDuration];
    [lbDuration release];
    
    height = lbDuration.frame.origin.y + size.height;
    //add imgs
    
    if(imgs != nil)
    {
        UIScrollView *cellScroll = [[UIScrollView alloc] init];
        [cell addSubview:cellScroll];
        int index = 0;
        for(NSDictionary *imgInfo in imgs){
            NSString *url = [NSString stringWithFormat:@"%@%@", API_IMG_URL, [imgInfo objectForKey:@"t"]];

            ImgDownloaderView *imgView = [[ImgDownloaderView alloc] init];
            imgView.backgroundColor = [UIColor redColor];
            [imgView setFrame:CGRectMake(xPos, 0, WIDTH_IMG_VIDEO, HEIGHT_IMG_VIDEO)];
            xPos += WIDTH_IMG_VIDEO + 5;
            
            [cellScroll addSubview:imgView];
            [self startDownload:url imgView:imgView forIndexPath:[NSIndexPath indexPathWithIndex:index]];
            [imgView release];
            
            index++;
        }
        
        [cellScroll setFrame:CGRectMake(0, height, 320, HEIGHT_IMG_VIDEO)];
        cellScroll.contentSize = CGSizeMake(xPos, HEIGHT_IMG_VIDEO);
        [cellScroll release];
    }
    
}
- (CGFloat)createSynoCell:(UITableViewCell*)cell
{
    CGSize maximumLabelSize = CGSizeMake(WIDTH_VIEW - 20,9999);
    //add
    
    UILabel *lbSyno = [[UILabel alloc] init];
    lbSyno.numberOfLines = 0;
    lbSyno.text = [eventObj getSynopsis];
    lbSyno.textColor = UIColorFromRGB(0x666666);
    lbSyno.lineBreakMode = UILineBreakModeWordWrap;
    lbSyno.font = [UIFont fontWithName:@"Arial" size:12];
    CGSize size = [Util sizeOfText:lbSyno.text 
                   withFont:lbSyno.font 
          constrainedToSize:maximumLabelSize 
              lineBreakMode:lbSyno.lineBreakMode];
    [lbSyno setFrame:CGRectMake(10, 5, WIDTH_VIEW-20, size.height)];
    
    
    
    //UIWebView *webSyno = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW, size.height)];
    UIWebView *webSyno = [[UIWebView alloc] init];
    [webSyno sizeThatFits:CGSizeZero];
    [webSyno loadHTMLString:lbSyno.text baseURL:[NSURL URLWithString:@""]];
    CGSize webSize = webSyno.scrollView.contentSize;
    [webSyno setFrame:CGRectMake(0, 0, WIDTH_VIEW, webSize.height)];
    
    [cell addSubview:webSyno];
    //[cell addSubview:lbSyno];
    [lbSyno release];
    [webSyno release];
    return size.height + 10;
}

#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(haveData == NO)
        return 0;
    
    if(infoBlockList != nil)
        return 3 + [infoBlockList count];
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"height");

    CGFloat height = 0;
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    switch (indexPath.row) {
        case 0:
            height = [self heightForDescriptionCell];
            break;
        case 1:
            height = [self createSynoCell:cell];
            break;  
        case 2:
            height = [self heightForVideoCell];
            break;
        default:
            height = 50;
            break;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell have data");
    static NSString *EventsCell = @"rrr";
    static NSString *DesCell = @"DesCell";
    static NSString *SynoCell = @"SynoCell";
    static NSString *VideoCell = @"VideoCell";
    if(indexPath.row == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DesCell];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DesCell] autorelease];
            
            [self createDescriptionCell:cell];
        }
        
        return cell;
    }
    if(indexPath.row == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SynoCell];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SynoCell] autorelease];
            
            [self createSynoCell:cell];
        }
        
        return cell;
    }
    if(indexPath.row == 2)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoCell];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VideoCell] autorelease];
            
            [self createVideoCell:cell];
        }
        
        return cell;
    }else{
        InfoBlockViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EventsCell];
        if (cell == nil) {
            cell = [[[InfoBlockViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EventsCell] autorelease];
        }
        int rowIdx = indexPath.row-3;
        BOOL even = rowIdx%2 == 0 ? TRUE : NO;
        NSDictionary *infoDict = [infoBlockList objectAtIndex:rowIdx];
        [cell setTitle:[infoDict objectForKey:@"t"] evenRow:even];
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark - servide delegate 
- (void)getDataFromServer
{
    //show loading
    [Util showLoading:self.view];
    Service *srv = [[Service alloc] init];
    srv.delegate = self;
    srv.canShowAlert = YES;
    srv.canShowLoading = YES;
    
    //
    [srv getEventDetail:eventCode];
    [srv release];
}

- (void) mServiceGetEventDetailSucces:(Service *) service responses:(id) response {
    NSLog(@"API mServiceGetEventDetailSucces : success");
    
    eventObj = [[EventsObj alloc] initWithDataResponse:response];
    infoBlockList = [[NSMutableArray alloc] initWithArray:[eventObj getInfoBlocks]];
    haveData = TRUE;
    [eventDetailTable reloadData];
    [Util hideLoading];
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
    NSLog(@"appImageDidLoad:");
    
    [imageDownloadsInProgress removeObjectForKey:indexPath];
    
}
@end