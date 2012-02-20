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
    UIScrollView                        *videoSubScroll;
//    IBOutlet    UIBarButtonItem         *_playButton;
//    IBOutlet    UIBarButtonItem         *_nextButton;
//    IBOutlet    UIBarButtonItem         *_doneButton;
    
    MPMoviePlayerController             *_movieController;
    NSString                            *_movieFileName;
    int                                  _currentIndex;
    int                                  _currentView;
    int                                  _currentViewHeight;
    NSTimeInterval                       _currentTime;
    Subtitle                            *_subtitle;
    NSTimer                             *_timer;
    
    VideoData                           *_data;
    
    NSMutableArray                      *indexPageMapToSub;
}

@property (nonatomic, retain) Subtitle  *subtitle;
@property (nonatomic, retain) NSString  *movieFileName;
@property (nonatomic, retain) NSMutableArray                      *indexPageMapToSub;
@property (nonatomic, assign) int       currentPage;
@property (nonatomic, assign) int       currentPageHeight;
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil video:(VideoData *) data;
- (void)loadSubtitle;
- (void)ceateSubtitleView;
- (void)startTimer;
- (void)stopTimer;
//- (IBAction)playButton_clicked:(id)sender;
//- (IBAction)nextButton_clicked:(id)sender;
//- (IBAction)doneButton_clicked:(id)sender;
@end
