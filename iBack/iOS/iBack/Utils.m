//
//  Utils.m
//  iBack
//
//  Created by bohemian on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import "iBackSettings.h"
#import "GDataServiceGoogleYouTube.h"
#import "GDataEntryYouTubeUpload.h"

@interface Utils (private)
- (GDataServiceTicket *)uploadTicket;
- (void)setUploadTicket:(GDataServiceTicket *)ticket;
- (GDataServiceGoogleYouTube *)youTubeService;
- (void)ticket:(GDataServiceTicket *)ticket hasDeliveredByteCount:(unsigned long long)numberOfBytesRead 
ofTotalByteCount:(unsigned long long)dataLength;
@end

@implementation Utils
@synthesize user, pass;

//create singleton object
static Utils * __sharedUtils = nil;
+ (Utils*) sharedUtils
{
	if (__sharedUtils == nil) {
		[[self alloc] init];
        //[__sharedHelper initFileHelper];
	}
    return __sharedUtils;
}
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (__sharedUtils == nil) {
            __sharedUtils = [super allocWithZone:zone];
            return __sharedUtils;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (id)autorelease {
    return self;
}
//- (void)dealloc
//{
//    [super dealloc];
//}

#pragma mark upload video to youtube
- (void)uploadYoutube:(NSString*)filePath withUser:(NSString*)username withPass:(NSString*)password
{
//    if(user != nil)
//        [user release];
//    if(pass != nil)
//        [pass release];
    user = @"scorpius2710sg";
    pass = @"scor-hg0209";
    
    GDataServiceGoogleYouTube *service = [self youTubeService];
    [service setYouTubeDeveloperKey:DEVELOPER_KEY];
    
    
    
    NSURL *url = [GDataServiceGoogleYouTube youTubeUploadURLForUserID:user
                                                             clientID:CLIENT_ID];
    
    // load the file data
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *filename = [filePath lastPathComponent];
    
    // gather all the metadata needed for the mediaGroup
    NSString *titleStr = @"Test video";
    GDataMediaTitle *title = [GDataMediaTitle textConstructWithString:titleStr];
    
    NSString *categoryStr = @"Entertainment";
    GDataMediaCategory *category = [GDataMediaCategory mediaCategoryWithString:categoryStr];
    [category setScheme:kGDataSchemeYouTubeCategory];
    
    NSString *descStr = @"This is test upload video";
    GDataMediaDescription *desc = [GDataMediaDescription textConstructWithString:descStr];
    
    NSString *keywordsStr = @"key world for this app";
    GDataMediaKeywords *keywords = [GDataMediaKeywords keywordsWithString:keywordsStr];
    
    
    
    GDataYouTubeMediaGroup *mediaGroup = [GDataYouTubeMediaGroup mediaGroup];
    [mediaGroup setMediaTitle:title];
    [mediaGroup setMediaDescription:desc];
    [mediaGroup addMediaCategory:category];
    [mediaGroup setMediaKeywords:keywords];
    [mediaGroup setIsPrivate:NO];
    
    NSString *mimeType = [GDataUtilities MIMETypeForFileAtPath:filePath
                                               defaultMIMEType:@"video/mov"];
    
    // create the upload entry with the mediaGroup and the file data
    GDataEntryYouTubeUpload *entry;
    entry = [GDataEntryYouTubeUpload uploadEntryWithMediaGroup:mediaGroup
                                                          data:data
                                                      MIMEType:mimeType
                                                          slug:filename];
    
    SEL progressSel = @selector(ticket:hasDeliveredByteCount:ofTotalByteCount:);
    [service setServiceUploadProgressSelector:progressSel];
    
    GDataServiceTicket *ticket;
    ticket = [service fetchEntryByInsertingEntry:entry
                                      forFeedURL:url
                                        delegate:self
                               didFinishSelector:@selector(uploadTicket:finishedWithEntry:error:)];
    
    //[self setUploadTicket:ticket];
}
// get a YouTube service object with the current username/password
//
// A "service" object handles networking tasks.  Service objects
// contain user authentication information as well as networking
// state information (such as cookies and the "last modified" date for
// fetched data.)

- (GDataServiceGoogleYouTube *)youTubeService {
    
    static GDataServiceGoogleYouTube* service = nil;
    
    if (!service) {
        service = [[GDataServiceGoogleYouTube alloc] init];
        
        [service setShouldCacheDatedData:YES];
        [service setServiceShouldFollowNextLinks:YES];
        [service setIsServiceRetryEnabled:YES];
    }
    
    // fetch unauthenticated
    [service setUserCredentialsWithUsername:user
                                   password:pass];
    
    [service setYouTubeDeveloperKey:DEVELOPER_KEY];
    
    return service;
}

// progress callback
- (void)ticket:(GDataServiceTicket *)ticket hasDeliveredByteCount:(unsigned long long)numberOfBytesRead 
ofTotalByteCount:(unsigned long long)dataLength {
    
    //[mProgressView setProgress:(double)numberOfBytesRead / (double)dataLength];
}

// upload callback
- (void)uploadTicket:(GDataServiceTicket *)ticket
   finishedWithEntry:(GDataEntryYouTubeVideo *)videoEntry
               error:(NSError *)error {
//    if (error == nil) {
//        // tell the user that the add worked
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uploaded!"
//                                                        message:[NSString stringWithFormat:@"%@ succesfully uploaded", 
//                                                                 [[videoEntry title] stringValue]]                    
//                                                       delegate:nil 
//                                              cancelButtonTitle:@"Ok" 
//                                              otherButtonTitles:nil];
//        
//        [alert show];
//        [alert release];
//    } else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
//                                                        message:[NSString stringWithFormat:@"Error: %@", 
//                                                                 [error description]] 
//                                                       delegate:nil 
//                                              cancelButtonTitle:@"Ok" 
//                                              otherButtonTitles:nil];
//        
//        [alert show];
//        [alert release];
//    }
    
    //[self setUploadTicket:nil];
}

#pragma mark -
#pragma mark Setters

- (GDataServiceTicket *)uploadTicket {
    return mUploadTicket;
}

- (void)setUploadTicket:(GDataServiceTicket *)ticket {
    [mUploadTicket release];
    mUploadTicket = [ticket retain];
}
@end
