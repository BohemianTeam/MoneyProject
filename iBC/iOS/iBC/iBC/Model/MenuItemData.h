//
//  MenuItemData.h
//  iBC
//
//  Created by Cuong Tran on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItemData : NSObject {
    NSString            *_title;
    NSString            *_buttonImage;
}
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *buttonImage;
- (id) initWithTitle:(NSString *) title andButtonImage:(NSString *) img;
@end
