//
//  ViewController.m
//  VideoSubtitle
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VideoSubViewController.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import "VideoData.h"
#import "VideoSubView.h"
#import "FileHelper.h"

#define WIDTH_SUBTITLE_VIEW 240
#define HEIGHT_SUBTITLE_VIEW 300
@interface VideoSubViewController()
- (void) mockupSubtitle;
@end
@implementation VideoSubViewController
@synthesize subtitle = _subtitle;
@synthesize currentPage = _currentPage;
@synthesize currentPageHeight = _currentPageHeight;
@synthesize movieFileName  = _movieFileName;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil video:(VideoData *) data{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.showWithOrientation = UIInterfaceOrientationLandscapeLeft;
        _data = [data retain];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Video View Controller";

    _currentIndex = 0;
    NSString *videoPath = [FileHelper documentsPath:[NSString stringWithFormat:@"%@/%@", VIDEO_FOLDER, self.movieFileName]];
//    NSURL *localPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"LARVA_Airform" ofType:@"mp4"]];
    NSURL *videoUrl = [NSURL URLWithString:videoPath];
    if (_movieController == nil) {
        _movieController = [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];
        _movieController.fullscreen = FALSE;
        _movieController.scalingMode = MPMovieScalingModeAspectFit;
        _movieController.controlStyle = MPMovieControlStyleEmbedded;
        _movieController.useApplicationAudioSession= NO;
        _movieController.view.frame = CGRectMake(0, 0, _movieView.frame.size.width, _movieView.frame.size.height);
		//        _movieController.movieControlMode = MPMovieControlModeDefault;
    }
    [_movieView addSubview:_movieController.view];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(moviePlayBackDidChange:) 
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    
    _subtitle = [[Subtitle alloc] init];

    [self loadSubtitle];
    [self ceateSubtitleView];
    
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

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [_movieController stop];
    [self stopTimer];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    //if (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        //return TRUE;
    //}
    //return FALSE;
}


#pragma mark - LoadData
- (void)loadSubtitle {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *fileDirectory = [paths objectAtIndex:0];
//    NSString *filePath = [fileDirectory stringByAppendingPathComponent:@"/timelines/Train Lights.sub"];
    NSString *subFile = [[self.movieFileName stringByDeletingPathExtension] stringByAppendingPathExtension:@"sub"];
    NSString *filePath = [FileHelper documentsPath:[NSString stringWithFormat:@"/%@/%@", TIMELINE_FOLDER, subFile]];
    NSLog(@"%@", filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        CJSONDeserializer *deserializer = [CJSONDeserializer deserializer];
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *dic = [deserializer deserializeAsDictionary:data error:&error];
        if (error) {
            NSLog(@"%@", [error description]);
            [self mockupSubtitle];
        } else {
            Subtitle *sub = [Subtitle initWithDictionary:dic];
            self.subtitle = sub;
            [sub release];
        }
    } else {
        [self mockupSubtitle];
    }
}

- (void) mockupSubtitle {
    NSLog(@"using mockup subtitle");
    _subtitle.name = @"I am the best";
    
    Timeline *timeline1 = [[Timeline alloc] init];
    timeline1.index = 0;
    timeline1.time = 0;
    timeline1.text = [NSString stringWithFormat:@"text sub 1 set at time : %.2f", timeline1.time]; 
    [_subtitle.listTimes addObject:timeline1];
    [timeline1 release];
    
    Timeline *timeline2 = [[Timeline alloc] init];
    timeline2.index = 1;
    timeline2.time = 5;
    timeline2.text = [NSString stringWithFormat:@"text sub 2 set at time : %.2f", timeline2.time]; 
    [_subtitle.listTimes addObject:timeline2];
    [timeline2 release];
    
    Timeline *timeline3 = [[Timeline alloc] init];
    timeline3.index = 2;
    timeline3.time = 20;
    timeline3.text = [NSString stringWithFormat:@"text sub 3 set at time : %.2f", timeline3.time]; 
    [_subtitle.listTimes addObject:timeline3];
    [timeline3 release];
    
    Timeline *timeline4 = [[Timeline alloc] init];
    timeline4.index = 3;
    timeline4.time = 30;
    timeline4.text = [NSString stringWithFormat:@"text sub 4 set at time : %.2f", timeline4.time]; 
    [_subtitle.listTimes addObject:timeline4];
    [timeline4 release];
    
    Timeline *timeline5 = [[Timeline alloc] init];
    timeline5.index = 4;
    timeline5.time = 40;
    timeline5.text = [NSString stringWithFormat:@"text sub 5 set at time : %.2f", timeline5.time]; 
    [_subtitle.listTimes addObject:timeline5];
    [timeline5 release];
    
    Timeline *timeline6 = [[Timeline alloc] init];
    timeline6.index = 5;
    timeline6.time = 50;
    timeline6.text = [NSString stringWithFormat:@"text sub 6 set at time : %.2f", timeline6.time]; 
    [_subtitle.listTimes addObject:timeline6];
    [timeline6 release];
    
    Timeline *timeline7 = [[Timeline alloc] init];
    timeline7.index = 6;
    timeline7.time = 60;
    timeline7.text = [NSString stringWithFormat:@"text sub 7 set at time : %.2f", timeline7.time]; 
    [_subtitle.listTimes addObject:timeline7];
    [timeline7 release];
}

