//
//  VenuesObj.h
//  iBC
//
//  Created by bohemian on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseObj.h"
#import "ImageDownloader.h"

@interface VenuesObj : ResponseObj<SetImageDelegate>
{
    UIImage     *imgLogo;
}
@property(nonatomic, retain)UIImage     *imgLogo;

- (NSString*)getName;
- (NSString*)getDistanceOrCity;
- (NSString*)getAddress;
- (NSString*)getVenueCode;
- (NSString*)getLogoUrl;
- (NSString*)getDescription;
- (NSString*)getWeb;
- (NSString*)getEmail;
- (NSString*)getPhone;
- (NSString*)getCoordinates;
- (NSArray*)getImgs;
@end
