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

#define HEIGHT_OF_CELL 50

@implementation SaveFilesViewController
@synthesize movFiles;
@synthesize filesTable;
@synthesize isEditTable;
@synthesize needDeleteFiles;
@synthesize fileSelectedIndex;

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
        if([file rangeOfString:@".MOV"].location > 0 || [file rangeOfString:@".caf"].location > 0)
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
@end
