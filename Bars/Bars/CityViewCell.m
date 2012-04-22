//
//  CityViewCell.m
//  Bars
//
//  Created by bohemian on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CityViewCell.h"
#import "CityObj.h"
#import "AppDatabase.h"
@implementation CityViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        cityID = 0;
        isWish = FALSE;
        
        btnWish = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
        [btnWish setBackgroundImage:[UIImage imageNamed:@"unwish"] forState:UIControlStateNormal];
        [btnWish setBackgroundImage:[UIImage imageNamed:@"wish"] forState:UIControlStateSelected];
        [btnWish addTarget:self action:@selector(btnWishPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnWish];
        
        //set name
        lbName = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 50)];
        lbName.backgroundColor = [UIColor clearColor];
        lbName.textColor = [UIColor whiteColor];
        [self addSubview:lbName];
        
        //set Price
        lbPrice = [[UILabel alloc] initWithFrame:CGRectMake(250, 0, 70, 50)];
        lbPrice.backgroundColor = [UIColor clearColor];
        lbPrice.textColor = [UIColor whiteColor];
        [self addSubview:lbPrice];
    }
    return self;
}
- (void)btnWishPressed
{
    if(isWish)
    {
        [btnWish setSelected:NO];
        //remove wish from database
        [[AppDatabase sharedDatabase] updateCity:cityID withWish:NO];
    }else
    {
        [btnWish setSelected:YES];
        //add wish
        [[AppDatabase sharedDatabase] updateCity:cityID withWish:YES];
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
    isWish = city.isWishlist;
    [btnWish setSelected:isWish];
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
