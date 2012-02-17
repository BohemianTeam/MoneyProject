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
            [alertView addButtonWithTitle:@"Upload to Youtube"];
            [alertView addButtonWithTitle:@"Cancel"];
            [alertView setFrame:CGRectMake(20, 45, 245, 100)];
            
            [alertView show];
            [alertView release];
            break;
        case aPickName:
            alertView = [[UIAlertView alloc] initWithTitle:@"Enter file name" message:@"\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
            
            //create name field
            UITextField *nameF = [[UITextField alloc] initWithFrame:CGRectMake(16, 60, 252, 30)];
            nameF.font = [UIFont systemFontOfSize:18];
            nameF.backgroundColor = [UIColor whiteColor];
            nameF.keyboardAppearance = UIKeyboardAppearanceAlert;
            [nameF becomeFirstResponder];
            nameF.tag = 999;
            
            [alertView addSubview:nameF];
            [alertView show];
            
            [nameF release];
            [alertView release];
            break;
        case aSignIn:
            alertView = [[UIAlertView alloc] initWithTitle:@"Login Youtube" message:@"\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
            
            //create name field
            UITextField *txfUser = [[UITextField alloc] initWithFrame:CGRectMake(16, 60, 252, 30)];
            txfUser.font = [UIFont systemFontOfSize:18];
            txfUser.backgroundColor = [UIColor whiteColor];
            txfUser.keyboardAppearance = UIKeyboardAppearanceAlert;
            txfUser.tag = 999;
            txfUser.placeholder = @"Username";
            [txfUser becomeFirstResponder];
            
            UITextField *txfPass = [[UITextField alloc] initWithFrame:CGRectMake(16, 100, 252, 30)];
            txfPass.font = [UIFont systemFontOfSize:18];
            txfPass.backgroundColor = [UIColor whiteColor];
            txfPass.keyboardAppearance = UIKeyboardAppearanceAlert;
            txfPass.tag = 998;
            txfPass.placeholder = @"Password";
            txfPass.secureTextEntry = YES;
            
            [alertView addSubview:txfUser];
            [alertView addSubview:txfPass];
            [alertView show];
            
            [txfUser release];
            [txfPass release];
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
    UITextField *passField = (UITextField*)[alertView viewWithTag:998];
    switch (type) {
        case aError:
            break;
        case aRename:
            if(buttonIndex == 0)
                NSLog(@"Cancel rename file");
            else{
                if([nameField.text isEqual:@""])
                {
                    type = aRename;
                    [self showAlert];
                }else
                    [fileSelectionDelegate renameFileSelectionWithName:nameField.text];
            }
            break;
        case aFileSelection:
            if(buttonIndex == 0)
                [fileSelectionDelegate playFileSelection];
            else if(buttonIndex == 1)
                [fileSelectionDelegate uploadToYoutube];     
            break;
        case aPickName:
            if(buttonIndex == 0)
                NSLog(@"Cancel");
            else{
                if([nameField.text isEqual:@""])
                {
                    type = aPickName;
                    [self showAlert];
                }else
                    [fileSelectionDelegate pickName:nameField.text];
            }
            break;
        case aSignIn:
            if(buttonIndex == 0)
                NSLog(@"Cancel");
            else{
                if([nameField.text isEqual:@""] || [passField.text isEqual:@""])
                {
                    type = aSignIn;
                    [self showAlert];
                }else
                    [fileSelectionDelegate signinYoutube:nameField.text pass:passField.text];
            }
            break;
        default:
            break;
    }
}
@end
