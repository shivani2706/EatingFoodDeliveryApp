//
//  UIImage+Utility.h
//  EatinApp
//
//  Created by Ved Prakash on 1/24/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Screenshot)
- (UIImage*)screenshot:(CGRect)rect;
@end

@interface UIImage (Utility)
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur frame:(CGRect)rect;
@end
