//
//  config.h
//  iBC
//
//  Created by Cuong Tran on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef iBC_config_h
#define iBC_config_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//API request
#define Kinectia                @"i"
#define UTCTime                 @"d"
#define Hash                    @"h"
#define Platform                @"p"
#define PlatformVersion         @"v"
#define ScreenResolution        @"r"
#define AppVersion              @"a"
#define VenueCode               @"vc"
#define EventCode               @"ec"

//API response
#define InstID                  @"instID"
#define VenuesArray             @"v"
#define EventsArray             @"e"
#define VenueName               @"vn"
#define Logo                    @"ic"
#define Distance                @"di"
#define City                    @"ct"
#define Price                   @"pr"
#define Dates                   @"dt"
#define Title                   @"et"
#define Description             @"ds"
#define Address                 @"ad"
#define Phone                   @"ph"
#define Email                   @"em"
#define WebAdd                  @"url"
#define Images                  @"imgs"
#define Genre                   @"gn"
#define Synopsis                @"sy"
#define InfoBlocks              @"ib"
#define Coordinates             @"cd"

//Main Menu
#define EventMenu               @"ESPECTACLES"
#define VenueMenu               @"ESPAIS"
#define CalendarMenu            @"AGENDA"
#define VenueDictanceMenu           @"A PROP"
#define StarredMenu                 @"FAVORITS"

#define kAppInstall @"InstallationID"
#define API_URL @"http://ws.kinectia.com/public/api/v1"
#define API_IMG_URL @"http://media.totteatre.cat"
#define HASH_ALGORITHM @"HMACSHA256"
#define SECRET_KEY @"xaDEUfq6R8j3464sWrIjicaOoWsj1c17PkhWbqf6V9ygfXAjIuV4bY9DL9mFSx1"
#define KinectiaAppId @"rd4Gds"

#define WIDTH_VIEW  320
#define HEIGHT_VIEW 480
//Venue Size
#define WIDTH_VENUE_LOGO 120
#define HEIGHT_VENUE_LOGO 50

//Event size
#define WIDTH_EVENT_LOGO 40
#define HEIGHT_EVENT_LOGO 60

#define WIDTH_IMG_VIDEO 60
#define HEIGHT_IMG_VIDEO 50

#define ROW_HEIGHT 55
#define SECTION_HEIGHT 36

#define VENUE_CELL_HEIGHT 70
#define EVENT_CELL_HEIGHT 100

//using for MAP
#define METERS_PER_MILE 1609.344
#endif
