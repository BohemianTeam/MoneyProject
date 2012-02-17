//
//  SaveFilesViewController.m
//  iBack
//
//  Created by bohemian on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import "SaveFilesViewController.h"
#import "FileViewCell.h"
#import "PlayerViewController.h"
#import "FileHelper.h"
#import "AppConstant.h"
#import "iBackAppDelegate.h"
#import "AlertManager.h"
#import "iBackSettings.h"
#import "Utils.h"
#import "GDataServiceGoogleYouTube.h"
#import "GDataEntryYouTubeUpload.h"
#import "KeychainItemWrapper.h"


@implementation SaveFilesViewController
@synthesize movFiles;
@synthesize filesTable;
@synthesize isEditTable;
@synthesize needDeleteFiles;
@synthesize fileSelectedIndex;
@synthesize passLogin, userLogin;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    filesTable.dataSource = self;
    filesTable.delegate = self;
    isEditTable = false;
    fileSelectedIndex = -1;
    
    //create Edit button
    //create back button
//	UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];	
//	UIImage *buttonImage = [UIImage imageNamed:@"Back"];
//	[customBackButton setImage:buttonImage forState:UIControlStateNormal];
//	customBackButton.frame = CGRectMake(0, 0, 50, buttonImage.size.height);
//    [customBackButton addTarget:self action:@selector(pressedBackButton:) forControlEvents:UIControlEventTouchUpInside];
//	customBackButton.showsTouchWhenHighlighted = YES;
//    
//    //create backBarButton from customBackButton
//	UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:customBackButton]; 
    
    self.editButtonItem.target = self;
    self.editButtonItem.action = @selector(editBtnClick);
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self loadFilesIntoArray];
    
    //keychain save data
    keychain = [[KeychainItemWrapper alloc] initWithIdentifier:APP_KEYCHAIN accessGroup:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [passLogin release];
    [userLogin release];
    [keychain release];
    [movFiles release];
    [super dealloc];
}
- (void)loadFilesIntoArray
{
    if(movFiles != nil)
    {
        [movFiles release];
        movFiles = nil;
    }
    movFiles = [[NSMutableArray alloc] init];
    //load MOV and CAF files
    NSArray *files = [[[FileHelper sharedFileHelper] getFilesInFolder] retain];
    
    for(NSString* file in files){
        if([FileHelper checkFile:file isType:@"mov"] || [FileHelper checkFile:file isType:@"caf"])
        {
            [movFiles addObject:[[FileHelper sharedFileHelper] createFullFilePath:file]];
        }    
    }
    
    [files release];
    [filesTable reloadData];
}
#pragma mark - button events
- (void)editBtnClick
{
    if(!isEditTable)
    {
        [self.editButtonItem setTitle:@"Delete"];
        if(needDeleteFiles != nil)
        {
            [needDeleteFiles release];
            needDeleteFiles = nil;
        }
        needDeleteFiles = [[NSMutableDictionary alloc] init];
    }else{
        [self.editButtonItem setTitle:@"Edit"];
        NSArray *values = [needDeleteFiles allValues];
        NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
        for(NSIndexPath *path in values){
            [indexSet addIndex:path.row];
        }
        [[FileHelper sharedFileHelper] deleteFileAtPaths:[movFiles objectsAtIndexes: indexSet]];
        [movFiles removeObjectsAtIndexes:indexSet];
        [filesTable deleteRowsAtIndexPaths:[needDeleteFiles allValues] withRowAnimation:UITableViewRowAnimationNone];
        
        [needDeleteFiles release];
        needDeleteFiles = nil;
    }
    isEditTable = !isEditTable;
    //refresh table
    [filesTable reloadData];
}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_OF_CELL;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"%d", [movFiles count]);
    return [movFiles count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    FileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[FileViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.customCellDelegate = self;
    }
    if(isEditTable)
        [cell changeToEditMode];
    else
        [cell changeToDoneMode];
    NSString *pathMovie = [movFiles objectAtIndex:indexPath.row];    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:pathMovie]];    
    CMTime duration = playerItem.duration;
    
    // Configure the cell...    
    NSArray *splitPath = [pathMovie componentsSeparatedByString:@"/"];
    NSArray *fileComponents = [[splitPath lastObject] componentsSeparatedByString:@"."];
    NSString *fileName = [fileComponents objectAtIndex:0];
    NSString *fileType = [fileComponents objectAtIndex:1];
    //setup file type
    NSLog(@"filetype:%@", fileType);
    if([fileType isEqualToString:MOV]){
        cell.fileType = 0;
        cell.imvFileType.image = [UIImage imageNamed:@"movFile"];
    }else{
        cell.fileType = 1;
        cell.imvFileType.image = [UIImage imageNamed:@"cafFile"];
    }
    NSLog(@"type:%d", cell.fileType);
    NSInteger secondDuration = CMTimeGetSeconds(duration);
    int hours =  secondDuration / 3600;
    int minutes = ( secondDuration - hours * 3600 ) / 60; 
    int seconds = secondDuration - hours * 3600 - minutes * 60;
    cell.lbFileName.text = fileName;
    cell.lbFileDuration.text = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", hours, minutes, seconds];
    cell.lbFileNumber.text = [NSString stringWithFormat:@"%d.", indexPath.row + 1];
    
    if([needDeleteFiles objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]] != nil)
    {
        cell.isSelected = TRUE;
        [cell.btnSelectedBox setSelected:YES];
    }else{
        cell.isSelected = FALSE;
        [cell.btnSelectedBox setSelected:NO];
    }
    return cell;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		[movFiles removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    fileSelectedIndex = indexPath.row;
    
    AlertManager *alertManager = [AlertManager sharedManager];
    alertManager.fileSelectionDelegate = self;
    if(!isEditTable){
        alertManager.type = aFileSelection;
    }else{
        //show alert
        alertManager.type = aRename;
    }
    [alertManager showAlert];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - FileSelectionAlertDelegate
- (void)renameFileSelectionWithName:(NSString*)newName;
{
    NSLog(@"Rename file with name: %@", newName);
    NSIndexPath *rowIndex = [NSIndexPath indexPathForRow:fileSelectedIndex inSection:0];
    FileViewCell *cell = (FileViewCell*)[self.filesTable cellForRowAtIndexPath:rowIndex];
    
    if([[FileHelper sharedFileHelper] renameFileAtPath:[movFiles objectAtIndex:fileSelectedIndex] withName:newName withType:cell.fileType])
    {
        [needDeleteFiles removeAllObjects];
        [self editBtnClick];
        //reload array of movie
        [self loadFilesIntoArray];
    }
}
- (void)playFileSelection
{
    PlayerViewController *playerVC = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
    playerVC.pathVideo = [movFiles objectAtIndex:fileSelectedIndex];
    
    [self.navigationController pushViewController:playerVC animated:YES];  
    [playerVC release];
}


#pragma mark upload video to youtube
-(void)uploadVideoToYutube: (NSString*)user pass:(NSString*)pass
{
    //NSString *devKey = [mDeveloperKeyField text];
    
    GDataServiceGoogleYouTube *service = [self youTubeService:user pass:pass];
    [service setYouTubeDeveloperKey:DEVELOPER_KEY];
    NSLog(@"%@", pass);
    
    NSURL *url = [GDataServiceGoogleYouTube youTubeUploadURLForUserID:user
                                                             clientID:CLIENT_ID];
    
    // load the file data
    NSString *path = [movFiles objectAtIndex:fileSelectedIndex];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *filename = [path lastPathComponent];
    
    // gather all the metadata needed for the mediaGroup
    NSString *titleStr = @"Test video";
    GDataMediaTitle *title = [GDataMediaTitle textConstructWithString:titleStr];
    
    NSString *categoryStr = @"Entertainment";
    GDataMediaCategory *category = [GDataMediaCategory mediaCategoryWithString:categoryStr];
    [category setScheme:kGDataSchemeYouTubeCategory];
    
    NSString *descStr = @"This is test upload video";
    GDataMediaDescription *desc = [GDataMediaDescription textConstructWithString:descStr];
    
    NSString *keywordsStr = @"key world for this app";
    GDataMediaKeywords *keywords = [GDataMediaKeywords keywordsWithString:keywordsStr];
    
    
    
    GDataYouTubeMediaGroup *mediaGroup = [GDataYouTubeMediaGroup mediaGroup];
    [mediaGroup setMediaTitle:title];
    [mediaGroup setMediaDescription:desc];
    [mediaGroup addMediaCategory:category];
    [mediaGroup setMediaKeywords:keywords];
    [mediaGroup setIsPrivate:NO];
    
    NSString *mimeType = [GDataUtilities MIMETypeForFileAtPath:path
                                               defaultMIMEType:@"video/mov"];
    
    // create the upload entry with the mediaGroup and the file data
    GDataEntryYouTubeUpload *entry;
    entry = [GDataEntryYouTubeUpload uploadEntryWithMediaGroup:mediaGroup
                                                          data:data
                                                      MIMEType:mimeType
                                                          slug:filename];
    
    SEL progressSel = @selector(ticket:hasDeliveredByteCount:ofTotalByteCount:);
    [service setServiceUploadProgressSelector:progressSel];
    
    GDataServiceTicket *ticket;
    ticket = [service fetchEntryByInsertingEntry:entry
                                      forFeedURL:url
                                        delegate:self
                               didFinishSelector:@selector(uploadTicket:finishedWithEntry:error:)];
    if(ticket != nil)
        NSLog(@"yes");
    else
        NSLog(@"NO");
    [self setUploadTicket:ticket]; 
}
// get a YouTube service object with the current username/password
//
// A "service" object handles networking tasks.  Service objects
// contain user authentication information as well as networking
// state information (such as cookies and the "last modified" date for
// fetched data.)

- (GDataServiceGoogleYouTube *)youTubeService: (NSString*)user pass:(NSString*)pass {
    
    static GDataServiceGoogleYouTube* service = nil;
    
    if (!service) {
        service = [[GDataServiceGoogleYouTube alloc] init];
        
        [service setShouldCacheDatedData:YES];
        [service setServiceShouldFollowNextLinks:YES];
        [service setIsServiceRetryEnabled:YES];
    }
    
    // update the username/password each time the service is requested
    /*
     NSString *username = [mUsernameField text];
     NSString *password = [mPasswordField text];
     
     if ([username length] > 0 && [password length] > 0) {
     [service setUserCredentialsWithUsername:@"vancucit@gmail.com"
     password:@"caotronganh_1"];
     } else {
     */
    // fetch unauthenticated
    [service setUserCredentialsWithUsername:user
                                   password:pass];
    
    [service setYouTubeDeveloperKey:DEVELOPER_KEY];
    
    return service;
}

// progress callback
- (void)ticket:(GDataServiceTicket *)ticket
hasDeliveredByteCount:(unsigned long long)numberOfBytesRead 
ofTotalByteCount:(unsigned long long)dataLength {
    
    int curr = ((double)numberOfBytesRead / (double)dataLength)*100;
    NSLog(@"callback  %d", curr);
    //[mProgressView setProgress:(double)numberOfBytesRead / (double)dataLength];
    
    uploading.labelText = [NSString stringWithFormat:@"Uploading... %02d%%", curr];
}

// upload callback
- (void)uploadTicket:(GDataServiceTicket *)ticket
   finishedWithEntry:(GDataEntryYouTubeVideo *)videoEntry
               error:(NSError *)error {
    if (error == nil) {
        // tell the user that the add worked
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uploaded!"
                                                        message:[NSString stringWithFormat:@"%@ succesfully uploaded", 
                                                                 [[videoEntry title] stringValue]]                    
                                                       delegate:nil 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];

        //using keychain
//        // Store username to keychain 	
//        [keychain setObject:userLogin forKey:kUserYoutube];
//        
//        // Store password to keychain
//        [keychain setObject:passLogin forKey:kPassYoutube];
        
        //using USerDefault
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        
        if (standardUserDefaults) {
            [standardUserDefaults setObject:userLogin forKey:kUserYoutube];
            [standardUserDefaults setObject:passLogin forKey:kPassYoutube];
            [standardUserDefaults synchronize];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:[NSString stringWithFormat:@"Error: %@", 
                                                                 [error description]] 
                                                       delegate:nil 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];  
    }
    //[mProgressView setProgress: 0.0];
    
    [self setUploadTicket:nil];
    [self endLoading];
}

