//
//  CartDenominationCell.m
//  EatinApp
//
//  Created by Ved Prakash on 1/28/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "CartDenominationCell.h"

@implementation CartDenominationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self setupFonts];
}

-(void)setupFonts{
    self.lblSubTotalTitle.font=self.lblDiscountTitle.font=self.lblChargeTitle.font=self.lblDiscountTitle.font=self.lblTaxTitle.font=UBUNTU_REGULAR(15.0);
    
    self.lblSubTotalValue.font=self.lblDiscountValue.font=self.lblChargeValue.font=self.lblTaxValue.font=UBUNTU_MEDIUM(14.0);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
