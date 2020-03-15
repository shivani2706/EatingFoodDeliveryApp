//
//  CustomNavBar.h
//  EatinApp
//
//  Created by Ved Prakash on 1/25/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kNavHome            =               1,
    kNavWithSearch      =               2,
    kNavNormal          =               3
} kNavBarType;


@interface CustomNavBar : UIView
@property (strong, nonatomic) IBOutlet UIImageView *navBGImage;
@property (strong, nonatomic) IBOutlet UIButton *btnMenu;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnOthers;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

-(void)createNavBarWithTitle:(NSString *)title ofType:(kNavBarType)navType;

@end
