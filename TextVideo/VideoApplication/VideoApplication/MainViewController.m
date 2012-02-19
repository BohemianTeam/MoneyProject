//
//  MainViewController.m
//  VideoApplication
//
//  Created by bohemian on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "NewMookViewController.h"
#import "VideoDatabase.h"
#import "TitleTableViewCell.h"
@implementation MainViewController
@synthesize movieTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = LocStr(@"TitleMainView");
        
        movieTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) 
                                                  style:UITableViewStylePlain];
        movieTable.delegate = self;
        movieTable.dataSource = self;
        movieTable.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:movieTable];
        
        UIButton * button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(btnNewMookPressed) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor blueColor];
        button.frame = CGRectMake(0, 100, 50, 30);
        [button setTitle:LocStr(@"New Mook") forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        
        movieTable.tableFooterView = button;
        [button release];
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
    // Do any additional setup after loading the view from its nib.
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

#pragma - Events button
- (void) btnNewMookPressed {
    NSLog(@"btnNewMookPressed");
    
    NewMookViewController *newMookVC = [[NewMookViewController alloc] initWithNibName:@"NewMookViewController" bundle:nil];
    
    [self.navigationController pushViewController:newMookVC animated:YES];
}

#pragma - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[VideoDatabase sharedDatabase] sumOfRow];
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 44;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    TitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    
    // Configure the cell.
    cell.title.text = [[VideoDatabase sharedDatabase] lookingVideoByIndexPath:indexPath.row];
    cell.details.text = @"test";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
