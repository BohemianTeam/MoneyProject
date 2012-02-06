//
//  MenuItemData.m
//  iBC
//
//  Created by Cuong Tran on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuItemData.h"

@implementation MenuItemData
@synthesize buttonImage = _buttonImage;
@synthesize title = _title;
- (id) initWithTitle:(NSString *)title andButtonImage:(NSString *)img {
    self = [super init];
    if (self) {
        self.title = title;
        self.buttonImage = img;
    }
    return self;
}


- (void) dealloc {
    [_title release];
    [_buttonImage release];
    [super dealloc];
}
@end
