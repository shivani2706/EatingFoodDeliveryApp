//
//  AppHolderController.m
//  EatinApp
//
//  Created by Ved Prakash on 1/24/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "AppHolderController.h"
#import "ResultsViewController.h"
#import "AppDelegate.h"
#import "CheckoutViewController.h"
#define ShowResultsSegueIdentifier @"showResults"
#define DetailsControllerSegueIdentifier @"showRestaurantDetails"
#define ShowResultsSegueIdentifier @"BackToProfile"
#define ShowCartSegueIdentifier @"showCart"

@interface AppHolderController ()<MenuActionDelegate>
{
    AppDelegate *appSharedObj;
}
@property(nonatomic, strong)UITapGestureRecognizer *closeMenuGesture;
@end

@implementation AppHolderController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     appSharedObj = (AppDelegate *)[[UIApplication sharedApplication]delegate];
	// Do any additional setup after loading the view.
    self.backgroundImage=[[UIImageView alloc] initWithFrame:self.view.frame];
    self.backgroundImage.image=APP_IMAGE;
    [self.viewContainer addSubview:self.backgroundImage];
    [self.viewContainer sendSubviewToBack:self.backgroundImage];
    
    self.menuController=[[MenuViewController alloc] initWithNibName:@"MenuView" bundle:nil];
    self.menuController.delegate=self;
    
    self.closeMenuGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuDidClose)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.calledFromMenu=NO;
    self.isHidden=NO;
    if(self.navBar.btnMenu.selected)
    {//If menu is open
        [self menuDidClose];
    }
}



-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)addCustomNavBarOfType:(kNavBarType)type withTitle:(NSString *)title{

    self.navBar=(CustomNavBar *)[[[NSBundle mainBundle] loadNibNamed:@"CustomNavBar" owner:self options:nil] lastObject];
    [self.viewContainer addSubview:self.navBar];
    [self.navBar createNavBarWithTitle:title ofType:type];
    [self.navBar.btnMenu addTarget:self action:@selector(btnMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar.btnBack addTarget:self action:@selector(btnBackAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -
#pragma mark Common Actions

-(IBAction)btnBackAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnMenuAction:(id)sender{
    
    UIButton *btn=(UIButton *)sender;
    
    if(!btn.selected){//If not selected open the menu
        
        btn.selected=YES;
    
        //Add the menu to start x position
        CGRect rect=self.menuController.view.frame;
        rect.origin.x=0.0;
        self.menuController.view.frame=rect;
        
        [self.view addSubview:self.menuController.view];
        [self.view bringSubviewToFront:self.viewContainer];
        
        //Animate to show the menu..
        
        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
            
            //Move the container to right
            CGRect rect=self.viewContainer.frame;
            rect.origin.x=rect.size.width-170.0;
            //Only for smaller devices
            if(!IS_IPHONE_5)
                rect.origin.y=rect.origin.y+30.0;
            self.viewContainer.frame=rect;
            
            //Scale down the view
            self.viewContainer.transform=CGAffineTransformMakeScale(.55, .55);
            
            //Add shadow to the container
            self.viewContainer.layer.masksToBounds = NO;
            self.viewContainer.layer.shadowColor = [UIColor blackColor].CGColor;
            self.viewContainer.layer.shadowOffset = CGSizeMake(8.0f, 5.0f);
            self.viewContainer.layer.shadowRadius=15.0;
            self.viewContainer.layer.shadowOpacity = 0.8f;
        
            //Add close menu tap gesture
            [self.viewContainer addGestureRecognizer:self.closeMenuGesture];
            
            
            
        }
                         completion:^(BOOL finished) {
            if(finished){
                //Animate the table to appear sliding in from left
                 [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
                            CGRect rect=self.menuController.tblMenu.frame;
                            rect.origin.x=0.0;
                            self.menuController.tblMenu.frame=rect;
                 } completion:^(BOOL finished) {
                     
                 }];
            }
        }];
        
    }else{//Else close the menu
        btn.selected=NO;
        [self menuDidClose];
        
    }
    
}

#pragma mark -
#pragma MenuActionDelegates

-(void)menuDidSelect:(kMenuType)type{
    
    //Call the actions when menu animation has finished..
    
    [self closeMenu:^(void){
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            //Handles segues are called from the menu manually..
            self.calledFromMenu=YES;
             self.isHidden=YES;
            switch (type)
            {
                case kMenuHome:
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    break;
                case kMenuCart:
                    if(![self controllerExist:@"CheckoutViewController"]){
                        //We needed a common segue connecting to Checkout from all the controllers, see segue connections in storyboard
                        [self performSegueWithIdentifier:ShowCartSegueIdentifier sender:self];
                    }
                      break;
//                case kMenuOrder:
//                    break;
//                case kMenuInfo:
//                    break;
//                case kMenuProfile:
//                    break;
                    
               default:
                    break;
            }
        });
    
    }];
}

-(UIViewController *)controllerForClass:(NSString *)className{

    UIViewController *vc=nil;
    
    for(UIViewController *controller in self.navigationController.viewControllers){
        
        if([className isEqualToString:NSStringFromClass([controller class])]){
            vc=controller;
            break;
        }
    }
    
    return vc;
}

-(BOOL)controllerExist:(NSString *)className{
    //Check of the controller is present in navigation controller or, not.
    BOOL exist=NO;

    for(UIViewController *controller in self.navigationController.viewControllers){
    
        if([className isEqualToString:NSStringFromClass([controller class])]){
            exist=YES;
            break;
        }
    }

    return exist;
}

-(void)menuDidClose{

    [self closeMenu:nil];
}

-(void)closeMenu:(void (^) (void))completion{
    
    self.navBar.btnMenu.selected=NO;
    
    //Animate to hide the menu..
    
    //Animate the table to hide sliding in to left
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
        CGRect rect=self.menuController.tblMenu.frame;
        rect.origin.x=-rect.size.width;
        self.menuController.tblMenu.frame=rect;
    } completion:^(BOOL finished) {
        if(finished){
            [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
                
                //Scale down the view
                self.viewContainer.transform=CGAffineTransformIdentity;
                
                //Move the container to right
                CGRect rect=self.viewContainer.frame;
                rect.origin.x=0.0;
                //Only for smaller devices
                if(!IS_IPHONE_5)
                    rect.origin.y=0.0;
                self.viewContainer.frame=rect;
                
                [self.viewContainer removeGestureRecognizer:self.closeMenuGesture];
                
                [[self.viewContainer layer] setShadowOpacity:0.0];
                [[self.viewContainer layer] setShadowRadius:0.0];
                [[self.viewContainer layer] setShadowColor:nil];
                
            } completion:^(BOOL finished) {
                if(finished){
                    [self.menuController.view removeFromSuperview];
                    
                    if(completion){
                        completion();
                    }
                }
            }];
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
