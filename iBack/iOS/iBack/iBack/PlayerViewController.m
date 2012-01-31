//
//  PlayerViewController.m
//  iBack
//
//  Created by bohemian on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayerViewController.h"

@implementation PlayerViewController
@synthesize playerView;
@synthesize rate;
@synthesize pathVideo;

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
    // Do any additional setup after loading the view from its nib.
    
    rate = 0;

    playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:pathVideo]];
    NSLog(@"player: %@", pathVideo);
    //    player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:moviePath]];
    //    [player.view setFrame:CGRectMake(0, 0, 320, 420)];
    //[playerView.view setFrame:CGRectMake(0, 200, 320, 220)];
    
    self.playerView.view.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:playerView.view];
    //playerView.moviePlayer.shouldAutoplay = NO;
    //playerView.moviePlayer.repeatMode = MPMovieRepeatModeOne;
    //playerView.moviePlayer.controlStyle = MPMovieControlStyleNone;
    //playerView.moviePlayer.initialPlaybackTime = 1.0;
    //playerView.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    //playerView.moviePlayer.useApplicationAudioSession = NO;
    //playerView.moviePlayer.currentPlaybackRate = 2.0f;
    [[playerView moviePlayer] setFullscreen:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];

    
    [[playerView moviePlayer] prepareToPlay];
    [[playerView moviePlayer] play];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
     self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = FALSE;
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
    [playerView release];
    [pathVideo release];
    [super dealloc];
}
#pragma mark - Notification player
- (void)playbackFinished:(NSNotification*)notification
{
    [[playerView moviePlayer] setFullscreen:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
