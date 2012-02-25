//
//  CalendarViewController.h
//  iBC
//
//  Created by bohemian on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KalView.h"
#import "KalDataSource.h"
@class KalDate;

@interface CalendarViewController : UIViewController<KalViewDelegate, KalDataSourceCallbacks>
{
    KalView             *calendarView;
    KalLogic            *logic;
    id <KalDataSource>  dataSource;
    
    KalDate             *selectedDates;
    
    BOOL                isFirst;
}
- (id) initWithTitle:(NSString *) title;
@property (nonatomic, assign) id<KalDataSource> dataSource;
@property (nonatomic, retain, readonly) NSDate *selectedDate;
@end
