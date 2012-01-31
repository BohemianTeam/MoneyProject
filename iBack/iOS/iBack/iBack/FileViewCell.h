//
//  FileViewCell.h
//  iBack
//
//  Created by bohemian on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FileViewCellDelegate;

@interface FileViewCell : UITableViewCell
{
    UILabel     *lbFileNumber;
    UILabel     *lbFileName;
    UILabel     *lbFileDuration;
    UIImageView *imvFileType;
    UIButton    *btnSelectedBox;
    
    BOOL        isSelected;
    NSInteger   fileType;   //0-->.MOV file, 1-->.caf file
    id<FileViewCellDelegate>    customCellDelegate;
}
@property(nonatomic, assign)id<FileViewCellDelegate>    customCellDelegate;
@property(nonatomic, retain)UILabel     *lbFileNumber;
@property(nonatomic, retain)UILabel     *lbFileName;
@property(nonatomic, retain)UILabel     *lbFileDuration;
@property(nonatomic, retain)UIButton    *btnSelectedBox;
@property(nonatomic, retain)UIImageView *imvFileType;
@property(nonatomic, assign)BOOL        isSelected;
@property(nonatomic, assign)NSInteger        fileType;

- (void)initViewCell;
- (void)changeToEditMode;
- (void)changeToDoneMode;
@end

@protocol FileViewCellDelegate
- (void)selectedDeleteCell:(NSString*)indexRow;
- (void)unselectedDeleteCell:(NSString*)indexRow;
@end