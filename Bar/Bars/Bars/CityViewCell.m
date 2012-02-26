//
//  CityViewCell.m
//  Bars
//
//  Created by bohemian on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CityViewCell.h"
#import "CityObj.h"
@implementation CityViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        cityID = 0;
        isWish = FALSE;
        
        btnWish = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
        [btnWish setBackgroundImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        [btnWish setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
        [btnWish addTarget:self action:@selector(btnWishPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnWish];
        [btnWish release];
        
        //set name
        lbName = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 50)];
        [self addSubview:lbName];
        [lbName release];
        
        //set Price
        lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(250, 0, 70, 50)];
        [self addSubview:lbPrice];
        [lbPrice release];
    }
    return self;
}
- (void)btnWishPressed
{
    if(isWish)
    {
        [btnWish setSelected:NO];
        //remove wish from database
    }else
    {
        [btnWish setSelected:YES];
        //add wish
    }
    
    isWish = !isWish;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setData:(CityObj*)city
{
    cityID = city.cityID;
    [btnWish setSelected:city.isWishlist];
    lbName.text = city.cityName;
    lbPrice.text = city.cityPrice;
}

- (void)dealloc
{
    [btnWish release];
    [lbName release];
    [lbPrice release];
    [super dealloc];
}
@end
