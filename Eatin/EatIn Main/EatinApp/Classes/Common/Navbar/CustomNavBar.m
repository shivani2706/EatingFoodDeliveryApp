//
//  CustomNavBar.m
//  EatinApp
//
//  Created by Ved Prakash on 1/25/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "CustomNavBar.h"

@implementation CustomNavBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)createNavBarWithTitle:(NSString *)title ofType:(kNavBarType)navType{

    //Create navigation bar for different requirements in different screens
    
    BOOL iOS7=NO;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        //If iOS version is >= 7.0 the navigation bar should be bigger to accomodate extra 20 px shift towards top.
        
        CGRect rect=self.frame;
        rect.size.height=rect.size.height+20.0;
        self.frame=rect;
        
        iOS7=YES;
    }
    
    self.lblTitle.font=UBUNTU_REGULAR(16.0);
    self.lblTitle.text=NSLocalizedString(title, nil);
    self.navBGImage.image=[UIImage imageNamed:iOS7?@"navbar_iOS7_nologo.png":@"navbar_nologo.png"];
    self.lblTitle.hidden=NO;
    self.btnOthers.hidden=NO;
    self.btnMenu.hidden=NO;
    self.btnBack.hidden=YES;
    
    switch (navType) {
        case kNavHome:
            //Navigation bar with logo
//            self.navBGImage.image=[UIImage imageNamed:iOS7?@"navbar_iOS7.png":@"navbar.png"];
            self.lblTitle.hidden=NO;
            self.btnOthers.hidden=YES;
            self.btnMenu.hidden=NO;
            break;
        case kNavNormal:
            self.lblTitle.hidden=NO;
            self.btnOthers.hidden=NO;
            self.btnBack.hidden=NO;
            break;
        case kNavWithSearch:
            self.lblTitle.hidden=NO;
            self.btnOthers.hidden=YES;
            self.btnBack.hidden=NO;
            self.btnMenu.hidden=YES;
            break;
            
        default:
            break;
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
