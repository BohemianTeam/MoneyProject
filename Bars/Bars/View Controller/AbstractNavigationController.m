//
//  AbstractNavigationController.m
//  Bars
//
//  Created by Trinh Hung on 3/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbstractNavigationController.h"
#import "UINavigationBar+CustomBackground.h"

@interface AbstractNavigationController (private)

@end

@implementation AbstractNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.navigationBar.barStyle = UIBarStyleBlackOpaque;
        //[self.navigationBar applyCustomTintColor];
        self.navigationBar.tintColor = kNavigationBarCustomTintColor;
        //[self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_o"] forBarMetrics:UIBarMetricsDefault];
    }
    
    return self;
}

- (id) initNav {
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
