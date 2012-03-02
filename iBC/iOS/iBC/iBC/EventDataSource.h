//
//  EventDataSource.h
//  iBC
//
//  Created by bohemian on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Kal.h"

@class EKEventStore;
@class EKEvent;

@interface EventDataSource : NSObject<KalDataSource, UITableViewDelegate>
{
    NSArray         *eventSessions;
    
    NSMutableArray *items;            // The list of events corresponding to the currently selected day in the calendar. These events are used to configure cells vended by the UITableView below the calendar month view.
    NSMutableArray *events;           // Must be used on the main thread
    EKEventStore *eventStore;         // Must be used on a background thread managed by eventStoreQueue
    
    //using for load event from event of device
    //dispatch_queue_t eventStoreQueue; // Serializes access to eventStore and offloads the query work to a background thread.
}
@property(nonatomic, retain) NSArray         *eventSessions;
+ (EventDataSource *)dataSource;
- (id)initWithDatas:(NSArray*)sessionData;
- (EKEvent *)eventAtIndexPath:(NSIndexPath *)indexPath;  // exposed for client so that it can implement the UITableViewDelegate protocol
@end
