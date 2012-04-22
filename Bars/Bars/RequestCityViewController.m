//
//  RequestCityViewController.m
//  Bars
//
//  Created by Cuccku on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestCityViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RequestCityViewController(private)
- (void) sendMailByDefaultApp;
- (void) sendMailByMFMailComposer;
- (void) mailShareOpenMail;
@end

@implementation RequestCityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) init {
    self = [super init];
    
    if (self) {
        
        self.title = @"Request City";
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendMailClicked)];        
        self.navigationItem.rightBarButtonItem = rightItem;
        [rightItem release];
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        txvRequest = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 135)];				
        txvRequest.keyboardType = UIKeyboardTypeDefault;
        txvRequest.returnKeyType = UIReturnKeyDefault;
		txvRequest.autocorrectionType = UITextAutocorrectionTypeNo;
		txvRequest.autocapitalizationType = UITextAutocapitalizationTypeNone;
        txvRequest.keyboardAppearance = UIKeyboardAppearanceDefault;
        txvRequest.textAlignment = UITextAlignmentLeft;
        txvRequest.textColor = [UIColor blackColor]; 
        txvRequest.backgroundColor = [UIColor clearColor];
        txvRequest.font = [UIFont systemFontOfSize:15];
        txvRequest.delegate = self;
        
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 200) 
                                                  style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 135;
        _tableView.scrollEnabled = FALSE;
        [self.view addSubview:_tableView];
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ColorPattern.png"]];
    }
    
    return self;
}

- (void) sendMailClicked {
    [self mailShareOpenMail];
}

- (void) sendMailByDefaultApp {
    NSLog(@"send mail");
    NSString *mailTo = @"trinhduchung266@gmail.com";
    NSString *cc = @"";
    NSString *subject = @"I want to request new city";
    NSString *body = txvRequest.text;
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
    NSString *body = txvRequest.text;
    
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
								  initWithTitle:@"AlertTitleMailShare"
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
								  initWithTitle:@"AlertTitleMailShare"
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
								  initWithTitle:@"AlertTitleMailShare"
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
								  initWithTitle:@"AlertTitleMailShare"
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
    /*
    UILabel *lbRequest = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 320, 20)];
    [lbRequest setFont:[UIFont boldSystemFontOfSize:18]];
    lbRequest.text = @"Your request:";
    [self.view addSubview:lbRequest];
    [lbRequest release];
    
    txvRequest = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, 300, 300)];
    txvRequest.layer.borderWidth = 1;
    txvRequest.layer.cornerRadius = 9;
    txvRequest.delegate = self;
    [self.view addSubview:txvRequest];
    
    UIButton *btnSend = [[UIButton alloc] initWithFrame:CGRectMake(200, 350, 100, 30)];
    [btnSend setTitle:@"Send" forState:UIControlStateNormal];
    btnSend.titleLabel.textColor = [UIColor grayColor];
    [btnSend addTarget:self action:@selector(sendRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSend];
    [btnSend release];
    
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(50, 350, 100, 30)];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    btnCancel.titleLabel.textColor = [UIColor grayColor];
    [btnCancel addTarget:self action:@selector(cancelRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCancel];
    [btnCancel release];
     */
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *newString = [textView.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([newString length] != 0){
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

- (void) viewDidAppear:(BOOL)animated {
    [txvRequest resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 58;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
    sectionHeader.backgroundColor = [UIColor clearColor];    
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 55)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.font = [UIFont systemFontOfSize:13];
    lbl.text = @"Send email to request city";
    lbl.textColor = [UIColor whiteColor];
    lbl.numberOfLines = 0;
    [sectionHeader addSubview:lbl];
    [lbl release];    
    
    return [sectionHeader autorelease];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:nil] autorelease];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"";
    [cell.contentView addSubview:txvRequest];
    return cell;
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
    [_tableView release];
    [txvRequest release];
    [super dealloc];
}

#pragma mark - Event methods
- (void)sendRequest
{
    
    [self dismissModalViewControllerAnimated:YES];
}
- (void)cancelRequest
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
