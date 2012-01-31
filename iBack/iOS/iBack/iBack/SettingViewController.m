//
//  SettingViewController.m
//  iBack
//
//  Created by bohemian on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "AppConstant.h"
@implementation SettingViewController
@synthesize btnNormal;
@synthesize btnHD;
@synthesize btn480P;
@synthesize btnEcho;
@synthesize audioQuality;
@synthesize videoQuality;
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
    videoQuality = 0;
    audioQuality = 1;
    // Do any additional setup after loading the view from its nib.
    btnHD = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnHD setFrame:CGRectMake(207, 72, 72, 37)];
    [btnHD setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [btnHD setImage:[UIImage imageNamed:@"selected3"] forState:UIControlStateSelected];
    [btnHD setTag:btn_HD];
    [btnHD setSelected:YES];
    [btnHD addTarget:self action:@selector(btnVideoQualityClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnHD];
    
    btn480P = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn480P setFrame:CGRectMake(207, 110, 72, 37)];
    [btn480P setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [btn480P setImage:[UIImage imageNamed:@"selected3"] forState:UIControlStateSelected];
    [btn480P addTarget:self action:@selector(btnVideoQualityClick) forControlEvents:UIControlEventTouchUpInside];
    [btn480P setTag:btn_480P];
    [btn480P setSelected:NO];
    [self.view addSubview:btn480P];
    
    btnEcho = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEcho setFrame:CGRectMake(207, 208, 72, 37)];
    [btnEcho setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [btnEcho setImage:[UIImage imageNamed:@"selected3"] forState:UIControlStateSelected];
    [btnEcho setSelected:NO];
    [btnEcho addTarget:self action:@selector(btnAudioQualityClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnEcho];
    
    btnNormal = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNormal setFrame:CGRectMake(207, 244, 72, 37)];
    [btnNormal setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [btnNormal setImage:[UIImage imageNamed:@"selected3"] forState:UIControlStateSelected];
    [btnNormal addTarget:self action:@selector(btnAudioQualityClick) forControlEvents:UIControlEventTouchUpInside];
    [btnNormal setSelected:YES];
    [self.view addSubview:btnNormal];
    
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
#pragma mark - events
- (void)btnVideoQualityClick
{
    if(videoQuality == 0)
    {
        [btnHD setSelected:NO];
        videoQuality = 1;
        [btn480P setSelected:YES];
    }else{
        [btnHD setSelected:YES];
        videoQuality = 0;
        [btn480P setSelected:NO];
    }        
}
- (void)btnAudioQualityClick
{
    if(audioQuality == 0)
    {
        [btnNormal setSelected:YES];
        audioQuality = 1;
        [btnEcho setSelected:NO];
    }else{
        [btnNormal setSelected:NO];
        audioQuality = 0;
        [btnEcho setSelected:YES];
    }        
}
@end