- (void)uploadToYoutube
{
    //using keychain
//    NSString *user = [keychain objectForKey:kUserYoutube];
//    NSString *pass = [keychain objectForKey:kPassYoutube];
    
    //using UserDefault
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *user = nil;
    NSString *pass = nil;
    if (standardUserDefaults) 
    {
        user = [standardUserDefaults objectForKey:kUserYoutube];
        pass = [standardUserDefaults objectForKey:kPassYoutube];
    }
    if (user != nil && pass != nil) 
    {
        [self uploadVideoToYutube:user pass:pass];
        [self showLoading];
    }else{
        AlertManager *alert = [AlertManager sharedManager];
        alert.fileSelectionDelegate = self;
        alert.type = aSignIn;
        
        [alert showAlert];
    }
    
    //[self uploadVideoToYutube];
}
- (void)signinYoutube: (NSString*)user pass:(NSString*)pass
{
    if(userLogin)
        [userLogin release];
    if(passLogin)
        [passLogin release];
    
    //using to save keychain when login success
    userLogin = [user retain];
    passLogin = [pass retain];
    [self uploadVideoToYutube:user pass:pass];
    [self showLoading];
    //[[Utils sharedUtils] uploadYoutube:[movFiles objectAtIndex:fileSelectedIndex] withUser:user withPass:pass];
}
#pragma mark -
#pragma mark Setters

