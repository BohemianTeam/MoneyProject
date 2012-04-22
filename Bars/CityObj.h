//
//  CityObj.h
//  Bars
//
//  Created by bohemian on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityObj : NSObject
{
    NSInteger           cityID;
    NSInteger           stateID;
    NSString            *cityName;
    NSString            *cityPrice;
    BOOL                isCompleted;
    BOOL                isWishlist;
    
}
@property(nonatomic, readonly)NSString            *cityName;
@property(nonatomic, readonly)NSString            *cityPrice;
@property(nonatomic, readonly)NSInteger           cityID;
@property(nonatomic, readonly)NSInteger           stateID;
@property(nonatomic, assign)BOOL                  isCompleted;
@property(nonatomic, assign)BOOL                  isWishlist;

- (id)initWithID:(NSInteger)cityId stateID:(NSInteger)stateId name:(NSString*)name price:(NSString*)price complete:(BOOL)comp wish:(BOOL)wish;

- (NSString*)getName;
@end
