//
//  AppDelegate.h
//  EatinApp
//
//  Created by Ved Prakash on 1/24/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *arrCart,*MyCartArr;
@property float  lat , lon;
@property double TotalPricez;
@property (strong, nonatomic)  NSMutableDictionary *MyLocation,*FetchRestaurantDict;
@property (strong, nonatomic)NSString *strmainpath,*strID,*strRestauntantID,*strRestauntantIDTemp,*StrPrice,*strPopularPrice,*stringTotal,*stringFoodItemQuant,*stringPopularFoodItemQuant,*strTotalSubValue, *strTitleTotal, *strName, *strDeliveryPrice,*strTotalPricez,*strDeliveryCharge;


@end
