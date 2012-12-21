//
//  UIImage-Extensions.m
//
//  Created by Hardy Macia on 7/1/09.
//  Copyright 2009 Catamount Software. All rights reserved.
//

#import "UIImage-Extension.h"

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@implementation UIImage (CS_Extensions)

-(UIImage *)imageAtRect:(CGRect)rect
{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
    
}

- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) 
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}


- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor) 
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}


- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    //   CGSize imageSize = sourceImage.size;
    //   CGFloat width = imageSize.width;
    //   CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    //   CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}


- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees 
{   
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    [rotatedViewBox release];
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
- (UIImage *)imageByColorizing:(UIColor *)theColor
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, self.CGImage);
    
    [theColor set];
    
    CGContextFillRect(ctx, area);
    
    CGContextRestoreGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)convertImageToGrayScale:(UIColor *)theColor
{
    //http://stackoverflow.com/questions/3514066/how-to-tint-a-transparent-png-image-in-iphone
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, self.CGImage);
    

    // draw tint color
    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    [theColor setFill];
    CGContextFillRect(ctx, area);
    
    // replace luminosity of background (ignoring alpha)
    CGContextSetBlendMode(ctx, kCGBlendModeLuminosity);
    CGContextDrawImage(ctx, area, self.CGImage);
    
    // mask by alpha values of original image
    CGContextSetBlendMode(ctx, kCGBlendModeDestinationIn);
    CGContextDrawImage(ctx, area, self.CGImage);
    
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}


@end;

//static CGRect swapWidthAndHeight(CGRect rect)
//{
//    CGFloat  swap = rect.size.width;
//    
//    rect.size.width  = rect.size.height;
//    rect.size.height = swap;
//    
//    return rect;
//}
//
//@implementation UIImage (UKImage)
//
//-(UIImage*)rotate:(UIImageOrientation)orient
//{
//    CGRect             bnds = CGRectZero;
//    UIImage*           copy = nil;
//    CGContextRef       ctxt = nil;
//    CGImageRef         imag = self.CGImage;
//    CGRect             rect = CGRectZero;
//    CGAffineTransform  tran = CGAffineTransformIdentity;
//    
//    rect.size.width  = CGImageGetWidth(imag);
//    rect.size.height = CGImageGetHeight(imag);
//    
//    bnds = rect;
//    
//    switch (orient)
//    {
//        case UIImageOrientationUp:
//            // would get you an exact copy of the original
//            assert(false);
//            return nil;
//            
//        case UIImageOrientationUpMirrored:
//            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
//            tran = CGAffineTransformScale(tran, -1.0, 1.0);
//            break;
//            
//        case UIImageOrientationDown:
//            tran = CGAffineTransformMakeTranslation(rect.size.width,
//                                                    rect.size.height);
//            tran = CGAffineTransformRotate(tran, M_PI);
//            break;
//            
//        case UIImageOrientationDownMirrored:
//            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
//            tran = CGAffineTransformScale(tran, 1.0, -1.0);
//            break;
//            
//        case UIImageOrientationLeft:
//            bnds = swapWidthAndHeight(bnds);
//            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
//            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
//            break;
//            
//        case UIImageOrientationLeftMirrored:
//            bnds = swapWidthAndHeight(bnds);
//            tran = CGAffineTransformMakeTranslation(rect.size.height,
//                                                    rect.size.width);
//            tran = CGAffineTransformScale(tran, -1.0, 1.0);
//            tran = CGAffineTransformRotate(tran, 3.0 * M_PI / 2.0);
//            break;
//            
//        case UIImageOrientationRight:
//            bnds = swapWidthAndHeight(bnds);
//            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
//            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
//            break;
//            
//        case UIImageOrientationRightMirrored:
//            bnds = swapWidthAndHeight(bnds);
//            tran = CGAffineTransformMakeScale(-1.0, 1.0);
//            tran = CGAffineTransformRotate(tran, M_PI / 2.0);
//            break;
//            
//        default:
//            // orientation value supplied is invalid
//            assert(false);
//            return nil;
//    }
//    
//    UIGraphicsBeginImageContext(bnds.size);
//    ctxt = UIGraphicsGetCurrentContext();
//    
//    switch (orient)
//    {
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            CGContextScaleCTM(ctxt, -1.0, 1.0);
//            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
//            break;
//            
//        default:
//            CGContextScaleCTM(ctxt, 1.0, -1.0);
//            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
//            break;
//    }
//    
//    CGContextConcatCTM(ctxt, tran);
//    CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imag);
//    
//    copy = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return copy;
//}
//
//@end


