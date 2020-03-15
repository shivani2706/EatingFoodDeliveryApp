//
//  User.m
//  EatinApp
//
//  Created by shivani on 3/27/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

#import "User.h"
#import "APICall.h"
#import "AppDelegate.h"
#import "UIView+Toast.h"
#import <MBProgressHUD.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import <AFNetworking/AFNetworking.h>
#define BASE_URL        @"http://216.55.169.45/~eatin/master/api/"
#define URL_FetchRestaurant           BASE_URL@"ws_update_user_details"
@implementation User


-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.RestaurantDetails=[[NSMutableString alloc]init];
       
        
    }
    
    return self;
}


//-(void)FetchRestaurant:(user_completion_block)completion   //CourtList
//{
//NSMutableDictionary *RestaurantListDic =[[NSMutableDictionary alloc]init];
//[RestaurantListDic setObject:self.CurrentLat forKey:@"lat"];
//[RestaurantListDic setObject:self.CurrentLong forKey:@"lng"];


//[APICall callPostWebService:URL_FetchRestaurant andDictionary:RestaurantListDic completion:^(NSDictionary* user, NSError*error, long code)
// {
//     
//     
//     if(error)
//     {
//         if(completion)
//         {
//             completion(@"There was some error, please try again later",-1);
//         }
//         //AFNetworkingOperationFailingURLResponseErrorKey
//         [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
//     }
//     else
//     {
//         if(completion)
//         {
//             if([[ NSString stringWithFormat:@"%@",[user valueForKey:@"status"] ]isEqualToString:@"1"])
//             {
//                 AppDelegate *appSharedObj = (AppDelegate *)[[[UIApplication sharedApplication]delegate];
//                 appSharedObj.FetchRestaurantDict=[[NSMutableDictionary alloc]initWithDictionary:user];
//                 completion(@"Court list obtained, succesfully!",1);
//             }
//             else
//             {
//                 completion(@"No list found!",0);
//             }
//         }
//     }
// }];
//}
//

//+ (BOOL)connectedToNetwork
//{
//    // Create zero addy
//    struct sockaddr_in zeroAddress;
//    bzero(&zeroAddress, sizeof(zeroAddress));
//    zeroAddress.sin_len = sizeof(zeroAddress);
//    zeroAddress.sin_family = AF_INET;
//    
//    // Recover reachability flags
//    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
//    SCNetworkReachabilityFlags flags;
//    
//    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
//    CFRelease(defaultRouteReachability);
//    
//    if (!didRetrieveFlags)
//    {
//        printf("Error. Could not recover network reachability flags\n");
//        return 0;
//    }
//    
//    BOOL isReachable = flags & kSCNetworkFlagsReachable;
//    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
//    
//    BOOL isconnected = (isReachable && !needsConnection) ? YES : NO;
//    if (!isconnected)
//    {
//        [[(AppDelegate*) [UIApplication sharedApplication].delegate window] makeToast:@"Check Your Internet Connection"];
//        [self init];
//    }
//    return isconnected;
//}


@end
