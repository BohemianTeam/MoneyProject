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
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>
#import "CoreLocationController.h"
#import "AppDatabase.h"

#import "ImageCaptureViewController.h"

#define TEXT_VIEW_HEIGHT 80
#define GROUP_BUTTON_HEIGHT 54
#define TABLEVIEW_HEIGHT (416 - 49)

@interface BarDetailViewController(private)
- (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)size;
- (NSString *) getCurrentDateTimeString;
- (void)saveImage:(UIImage *)image withName:(NSString *)name info:(NSDictionary *) info;
- (void) handleImageLocation:(CLLocation *)location;
- (NSMutableArray*) createLocArray:(double) val;

- (void) setLocationTagForImage:(UIImage *) img;
- (void) getLocationTagForImage:(UIImage *) img;
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
        
        UIImageView *bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.jpg"]];
        bg.frame = _tableView.frame;
        UIView *v = [[UIView alloc] initWithFrame:_tableView.frame];
        v.backgroundColor = [UIColor clearColor];
        [v addSubview:bg];
        [bg release];
        
        _tableView.backgroundView = v;
        [v release];
        
        [self.view addSubview:_tableView];
        
        NSString * location = [_bar barLocation];
        NSArray *arr = [location componentsSeparatedByString:@"~"];
        double lat = [[arr objectAtIndex:0] doubleValue];
        double lng = [[arr objectAtIndex:1] doubleValue];
        _currentLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    }
    
    return self;
}

- (void) dealloc {
    [_tableView release];
    [_barDescription release];
    [_galeryView release];
    if (_helpAlert) {
        [_helpAlert release];
        _helpAlert = nil;
    }
    
    if (_getLocationAlert) {
        [_getLocationAlert release];
        _getLocationAlert = nil;
    }
    [super dealloc];
}

