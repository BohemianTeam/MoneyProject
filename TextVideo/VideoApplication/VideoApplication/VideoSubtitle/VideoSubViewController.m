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
@interface VideoSubViewController()
- (void) mockupSubtitle;
@end
@implementation VideoSubViewController
@synthesize subtitle = _subtitle;
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
//    [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeRight;
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"Video View Controller";
//    _playButton.enabled = FALSE;
//    _doneButton.enabled = FALSE;
//    _nextButton.enabled = FALSE;`
    _currentIndex = 0;
    NSURL *localPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"LARVA_Electronic Shock" ofType:@"mp4"]];
    NSURL *videoUrl = localPath;//[NSURL URLWithString:videoPath];
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
    UIView *tempView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 300)] autorelease];
    [tempView setBackgroundColor:[UIColor blueColor]];
    
    UIScrollView *videoSubScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 240, 300)];
    videoSubScroll.contentSize = CGSizeMake(240*3, 300);
    videoSubScroll.delegate = self;
    [tempView addSubview:videoSubScroll];
    
    UITextView *tvTest1 = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 240, 300)];
    tvTest1.text = @"He hated the women of the City. That's why he could get off to watching them taking shits and pissing and splattering thick blood everywhere during 'that time of the month'. He loved to be able to see them in their most private, their most guarded moments. Without all their expensive clothes, and most importantly, without them even knowing. He gained privilege to how dirty and disgusting they really were when the bathroom door was shut tight behind them and they thought that no one was looking in. He came when it was a skinny petite chick taking a massive shit, that seemed to go on and on forever. Or the long thick stream of piss and the shit coming out together in unison at that the same time. Or a particularly clean- looking, brand-wearing heiress dribbling out or her ass a relentless stream of dirty diarrhea. Those times he would come so hard it would end up catapulting a few feet across and onto the coffee table.";
    tvTest1.bounces = YES;
    tvTest1.editable = NO;
    [videoSubScroll addSubview:tvTest1];
    
    UITextView *tvTest2 = [[UITextView alloc] initWithFrame:CGRectMake(241, 0, 240, 300)];
    tvTest2.text = @"I was told by my doctor that it was a scientific fact that people who talk to themselves during their waking day, they will have more of a tendency to hear voices in their sleep and will suffer from more listlessness and restlessness during their sleep.All the poor of the city. I watched him hastily collecting cardboard like kindling. Sunset comes closing in on him.The more I spent ringing people through it began dawning on me that life is a cash register. Or: Cash Register-Karma. One person pays with the bills and change that will then become the next persons change and with out even knowing it what was once yours has now become theirs. They have been connected quickly for that one transaction in time and space. Money their only tangible connection. And i am the only one to know it. I once wrote this poem or song about it. It goes:She came up crying, looked like she had been dying She still had to pay in cash, I was afraid to ask.He came up next, next to no clue Her tears his change been through";
    tvTest2.bounces = YES;
    tvTest2.editable = NO;
    [videoSubScroll addSubview:tvTest2];
    
    UITextView *tvTest3 = [[UITextView alloc] initWithFrame:CGRectMake(240*2+2, 0, 240, 300)];
    tvTest3.text = @"asdjfhjasd f";
    tvTest3.bounces = YES;
    tvTest3.editable = NO;
    [videoSubScroll addSubview:tvTest3];
    
    [self.view addSubview:tempView];
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileDirectory = [paths objectAtIndex:0];
    NSString *filePath = [fileDirectory stringByAppendingPathComponent:@"iamthebest.sub"];
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
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    
    CGPoint currentloca = scrollView.contentOffset;
    int temp = (int)currentloca.x % 240;
    int indexSub = (int)currentloca.x / 240;
    if(temp >= 240/2){
        [scrollView setContentOffset:CGPointMake((indexSub+1)*240, 0)];
    }else{
        [scrollView setContentOffset:CGPointMake(indexSub*240, 0)];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint currentloca = scrollView.contentOffset;
    int temp = (int)currentloca.x % 240;
    int indexSub = (int)currentloca.x / 240;
    if(temp >= 240/2){
        [scrollView setContentOffset:CGPointMake((indexSub+1)*240, 0)];
    }else{
        [scrollView setContentOffset:CGPointMake(indexSub*240, 0)];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
    
}
@end
