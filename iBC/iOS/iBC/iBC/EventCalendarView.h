//
//  EventCalendarView.h
//  iBC
//
//  Created by bohemian on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KalViewController;

@interface EventCalendarView : UIViewController
{
    KalViewController   *kal;
    id                  dataSource;
    NSString            *eventCode;
    NSMutableArray      *eventSessionArray;
    Service             *service;
    BOOL                haveData;
}
@property(nonatomic, retain)NSString            *eventCode;
- (void)getDataFromServer;
@end
