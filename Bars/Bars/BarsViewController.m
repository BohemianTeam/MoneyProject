//
//  BarsViewController.m
//  Bars
//
//  Created by bohemian on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BarsViewController.h"
#import "AppDatabase.h"
#import "CityObj.h"
#import "Bar.h"
#import "CityViewCell.h"
#import "BarDetailViewController.h"
#import "RequestCityViewController.h"

#define HEIGHT_CELL 50

@interface BarsViewController (private)
- (void)loadDataFromDatabase;
- (void) sendMailByDefaultApp;
- (void) sendMailByMFMailComposer;
- (void) mailShareOpenMail;
@end
@implementation BarsViewController
@synthesize dataType;
@synthesize dataID;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    NSLog(@"Bars view - %@ - didReceiveMemoryWarning", self.title);
}
- (id) initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.title = [title retain];

        // Custom initialization
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStylePlain];
        table.dataSource = self;
        table.delegate = self;
        table.autoresizesSubviews = YES;
        table.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        [self.view addSubview:table];
        
        
        //[self loadDataFromDatabase];
        
    }
    return self;
}
- (void)sendEmail
{
    NSLog(@"request...");
    [self mailShareOpenMail];
    /*
    RequestCityViewController *requestVC = [[RequestCityViewController alloc] init];
    //[self presentModalViewController:requestVC animated:YES];
    [self.navigationController pushViewController:requestVC animated:YES];
    [requestVC release];
     */

}

- (void) sendMailByDefaultApp {
    NSLog(@"send mail");
    NSString *mailTo = @"trinhduchung266@gmail.com";
    NSString *cc = @"";
    NSString *subject = @"I want to request new city";
    NSString *body = @"";
    NSString *email = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@",
					   mailTo,cc,subject,body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (void) sendMailByMFMailComposer {
    NSLog(@"send mail");
    NSString *mailTo = @"trinhduchung266@gmail.com";
    NSString *cc = @"";
    NSString *subject = @"I want to request new city";
    NSString *body = @"";
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:subject];
    
    // Set up recipients
    NSArray *toRecipients = [[NSArray alloc] initWithObjects:mailTo, nil];
    [picker setToRecipients:toRecipients];
    [toRecipients release];
    if ([cc isEqualToString:@""] == NO) {
		NSArray *ccRecipients = [NSArray arrayWithObject:cc];
		[picker setCcRecipients:ccRecipients];
    }
    
    [picker setMessageBody:body isHTML:NO];
    CGRect fram = CGRectMake(0, -20, 320, 480);
    [picker.view setFrame:fram];
    
    [self presentModalViewController:picker animated:YES];
    
    [picker release];
    
}


//MFMailComposeDelegate
// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    NSLog(@"===didFinishWithResult=");
    NSString *_msg;
    switch (result) {
		case MFMailComposeResultCancelled:
			//_msg = @"MailShareCanceled";
			break;
		case MFMailComposeResultSaved:
		{
			_msg = @"MailShareSaved";
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"Bars"
								  message:_msg
								  delegate:self
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
			break;
		case MFMailComposeResultSent:
		{
			_msg = @"MailShareSent";
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"Bars"
								  message:_msg
								  delegate:self
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
			break;
		case MFMailComposeResultFailed:
		{
			_msg = @"Failed";
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"Bars"
								  message:_msg
								  delegate:self
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
			break;
		default:
		{
			_msg = @"MailShareFailed";
			UIAlertView *alert = [[UIAlertView alloc]
								  initWithTitle:@"Bars"
								  message:_msg
								  delegate:self
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil];
            [alert show];
            [alert release];
		}
			break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void) mailShareOpenMail {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil) {
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail]) {
			NSLog(@"===1=");
			//_body = @"I love this song";
			[self sendMailByMFMailComposer];
		}
		else {
			NSLog(@"===2=");
			[self sendMailByDefaultApp];
		}
    }
    else {
		NSLog(@"===3=");
		[self sendMailByDefaultApp];
    }
    
}

