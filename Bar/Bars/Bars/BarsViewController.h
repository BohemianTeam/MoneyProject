//
//  BarsViewController.h
//  Bars
//
//  Created by bohemian on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum DataSourceType
{
    States = 0,
    Citys,
    Bars,
    Completeds,
    Wishlists,
}DataSourceType;
@interface BarsViewController : UIViewController<UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITableView     *table;
    NSArray         *datas;
    NSInteger       sumRow;
    NSInteger       dataID;
    DataSourceType  dataType;
}
@property(nonatomic,assign)DataSourceType  dataType;
@property(nonatomic,assign)NSInteger       dataID;
- (id) initWithTitle:(NSString *)title;
- (id) initWithID:(NSInteger)dataId type:(DataSourceType)type;
@end
