//
//  RestaurantItemsCell.m
//  EatinApp
//
//  Created by Ved Prakash on 1/27/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "RestaurantItemsCell.h"

@implementation RestaurantItemsCell

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
    self.lblTitle.font=UBUNTU_REGULAR(12.0);
    self.lblDesc.font=UBUNTU_REGULAR(12.0);
    
    self.lblPrice.font=UBUNTU_REGULAR(12.0);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
