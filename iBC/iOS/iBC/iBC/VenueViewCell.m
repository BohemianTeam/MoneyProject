//
//  VenueViewCell.m
//  iBC
//
//  Created by bohemian on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VenueViewCell.h"
#import "VenuesObj.h"



@implementation VenueViewCell
@synthesize imgViewLogo;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //logo view
        imgViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 50)];
        [self addSubview:imgViewLogo];
        
        //name view
        lbName = [[UILabel alloc] initWithFrame:CGRectMake(140, 15, 160, 20)];
        lbName.textColor = UIColorFromRGB(0x53a8cc);
        lbName.font = [UIFont fontWithName:@"Arial" size:18];
        [self addSubview:lbName];
        
        //address view
        lbAddress = [[UILabel alloc] initWithFrame:CGRectMake(140, 30, 200, 20)];
        lbAddress.textColor = UIColorFromRGB(0x666666);
        lbAddress.font = [UIFont fontWithName:@"Arial" size:14];
        [self addSubview:lbAddress];
    }
    return self;
}
- (void)setupData: (VenuesObj*)data
{
    lbName.text = [data getName];
    lbAddress.text = [data getAddress];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc
{
    [imgViewLogo release];
    [lbAddress release];
    [lbName release];
    [super dealloc];
}
@end
