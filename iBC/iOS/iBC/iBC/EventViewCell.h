//
//  EventViewCell.h
//  iBC
//
//  Created by bohemian on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsObj.h"

@interface EventViewCell : UITableViewCell
{
    UIImageView         *imgViewLogo;
    UILabel             *lbTitle;
    UILabel             *lbName;
    UILabel             *lbDates;
    UILabel             *lbPrice;
}
@property(nonatomic, retain)UIImageView         *imgViewLogo;
- (void)setupData: (EventsObj*)data;
@end
