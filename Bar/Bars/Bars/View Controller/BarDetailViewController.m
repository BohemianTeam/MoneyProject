//
//  BarDetailViewController.m
//  Bars
//
//  Created by Cuong Tran on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BarDetailViewController.h"
#import "Bar.h"
#import "ImageGaleryView.h"

#define TEXT_VIEW_HEIGHT 80
#define GROUP_BUTTON_HEIGHT 54
#define TABLEVIEW_HEIGHT (416 - 49)
@implementation BarDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithBar:(Bar *)bar {
    
    self = [super init];
    if (self) {
        _bar = [bar retain];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, TABLEVIEW_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        
        [self.view addSubview:_tableView];
    }
    
    return self;
}

- (void) dealloc {
    [_tableView release];
    [_bar release];
    [_barDescription release];
    [_galeryView release];
    [_map release];
    [_camera release];
    [_upload release];
    
    
    [super dealloc];
}

#pragma UITableView Delegate & Datasource


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return TEXT_VIEW_HEIGHT;
    } else if (indexPath.section == 1) {
        return (TABLEVIEW_HEIGHT - TEXT_VIEW_HEIGHT - GROUP_BUTTON_HEIGHT);
    } else if (indexPath.section == 2) {
        return GROUP_BUTTON_HEIGHT;
    }
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"cellId";
    UITableViewCell *cell;
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                   reuseIdentifier:cellId] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    int section = indexPath.section;
    if (section == 0) {
        _barDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320 - 10, TEXT_VIEW_HEIGHT)];
        _barDescription.backgroundColor = [UIColor clearColor];
        _barDescription.font = [UIFont systemFontOfSize:14];
        _barDescription.textAlignment = UITextAlignmentLeft;
        _barDescription.lineBreakMode = UILineBreakModeWordWrap;
        _barDescription.numberOfLines = 5;
        _barDescription.text = @"Dan Kelly's Bar & Grill, in business since 1997, is an Irish-themed bar that features Happy Hour specials and a huge selection of down-home, Irish fare appetizers.";
        [cell addSubview:_barDescription];
    }else if (section == 1) {
        int h = TABLEVIEW_HEIGHT - TEXT_VIEW_HEIGHT - GROUP_BUTTON_HEIGHT;
        int w = 320;
        int igh = 180;
        int igw = 320;
        _galeryView = [[ImageGaleryView alloc] initWithFrame:CGRectMake((w - igw) / 2, (h - igh) / 2, igw, igh)];
        [cell addSubview:_galeryView];
        
    } else if (section == 2) {
        _map = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _map.frame = CGRectMake(20, (GROUP_BUTTON_HEIGHT - 46) / 2, 72, 46);
        [_map setTitle:@"Map" forState:UIControlStateNormal];
        [cell addSubview:_map];
        
        _camera = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _camera.frame = CGRectMake(124, (GROUP_BUTTON_HEIGHT - 46) / 2, 72, 46);
        [_camera setTitle:@"Camera" forState:UIControlStateNormal];
        [cell addSubview:_camera];
        
        _upload = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _upload.frame = CGRectMake(228, (GROUP_BUTTON_HEIGHT - 46) / 2, 72, 46);
        [_upload setTitle:@"Upload" forState:UIControlStateNormal];
        [cell addSubview:_upload];
        
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[_tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

@end
