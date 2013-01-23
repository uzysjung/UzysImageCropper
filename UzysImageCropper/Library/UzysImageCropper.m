//
//  UzysImageCropper.m
//  UzysImageCropper
//
//  Created by Uzys on 11. 12. 13..
//

#define MAX_ZOOMSCALE 3

//#define CROPPERVIEW_IMG

#import "UzysImageCropper.h"
#import "UIImage-Extension.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
@implementation UzysImageCropper
@synthesize imgView,inputImage,cropRect;




#pragma mark - Collision 
-(BOOL) RectCollision
{
    //imgView cropperView
    BOOL ret=CGRectContainsRect(imgView.frame, cropperView.frame);

    //NSLog(@"Contain :%d",ret);
    return ret;
  
}


#pragma mark - UIGestureAction
- (void)zoomAction:(UIGestureRecognizer *)sender {
    
    CGFloat factor = [(UIPinchGestureRecognizer *)sender scale];
    static CGFloat lastScale=1;
    //BOOL isCollide = [self RectCollision];
    
    if([sender state] == UIGestureRecognizerStateBegan) {
        // Reset the last scale, necessary if there are multiple objects with different scales
        lastScale =1;
        
    }
    if ([sender state] == UIGestureRecognizerStateChanged
        || [sender state] == UIGestureRecognizerStateEnded)
    {
        CGRect imgViewFrame = imgView.frame;
        CGFloat minX,minY,maxX,maxY,imgViewMaxX,imgViewMaxY;
        minX= CGRectGetMinX(cropRect);
        minY= CGRectGetMinY(cropRect);
        maxX= CGRectGetMaxX(cropRect);
        maxY= CGRectGetMaxY(cropRect);   
        
        CGFloat currentScale = [[self.imgView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
        // CGFloat currentScale = self.imgView.transform.a;
        const CGFloat kMaxScale = 2.0;
        CGFloat newScale = 1 -  (lastScale - factor); // new scale is in the range (0-1)        
        newScale = MIN(newScale, kMaxScale / currentScale);
        
        //변화된 후의 imgViewFrame
        imgViewFrame.size.width = imgViewFrame.size.width * newScale;
        imgViewFrame.size.height = imgViewFrame.size.height * newScale;
        imgViewFrame.origin.x = self.imgView.center.x - imgViewFrame.size.width/2;
        imgViewFrame.origin.y = self.imgView.center.y - imgViewFrame.size.height/2;
        
        imgViewMaxX= CGRectGetMaxX(imgViewFrame);
        imgViewMaxY= CGRectGetMaxY(imgViewFrame); 
        
        //역변환 공식
        NSInteger collideState = 0;
        
        if(imgViewFrame.origin.x >= minX) //left
        {
            collideState = 1;
        }
        else if(imgViewFrame.origin.y >= minY) // up 
        {
            collideState = 2;
        }
        else if(imgViewMaxX <= maxX) //right
        {
            collideState = 3;
        }
        else if(imgViewMaxY <= maxY) //down
        {
            collideState = 4;
        }
        
        //        NSLog(@"scale :%f",newScale);
        if(collideState >0)  // 걸렸을 때 
        {
            
            if(lastScale - factor <= 0) //확대 모션
            {
                
                lastScale = factor;
                CGAffineTransform transformN = CGAffineTransformScale(self.imgView.transform, newScale, newScale);
                self.imgView.transform = transformN;
            }
            else
            {
                lastScale = factor;
                
                CGPoint newcenter = imgView.center;
                
                if(collideState ==1 || collideState ==3)
                {
                    newcenter.x = cropperView.center.x;
                }
                else if(collideState ==2 || collideState ==4)
                {
                    newcenter.y = cropperView.center.y;
                }
                
                [UIView animateWithDuration:0.5f animations:^(void) {
                    
                    self.imgView.center = newcenter;
                    [sender reset];
                    
                } ];
                
            }
            
        }
        else //정상일 때
        {
            CGAffineTransform transformN = CGAffineTransformScale(self.imgView.transform, newScale, newScale);
            self.imgView.transform = transformN;
            lastScale = factor;
        }
        
    }
        
}
- (void)panAction:(UIPanGestureRecognizer *)gesture {
    
    static CGPoint prevLoc;
    CGPoint location = [gesture locationInView:self];
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        prevLoc = location; //Starting position
    }
    
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) 
    {
        
        CGFloat minX,minY,maxX,maxY,imgViewMaxX,imgViewMaxY;
        
        //calculate offset
        translateX =  (location.x - prevLoc.x); 
        translateY =  (location.y - prevLoc.y);
        
        // 회전이 있는 경우 기준  
        CGPoint center = self.imgView.center;
        minX= CGRectGetMinX(cropRect);
        minY= CGRectGetMinY(cropRect);
        maxX= CGRectGetMaxX(cropRect);
        maxY= CGRectGetMaxY(cropRect);   
        
        center.x =center.x +translateX;
        center.y = center.y +translateY;
        
        imgViewMaxX= center.x + imgView.frame.size.width/2;
        imgViewMaxY= center.y+ imgView.frame.size.height/2; 
        
        if(  (center.x - (imgView.frame.size.width/2) ) >= minX)
        {
            center.x = minX + (imgView.frame.size.width/2) ;
        }
        if( center.y - (imgView.frame.size.height/2) >= minY)
        {
            center.y = minY + (imgView.frame.size.height/2) ;
        }
        if(imgViewMaxX <= maxX)
        {
            center.x = maxX - (imgView.frame.size.width/2);
        }
        if(imgViewMaxY <= maxY)
        {
            center.y = maxY - (imgView.frame.size.height/2);   
        }
        
        self.imgView.center = center;
        
        prevLoc = location;
        
    }
}
- (void)RotationAction:(UIGestureRecognizer *)sender {
    
    UIRotationGestureRecognizer *recognizer = (UIRotationGestureRecognizer *) sender;
    static CGFloat rot=0;
    //float RotationinDegrees = recognizer.rotation * (180/M_PI);
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        rot = recognizer.rotation;
    }
    
    if(sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged)
    {
        self.imgView.transform = CGAffineTransformRotate(self.imgView.transform, recognizer.rotation - rot);
        NSLog(@"imgViewFrame : %@",NSStringFromCGRect(self.imgView.frame));
        rot =recognizer.rotation;
        
    }
    
    
    if (sender.state == UIGestureRecognizerStateEnded) { 
        
        
        if(self.imgView.frame.size.width < cropperView.frame.size.width || self.imgView.frame.size.height < cropperView.frame.size.height)
        {
            double scale = MAX(cropperView.frame.size.width/self.imgView.frame.size.width,cropperView.frame.size.height/self.imgView.frame.size.height) + 0.01;
            
            self.imgView.transform = CGAffineTransformScale(self.imgView.transform,scale, scale);
        }
    }
    
}
- (void)DoubleTapAction:(UIGestureRecognizer *)sender {
    
    //각도도 20도 단위로 맞추기
    [UIView animateWithDuration:0.2f animations:^(void) {
        
        self.imgView.center = cropperView.center;
        
    } ];
}


