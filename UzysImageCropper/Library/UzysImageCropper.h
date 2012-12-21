//
//  UzysImageCropper.h
//  UzysImageCropper
//
//  Created by Uzys on 11. 12. 13..
//

#import <UIKit/UIKit.h>

@interface UzysImageCropper : UIView <UIGestureRecognizerDelegate>
{
    double imageScale; //frame : image

    double translateX;
    double translateY;
    
    CGRect imgViewframeInitValue; //imgView는 가운데 정렬 되므로 초기값 위치가 (0,0)이 아니므로 위치를 알아야함
    CGPoint imgViewcenterInitValue; 
    CGSize realCropsize;
    UIView *cropperView;
    
    UIPinchGestureRecognizer *pinchGestureRecognizer;
    UIPanGestureRecognizer *panGestureRecognizer;
    UIRotationGestureRecognizer *rotationGestureRecognizer;
    UITapGestureRecognizer *doubleTapGestureRecognizer;
    
}
@property (nonatomic,retain) UIImageView *imgView;
@property (nonatomic,assign) CGRect cropRect;
@property (nonatomic, retain) UIImage *inputImage;

- (id)initWithImage:(UIImage*)newImage andframeSize:(CGSize)frameSize andcropSize:(CGSize)cropSize;
- (UIImage*) getCroppedImage;
- (BOOL) saveCroppedImage:(NSString *)path;

- (void) actionRotate;
- (void) actionRestore;
@end
