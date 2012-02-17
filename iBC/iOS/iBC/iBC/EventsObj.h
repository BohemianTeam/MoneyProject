//
//  EventsObj.h
//  iBC
//
//  Created by bohemian on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseObj.h"
#import "ImageDownloader.h"
@interface EventsObj : ResponseObj<SetImageDelegate>
{
    UIImage     *imgLogo;
}
@property(nonatomic, retain)UIImage     *imgLogo;

- (NSString*)getTitle;
- (NSString*)getName;
- (NSString*)getDates;
- (NSString*)getPrice;
- (NSString*)getLogoUrl;


@end
