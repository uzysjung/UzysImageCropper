//
//  ViewController.h
//  UzysImageCropper
//
//  Created by Uzys on 11. 12. 13..
//

#import <UIKit/UIKit.h>
#import "UzysImageCropperViewController.h"

@interface ViewController : UIViewController <UzysImageCropperDelegate ,UIImagePickerControllerDelegate, UIActionSheetDelegate ,UINavigationControllerDelegate>

@property (nonatomic,retain) UIImageView *resultImgView;
@property (nonatomic,retain) UzysImageCropperViewController *imgCropperViewController;
@property (nonatomic,retain) UIImagePickerController *picker;
@end
