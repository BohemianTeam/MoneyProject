//
//  AlertManager.m
//  iBack
//
//  Created by bohemian on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AlertManager.h"

@implementation AlertManager
@synthesize type;
@synthesize fileSelectionDelegate;
static AlertManager *sharedAlertManager = nil;


+ (AlertManager*)sharedManager

{
	
    if (sharedAlertManager == nil) {
		
		sharedAlertManager = [[super allocWithZone:NULL] init];
        
		
    }
	
	
    return sharedAlertManager;
	
}
+ (id)allocWithZone:(NSZone *)zone

{
	
    return [[self sharedManager] retain];
	
}
- (id)copyWithZone:(NSZone *)zone

{
	
    return self;
	
}
- (id)retain

{
	
    return self;
	
}



- (NSUInteger)retainCount

{
	
    return NSUIntegerMax;
	
}



- (void)release

{
	
	
	
}



- (id)autorelease

{
	
    return self;
	
}

-(void)showAlert
{
    NSLog(@"show Alert");
    UIAlertView *alertView = nil;
    
    switch (type) {
        case aError:
            break;
        case aRename:
            alertView = [[UIAlertView alloc] initWithTitle:@"Rename File" message:@"\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
            
            //create name field
            UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(16, 60, 252, 30)];
            nameField.font = [UIFont systemFontOfSize:18];
            nameField.backgroundColor = [UIColor whiteColor];
            nameField.keyboardAppearance = UIKeyboardAppearanceAlert;
            nameField.tag = 999;
            [nameField becomeFirstResponder];
            
            [alertView addSubview:nameField];
            [alertView show];
            
            [nameField release];
            [alertView release];
            break;
        case aFileSelection:
            alertView = [[UIAlertView alloc] init];
            alertView.title = @"File Selection";
            alertView.delegate = self;
            [alertView addButtonWithTitle:@"Play"];            
            [alertView addButtonWithTitle:@"Upload Youtube"];
            [alertView addButtonWithTitle:@"Cancel"];
            [alertView setFrame:CGRectMake(20, 45, 245, 100)];
            
            [alertView show];
            [alertView release];
            break;
        default:
            break;
    }
}
#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *nameField = (UITextField*)[alertView viewWithTag:999];
    switch (type) {
        case aError:
            break;
        case aRename:
            if(buttonIndex == 0)
                NSLog(@"Cancel rename file");
            else{
                [fileSelectionDelegate renameFileSelectionWithName:nameField.text];
            }
            break;
        case aFileSelection:
            if(buttonIndex == 0)
                [fileSelectionDelegate playFileSelection];
            else if(buttonIndex == 1)
                [fileSelectionDelegate playFileSelection];
                
            break;
        default:
            break;
    }
}
@end
