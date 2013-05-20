//
//  UIImage-Extension.h
//
//  Created by Hardy Macia on 7/1/09.
//  Copyright 2009 Catamount Software. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ARCHelper.h"

@interface UIImage (CS_Extensions)
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

- (UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;
- (UIImage*)resizedImageToSize:(CGSize)dstSize;
- (UIImage *)cropImage:(CGRect) rect;
- (UIImage *)fixOrientation;

@end


