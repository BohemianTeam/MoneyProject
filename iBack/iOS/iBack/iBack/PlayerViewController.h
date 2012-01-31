//
//  PlayerViewController.h
//  iBack
//
//  Created by bohemian on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PlayerViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    MPMoviePlayerViewController *playerView;
    NSString                    *pathVideo;
    float rate;
}
@property(nonatomic, retain) MPMoviePlayerViewController *playerView;
@property(nonatomic, retain) NSString                    *pathVideo;
@property(nonatomic, assign) float rate;

@end