#pragma mark - UITableView Delegate & Datasource


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
        _barDescription.font = [UIFont boldSystemFontOfSize:14];
        _barDescription.textAlignment = UITextAlignmentLeft;
        _barDescription.lineBreakMode = UILineBreakModeWordWrap;
        _barDescription.numberOfLines = 5;
        _barDescription.textColor = [UIColor whiteColor];
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

        if(_bar.isCompleted)
        {
            btnCompleted = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnCompleted setFrame:CGRectMake(230, 0, 90, 90)];
            [btnCompleted setImage:[UIImage imageNamed:@"completed_icon"] forState:UIControlStateNormal];
            
        }else {
            btnCompleted = [UIButton buttonWithType:UIButtonTypeInfoLight];
            btnCompleted.frame = CGRectMake(290, 10, 18, 19);
            [btnCompleted addTarget:self action:@selector(didHelpButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        }
        [cell addSubview:btnCompleted];
        
    } else if (section == 2) {
        _map = [UIButton buttonWithType:UIButtonTypeCustom];
        [_map setImage:[UIImage imageNamed:@"Maps-icon"] forState:UIControlStateNormal];
        _map.frame = CGRectMake(20, (GROUP_BUTTON_HEIGHT - 46) / 2, 72, 46);
        [_map setTitle:@"Map" forState:UIControlStateNormal];
        [_map addTarget:self action:@selector(didButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:_map];
        
        _camera = [UIButton buttonWithType:UIButtonTypeCustom];
        [_camera setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
        _camera.frame = CGRectMake(124, (GROUP_BUTTON_HEIGHT - 46) / 2, 72, 46);
        [_camera setTitle:@"Camera" forState:UIControlStateNormal];
        [_camera addTarget:self action:@selector(didButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:_camera];
        
        _upload = [UIButton buttonWithType:UIButtonTypeCustom];

        [_upload setImage:[UIImage imageNamed:@"upload-icon"] forState:UIControlStateNormal];
        _upload.frame = CGRectMake(228, (GROUP_BUTTON_HEIGHT - 46) / 2, 72, 46);
        [_upload setTitle:@"Upload" forState:UIControlStateNormal];
        [_upload addTarget:self action:@selector(didButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:_upload];
        
    }
    return cell;
}

- (void) didHelpButtonClicked {
    _helpAlert = [[UIAlertView alloc] initWithTitle:@"Bars" message:@"How to complete the bar?\n\nYou should capture image at bar and upload it to Facebook." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [_helpAlert show];
    [self performSelector:@selector(dismissHelpAlert) withObject:nil afterDelay:2.0];
}

- (void) dismissHelpAlert {
    [_helpAlert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) didButtonClicked:(id) sender {
    if (sender == _map) {
        MapViewController *mapVC = [[MapViewController alloc] initWithAddress:_bar.barAddress title:_bar.barName];
        [self.navigationController pushViewController:mapVC animated:YES];
        [mapVC release];
    } else if (sender == _camera) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            /*
            ImageCaptureViewController *vc = [[ImageCaptureViewController alloc] initWithBarLocation:_currentLocation];
            vc.delegate = self;
            [self presentModalViewController:vc animated:YES];
            [vc release];
             */
            
            if (_picker) {
                [_picker release];
                _picker = nil;        
            }
            _picker = [[UIImagePickerController alloc] init];
            _picker.delegate = self;
            _picker.allowsEditing = YES;
            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            if (_picker) {
                
                if (_locationController) {
                    [_locationController release];
                    _locationController = nil;
                }
                _locationController = [[CoreLocationController alloc] init];
                _locationController.delegate = self;
                [_locationController.locMgr startUpdatingLocation];
                
                _getLocationAlert = [[UIAlertView alloc] initWithTitle:@"Get Current Location\nPlease Wait..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
                //[_getLocationAlert show];
                
                UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                
                // Adjust the indicator so it is up a few pixels from the bottom of the alert
                indicator.center = CGPointMake(_getLocationAlert.bounds.size.width / 2, _getLocationAlert.bounds.size.height - 50);
                [indicator startAnimating];
                [_getLocationAlert addSubview:indicator];
                [indicator release];
                
                //test//[self presentModalViewController:_picker animated:YES];
            }
             
        } else {
            NSLog(@"no camera available");
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
        if (_galeryView.totalItems > 0) {
            UIImage * currImg =  [[_galeryView getCurrentImageDisplay] retain];
            FacebookViewController *fbViewController = [[FacebookViewController alloc] init];
            [fbViewController setImage:currImg withBar:_bar];
            [self.navigationController pushViewController:fbViewController animated:YES];
            [fbViewController release];
        }else{
            
            UIAlertView *uploadAlert = [[UIAlertView alloc] initWithTitle:@"Upload Error" message:@"Please select a image to upload." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [uploadAlert show];
            [uploadAlert release];
             /*
            UIImage * currImg =  [UIImage imageNamed:@"Maps-icon"];//[[_galeryView getCurrentImageDisplay] retain];
            FacebookViewController *fbViewController = [[FacebookViewController alloc] init];
            [fbViewController setImage:currImg withBar:_bar];
            [self.navigationController pushViewController:fbViewController animated:YES];
            [fbViewController release];
              */ //test
        }
    }
}
#pragma ImageCaptureViewControllerDelegate
- (void) didFinishCaptureImage:(UIImage *)img {
    NSString *imgName = [self getCurrentDateTimeString];
    [self saveImage:img withName:imgName info:nil];
    
    [_galeryView notifyDataSetChanged];
    
    [self didHelpButtonClicked];
}


#pragma mark - FacebookViewController Delegate
- (void) didUploadToFacebookSuccess {
    [_bar setBarIsCompleted];
    [_tableView reloadData];
}

// Helper methods for location conversion
-(NSMutableArray*) createLocArray:(double) val{
    val = fabs(val);
    NSMutableArray* array = [[NSMutableArray alloc] init];
    double deg = (int)val;
    [array addObject:[NSNumber numberWithDouble:deg]];
    val = val - deg;
    val = val*60;
    double minutes = (int) val;
    [array addObject:[NSNumber numberWithDouble:minutes]];
    val = val - minutes;
    val = val *60;
    double seconds = val;
    [array addObject:[NSNumber numberWithDouble:seconds]];
    return array;
}
// end of helper methods

#pragma mark - UIActionSheet delegate
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

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image;
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
    } else {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    
    NSString *imgName = [self getCurrentDateTimeString];
    [self saveImage:image withName:imgName info:(NSDictionary *)info];
    
    [_galeryView notifyDataSetChanged];
    
    [_picker dismissModalViewControllerAnimated:NO];
    if (_picker) {
        [_picker release];
        _picker = nil;
    }
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Bars" message:@"Upload image to complete Bar." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil] autorelease];
    [alert show];
    
    [self performSelector:@selector(dismissUploadNotice:) withObject:alert afterDelay:2.0];
}

- (void) dismissUploadNotice:(UIAlertView *) alert {
    [alert dismissWithClickedButtonIndex:0 animated:YES];
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

- (void) handleImageLocation:(CLLocation *)location {
    NSLog(@"%@",[location description]);
}

#pragma CoreLocationController delegate
- (void) locationUpdate:(CLLocation *)location {
    [_getLocationAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    // check that the location data isn't older than 60 seconds
//    if ([location.timestamp timeIntervalSinceReferenceDate] < [NSDate timeIntervalSinceReferenceDate] - 60) {
//        return;
//    }
    
    _barLocation = [location retain];
    NSLog(@"current location : %f~%f", _barLocation.coordinate.latitude, _barLocation.coordinate.longitude);

    
    
    CLLocationDistance distance = [_currentLocation distanceFromLocation:_barLocation];
    [_locationController.locMgr stopUpdatingLocation];
    _locationController.delegate = nil;
    
    NSLog(@"distance = %f m", distance);
//    UIAlertView *testAlert = [[UIAlertView alloc] initWithTitle:@"test" message:[NSString stringWithFormat:@"Distance: %f",distance] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [testAlert show];
//    [testAlert release];
    if (distance <= 60) {
        NSLog(@"present model picker");
        [self presentModalViewController:_picker animated:YES];

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bars" message:@"You must stand in bar to capture" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }

}

- (void)locationError:(NSError *)error {
    [_getLocationAlert dismissWithClickedButtonIndex:0 animated:YES];
    NSString *errorString;
    NSLog(@"error : %@", [error description]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"Photos will be tagged with the location where they are taken";
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"Location data unavailable";
            //Do something else...
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"\"Bars\" Would Like to Use Your Current Location" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%d", buttonIndex);
    
    if ([_picker isFirstResponder]) {
        NSLog(@"dismiss");
        [_picker dismissModalViewControllerAnimated:YES];
    }
    
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
    }
}

#pragma mark - Util
- (NSString *) getCurrentDateTimeString {
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    [formatter release];
    
    return dateString;
}

- (BOOL)writeCGImage:(CGImageRef)theImage toURL:(NSURL*)url withType:(CFStringRef)imageType andOptions:(CFDictionaryRef)options {
    CGImageDestinationRef myImageDest   = CGImageDestinationCreateWithURL((CFURLRef)url, imageType, 1, nil);
    CGImageDestinationAddImage(myImageDest, theImage, options);
    BOOL success                        = CGImageDestinationFinalize(myImageDest);
    
    // Memory Mangement
    CFRelease(myImageDest);
    if (options)
        CFRelease(options);
    
    return success;
}

- (void)saveImage:(UIImage *)image withName:(NSString *)name info:(NSDictionary *)info{
    
    //grab the data from our image
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    
    //get a path to the documents Directory
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *barImageDir = [Util getImageBarDir:[NSString stringWithFormat:@"%d", _bar.barID]];
    // Add out name to the end of the path with .PNG
    NSString *fullPath = [barImageDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];
    
    //Save the file, over write existing if exists. 
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
    
    
    //[self setLocationTagForImage:image];
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
    
    NSLog(@" Bar detail didReceiveMemoryWarning");
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