- (void)resetTimeLine {
    [_movieController stop];
    for (Timeline *t in _subtitle.listTimes) {
        t.time = 0;
        t.index = 0;
    }
    _currentIndex = 0;
    _currentTime = 0;
    [_tableView reloadData];
    
}
- (void)ceateSubtitleView
{
    self.currentPage = 0;
    UIView *subtitleView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SUBTITLE_VIEW, HEIGHT_SUBTITLE_VIEW)] autorelease];
    [subtitleView setBackgroundColor:[UIColor grayColor]];
    
    UIScrollView *videoSubScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SUBTITLE_VIEW, HEIGHT_SUBTITLE_VIEW)];
    videoSubScroll.delegate = self;
    
    [subtitleView addSubview:videoSubScroll];
    
    //create page view for subtitle view
    UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH_SUBTITLE_VIEW*self.currentPage, 0, WIDTH_SUBTITLE_VIEW - 5, HEIGHT_SUBTITLE_VIEW)];
    self.currentPageHeight = 0;
    self.currentPage++;
    videoSubScroll.contentSize = CGSizeMake(WIDTH_SUBTITLE_VIEW*self.currentPage, HEIGHT_SUBTITLE_VIEW);
    
    
    //[videoSubScroll addSubview:pageView];
    
    NSLog(@"-----------");
    CGSize maximumLabelSize = CGSizeMake(235,9999);
    

    for (Timeline *timeLine in self.subtitle.listTimes) {        
        UILabel *lvSub = [[UILabel alloc] init];
        lvSub.numberOfLines = 0;
        lvSub.lineBreakMode = UILineBreakModeWordWrap;
        CGSize size = [timeLine sizeOfTextWithFont:lvSub.font 
                                 constrainedToSize:maximumLabelSize 
                                     lineBreakMode:lvSub.lineBreakMode];
        
        if(size.height + self.currentPageHeight > HEIGHT_SUBTITLE_VIEW)
        {
            [videoSubScroll addSubview:pageView];
            [pageView release];
            pageView = nil;
            
            pageView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH_SUBTITLE_VIEW*self.currentPage, 0, WIDTH_SUBTITLE_VIEW - 5, HEIGHT_SUBTITLE_VIEW)];
            self.currentPageHeight = 0;
            self.currentPage++;
            videoSubScroll.contentSize = CGSizeMake(WIDTH_SUBTITLE_VIEW*self.currentPage, HEIGHT_SUBTITLE_VIEW);
        }else{
            [lvSub setFrame:CGRectMake(0, self.currentPageHeight, size.width, size.height)];
            lvSub.text = timeLine.text;
            [pageView addSubview:lvSub];
            self.currentPageHeight += size.height;
        }
        
        [lvSub release];
    }
    [videoSubScroll addSubview:pageView];
    [pageView release];
    pageView = nil;
    [self.view addSubview:subtitleView];
    
