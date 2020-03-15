//
//  AppHolderController.h
//  EatinApp
//
//  Created by Ved Prakash on 1/24/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavBar.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "MenuViewController.h"

@interface AppHolderController : UIViewController
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) IBOutlet UIView *viewContainer;
@property (nonatomic, strong) CustomNavBar *navBar;
@property (nonatomic, strong) MenuViewController *menuController;
@property (assign) BOOL calledFromMenu, isHidden;
-(void)addCustomNavBarOfType:(kNavBarType)type withTitle:(NSString *)title;
@end
