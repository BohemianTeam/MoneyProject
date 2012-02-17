//
//  AlertManager.h
//  iBack
//
//  Created by bohemian on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol FileSelectionAlertDelegate;
enum alertType {
    aError = 0,
    aRename = 1,
    aFileSelection = 2,
    aPickName = 3,
    aSignIn = 4,
};

@interface AlertManager : NSObject <UIAlertViewDelegate>{
    NSInteger   type;
    id<FileSelectionAlertDelegate>  fileSelectionDelegate;
}
@property(nonatomic, assign)id<FileSelectionAlertDelegate>  fileSelectionDelegate;
@property(nonatomic, assign)NSInteger   type;
+ (AlertManager*)sharedManager;

-(void)showAlert;
@end

@protocol FileSelectionAlertDelegate
@optional
- (void)pickName:(NSString*)name;
- (void)renameFileSelectionWithName:(NSString*)newName;
- (void)playFileSelection;
- (void)uploadToYoutube;
- (void)signinYoutube: (NSString*)user pass:(NSString*)pass;
@end