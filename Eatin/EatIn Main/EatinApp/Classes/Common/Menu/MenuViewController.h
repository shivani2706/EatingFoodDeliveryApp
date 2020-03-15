//
//  MenuViewController.h
//  EatinApp
//
//  Created by Ved Prakash on 1/28/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ShowResultsSegueIdentifier @"showResults"
#define DetailsControllerSegueIdentifier @"showRestaurantDetails"
typedef enum
{
    kMenuHome       =           3,
    kMenuProfile    =           1,
    kMenuCart       =           2,
    kMenuOrder      =           4,
    kMenuInfo       =           5    
//    kMenuHome       =           1,
//    kMenuProfile    =           2,
//    kMenuCart       =           3,
//    kMenuOrder      =           4,
//    kMenuInfo       =           5
    
    
  
}kMenuType;

@protocol MenuActionDelegate <NSObject>

-(void)menuDidSelect:(kMenuType)type;
-(void)menuDidClose;

@end

@interface MenuViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UITableView *tblMenu;
@property (strong, nonatomic) id <MenuActionDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *viewControllerHolder;


@end
