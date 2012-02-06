//
//  TitleTableViewCell.h
//  VideoApplication
//
//  Created by Cuong Tran on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoData;
@interface TitleTableViewCell : UITableViewCell {
    UILabel                     *_title;
    UILabel                     *_details;
    VideoData                   *_data;
}
@property (nonatomic, retain) VideoData * data;
- (void) setData:(VideoData *)data;
@end
