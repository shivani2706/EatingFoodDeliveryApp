//
//  UINavigationController+Custom.h
//  EatinApp
//
//  Created by Teknowledge Software on 1/24/14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef enum {
    CustomViewAnimationTransitionNone,
    CustomViewAnimationTransitionFlipFromLeft,
    CustomViewAnimationTransitionCrossDesolve,
    CustomViewAnimationTransitionFlipFromRight,
    CustomViewAnimationTransitionCurlUp,
    CustomViewAnimationTransitionCurlDown,
    CustomViewAnimationTransitionFadeIn,
    CustomViewAnimationTransitionMoveIn,
    CustomViewAnimationTransitionPush,
    CustomViewAnimationTransitionReveal
} CustomViewAnimationTransition;

#define CustomViewAnimationSubtypeFromRight kCATransitionFromRight
#define CustomViewAnimationSubtypeFromLeft kCATransitionFromLeft
#define CustomViewAnimationSubtypeFromTop kCATransitionFromTop
#define CustomViewAnimationSubtypeFromBottom kCATransitionFromBottom

@interface UINavigationController(Additions)
//Custom Navigations
- (void)pushViewController:(UIViewController *)viewController withCustomTransition:(CustomViewAnimationTransition)transition subtype:(NSString*)subtype;

- (void)popViewControllerWithCustomTransition:(CustomViewAnimationTransition)transition subtype:(NSString*)subtype;
- (void)popToRootViewControllerWithCustomTransition:(CustomViewAnimationTransition)transition subtype:(NSString*)subtype;
- (void)popToViewController:(UIViewController *)viewController withCustomTransition:(CustomViewAnimationTransition)transition subtype:(NSString*)subtype;

- (void)standardAnimationWithController:(UIViewController*)viewController
							   duration:(NSTimeInterval)duration
                                options:(UIViewAnimationOptions)options
						   changesBlock:(void (^)(void))block;

- (void)coreAnimationWithController:(UIViewController*)viewController
						   duration:(NSTimeInterval)duration
							   type:(NSString*)type
							subtype:(NSString*)subtype
					   changesBlock:(void (^)(void))block;


@end
