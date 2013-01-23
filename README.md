UzysImageCropper
================

An alternative to the UIImagePickerController editor with extended features.
![Screenshot](https://github.com/uzysjung/UzysImageCropper/raw/master/UzysImageCropper.png)

## Installation
Copy over the files libary folder to your project folder

## Usage

Import header.

``` objective-c
#import "UzysImageCropperViewController.h"
@interface ViewController : UIViewController <UzysImageCropperDelegate>
@end
```

### Initialize
Simply define CropviewController View size and cropImage size.

``` objective-c
_imgCropperViewController = [[UzysImageCropperViewController alloc] initWithImage:[UIImage imageNamed:@"Hyuna.jpg"] 
																	andframeSize:[UIScreen mainScreen].bounds.size 
																	andcropSize:CGSizeMake(1024, 580)];
_imgCropperViewController.delegate = self;
_imgCropperViewController.modalPresentationStyle = UIModalPresentationFullScreen;
```

###Delegate
``` objective-c
- (void)imageCropper:(UzysImageCropperViewController *)cropper didFinishCroppingWithImage:(UIImage *)image {
    //Save Image here
	[self dismissModalViewControllerAnimated:YES];
}

- (void)imageCropperDidCancel:(UzysImageCropperViewController *)cropper {
    [self dismissModalViewControllerAnimated:YES];
}
```
