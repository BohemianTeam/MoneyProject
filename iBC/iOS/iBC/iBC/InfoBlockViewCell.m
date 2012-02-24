//
//  InfoBlockViewCell.m
//  iBC
//
//  Created by bohemian on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoBlockViewCell.h"

@implementation InfoBlockViewCell
@synthesize titleInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        bgColor = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 320, 40)];
        [self addSubview:bgColor];
        
        titleInfo = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 320, 50)];
        titleInfo.textColor = UIColorFromRGB(0x53a8cc);
        titleInfo.backgroundColor = [UIColor clearColor];
        [self addSubview:titleInfo];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setTitle:(NSString *)title evenRow:(BOOL)flag
{
    titleInfo.text = [title uppercaseString];
    if(flag)
    {
        bgColor.backgroundColor = UIColorFromRGB(0xC4E1EE);
    }else{
        bgColor.backgroundColor = UIColorFromRGB(0x9ACDE2);
    }
}
- (void)dealloc
{
    [bgColor release];
    [titleInfo release];
    [super dealloc];
}
@end
