//
//  Bar.h
//  Bars
//
//  Created by Cuong Tran on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bar : NSObject
{
    NSInteger       barID;
    NSInteger       cityID;
    NSString        *barName;
    NSString        *barAddress;
    NSString        *barInfo;
    NSString        *barLocation;
}
@property(nonatomic, readonly)NSInteger       barID;
@property(nonatomic, readonly)NSInteger       cityID;
@property(nonatomic, readonly)NSString        *barName;
@property(nonatomic, readonly)NSString        *barAddress;
@property(nonatomic, readonly)NSString        *barInfo;
@property(nonatomic, retain)NSString          *barLocation;

- (id)initWithID:(NSInteger)barId cityID:(NSInteger)cityId name:(NSString*)name address:(NSString*)addr info:(NSString*)info location:(NSString*)loca;
@end
