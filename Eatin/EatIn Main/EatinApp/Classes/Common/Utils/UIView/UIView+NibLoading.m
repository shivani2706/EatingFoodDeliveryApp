//
//  UIView+NibLoading.m
//  EatinApp
//
//  Created by Ved Prakash on 1/24/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "UIView+NibLoading.h"

@implementation UIView(NibLoading)


+ (id)loadInstanceFromNib
{
    UIView *result;
    
    NSArray* elements = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    
    for (id anObject in elements) {
        if ([anObject isKindOfClass:[self class]]) {
            result = anObject;
            break;
        }
    }
    
    return result;
}
@end
