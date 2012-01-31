//
//  SettingViewController.h
//  iBack
//
//  Created by bohemian on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
{
    UIButton       *btnHD;
    UIButton       *btn480P;
    UIButton       *btnEcho;
    UIButton       *btnNormal;
    
    NSInteger       videoQuality;       //0-->HD, 1-->480P
    NSInteger       audioQuality;       //0-->echo, 1-->normal
}
@property(nonatomic, retain)UIButton       *btnHD;
@property(nonatomic, retain)UIButton       *btn480P;
@property(nonatomic, retain)UIButton       *btnEcho;
@property(nonatomic, retain)UIButton       *btnNormal;
@property(nonatomic, assign)NSInteger       videoQuality; 
@property(nonatomic, assign)NSInteger       audioQuality; 

- (void)btnQualityClick;
- (void)btnAudioQualityClick;
@end
