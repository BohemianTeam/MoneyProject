//
//  iBackMasterViewController.m
//  iBack
//
//  Created by bohemian on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>

#import "iBackAppDelegate.h"
#import "iBackMasterViewController.h"
#import "AboutViewController.h"
#import "SettingViewController.h"
#import "HowToViewController.h"
#import "SaveFilesViewController.h"
#import "RecordAudioViewController.h"
#import "RevertMedia.h"
#import "FileHelper.h"
#import "RecordVideoViewController.h"
#define MENU_SECTION_NUMBER 2
#define MENU_ROW_NUMBER 3

@implementation iBackMasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize menuTable;
@synthesize overlayView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)dealloc
{

    [_detailViewController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    menuTable.delegate = self;
    menuTable.dataSource = self;
    //menuTable.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
    menuTable.scrollEnabled = NO;
    menuTable.backgroundColor = [UIColor clearColor];

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
    self.navigationController.navigationBarHidden = true;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    //self.navigationController.navigationBarHidden = false;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    //return NO;
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}
#pragma mark - custome navigation bar
- (void)setBackButtonFor: (UIViewController*)vc
{
    //hide left bar button
    vc.navigationItem.hidesBackButton = YES;
    
    //create back button
	UIButton *customBackButton = [UIButton buttonWithType:UIButtonTypeCustom];	
	UIImage *buttonImage = [UIImage imageNamed:@"Back"];
	[customBackButton setImage:buttonImage forState:UIControlStateNormal];
	customBackButton.frame = CGRectMake(0, 0, 50, buttonImage.size.height);
    [customBackButton addTarget:self action:@selector(pressedBackButton:) forControlEvents:UIControlEventTouchUpInside];
	customBackButton.showsTouchWhenHighlighted = YES;
    
    //create backBarButton from customBackButton
	UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:customBackButton]; 
    
    vc.navigationItem.leftBarButtonItem = backBarButton;

    [backBarButton release];
}
- (void)setTitleImage: (NSString*)imgStr forView: (UIViewController*)vc
{
    UIImage *titleIma = [UIImage imageNamed:imgStr];
	vc.navigationItem.titleView = [[[UIImageView alloc] initWithImage:titleIma] autorelease];
}

#pragma mark - Button Events
- (void)pressedBackButton: (id)sender
{
	[self.navigationController popViewControllerAnimated:YES];	
}


#pragma mark - Camera Audio methods
- (void)showCameraViewController
{
//    if(cameraView != nil)
//    {
//        [cameraView release];
//        cameraView = nil;
//    }
//    cameraView = [[UIImagePickerController alloc] init];
//    NSString *mediaType = nil;
//    NSArray *types  = nil;
//    types = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
//    if([types containsObject:(NSString*)kUTTypeMovie]){
//        mediaType = (NSString*)kUTTypeMovie;
//    }else{
//        mediaType = (NSString*)kUTTypeVideo;
//    }
//    
//    cameraView.mediaTypes = [NSArray arrayWithObjects:mediaType, nil];
//    cameraView.delegate = self;
//    cameraView.sourceType = UIImagePickerControllerSourceTypeCamera;
//    cameraView.allowsEditing = NO;
//    cameraView.cameraDevice = UIImagePickerControllerCameraDeviceRear;
//    
//    [self presentModalViewController:cameraView animated:YES];
//    cameraView.cameraOverlayView = overlayView;
    //[cameraView release];
    
    RecordVideoViewController *recordVideoVC = [[RecordVideoViewController alloc] initWithNibName:@"RecordVideoViewController" bundle:nil];
    [self presentModalViewController:recordVideoVC animated:YES];
    
    [recordVideoVC release];
}
- (void)showAudioViewController
{
    RecordAudioViewController *audioVC = [[[RecordAudioViewController alloc] initWithNibName:@"RecordAudioViewController" bundle:nil] autorelease];
    [self.navigationController presentModalViewController:audioVC animated:YES];
}

- (void)saveMovie:(NSString*)oldPath
{  
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                                        NSUserDomainMask, YES) lastObject];
    
    NSTimeInterval milisecondedDate = ([[NSDate date] timeIntervalSince1970]);
    NSString *fileName =[NSString stringWithFormat:@"%.0f.MOV", milisecondedDate];
    NSString *newPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    BOOL isExistFile = [fileManager fileExistsAtPath:newPath];
    if(!isExistFile){
        NSError *error;
        BOOL success = [fileManager copyItemAtPath:oldPath toPath:newPath error:&error];
        
        if(!success){
            NSAssert1(0, @"Failed to save file with message'%@'.", [error localizedDescription]);
        }else{
            NSLog(@"save success with path: %@", newPath);
        }
        
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if(CFStringCompare((CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo){
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        [self saveMovie:moviePath];
        
        
        NSLog(@"movie path: --> %@", moviePath);
    }
    
    [picker dismissModalViewControllerAnimated:YES];
    //[picker release];
}


#pragma mark - TableView Delegate
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return MENU_SECTION_NUMBER;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MENU_ROW_NUMBER;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"Test";
//}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    iBackAppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
    
    // Configure the cell.
    if(indexPath.section == 0){
        cell.textLabel.text = [mainDelegate.menuArray objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text = [mainDelegate.menuArray objectAtIndex:MENU_ROW_NUMBER+indexPath.row];
    }
    
    return cell;
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
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (!self.detailViewController) {
//        self.detailViewController = [[[iBackDetailViewController alloc] initWithNibName:@"iBackDetailViewController" bundle:nil] autorelease];
//    }
    int row = indexPath.row + MENU_ROW_NUMBER*indexPath.section;
    iBackAppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
    NSString *imgStr = [mainDelegate.menuArray objectAtIndex:row];
    UIViewController *detailVC = nil;
    
    switch (row) {
        case 0:
            detailVC = [[[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil] autorelease];
            break;
        case 1:
            detailVC = [[[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil] autorelease];
            break;
        case 2:
            detailVC = [[[HowToViewController alloc] initWithNibName:@"HowToViewController" bundle:nil] autorelease];
            break;
        case 3:
            [self showCameraViewController];
            break;
        case 4:
            [self showAudioViewController];
            break;
        case 5:
            detailVC = [[[SaveFilesViewController alloc] initWithNibName:@"SaveFilesViewController" bundle:nil] autorelease];
            break;
        default:
            break;
    }
      
	if(detailVC != nil){
        [self setBackButtonFor:detailVC];
        [self setTitleImage:imgStr forView:detailVC];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
