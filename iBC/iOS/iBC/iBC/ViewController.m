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
#import "VenueListViewController.h"
#import "EventListViewController.h"
#import "Service.h"
#import "KalViewController.h"
#import "CalendarViewController.h"

#import "EventCalendarView.h"

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
    _tableView.scrollEnabled = NO;
    
    [self.view addSubview:_tableView];
    //add menu item
    _arrMenuItems = [[NSMutableArray alloc] init];
    [self initMenu];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
- (void) initMenu {
    MenuItemData *item = [[MenuItemData alloc] initWithTitle:EventMenu andButtonImage:@"v01_bt01.png"];
    [_arrMenuItems addObject:item];
    [item release];
    
    MenuItemData *item1 = [[MenuItemData alloc] initWithTitle:VenueMenu andButtonImage:@"v01_bt02.png"];
    [_arrMenuItems addObject:item1];
    [item1 release];
    
    MenuItemData *item2 = [[MenuItemData alloc] initWithTitle:CalendarMenu andButtonImage:@"v01_bt03.png"];
    [_arrMenuItems addObject:item2];
    [item2 release];
    
    MenuItemData *item3 = [[MenuItemData alloc] initWithTitle:VenueDictanceMenu andButtonImage:@"v01_bt04.png"];
    [_arrMenuItems addObject:item3];
    [item3 release];
    
    MenuItemData *item4 = [[MenuItemData alloc] initWithTitle:StarredMenu andButtonImage:@"v01_bt05.png"];
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
    NSLog(@"venue list selected..");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    MenuItemData *data = [_arrMenuItems objectAtIndex:indexPath.row];
    NSString *title = [self CapitalizedString:data.title];
    if([data.title isEqual:StarredMenu]){
        StarredListViewController *starredVC = [[StarredListViewController alloc] initWithTitle:title];
        [self.navigationController pushViewController:starredVC animated:YES];
        [starredVC release];
        
        return;
    }
    if([data.title isEqual:VenueMenu]){
        VenueListViewController *venueVC = [[VenueListViewController alloc] initWithTitle:title];
        [self.navigationController pushViewController:venueVC animated:YES];
        [venueVC release];
        
        
        return;
    }
    if([data.title isEqual:EventMenu]){
        EventListViewController *eventVC = [[EventListViewController alloc] initWithTitle:title];
        eventVC.filterType = EventFilterNone;
        [self.navigationController pushViewController:eventVC animated:YES];
        [eventVC release];
        
        return;
    }
    if([data.title isEqual:CalendarMenu]){
        KalViewController *cal = [[KalViewController alloc] init];
        cal.title = title;
        CalendarViewController *calVC = [[CalendarViewController alloc] initWithTitle:title];
        [self.navigationController pushViewController:calVC animated:YES];

        return;
    }
    if([data.title isEqual:VenueDictanceMenu]){
        EventCalendarView *calVC = [[EventCalendarView alloc] init];
        calVC.title = @"Event Calendar";
        [self.navigationController pushViewController:calVC animated:YES];
        return;
    }
}


#pragma servide delegate
- (void) mServiceGetStatusSuccess:(Service *) service responses:(id) response {
    NSLog(@"API getStatus : success");
}

- (void) mService:(Service *) service didFailWithError:(NSError *) error {
    
}


@end
