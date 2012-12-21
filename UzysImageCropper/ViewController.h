//
//  ViewController.h
//  UzysImageCropper
//
//  Created by Uzys on 11. 12. 13..
//

#import <UIKit/UIKit.h>
#import "UzysImageCropperViewController.h"



@interface ViewController : UIViewController <UzysImageCropperDelegate>
{
    UzysImageCropperViewController *imgCropperView;
}
@property (nonatomic,retain) UIImageView *resultImgView;
@end
