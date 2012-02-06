//
//  Subtitle.h
//  VideoSubtitle
//
//  Created by Cuong Tran on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Timeline.h"
@interface Subtitle : NSObject {
    NSString        *_name;
    NSMutableArray  *_listTimes;
}
@property (nonatomic, retain) NSString          *name;
@property (nonatomic, retain) NSMutableArray    *listTimes;

+ (Subtitle *)initWithDictionary:(NSDictionary *)dic;
- (NSMutableDictionary *)toDictionary;
@end