//    UILabel *lvTest = [[UILabel alloc] init];
//    lvTest.numberOfLines = 0;
//    lvTest.lineBreakMode = UILineBreakModeWordWrap;
//    lvTest.text = @"He hated the women of the City. That's why he could get off to watching them taking shits and pissing and splattering thick blood everywhere during 'that time of the month'.";
//    CGSize lvTestSize = [lvTest.text sizeWithFont:lvTest.font
//                                constrainedToSize:maximumLabelSize
//                                    lineBreakMode:lvTest.lineBreakMode];
//    
//    [lvTest setFrame:CGRectMake(0, 0, 240, lvTestSize.height)];
//    NSLog(@"%f----%f", lvTestSize.width, lvTestSize.height);
//    
//    UILabel *lvTest1 = [[UILabel alloc] init];
//    lvTest1.numberOfLines = 0;
//    lvTest1.text = @" He loved to be able to see them in their most private, their most guarded moments. Without all their expensive clothes, and most importantly, without them even knowing.";
//    CGSize lvTest1Size = [lvTest1.text sizeWithFont:lvTest1.font
//                                  constrainedToSize:maximumLabelSize
//                                      lineBreakMode:lvTest1.lineBreakMode];
//    [lvTest1 setFrame:CGRectMake(0, lvTestSize.height + 10, 240, lvTest1Size.height)];
//    
//    UILabel *lvTest2 = [[UILabel alloc] init];
//    lvTest2.numberOfLines = 0;
//    lvTest2.text = @"He gained privilege to how dirty and disgusting they really were when the bathroom door was shut tight behind them and they thought that no one was looking in. He came when it was a skinny petite chick taking a massive shit, that seemed to go on and on forever";
//    CGSize lvTest2Size = [lvTest2.text sizeWithFont:lvTest2.font
//                                  constrainedToSize:maximumLabelSize
//                                      lineBreakMode:lvTest2.lineBreakMode];
//    [lvTest2 setFrame:CGRectMake(0, lvTestSize.height + 10, 240, lvTest2Size.height)];
//    
//    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 300)];
//    view1.backgroundColor = [UIColor grayColor];
//    [view1 addSubview:lvTest];
//    [view1 addSubview:lvTest1];
//    [lvTest release];
//    [lvTest1 release];
//    [videoSubScroll addSubview:view1];
//    
//    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(241, 0, 240, 300)];
//    view2.backgroundColor = [UIColor whiteColor];
//    [videoSubScroll addSubview:view2];
//    
//    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(482, 0, 240, 300)];
//    view3.backgroundColor = [UIColor redColor];
//    //[view3 addSubview:lvTest];
//    [videoSubScroll addSubview:view3];

    
}
#pragma mark - UIEvent
- (IBAction)playButton_clicked:(id)sender {
    if (!_movieController.playbackState == MPMoviePlaybackStatePlaying) {
        [_movieController prepareToPlay];
        [_movieController play];
//        [_playButton setTitle:@"Pause"];
    } else {
        [_movieController pause];
//        [_playButton setTitle:@"Play"];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(moviePlayBackDidChange:) 
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification 
                                               object:nil];
}



- (void)moviePlayBackDidChange:(NSNotification*)notification {
    if (_movieController.playbackState == MPMoviePlaybackStatePlaying) {
        _currentTime = floor(_movieController.currentPlaybackTime);
        NSLog(@"SDSD:%f", _currentTime);
        [self startTimer];
    } else {
        [self stopTimer];
    }
//    [_playButton setTitle:@"Play"];
}


- (IBAction)nextButton_clicked:(id)sender {
    if ((_currentIndex + 1) == [_subtitle.listTimes count]) {
        //sync xong
        //start - Luu xuong Json
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *fileDirectory = [paths objectAtIndex:0];
        NSString *filePath = [fileDirectory stringByAppendingPathComponent:@"iamthebest.sub"];
        CJSONSerializer *serializer = [CJSONSerializer serializer];
        NSError *error;
        NSData *jsonData = [serializer serializeDictionary:[_subtitle toDictionary] error:&error];
        if (error) {
            NSLog(@"%@", [error description]);
        } else {
            [jsonData writeToFile:filePath atomically:YES];
        }
        //End
        _currentIndex = 0;
        _currentTime = 0;
        [_tableView reloadData];
        if (_movieController.playbackState == MPMoviePlaybackStatePlaying) {
            [_movieController setCurrentPlaybackTime:[_movieController endPlaybackTime]];
            //[_movieController play];
        } else {
            [_movieController setCurrentPlaybackTime:[_movieController endPlaybackTime]];
            //[_movieController play];
        }
    } else {
        Timeline *timeLine = [_subtitle.listTimes objectAtIndex:_currentIndex];
        timeLine.index = _currentIndex;
        timeLine.time = floor(_movieController.currentPlaybackTime);
        _currentIndex ++;
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [_tableView reloadData];

    }
}


