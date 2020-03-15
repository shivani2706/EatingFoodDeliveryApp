//
//  APICall.m
//  EatinApp
//
//  Created by shivani on 3/27/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

#import "APICall.h"
#import "AFNetworking.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>


@implementation APICall

+(void)callPostWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter completion:(completion_handler_t)completion
{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
  
//    managerAF.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer = [AFJSONResponseSerializer                                   serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
   // manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
   // manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //[manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", encodedUsernameAndPassword] forHTTPHeaderField:@"Authorization"];
   // [manager.requestSerializer setValue:@"application/form-data" forHTTPHeaderField:@"Content-Type"];
   
    
    //-=========
     manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager POST:urlStr parameters: parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"POST data JSON returned: %@", responseObject);
        if (completion) {
            long code=200;
              NSDictionary* json = responseObject;
           completion([json mutableCopy], nil,code);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            
            long code=(long)[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
            completion(nil, error,code);
        }
    }
     ];
}




@end
