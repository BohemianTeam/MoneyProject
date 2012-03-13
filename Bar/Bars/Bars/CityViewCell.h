//
//  CityViewCell.h
//  Bars
//
//  Created by bohemian on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CityObj;
@interface CityViewCell : UITableViewCell
{
    NSInteger           cityID;
    BOOL                isWish;
    UIButton            *btnWish;
    UILabel             *lbName;
    UILabel             *lbPrice;
}

- (void)setData:(CityObj*)city;
- (void)btnWishPressed;
@end
