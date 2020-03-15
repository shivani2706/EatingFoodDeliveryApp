//
//  APICall.h
//  EatinApp
//
//  Created by shivani on 3/27/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APICall : NSObject
typedef void(^completion_handler_t)(NSMutableDictionary *, NSError*error, long code);




+(void)callPostWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter completion:(completion_handler_t)completion;

+(void)callPostWebServiceOrder:(NSString *)urlStr andDictionary:(NSDictionary *)parameter completion:(completion_handler_t)completion;

@end
