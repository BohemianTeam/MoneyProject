//
//  ViewController.m
//  VideoApplication
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Service.h"
#import "LoadingMaskView.h"
#import "ListVideoData.h"
#import "VideoSubViewController.h"
@interface ViewController()

- (void) showLoading;
- (void) hideLoading;
@end
@implementation ViewController
@synthesize tableView = _tableView;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


- (id) init {
    self = [super init];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 320, 416 - 50) 
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        _service = [[Service alloc] init];
        _service.delegate = self;
        _service.canShowAlert = NO;
        
        _data = [[ListVideoData alloc] init];
        
        [_service getAllVideo];
        [self showLoading];
    }
    return self;
}

- (void) showLoading {
    if(_loadingView == nil) {
        _loadingView = [[LoadingMaskView alloc] initWithMessage:@"Waiting..."];
    }
    [_loadingView show];
}

- (void) hideLoading {
    [_loadingView hide];
}

#pragma service delegate
- (void) mServiceGetVideoSuccess:(Service *)service responses:(ListVideoData *) response{
    [self hideLoading];
    _data = [response retain];
    [_tableView reloadData];
}


- (void) mServiceGetVideoFailed:(Service *)service responses:(ListVideoData *) response{
    [self hideLoading];
}


- (void)service:(Service *)service didFailWithError:(NSError *)error {
    [self hideLoading];
}

#pragma tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data.videos count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                                    reuseIdentifier:nil] autorelease];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.detailTextLabel.text = @"";
    cell.textLabel.text = [[_data.videos objectAtIndex:indexPath.row] title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoSubViewController *vc = [[VideoSubViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    
}


- (void) dealloc {
    [_tableView release];
    [_service release];
    if (_loadingView) {
        [_loadingView release];
    }
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = LocStr(@"Title");
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416 - 50) 
                                              style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _service = [[Service alloc] init];
    _service.delegate = self;
    _service.canShowAlert = YES;
    _service.canShowLoading = YES;
    
    _data = [[ListVideoData alloc] init];
    
    [_service getAllVideo];
    [self showLoading];

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
    if (_service && _service.connecting) {
        [_service stop];
    }
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

@end
