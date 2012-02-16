//
//  EventViewCell.m
//  iBC
//
//  Created by bohemian on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventViewCell.h"

@implementation EventViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //title view
        lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 25)];
        lbTitle.textColor = UIColorFromRGB(0x53a8cc);
        lbTitle.font = [UIFont fontWithName:@"Arial" size:18];
        [self addSubview:lbTitle];
        
        //logo view
        imgViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 40, 60)];
        [self addSubview:imgViewLogo];       
        
        //name view
        lbName = [[UILabel alloc] initWithFrame:CGRectMake(60, 45, 200, 20)];
        lbName.textColor = UIColorFromRGB(0x666666);
        lbName.font = [UIFont fontWithName:@"Arial" size:16];
        [self addSubview:lbName];
        
        //dates view
        lbDates = [[UILabel alloc] initWithFrame:CGRectMake(60, 65, 200, 20)];
        lbDates.textColor = UIColorFromRGB(0x666666);
        lbDates.font = [UIFont fontWithName:@"Arial" size:16];
        [self addSubview:lbDates];
        
        //address view
        lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(200, 65, 80, 20)];
        lbPrice.textAlignment = UITextAlignmentRight;
        lbPrice.textColor = UIColorFromRGB(0xCC3366);
        lbPrice.font = [UIFont fontWithName:@"Arial" size:16];
        [self addSubview:lbPrice];
    }
    return self;
}

- (void)setupData: (EventsObj*)data
{

    imgViewLogo.image = [UIImage imageNamed:@"eventTest.jpg"];// data.imgLogo;
    lbTitle.text = [data getTitle];
    lbName.text = [data getName];
    lbPrice.text = @"test";//[data getPrice];
    lbDates.text = [data getDates];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)dealloc
{
    [imgViewLogo release];
    [lbTitle release];
    [lbName release];
    [lbDates release];
    [lbPrice release];
    [super dealloc];
}

@end
