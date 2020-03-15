//
//  ResultsViewController.h
//  Eatin
//
//  Created by Ved Prakash on 1/24/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ResultsViewController : AppHolderController
{
    AppDelegate *appSharedObj;
    UIRefreshControl *refreshControl;
}

@property (strong, nonatomic) IBOutlet UITableView *tblResults;
@property (strong, nonatomic) IBOutlet UIView *viewFilterButtons;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) NSString *address,*strMinValue,*strRestaurantName,*strResultDeliveryPrice,*strRestLat,*strRestLong;

@property (weak, nonatomic) IBOutlet UIImageView *ImgFreeDelivery;
@property (strong, nonatomic) IBOutlet UIButton *BtnPopular;
@property (strong , nonatomic) NSString *selectedIndexStr;
@property (weak, nonatomic) IBOutlet UIButton *BtnNewest;
@property (weak, nonatomic) IBOutlet UIButton *BtnDistance;
@property (weak, nonatomic) IBOutlet UIButton *BtnMinimum;
@property (weak, nonatomic) IBOutlet UIButton *BtnFreeDelivery;


@property (weak, nonatomic) IBOutlet UILabel *LblNoFreeRestaurant;





@end
