//
//  DataManager.m
//  EatinApp
//
//  Created by Ved Prakash on 1/25/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "DataManager.h"
#import "AppDelegate.h"

@implementation DataManager

+(NSArray *)nearByRestaurants{

    NSString *jsonPath=BUNDLE_PATH(@"restaurants", @"json");
    
    NSDictionary *jsonData=(NSDictionary *)[DataManager parseJsonData:[NSData dataWithContentsOfFile:jsonPath]];
    return [jsonData objectForKey:@"results"];

}

+(NSDictionary *)restaurantDetails{
    
    NSString *jsonPath=BUNDLE_PATH(@"restaurant_details", @"json");
    
    return (NSDictionary *)[DataManager parseJsonData:[NSData dataWithContentsOfFile:jsonPath]];
}

+(id)parseJsonData:(NSData *)data{

    NSError *error;
        
    NSJSONSerialization *json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if(!error)
        return json;
    
    return nil;

}

#pragma mark -
#pragma mark Cart Operations

+(AppDelegate *)appDelegate{

    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

+(void)addItemToCart:(NSMutableDictionary *)item
{
    [[DataManager appDelegate].MyCartArr addObject:item];

}

+(void)removeItemFromCart:(NSMutableDictionary *)item{
    [[DataManager appDelegate].MyCartArr removeObject:item];
}

+(void)clearCartItems{
    [[DataManager appDelegate].MyCartArr removeAllObjects];
}

+(NSMutableArray *)getCartItems{

    return [DataManager appDelegate].MyCartArr;
}

+(CGFloat)cartTotal{

    float total=0.0;
    
    for(NSMutableDictionary *item in [DataManager appDelegate].MyCartArr){
        NSDictionary *foodItem=[item objectForKey:@"name"];
        float basePrice=[[foodItem objectForKey:@"price"] floatValue];
        float price=basePrice * [[item objectForKey:@"qty"] floatValue];
        
        total=total+price;
    }
    
    return total;
}

+(BOOL)itemExistInCart:(NSDictionary *)item
{
   BOOL exist=NO;
    
//    for(NSMutableDictionary *cartItem in [DataManager appDelegate].MyCartArr)
//    {
//        if([[cartItem objectForKey:@"id"] intValue] == [[item objectForKey:@"id"] intValue])
//        {
//            exist=YES;
//            break;
//        }
//    }
//    
    return exist;
}


@end
