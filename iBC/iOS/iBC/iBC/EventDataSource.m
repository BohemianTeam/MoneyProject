//
//  EventDataSource.m
//  iBC
//
//  Created by bohemian on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventDataSource.h"
#import "EventKit/EventKit.h"
#import "Util.h"

static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
    return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}
@interface EventDataSource ()
- (NSArray *)eventsFrom:(NSDate *)fromDate to:(NSDate *)toDate;
- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end

@implementation EventDataSource
@synthesize eventSessions;

+ (EventDataSource *)dataSource
{
    return [[[[self class] alloc] init] autorelease];
}

- (id)init
{
    if ((self = [super init])) {
        eventStore = [[EKEventStore alloc] init];
        events = [[NSMutableArray alloc] init];
        items = [[NSMutableArray alloc] init];
        eventSessions = nil;
    }
    return self;
}
- (id)initWithDatas:(NSArray*)sessionData
{
    if ((self = [super init])) {
        eventStore = [[EKEventStore alloc] init];
        events = [[NSMutableArray alloc] init];
        items = [[NSMutableArray alloc] init];
        eventSessions = [[NSArray alloc] initWithArray:sessionData];
    }
    return self;
}
//
- (EKEvent *)eventAtIndexPath:(NSIndexPath *)indexPath
{
    return [items objectAtIndex:indexPath.row];
}

#pragma mark UITableViewDataSource protocol conformance
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightForRowAtIndexPath -- %f", HEIGHT_VIEW - tableView.frame.origin.y);
    return tableView.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    //custom cell
    UIWebView *detail = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_VIEW - 100, tableView.frame.size.height)];
    EKEvent *event = [self eventAtIndexPath:indexPath];
    [detail loadHTMLString:event.title baseURL:[NSURL URLWithString:@""]];
    [cell addSubview:detail];
    
    //
    UIImage *imgBuy = [UIImage imageNamed:@"buybutton"];
    UIButton *btnBuy = [[UIButton alloc] init];
    [btnBuy setImage:imgBuy forState:UIControlStateNormal];
    [btnBuy setFrame:CGRectMake(detail.frame.size.width + 20, 10 , imgBuy.size.width, imgBuy.size.height)];
    //[btnBuy addTarget:self action:@selector(btnBuyPressed) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btnBuy];
    
    [btnBuy release];
    [detail release];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}

#pragma mark KalDataSource protocol conformance
- (NSInteger)getEventSessionIDFromBeginDate:(NSDate*)date
{
    NSInteger idx = -1;

    for(NSDictionary *eventDict in eventSessions)
    {
        idx++;
        NSString *dateStr = [eventDict objectForKey:DateSession];
        NSDate *eventDate = [Util convertStringToDate:dateStr withFormat:@"yyyyMMdd"];
        if([eventDate compare:date]!=NSOrderedAscending)
            return idx;
  
    }
    
    return -1;
}
- (NSInteger)getEventSessionIDFromEndDate:(NSDate*)date
{
    int i;
    for(i = [eventSessions count] - 1; i >= 0 ; i--)
    {
        NSDictionary *eventDict = [eventSessions objectAtIndex:i];
        NSString *dateStr = [eventDict objectForKey:DateSession];
        NSDate *eventDate = [Util convertStringToDate:dateStr withFormat:@"yyyyMMdd"];
        if([eventDate compare:date]!= NSOrderedDescending)
            return i; 
    }
    
    return -1;
}
- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
    NSLog(@"presentingDatesFrom");
    // asynchronous callback on the main thread
    [events removeAllObjects];
    
//    EKEventStore *eventStoref = [[[EKEventStore alloc] init] autorelease];
//    EKEvent *event = [EKEvent eventWithEventStore:eventStoref];
//    event.title = @"test";
//    event.startDate = [[[NSDate alloc] init] autorelease];
//    event.endDate = [[[NSDate alloc] init] autorelease];
//    event.allDay = YES;
//    
//    [events addObjectsFromArray:[NSArray arrayWithObject:event]];
//    //[delegate loadedDataSource:self];
    
    NSInteger idxSessionBegin = [self getEventSessionIDFromBeginDate:fromDate];
    NSInteger idxSessionEnd = [self getEventSessionIDFromEndDate:toDate];

    if(idxSessionBegin >= 0 && idxSessionEnd < [eventSessions count] && idxSessionBegin <= idxSessionEnd)
    {
        for(int i = idxSessionBegin; i <= idxSessionEnd; i++){
            NSDictionary *eventDict = [eventSessions objectAtIndex:i];
            EKEventStore *eventStoref = [[EKEventStore alloc] init];
            EKEvent *event = [EKEvent eventWithEventStore:eventStoref];
            event.title = [eventDict objectForKey:Detail];
            event.startDate = [Util convertStringToDate:[eventDict objectForKey:DateSession] withFormat:@"yyyyMMdd"];
            event.endDate = [Util convertStringToDate:[eventDict objectForKey:DateSession] withFormat:@"yyyyMMdd"];
            event.allDay = YES;
            
            [events addObjectsFromArray:[NSArray arrayWithObject:event]];
            
            [eventStoref release];
        }
    }

    
    [delegate loadedDataSource:self];
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    // synchronous callback on the main thread
    return [[self eventsFrom:fromDate to:toDate] valueForKeyPath:@"startDate"];
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    // synchronous callback on the main thread
    [items addObjectsFromArray:[self eventsFrom:fromDate to:toDate]];
}

- (void)removeAllItems
{
    // synchronous callback on the main thread
    [items removeAllObjects];
}

#pragma mark -

- (NSArray *)eventsFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    NSLog(@"eventsFrom:fromDate to:toDate");
    NSMutableArray *matches = [NSMutableArray array];
    for (EKEvent *event in events)
        if (IsDateBetweenInclusive(event.startDate, fromDate, toDate))
            [matches addObject:event];
    
    return matches;
}

- (void)dealloc
{
    [eventSessions release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EKEventStoreChangedNotification object:nil];
    [items release];
    [events release];
    [super dealloc];
}

@end