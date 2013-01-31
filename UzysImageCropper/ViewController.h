//
//  ViewController.h
//  UzysImageCropper
//
//  Created by Uzys on 11. 12. 13..
//

#import <UIKit/UIKit.h>
#import "UzysImageCropperViewController.h"

@interface ViewController : UIViewController <UzysImageCropperDelegate>

@property (nonatomic,retain) UIImageView *resultImgView;
@property (nonatomic,retain) UzysImageCropperViewController *imgCropperViewController;
@end
