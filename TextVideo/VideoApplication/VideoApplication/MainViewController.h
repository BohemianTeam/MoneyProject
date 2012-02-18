//
//  MainViewController.h
//  VideoApplication
//
//  Created by bohemian on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView     *movieTable;
    
}
@property (nonatomic, retain) UITableView *movieTable;
@end
