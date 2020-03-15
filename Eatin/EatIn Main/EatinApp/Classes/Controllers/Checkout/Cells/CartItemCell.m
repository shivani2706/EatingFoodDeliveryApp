//
//  CartItemCell.m
//  EatinApp
//
//  Created by Ved Prakash on 1/28/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "CartItemCell.h"

@implementation CartItemCell

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
    self.lblTitle.font=UBUNTU_MEDIUM(15.0);
    self.lblPrice.font=UBUNTU_MEDIUM(15.0);
    self.lblQty.font=UBUNTU_MEDIUM(15.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
