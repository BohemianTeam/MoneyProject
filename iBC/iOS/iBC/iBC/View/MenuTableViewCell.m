//
//  MenuTableViewCell.m
//  iBC
//
//  Created by Cuong Tran on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "MenuItemData.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation MenuTableViewCell
@synthesize button = _button;
@synthesize label = _label;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
        [self addSubview:_bg];
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 55)];
        [_bg addSubview:_button];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 220, 55)];
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = UITextAlignmentLeft;
        _label.textColor = UIColorFromRGB(0x266A85);
        _label.font = [UIFont boldSystemFontOfSize:16];
        [_bg addSubview:_label];
    }
    return self;
}

- (void) setMenuData:(MenuItemData *)data isEvenRow:(BOOL)isEven {
    _data = [data retain];
    [_button setImage:[UIImage imageNamed:data.buttonImage] forState:UIControlStateNormal];
    
    _label.text = data.title;
    if (!isEven) {
        _bg.backgroundColor = UIColorFromRGB(0xC4E1EE);
    } else {
        _bg.backgroundColor = UIColorFromRGB(0x9ACDE2);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) dealloc {
    [_button release];
    [_label release];
    [_bg release];
}

@end
