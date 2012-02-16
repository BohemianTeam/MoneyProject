//
//  VenueViewCell.h
//  iBC
//
//  Created by bohemian on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VenuesObj;

@interface VenueViewCell : UITableViewCell
{
    UIImageView         *imgViewLogo;
    UILabel             *lbName;
    UILabel             *lbAddress;
}

- (void)setupData: (VenuesObj*)data;
@end
