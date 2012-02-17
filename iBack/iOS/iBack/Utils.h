//
//  Utils.h
//  iBack
//
//  Created by bohemian on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GData.h"
@interface Utils : NSObject
{
    //upload youtube
    GDataServiceTicket  *mUploadTicket;
    NSString            *user;
    NSString            *pass;
    
}
@property(nonatomic, retain)NSString            *user;
@property(nonatomic, retain)NSString            *pass;
+ (Utils*) sharedUtils;
- (void)uploadYoutube:(NSString*)filePath withUser:(NSString*)username withPass:(NSString*)password;
@end
