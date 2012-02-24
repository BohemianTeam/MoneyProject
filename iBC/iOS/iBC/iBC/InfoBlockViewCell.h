//
//  InfoBlockViewCell.h
//  iBC
//
//  Created by bohemian on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoBlockViewCell : UITableViewCell
{
    UILabel     *titleInfo;
    UIView      *bgColor;
}
@property(nonatomic, retain)UILabel     *titleInfo;

- (void)setTitle:(NSString *)title evenRow:(BOOL)flag;
@end
