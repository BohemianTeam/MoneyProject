//
//  BarDetailViewController.m
//  Bars
//
//  Created by Cuong Tran on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BarDetailViewController.h"
#import "Bar.h"
#import "ImageGaleryView.h"
#import "Util.h"
#import "MapViewController.h"

#define TEXT_VIEW_HEIGHT 80
#define GROUP_BUTTON_HEIGHT 54
#define TABLEVIEW_HEIGHT (416 - 49)

@interface BarDetailViewController(private)
- (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)size;
- (NSString *) getCurrentDateTimeString;
- (void)saveImage:(UIImage *)image withName:(NSString *)name;
@end

@implementation BarDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithBar:(Bar *)bar {
    
    self = [super init];
    if (self) {
        _bar = [bar retain];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, TABLEVIEW_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        
        [self.view addSubview:_tableView];
    }
    
    return self;
}

- (void) dealloc {
    [_tableView release];
    [_barDescription release];
    [_galeryView release];
    
    [super dealloc];
}

#pragma UITableView Delegate & Datasource


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return TEXT_VIEW_HEIGHT;
    } else if (indexPath.section == 1) {
        return (TABLEVIEW_HEIGHT - TEXT_VIEW_HEIGHT - GROUP_BUTTON_HEIGHT);
    } else if (indexPath.section == 2) {
        return GROUP_BUTTON_HEIGHT;
    }
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"cellId";
    UITableViewCell *cell;
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                   reuseIdentifier:cellId] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    int section = indexPath.section;
    if (section == 0) {
        _barDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320 - 10, TEXT_VIEW_HEIGHT)];
        _barDescription.backgroundColor = [UIColor clearColor];
        _barDescription.font = [UIFont systemFontOfSize:14];
        _barDescription.textAlignment = UITextAlignmentLeft;
        _barDescription.lineBreakMode = UILineBreakModeWordWrap;
        _barDescription.numberOfLines = 5;
        _barDescription.text = _bar.barInfo;
        [cell addSubview:_barDescription];
    } 
    else if (section == 1) {
        int h = TABLEVIEW_HEIGHT - TEXT_VIEW_HEIGHT - GROUP_BUTTON_HEIGHT;
        int w = 320;
        int igh = 233;
        int igw = 320;
        _galeryView = [[ImageGaleryView alloc] initWithFrame:CGRectMake((w - igw) / 2, (h - igh) / 2, igw, igh) withBar:_bar];
        [cell addSubview:_galeryView];
        
    } else if (section == 2) {
        _map = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _map.frame = CGRectMake(20, (GROUP_BUTTON_HEIGHT - 46) / 2, 72, 46);
        [_map setTitle:@"Map" forState:UIControlStateNormal];
        [_map addTarget:self action:@selector(didButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:_map];
        
        _camera = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _camera.frame = CGRectMake(124, (GROUP_BUTTON_HEIGHT - 46) / 2, 72, 46);
        [_camera setTitle:@"Camera" forState:UIControlStateNormal];
        [_camera addTarget:self action:@selector(didButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:_camera];
        
        _upload = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _upload.frame = CGRectMake(228, (GROUP_BUTTON_HEIGHT - 46) / 2, 72, 46);
        [_upload setTitle:@"Upload" forState:UIControlStateNormal];
        [_upload addTarget:self action:@selector(didButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:_upload];
        
    }
    return cell;
}


- (void) didButtonClicked:(id) sender {
    if (sender == _map) {
        MapViewController *mapVC = [[MapViewController alloc] initWithAddress:_bar.barAddress];
        [self.navigationController pushViewController:mapVC animated:YES];
        [mapVC release];
    } else if (sender == _camera) {
        if (_picker) {
            [_picker release];
            _picker = nil;        
        }
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.allowsEditing = YES;
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if (_picker) {
            [self presentModalViewController:_picker animated:YES];
        }
        /*
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@"" 
                                                        delegate:self 
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil 
                                               otherButtonTitles:
                             @"Photo from Library",@"Take a Picture", nil];
        [ac showFromTabBar:self.tabBarController.tabBar];
        [ac release];
        [pool release];
         */
    } else if (sender == _upload) {
        
    }
}

#pragma UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_picker) {
        [_picker release];
        _picker = nil;        
    }
    if (buttonIndex == 0) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.allowsEditing = YES;
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if (buttonIndex == 1) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.allowsEditing = YES;
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    if (_picker) {
        [self presentModalViewController:_picker animated:YES];
    }
}

