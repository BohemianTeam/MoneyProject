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
#import "CityViewCell.h"
@interface BarsViewController (private)
- (void)loadDataFromDatabase;
@end
@implementation BarsViewController
@synthesize dataType;
@synthesize dataID;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
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
        
        
        [self loadDataFromDatabase];
        
    }
    return self;
}
- (id) initWithID:(NSInteger)dataId type:(DataSourceType)type{
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
        [self.view addSubview:table];
     
        [self loadDataFromDatabase];
    }
    return self;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
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
    switch (dataType) {
        case States:
            datas = nil;
            sumRow = [[AppDatabase sharedDatabase] lookingSumStates];
            break;
        case Citys:
            datas = [[NSArray alloc] initWithArray:[[AppDatabase sharedDatabase] lookingCitysByStateID:dataID]];
            sumRow = [datas count];
            break;
        default:
            datas = nil;
            break;
    }
    
    [table reloadData];
}
#pragma mark - tableview delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sumRow;
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return ;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cell = @"Cell";
    

    if(dataType == Citys)
    {
        CityViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
        if (cell == nil) {
            cell = [[[CityViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NSInteger cityID = [(NSNumber*)[datas objectAtIndex:indexPath.row] intValue];
        
        CityObj * cityObj = [[[AppDatabase sharedDatabase] lookingCityByCityID:cityID] retain];
        [cell setData:cityObj];
        
        
        return cell;
    }
    if(dataType == States)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NSInteger stID = indexPath.row + 1;
        cell.textLabel.text = [[AppDatabase sharedDatabase] lookingStateByStateID:stID];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BarsViewController *newVC = nil;
    switch (dataType) {
        case States:
            newVC = [[BarsViewController alloc] initWithID:indexPath.row type:Citys];
            newVC.title = [[AppDatabase sharedDatabase] lookingStateByStateID:indexPath.row + 1];
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:newVC animated:YES];
}


@end
