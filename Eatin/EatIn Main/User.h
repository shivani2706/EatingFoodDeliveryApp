//
//  User.h
//  EatinApp
//
//  Created by shivani on 3/27/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface User : NSObject
typedef void(^user_completion_block)(NSString *, int status);
typedef void(^user_completion_block_data)(NSString *, int status,NSDictionary *dict);

-(void)FetchRestaurant:(user_completion_block)completion;
@property NSMutableString *CurrentLat, *CurrentLong,*RestaurantDetails;
+ (BOOL)connectedToNetwork;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *surname;
@property (nonatomic, strong) NSDate *dateOfBirth;

@end
