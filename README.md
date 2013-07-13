UzysImageCropper
================

An alternative to the UIImagePickerController editor with extended features.
![Screenshot](https://github.com/uzysjung/UzysImageCropper/raw/master/UzysImageCropper.png)

**UzysImageCropper features:**

* You can crop image to exact size which you assign  
* Support rotate, scale, move, restore action.
* Support Both ARC and non-ARC Project

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

## Contact

[Uzys.net](http://uzys.net)

## License

See [LICENSE](https://github.com/uzysjung/UzysImageCropper/blob/master/MIT-LICENSE.txt).
