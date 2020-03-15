//
//  CartTotalCell.h
//  EatinApp
//
//  Created by Ved Prakash on 1/28/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartTotalCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTotalTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalValue;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblQty;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet CustomCellButton *btnDelete;

- (IBAction)btnDeleteAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgCellQty;


@property (weak, nonatomic) IBOutlet UIButton *Delete;
@property (weak, nonatomic) IBOutlet UILabel *LblTotalGrey;

@end