- (GDataServiceTicket *)uploadTicket {
    return mUploadTicket;
}

- (void)setUploadTicket:(GDataServiceTicket *)ticket {
    if(mUploadTicket != nil)
        [mUploadTicket release];
    mUploadTicket = [ticket retain];
}
#pragma mark - FileViewCellDelegate
- (void)selectedDeleteCell:(NSString*)indexRow;
{
    NSLog(@"selectedDeleteCell: %@", indexRow);
    NSInteger row = [indexRow integerValue] - 1;
    NSIndexPath *rowIndex = [NSIndexPath indexPathForRow:row inSection:0];
    [needDeleteFiles setValue:rowIndex forKey:[NSString stringWithFormat:@"%d", row]];

}
- (void)unselectedDeleteCell:(NSString*)indexRow
{
    NSLog(@"unDeleteCell: %@", indexRow);
    NSInteger row = [indexRow integerValue] - 1;
    [needDeleteFiles removeObjectForKey:[NSString stringWithFormat:@"%d", row]];
}

#pragma mark - Show loading
- (void)showLoading
{
    uploading = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:uploading];
    uploading.labelText = @"uploading...!";
    [uploading show:YES];
}
- (void)endLoading
{
    [uploading removeFromSuperview];
    [uploading release];
    uploading = nil;
}
@end