- (void) setupGestureRecognizer
{
    pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomAction:)];
    [pinchGestureRecognizer setDelegate:self];
    
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [panGestureRecognizer setMinimumNumberOfTouches:1];
    [panGestureRecognizer setMaximumNumberOfTouches:1];
    [panGestureRecognizer setDelegate:self];
    
    doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleTapAction:)];
    [doubleTapGestureRecognizer setDelegate:self];
    doubleTapGestureRecognizer.numberOfTapsRequired =2;
    
    rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(RotationAction:)];
    [rotationGestureRecognizer setDelegate:self];
    
    [self addGestureRecognizer:pinchGestureRecognizer];
    [self addGestureRecognizer:panGestureRecognizer];
    [self addGestureRecognizer:doubleTapGestureRecognizer];
    [self addGestureRecognizer:rotationGestureRecognizer];
    
}

#pragma mark - initialize

- (id)init
{
    self = [super init];
    if (self) {
        //[self setup];
    }
    
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithImage:(UIImage*)newImage andframeSize:(CGSize)frameSize andcropSize:(CGSize)cropSize
{
    self = [super init];
    if(self) 
    {

        //Variable for GestureRecognizer
        translateX =0;
        translateY =0;
        
        self.frame = CGRectMake(0, 0, frameSize.width, frameSize.height);
        inputImage = [newImage retain];
        
        //Case 1 실제 이미지를 frame Width size에 맞춤 --> 이미지가 커지면 크롭영역도 320x480의 프레임 영역에서 작게 표시됨.
        //imageScale = frameSize.width / inputImage.size.width; //scale criteria depend on width size
        
        //Case 2 crop Width를 310에 고정 --> 크롭영역은 일정.
        imageScale = 310/cropSize.width ;
        
        
        
        CGRect imgViewBound = CGRectMake(0, 0, inputImage.size.width*imageScale, inputImage.size.height*imageScale);   //이미지가 생성될 사이즈.   
        imgView = [[UIImageView alloc] initWithFrame:imgViewBound];
        imgView.center = self.center;
        imgView.image = inputImage;
        imgView.backgroundColor = [UIColor whiteColor];
        
        
        imgViewframeInitValue = imgView.frame;
        imgViewcenterInitValue = imgView.center;
            
        
        realCropsize = cropSize; // realCropsize = Cropping Size in RealImage
        
        
        //cropX,cropY = cropRect position to center in Frame.
        double cropX = (self.imgView.frame.size.width/2) - (imageScale*cropSize.width/2);
        double cropY = (self.imgView.frame.size.height/2) - (imageScale*cropSize.height/2);
        
        //cropX위치 + imgViewframe이 가운데 정렬되어있으므로 그위치 만큼 이동.
        cropRect = CGRectMake(cropX+ imgViewframeInitValue.origin.x, cropY+ imgViewframeInitValue.origin.y, imageScale*cropSize.width, imageScale*cropSize.height);
   
        
        //cropperView show the view will crop.
        cropperView = [[UIView alloc] initWithFrame:cropRect];
        cropperView.backgroundColor = [UIColor blueColor];
        cropperView.alpha = 0.5;
        
        UIImageView *cropimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cropperview.png"]];
        cropimg.center = cropperView.center;
        cropimg.alpha = 0.7;


#ifdef CROPPERVIEW_IMG
        cropperView.hidden = YES;
#else
        cropimg.hidden = YES;
#endif
        
        [self addSubview:imgView];
        [self addSubview:cropimg];
        [cropimg release];
        [self addSubview:cropperView];
        
        [self setupGestureRecognizer];

    }
    
    return self;
    
}


- (UIImage*) getCroppedImage
{
    double zoomScale = [[self.imgView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
    double rotationZ = [[self.imgView.layer valueForKeyPath:@"transform.rotation.z"] floatValue];

    CGPoint cropperViewOrigin = CGPointMake( (cropperView.frame.origin.x - imgView.frame.origin.x)  *1/zoomScale , 
                                            ( cropperView.frame.origin.y - imgView.frame.origin.y ) * 1/zoomScale
                                            );

    CGSize cropperViewSize = CGSizeMake(cropperView.frame.size.width * (1/zoomScale) ,cropperView.frame.size.height * (1/zoomScale));

    CGRect CropinView = CGRectMake(cropperViewOrigin.x, cropperViewOrigin.y, cropperViewSize.width  , cropperViewSize.height);

    NSLog(@"CropinView : %@",NSStringFromCGRect(CropinView));
    
    CGSize CropinViewSize = CGSizeMake((CropinView.size.width*(1/imageScale)),(CropinView.size.height*(1/imageScale)));
    
    
    if((NSInteger)CropinViewSize.width % 2 == 1)
    {
        CropinViewSize.width = ceil(CropinViewSize.width);
    }
    if((NSInteger)CropinViewSize.height % 2 == 1)
    {
        CropinViewSize.height = ceil(CropinViewSize.height);
    }
    
    
    CGRect CropRectinImage = CGRectMake((NSInteger)(CropinView.origin.x * (1/imageScale)) ,(NSInteger)( CropinView.origin.y * (1/imageScale)), (NSInteger)CropinViewSize.width,(NSInteger)CropinViewSize.height);
    
    
    
    UIImage *rotInputImage = [inputImage imageRotatedByRadians:rotationZ];
    // Create a new image in quartz with our new bounds and original image
    CGImageRef tmp = CGImageCreateWithImageInRect([rotInputImage CGImage], CropRectinImage);
    
    // Pump our cropped image back into a UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:tmp];
    
    // Be good memory citizens and release the memory
    CGImageRelease(tmp);
    
    if(newImage.size.width != realCropsize.width)
    {
        newImage = [newImage imageByScalingProportionallyToSize:realCropsize];
    }
        
    return newImage;

}
- (BOOL) saveCroppedImage:(NSString *) path
{
 
    return [UIImagePNGRepresentation([self getCroppedImage]) writeToFile:path atomically:YES];
    
}
- (void) actionRotate
{
    
    self.imgView.transform = CGAffineTransformRotate(self.imgView.transform,M_PI/2);
    if(self.imgView.frame.size.width < cropperView.frame.size.width || self.imgView.frame.size.height < cropperView.frame.size.height)
    {
        double scale = MAX(cropperView.frame.size.width/self.imgView.frame.size.width,cropperView.frame.size.height/self.imgView.frame.size.height) + 0.01;
        
        self.imgView.transform = CGAffineTransformScale(self.imgView.transform,scale, scale);
    }
    
}
- (void) actionRestore
{
    self.imgView.transform = CGAffineTransformIdentity;
    self.imgView.center = cropperView.center;
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)dealloc {
    [imgView release];
    [inputImage release];
    [pinchGestureRecognizer release];
    [panGestureRecognizer release];
    [rotationGestureRecognizer release];
    [doubleTapGestureRecognizer release];
    [super dealloc];
}
@end
