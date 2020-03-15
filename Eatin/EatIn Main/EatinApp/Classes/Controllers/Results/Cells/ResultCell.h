//
//  ResultCell.h
//  EatinApp
//
//  Created by Ved Prakash on 1/25/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *cellImage;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIView *viewRatings;
@property (strong, nonatomic) IBOutlet UILabel *lblReviews;
@property (strong, nonatomic) IBOutlet UILabel *lblDistance;
@property (strong, nonatomic) IBOutlet UILabel *lblCuisinesType;
@property (strong, nonatomic) IBOutlet UILabel *lblDeliveryTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDeliveryValue;
@property (strong, nonatomic) IBOutlet UILabel *lblMinTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblMinValue;
@property (strong, nonatomic) IBOutlet UILabel *lblDeliveryTime;
@property (strong, nonatomic) IBOutlet UIImageView *selectedCellImage;
@property (weak, nonatomic) IBOutlet UILabel *LblcreatedAt;

@property (weak, nonatomic) IBOutlet UILabel *LblDeliveryMaxTime;
@property (weak, nonatomic) IBOutlet UILabel *LblStars;

-(void)setRatings:(int)ratings;




@end
