//
//  Macros.h
//  Eatin
//
//  Created by Ved Prakash on 1/24/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import <Foundation/Foundation.h>
//Adding common imports
#import "AppHolderController.h"
#import "CustomCellButton.h"
#import "UIView+NibLoading.h"

//For custom navigation push and pop animations
#import "UINavigationController+Custom.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IsTablet (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IfNil(input,replacement) (input == nil) ? replacement : input
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define APP_IMAGE [UIImage imageNamed:IS_IPHONE_5?@"app_background.png":@"app_background_5.png"]

#define BUNDLE_PATH(filename,type)[[NSBundle mainBundle] pathForResource:filename ofType:type]


//FONTS
#define UBUNTU_REGULAR(SIZE)[UIFont fontWithName:@"Ubuntu" size:SIZE]
#define UBUNTU_BOLD(SIZE)[UIFont fontWithName:@"Ubuntu-Bold" size:SIZE]
#define UBUNTU_LIGHT(SIZE)[UIFont fontWithName:@"Ubuntu-Light" size:SIZE]
#define UBUNTU_MEDIUM(SIZE)[UIFont fontWithName:@"Ubuntu-Medium" size:SIZE]
#define UBUNTU_CONDENSED(SIZE)[UIFont fontWithName:@"UbuntuCondensed-Regular" size:SIZE]
#define UBUNTUMONO_BOLD(SIZE)[UIFont fontWithName:@"UbuntuMono-Bold" size:SIZE]


//Colors
#define WHITE_COLOR [UIColor whiteColor]
#define LIGHT_PINK_COLOR [UIColor colorWithRed:255.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0]
#define BLACK_COLOR [UIColor blackColor]

@interface Macros : NSObject

@end
