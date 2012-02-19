//
//  NewMookViewController.m
//  VideoApplication
//
//  Created by Cuong Tran on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewMookViewController.h"
#import "Service.h"
#import "ListVideoData.h"
#import "VideoSubViewController.h"
#import "TitleTableViewCell.h"
#import "VideoData.h"
#import "DownloadService.h"
#import "VideoDatabase.h"
#import "MainViewController.h"
#import "MBProgressHUD.h"

@interface NewMookViewController()
- (void) showLoading;
- (void) hideLoading;
@end

@implementation NewMookViewController
@synthesize tableView = _tableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = LocStr(@"TitleMainView");
                
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) 
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
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
    if (_loadingHUD == nil) {
        _loadingHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_loadingHUD];
        _loadingHUD.dimBackground = YES;
        _loadingHUD.labelText = @"Loading ..";
        [_loadingHUD show:YES];
    }

}

- (void) hideLoading {
    if (_loadingHUD) {
        [_loadingHUD hide:YES afterDelay:2];
        [_loadingHUD removeFromSuperview];
        [_loadingHUD release];
        _loadingHUD = nil;
    }
}

#pragma service delegate
- (void) mServiceGetVideoSuccess:(Service *)service responses:(ListVideoData *) response{
    [self hideLoading];
    ListVideoData * dataResponse = [response retain];

    [dataResponse.videos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![[VideoDatabase sharedDatabase] checkExistVideoID:idx + 1]) {
            [_data.videos addObject:[dataResponse.videos objectAtIndex:idx]];
        }
    }];
    
    [_tableView reloadData];
}


- (void) mServiceGetVideoFailed:(Service *)service responses:(ListVideoData *) response{
    [self hideLoading];
}


- (void)mService:(Service *)service didFailWithError:(NSError *)error {
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
    TitleTableViewCell *cell = [[[TitleTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                                    reuseIdentifier:nil] autorelease];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    VideoData *data = [_data.videos objectAtIndex:indexPath.row];
    [cell setData:data];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoData *data = [_data.videos objectAtIndex:indexPath.row];
    if (_download) {
        [_download stop];
        _download = nil;
    }
    _download = [[DownloadService alloc] initWithVideoData:data andSuperView:self.view];
    _download.delegate = self;
    [_download downloadWithASIRequest];
    

    
}
#pragma download service delegate
- (void) downloadService:(DownloadService *)service didSuccessWithVideoData:(VideoData *)videoData {
    VideoData *data = [videoData retain];
    NSLog(@"%@",data.localPathVideo);
    
    //save database
    [[VideoDatabase sharedDatabase] addNewVideo:data.localPathVideo videoID:[data.mid integerValue] duration:data.desc];
    
    NSLog(@"numOf Row: %d", [[VideoDatabase sharedDatabase] sumOfRow]);
    MainViewController *vc = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void) downloadServiceFailed:(DownloadService *)service {
    NSLog(@"download failed");
}

- (void) dealloc {
    [_tableView release];
    if (_service) {
        [_service stop];
        [_service release];
    }
    
    if (_download) {
        [_download stop];
        [_download release];
    }
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
}


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

- (void) viewWillDisappear:(BOOL)animated {
    if (_service && _service.connecting) {
        [_service stop];
    }
    if (_download && _download.connecting) {
        [_download stop];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