- (id) initWithID:(NSInteger)dataId type:(DataSourceType)type{
    NSLog(@"init");
    self = [super init];
    if (self) {
        dataID = dataId;
        dataType = type;
        
        // Custom initialization
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStylePlain];
        table.dataSource = self;
        table.delegate = self;
        table.autoresizesSubviews = YES;
        table.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        
        UIImageView *bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.jpg"]];
        bg.frame = table.frame;
        UIView *v = [[UIView alloc] initWithFrame:table.frame];
        v.backgroundColor = [UIColor clearColor];
        [v addSubview:bg];
        [bg release];
        
        table.backgroundView = v;
        [v release];
        
        [self.view addSubview:table];
     
        UIBarButtonItem *btnRequest = [[UIBarButtonItem alloc] initWithTitle:@"Request" 
                                                                       style:UIBarButtonItemStyleBordered 
                                                                      target:self 
                                                                      action:@selector(sendEmail)];
        self.navigationItem.rightBarButtonItem = btnRequest;
        [btnRequest release];
        //[self loadDataFromDatabase];
    }
    return self;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSLog(@"view did load");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Bars view - %@ - viewWillAppear", self.title);
    [super viewWillAppear:animated];
    [self loadDataFromDatabase];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (void)dealloc
{
    if(datas != nil)
        [datas release];
    [table release];
    [super dealloc];
}
#pragma mark - Class methods
- (void)loadDataFromDatabase
{
    if(datas != nil)
    {
        [datas release];
        datas = nil;
    }
    switch (dataType) {
        case States:
            datas = nil;
            sumRow = [[AppDatabase sharedDatabase] lookingSumStates];
            break;
        case Citys:
            datas = [[NSArray alloc] initWithArray:[[AppDatabase sharedDatabase] lookingCitysByStateID:dataID]];
            sumRow = [datas count];
            break;
        case Bars:
            datas = [[NSArray alloc] initWithArray:[[AppDatabase sharedDatabase] lookingBarsByCityID:dataID]];
            sumRow = [datas count];
            break;
        case Wishlists:
            datas = [[NSArray alloc] initWithArray:[[AppDatabase sharedDatabase] lookingCitysByWish]];
            sumRow = [datas count];
            break;
        case Completeds:
            datas = [[NSArray alloc] initWithArray:[[AppDatabase sharedDatabase] lookingCitysByCompleted]];
            sumRow = [datas count];
            break;
        default:
            datas = nil;
            sumRow = 0;
            break;
    }
    
    [table reloadData];
//    if(datas == nil)
//    {
//        switch (dataType) {
//            case States:
//                datas = nil;
//                sumRow = [[AppDatabase sharedDatabase] lookingSumStates];
//                break;
//            case Citys:
//                datas = [[NSArray alloc] initWithArray:[[AppDatabase sharedDatabase] lookingCitysByStateID:dataID]];
//                sumRow = [datas count];
//                break;
//            case Bars:
//                datas = [[NSArray alloc] initWithArray:[[AppDatabase sharedDatabase] lookingBarsByCityID:dataID]];
//                sumRow = [datas count];
//                break;
//            case Wishlists:
//                datas = [[NSArray alloc] initWithArray:[[AppDatabase sharedDatabase] lookingCitysByWish]];
//                sumRow = [datas count];
//                break;
//            case Completeds:
//                datas = [[NSArray alloc] initWithArray:[[AppDatabase sharedDatabase] lookingCitysByCompleted]];
//                sumRow = [datas count];
//                break;
//            default:
//                datas = nil;
//                sumRow = 0;
//                break;
//        }
//        
//        [table reloadData];
//    }
    
}
#pragma mark - tableview delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sumRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HEIGHT_CELL;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cell = @"Cell";
    

    if(dataType == Citys)
    {
        CityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
        if (cell == nil) {
            cell = [[[CityViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIImageView * accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WhiteAccessory.png"]];
            accessoryView.frame = CGRectMake(0, 0, 9, 15);
            cell.accessoryView = accessoryView;
            [accessoryView release];
        }
        
        NSInteger cityID = [(NSNumber*)[datas objectAtIndex:indexPath.row] intValue];
        
        CityObj * cityObj = [[AppDatabase sharedDatabase] lookingCityByCityID:cityID];
        [cell setData:cityObj];
        
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIImageView * accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WhiteAccessory.png"]];
            accessoryView.frame = CGRectMake(0, 0, 9, 15);
            cell.accessoryView = accessoryView;
            [accessoryView release];
        }
        
        NSInteger stID = indexPath.row + 1;
        
        if(dataType == States)
        {
            cell.textLabel.text = [[AppDatabase sharedDatabase] lookingStateByStateID:stID];
        }
        if(dataType == Bars)
        {
            stID = indexPath.row;
            Bar *barObj = [[AppDatabase sharedDatabase] lookingBarByBarID:[[datas objectAtIndex:stID] intValue]];
            cell.textLabel.text = barObj.barName;
        }
        if(dataType == Wishlists || dataType == Completeds)
        {
            stID = indexPath.row;
            CityObj * cityObj = [[AppDatabase sharedDatabase] lookingCityByCityID:[[datas objectAtIndex:stID] intValue]];
            cell.textLabel.text = cityObj.cityName;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textAlignment = UITextAlignmentCenter;
        }
        
        cell.textLabel.textColor = [UIColor whiteColor];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BarsViewController *newVC = nil;
    switch (dataType) {
        case States:
            NSLog(@"Selected State");
            NSInteger stateID = indexPath.row + 1;
            newVC = [[BarsViewController alloc] initWithID:stateID type:Citys];
            newVC.title = [[AppDatabase sharedDatabase] lookingStateByStateID:stateID];
            
            [self.navigationController pushViewController:newVC animated:YES];
            break;
            
        case Wishlists:
        case Completeds:
        case Citys:
            NSLog(@"Selected City");
            NSInteger cityID = [[datas objectAtIndex:indexPath.row] intValue];
            newVC = [[BarsViewController alloc] initWithID:cityID type:Bars];
            CityObj * cityObj = [[AppDatabase sharedDatabase] lookingCityByCityID:cityID];
            newVC.title = cityObj.cityName;
            
            [self.navigationController pushViewController:newVC animated:YES];
            break;
            
        case Bars:
            NSLog(@"Selected Bar");
            NSInteger barID = [[datas objectAtIndex:indexPath.row] intValue];
            
            Bar *bar = [[AppDatabase sharedDatabase] lookingBarByBarID:barID];
            BarDetailViewController *barDetailVC = [[BarDetailViewController alloc] initWithBar:bar];           
            barDetailVC.title = bar.barName;
            
            [self.navigationController pushViewController:barDetailVC animated:YES];
            [barDetailVC release];
            return;
        default:
            break;
    }
    
    [newVC release];
}


@end
