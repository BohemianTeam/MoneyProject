//
//  MenuTableViewCell.h
//  iBC
//
//  Created by Cuong Tran on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuItemData;
@interface MenuTableViewCell : UITableViewCell {
    MenuItemData        *_data;
    UIColor             *_backgroudColor;
    UIView              *_bg;
    
    UIButton            *_button;
    UILabel             *_label;
}
@property (nonatomic ,retain) UIButton  *button;
@property (nonatomic, retain) UILabel   *label;
- (void) setMenuData:(MenuItemData *) data isEvenRow:(BOOL) isEven;
@end
