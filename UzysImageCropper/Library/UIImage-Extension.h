//
//  UIImage-Extension.h
//
//  Created by Hardy Macia on 7/1/09.
//  Copyright 2009 Catamount Software. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface UIImage (CS_Extensions)
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)imageByColorizing:(UIColor *)theColor;
- (UIImage *)convertImageToGrayScale:(UIColor *)theColor;
//- (UIImage *)imageBygrayishImage;
//- (UIImage *)convertToGrayscale;
//- (UIImage *)convertToDark ;
@end

@interface UIImage (UKImage)

-(UIImage*)rotate:(UIImageOrientation)orient;

@end

