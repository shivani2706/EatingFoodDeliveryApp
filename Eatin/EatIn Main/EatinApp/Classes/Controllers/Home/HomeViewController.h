//
//  HomeViewController.h
//  Eatin
//
//  Created by Ved Prakash on 1/24/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"


@interface HomeViewController : AppHolderController {
    Reachability *internetReachableFoo;
    NSDictionary* json;

}
@property (strong, nonatomic) IBOutlet UIImageView *homeBgImage;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress;
@property (strong, nonatomic) IBOutlet UIButton *btnOrderNow;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property NSMutableString *CurrentLat, *CurrentLong,*strDistance,*strLat,*strLon;
//-(void) checkNetworkStatus:(NSNotification *)notice;


@property (weak,nonatomic) NSString *cityStr;
@property (strong, nonatomic) IBOutlet UITableView *AddressTableView;
@end
