//
//  CartDenominationCell.h
//  EatinApp
//
//  Created by Ved Prakash on 1/28/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartDenominationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblSubTotalTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTotalValue;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscountTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscountValue;
@property (strong, nonatomic) IBOutlet UILabel *lblTaxTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTaxValue;
@property (strong, nonatomic) IBOutlet UILabel *lblChargeTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblChargeValue;

@end
