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
- (void)renameFileSelectionWithName:(NSString*)newName;
- (void)playFileSelection;
@end