#pragma UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image;
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    } else {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
//    UIImage *newImage = [self imageWithImage:image scaledToSize:CGSizeMake(180, 180)];
    NSString *imgName = [self getCurrentDateTimeString];
    [self saveImage:image withName:imgName];
    
    [_galeryView notifyDataSetChanged];
    
    [_picker dismissModalViewControllerAnimated:NO];
    if (_picker) {
        [_picker release];
        _picker = nil;        
    }

}


- (void)image:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    NSLog(@"SAVE IMAGE COMPLETE");
    if(error != nil) {
        NSLog(@"ERROR SAVING:%@",[error localizedDescription]);
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
    if (_picker) {
        [_picker release];
        _picker = nil;        
    }
}
#pragma Util mark -----

- (NSString *) getCurrentDateTimeString {
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    [formatter release];
    
    return dateString;
}


- (void)saveImage:(UIImage *)image withName:(NSString *)name {
    
    //grab the data from our image
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    
    //get a path to the documents Directory
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *barImageDir = [Util getImageBarDir:_bar.barName];
    // Add out name to the end of the path with .PNG
    NSString *fullPath = [barImageDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];
    
    //Save the file, over write existing if exists. 
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
    
}


- (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)size {
	if (image == nil)    
        return nil;
    
    CGImageRef imageRef     = NULL;
    CGContextRef context    = NULL;
    CGImageRef newImage     = NULL;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();    
	
    float w = image.size.width;
    float h = image.size.height;
    float s = (w < h) ? w : h;
    
    CGRect r = CGRectMake((h-s)/2, (w-s)/2, s, s);
    if (image.imageOrientation == UIImageOrientationLeft) {
        r = CGRectMake((h-s)/2, (w-s)/2, s, s);
	} else if (image.imageOrientation == UIImageOrientationRight) {
        r = CGRectMake((h-s)/2, (w-s)/2, s, s);
	} else if (image.imageOrientation == UIImageOrientationUp) {
        r = CGRectMake((w-s)/2, (h-s)/2, s, s);
	} else if (image.imageOrientation == UIImageOrientationDown) {
        r = CGRectMake((w-s)/2, (h-s)/2, s, s);
	}
    imageRef = CGImageCreateWithImageInRect([image CGImage], r);
    if (imageRef == NULL)
        goto scale_error;
    
    context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaNoneSkipFirst);
//    NSLog(@"imageOrientation:%d", image.imageOrientation);
    if (image.imageOrientation == UIImageOrientationLeft) {		
        CGContextRotateCTM(context, M_PI/2);
        CGContextTranslateCTM(context, 0, -size.height);		        
	} else if (image.imageOrientation == UIImageOrientationRight) {		
        CGContextRotateCTM(context, -M_PI/2);
        CGContextTranslateCTM(context, -size.height, 0);
	} else if (image.imageOrientation == UIImageOrientationUp) {
	} else if (image.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM(context, size.width, size.height);		
		CGContextRotateCTM(context, -M_PI);        
	}
    
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), imageRef);    
    CGImageRelease(imageRef);
    imageRef = NULL;
    
    UIImage *cover = nil;
    newImage = CGBitmapContextCreateImage(context);
    if (newImage) {
        cover = [UIImage imageWithCGImage:newImage];
        CGImageRelease(newImage);
        newImage = NULL;
    }
    if (colorSpace) {
        CGColorSpaceRelease(colorSpace);
    }
    if (context) {
        CGContextRelease(context);
        context = NULL;
    }
    return cover;
    
scale_error:
    if (colorSpace) {
        CGColorSpaceRelease(colorSpace);
    }
    if (imageRef) {
        CGImageRelease(imageRef);
        imageRef = NULL;
    }
    if (newImage) {
        CGImageRelease(newImage);
        newImage = NULL;
    }
    if (context) {
        CGContextRelease(context);
        context = NULL;
    }
    return nil;
	
}


#pragma UITableView delegate & datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[_tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
