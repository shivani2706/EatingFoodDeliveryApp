//
//  DataManager.h
//  EatinApp
//
//  Created by Ved Prakash on 1/25/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@interface DataManager : NSObject
{
   

}
+(NSArray *)nearByRestaurants;
+(NSDictionary *)restaurantDetails;

+(void)addItemToCart:(NSMutableDictionary *)item;
+(void)removeItemFromCart:(NSMutableDictionary *)item;
+(void)clearCartItems;
+(NSMutableArray *)getCartItems;
+(CGFloat)cartTotal;
+(BOOL)itemExistInCart:(NSDictionary *)item;

@end
