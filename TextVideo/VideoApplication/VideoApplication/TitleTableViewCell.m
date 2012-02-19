//
//  TitleTableViewCell.m
//  VideoApplication
//
//  Created by Cuong Tran on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TitleTableViewCell.h"
#import <AVFoundation/AVAsset.h>
#import "VideoData.h"
@implementation TitleTableViewCell
@synthesize title = _title;
@synthesize details = _details;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 44)];
        _title.backgroundColor = [UIColor clearColor];
        _title.font = [UIFont systemFontOfSize:16];
        _title.textAlignment = UITextAlignmentLeft;
        [self addSubview:_title];
        
        _details = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 100, 44)];
        _details.backgroundColor = [UIColor clearColor];
        _details.font = [UIFont systemFontOfSize:14];
        _details.textAlignment = UITextAlignmentRight;
        [self addSubview:_details];
        
    }
    return self;
}

- (void) setData:(VideoData *)data {
//    _data = [data retain];
////    AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:data.url] options:nil];
////    CMTime duration = videoAsset.duration;
////    float secDuration = CMTimeGetSeconds(duration);
//    
//    _title.text = _data.title;
//    _details.text = _data.desc;
}

- (void) dealloc {
    [_title release];
    [_details release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
