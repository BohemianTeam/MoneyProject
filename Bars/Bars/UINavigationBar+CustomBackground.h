//
//  UINavigationBar+CustomBackground.h
//  CustomizingNavigationBarBackground
//
//  Created by Ahmet Ardal on 2/10/11.
//  Copyright 2011 LiveGO. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNavigationBarCustomTintColor   [UIColor colorWithRed:160.0f/255 green:100.0f/255 blue:43.0f/255 alpha:1.0]

@interface UINavigationBar (CustomBackground)

- (void) applyCustomTintColor;

@end
