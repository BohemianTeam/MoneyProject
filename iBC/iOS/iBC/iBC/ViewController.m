//
//  ViewController.m
//  iBC
//
//  Created by Cuong Tran on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "MenuItemData.h"
#import "MenuTableViewCell.h"
#import "SubMenuViewController.h"
#import "StarredListViewController.h"
#import "Service.h"
@interface ViewController(private)
- (void) initMenu;
@end
@implementation ViewController

#pragma mark - Base method

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = LocStr(@"MainTitle");
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:1];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    _tableView.separatorColor = [UIColor whiteColor];
    
    [self.view addSubview:_tableView];
    //add menu item
    _arrMenuItems = [[NSMutableArray alloc] init];
    [self initMenu];
    
    Service *sv = [[Service alloc] init];
    sv.canShowAlert = YES;
    sv.canShowLoading = YES;
    sv.delegate = self;
    [sv getVenueList:@"41.385756~2.164129"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
- (void) initMenu {
    MenuItemData *item = [[MenuItemData alloc] initWithTitle:@"ESPECTACLES" andButtonImage:@"v01_bt01.png"];
    [_arrMenuItems addObject:item];
    [item release];
    
    MenuItemData *item1 = [[MenuItemData alloc] initWithTitle:@"ESPAIS" andButtonImage:@"v01_bt02.png"];
    [_arrMenuItems addObject:item1];
    [item1 release];
    
    MenuItemData *item2 = [[MenuItemData alloc] initWithTitle:@"AGENDA" andButtonImage:@"v01_bt03.png"];
    [_arrMenuItems addObject:item2];
    [item2 release];
    
    MenuItemData *item3 = [[MenuItemData alloc] initWithTitle:@"A PROP" andButtonImage:@"v01_bt04.png"];
    [_arrMenuItems addObject:item3];
    [item3 release];
    
    MenuItemData *item4 = [[MenuItemData alloc] initWithTitle:@"FAVORITS" andButtonImage:@"v01_bt05.png"];
    [_arrMenuItems addObject:item4];
    [item4 release];
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
- (void) dealloc {
    [super dealloc];
    [_tableView release];
    [_arrMenuItems release];
}

#pragma mark - TableView Delegate
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
    UIImageView * accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WhiteAccessory.png"]];
    accessoryView.frame = CGRectMake(0, 0, 9, 15);
    cell.accessoryView = accessoryView;
    [accessoryView release];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setMenuData:[_arrMenuItems objectAtIndex:indexPath.row] isEvenRow:((indexPath.row % 2) == 0)];
    return cell;
}

- (NSString *) CapitalizedString:(NSString *) str {
    str = [str lowercaseString];
    NSString *firstCapChar = [[str substringToIndex:1] capitalizedString];
    NSString *cappedString = [str stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    return cappedString;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    MenuItemData *data = [_arrMenuItems objectAtIndex:indexPath.row];
//    NSString *title = [self CapitalizedString:data.title];
//    SubMenuViewController *vc = [[SubMenuViewController alloc] initWithTitle:title];
//    [self.navigationController pushViewController:vc animated:YES];
//    [vc release];
    
    MenuItemData *data = [_arrMenuItems objectAtIndex:indexPath.row];
    NSString *title = [self CapitalizedString:data.title];
    StarredListViewController *starredVC = [[StarredListViewController alloc] initWithTitle:title];
    [self.navigationController pushViewController:starredVC animated:YES];
    [starredVC release];
}


#pragma servide delegate
- (void) mServiceGetStatusSuccess:(Service *) service responses:(id) response {
    NSLog(@"API getStatus : success");
}

- (void) mService:(Service *) service didFailWithError:(NSError *) error {
    
}


@end
