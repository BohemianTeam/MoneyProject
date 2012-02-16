//
//  ViewController.h
//  VideoSubtitle
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Subtitle.h"
#import "SidaViewController.h"

@class VideoData;
@interface VideoSubViewController : SidaViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    IBOutlet    UIView                  *_movieView;
    IBOutlet    UITableView             *_tableView;
//    IBOutlet    UIBarButtonItem         *_playButton;
//    IBOutlet    UIBarButtonItem         *_nextButton;
//    IBOutlet    UIBarButtonItem         *_doneButton;
    
    MPMoviePlayerController             *_movieController;
    
    int                                  _currentIndex;
    NSTimeInterval                       _currentTime;
    Subtitle                            *_subtitle;
    NSTimer                             *_timer;
    
    VideoData                           *_data;
}
@property (nonatomic, retain) Subtitle  *subtitle;
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil video:(VideoData *) data;
- (void)loadSubtitle;
- (void)startTimer;
- (void)stopTimer;
//- (IBAction)playButton_clicked:(id)sender;
//- (IBAction)nextButton_clicked:(id)sender;
//- (IBAction)doneButton_clicked:(id)sender;
@end
