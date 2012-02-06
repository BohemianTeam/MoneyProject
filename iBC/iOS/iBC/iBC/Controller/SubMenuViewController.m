//
//  SubMenuViewController.m
//  iBC
//
//  Created by Cuong Tran on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubMenuViewController.h"
#import "MenuItemData.h"
#import "MenuTableViewCell.h"

@interface SubMenuViewController(private)
- (void) initMenu;
@end
@implementation SubMenuViewController

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
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        _tableView.separatorColor = [UIColor whiteColor];
        
        [self.view addSubview:_tableView];
        //add menu item
        _arrMenuItems = [[NSMutableArray alloc] init];
        [self initMenu];

    }
    return self;
}

- (void) initMenu {
    MenuItemData *item = [[MenuItemData alloc] initWithTitle:@"EN CARTELL" andButtonImage:@"v02_bt01.png"];
    [_arrMenuItems addObject:item];
    [item release];
    
    MenuItemData *item1 = [[MenuItemData alloc] initWithTitle:@"PROPERAMENT" andButtonImage:@"v02_bt02.png"];
    [_arrMenuItems addObject:item1];
    [item1 release];
    
    MenuItemData *item2 = [[MenuItemData alloc] initWithTitle:@"́LTIMA OPORTUNITAT" andButtonImage:@"v02_bt03.png"];
    [_arrMenuItems addObject:item2];
    [item2 release];
}
#pragma tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrMenuItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = [[[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                                        reuseIdentifier:nil] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView * accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WhiteAccessory.png"]];
    accessoryView.frame = CGRectMake(0, 0, 9, 15);
    cell.accessoryView = accessoryView;
    [accessoryView release];
    [cell setMenuData:[_arrMenuItems objectAtIndex:indexPath.row] isEvenRow:((indexPath.row % 2) == 0)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void) dealloc {
    [super dealloc];
    [_tableView release];
    [_arrMenuItems release];
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
	return YES;
}

@end
