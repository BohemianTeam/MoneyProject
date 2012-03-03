//
//  BookItemViewController.m
//  iEssenceMapPDF
//
//  Created by Cuong Tran on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BookItemViewController.h"
#import "BookItemTableViewCell.h"
#import "ReaderDocument.h"
#import "ReaderViewController.h"
@implementation BookItemViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) init {
    self = [super init];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
        _tableView.delegate = self;
        _tableView.dataSource = self;

        [self.view addSubview:_tableView];
        
        _links = [[NSMutableArray alloc] init];
        [_links addObject:@"https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/TableView_iPhone/TableView_iPhone.pdf"];
        [_links addObject:@"https://developer.apple.com/library/ios/#documentation/UIKit/Reference/UIWebView_Class/UIWebView_Class.pdf"];
        [_links addObject:@"https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIView_Class/UIView_Class.pdf"];
        [_links addObject:@"https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIPasteboard_Class/UIPasteboard_Class.pdf"];
        
        _pdfs = [[NSMutableArray alloc] init];
        [_pdfs addObject:@"TableView_iPhone"];
        [_pdfs addObject:@"UIWebView_Class"];
        [_pdfs addObject:@"UIView_Class"];
        [_pdfs addObject:@"UIPasteboard_Class"];

    }
    
    return self;
}

- (void) dealloc {
    [_tableView release];
    [_links release];
    [_pdfs release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_links count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookItemTableViewCell *cell = [[BookItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" path:[_links objectAtIndex:indexPath.row] name:[_pdfs objectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (void) openPDFWithPath:(NSString *)path {
    NSString *pth = [path retain];
    ReaderDocument *doc = [[ReaderDocument alloc] initWithFilePath:pth password:nil];
    [pth release];
    ReaderViewController *vc = [[ReaderViewController alloc] initWithReaderDocument:doc];
    [doc release];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void) viewDidLoad {
    

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