- (IBAction)doneButton_clicked:(id)sender {
    [self resetTimeLine];
}


#pragma mark - Timer
- (void)startTimer {
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                  target: self
                                                selector:@selector(changeTime)
                                                userInfo: nil repeats:YES];
}
- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}


- (void)changeTime {
    _currentTime += 1.0;
    Timeline *timeline;
    if (_currentIndex + 1 >= [_subtitle.listTimes count]) {
        timeline = [_subtitle.listTimes objectAtIndex:_currentIndex];
    } else {
        timeline = [_subtitle.listTimes objectAtIndex:_currentIndex + 1];
    }
    NSLog(@"Time:%f", _currentTime);
    NSLog(@"%f", floor(timeline.time));
    NSLog(@"curr index = %d",_currentIndex);
    if (floor(timeline.time) == _currentTime) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [_tableView reloadData];
        _currentIndex ++;
        if (_currentIndex >= [_subtitle.listTimes count]) {
            [self stopTimer];
        }
    }
}

#pragma mark - UITableViewDatasource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return _data.title;
    } else {
        return @"";
    }
}


- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_subtitle.listTimes count];
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self stopTimer];
    _currentIndex = indexPath.row;
    Timeline *timeline = [_subtitle.listTimes objectAtIndex:_currentIndex];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [_tableView reloadData];
    _currentTime = timeline.time;
    _movieController.currentPlaybackTime = _currentTime;
    [self startTimer];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIndentifier = @"subtitleCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Timeline *timeline = [_subtitle.listTimes objectAtIndex:indexPath.row];
    cell.textLabel.text = timeline.text;
    cell.textLabel.textColor = [UIColor whiteColor];
    if (indexPath.row == _currentIndex) {
        cell.textLabel.textColor = [UIColor blueColor];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDecelerating");
    
    [self scrollViewDidEndDecelerating:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    
    CGPoint currentloca = scrollView.contentOffset;
    if(currentloca.x < 0)
        [scrollView scrollRectToVisible:CGRectMake(0, 0, 240, 300) animated:YES];
    int temp = (int)currentloca.x % 240;
    int indexSub = (int)currentloca.x / 240;
    NSLog(@"%d----%d", temp, indexSub);
    if(temp >= 240/2){
        //[scrollView setContentOffset:CGPointMake((indexSub+1)*240, 0)];
        [scrollView scrollRectToVisible:CGRectMake((indexSub+1)*240, 0, 240, 300) animated:YES];
    }else{
        //[scrollView setContentOffset:CGPointMake(indexSub*240, 0)];
        [scrollView scrollRectToVisible:CGRectMake(indexSub*240, 0, 240, 300) animated:YES];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging");
    CGPoint currentloca = scrollView.contentOffset;
    if(currentloca.x < 0)
        [scrollView scrollRectToVisible:CGRectMake(0, 0, 240, 300) animated:YES];
    int temp = (int)currentloca.x % 240;
    int indexSub = (int)currentloca.x / 240;
    NSLog(@"%d----%d", temp, indexSub);
    if(temp >= 240/2){
        //[scrollView setContentOffset:CGPointMake((indexSub+1)*240, 0)];
        [scrollView scrollRectToVisible:CGRectMake((indexSub+1)*240, 0, 240, 300) animated:YES];
    }else{
        //[scrollView setContentOffset:CGPointMake(indexSub*240, 0)];
        [scrollView scrollRectToVisible:CGRectMake(indexSub*240, 0, 240, 300) animated:YES];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
    CGPoint currentloca = scrollView.contentOffset;
    if(currentloca.x < 0)
        [scrollView scrollRectToVisible:CGRectMake(0, 0, 240, 300) animated:YES];
}
@end
