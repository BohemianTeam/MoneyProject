//
//  FileViewCell.m
//  iBack
//
//  Created by bohemian on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FileViewCell.h"

@implementation FileViewCell
@synthesize lbFileNumber;
@synthesize lbFileName;
@synthesize lbFileDuration;
@synthesize btnSelectedBox;
@synthesize isSelected;
@synthesize customCellDelegate;
@synthesize fileType;
@synthesize imvFileType;

#define LEFT_MARGIN 5
#define TOP_MARGIN 5
#define HEIGHT_OF_CELL 40
#define LEFT_MARGIN_EDIT_MODE 45

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initViewCell];
    }
    return self;
}
- (void)initViewCell
{   
    UIFont *font = [UIFont fontWithName:@"Arial" size:20];
    lbFileNumber = [[[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN, TOP_MARGIN, 50, HEIGHT_OF_CELL)] autorelease];
    [lbFileNumber setText:@"0"];
    [lbFileNumber setFont:font];
    lbFileNumber.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [self addSubview:lbFileNumber];
    
    lbFileName = [[[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN + 25, TOP_MARGIN, 160, HEIGHT_OF_CELL)] autorelease];
    [lbFileName setFont:font];
    [lbFileName setText:@""];
    lbFileName.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [self addSubview:lbFileName];
    
    //set image for type file
    imvFileType = [[[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN + 190, TOP_MARGIN+5, 30, 30)] autorelease];
    [self addSubview:imvFileType];
    //set duration
    lbFileDuration = [[[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN + 225, TOP_MARGIN, 100, HEIGHT_OF_CELL)] autorelease];
    [lbFileDuration setFont:font];
    [lbFileDuration setText:@"0.0"];
    lbFileDuration.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [self addSubview:lbFileDuration];
    
    
    btnSelectedBox = [[UIButton alloc] initWithFrame:CGRectMake(LEFT_MARGIN, TOP_MARGIN, 40, HEIGHT_OF_CELL)];
    [btnSelectedBox setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
    [btnSelectedBox setImage:[UIImage imageNamed:@"selected3"] forState:UIControlStateSelected];
    [btnSelectedBox addTarget:self action:@selector(checkboxClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)checkboxClick
{
    if(!isSelected)
        [customCellDelegate selectedDeleteCell:lbFileNumber.text];
    else{
        [customCellDelegate unselectedDeleteCell:lbFileNumber.text];
    }

    isSelected = !isSelected;
    [btnSelectedBox setSelected:isSelected];

}
- (void)changeToEditMode
{
    [lbFileNumber setFrame:CGRectMake(LEFT_MARGIN_EDIT_MODE, TOP_MARGIN, 50, HEIGHT_OF_CELL)];
    [lbFileName setFrame:CGRectMake(LEFT_MARGIN_EDIT_MODE + 25, TOP_MARGIN, 200, HEIGHT_OF_CELL)];
    [self addSubview:btnSelectedBox];
}
- (void)changeToDoneMode
{
    [lbFileNumber setFrame:CGRectMake(LEFT_MARGIN, TOP_MARGIN, 50, HEIGHT_OF_CELL)];
    [lbFileName setFrame:CGRectMake(LEFT_MARGIN + 25, TOP_MARGIN, 200, HEIGHT_OF_CELL)];
    [btnSelectedBox removeFromSuperview];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc
{
    [btnSelectedBox release];
    [lbFileName release];
    [lbFileDuration release];
    [lbFileNumber release];
    [super dealloc];
}
@end
