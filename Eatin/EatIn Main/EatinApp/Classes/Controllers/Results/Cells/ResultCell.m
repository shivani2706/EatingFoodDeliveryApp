//
//  ResultCell.m
//  EatinApp
//
//  Created by Ved Prakash on 1/25/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "ResultCell.h"

@implementation ResultCell

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

-(void)setRatings:(int)ratings
{
    for(UIButton *btn in self.viewRatings.subviews)
    {
        btn.selected=NO;
    }
    
    for(UIButton *btn in self.viewRatings.subviews)
    {
        if(btn.tag<ratings)
            btn.selected=YES;
    }
    
}


-(void)setupFonts{
    
    //Setup fonts of all the elements of the cell

    self.lblTitle.font=UBUNTU_MEDIUM(16.0);
    self.lblReviews.font=UBUNTU_MEDIUM(12.0);
    self.lblDistance.font=UBUNTU_MEDIUM(12.0);
    self.lblMinTitle.font=UBUNTU_MEDIUM(12.0);
    self.lblMinValue.font=UBUNTU_MEDIUM(12.0);
    self.lblCuisinesType.font=UBUNTU_REGULAR(14.0);
    
    self.lblDeliveryTitle.font=UBUNTU_MEDIUM(12.0);
    self.lblDeliveryValue.font=UBUNTU_MEDIUM(12.0);
    self.LblDeliveryMaxTime.font=UBUNTU_MEDIUM(12.0);
    self.lblDeliveryTime.font=UBUNTU_MEDIUM(12.0);
}

-(void)applySelectedCellChanges{
    self.lblTitle.textColor=WHITE_COLOR;
    self.lblReviews.textColor=WHITE_COLOR;
    self.lblMinTitle.textColor=self.lblMinValue.textColor=WHITE_COLOR;
    self.lblDeliveryTitle.textColor=self.lblDeliveryValue.textColor=WHITE_COLOR;
    self.lblDeliveryTime.textColor=WHITE_COLOR;
    self.LblDeliveryMaxTime.textColor=WHITE_COLOR;
    self.lblDistance.textColor=LIGHT_PINK_COLOR;
    self.lblCuisinesType.textColor=LIGHT_PINK_COLOR;
}

-(void)applyNormalCellChanges{
    self.lblTitle.textColor=BLACK_COLOR;
    self.lblReviews.textColor=BLACK_COLOR;
    self.lblMinTitle.textColor=self.lblMinValue.textColor=BLACK_COLOR;
    self.lblDeliveryTitle.textColor=self.lblDeliveryValue.textColor=BLACK_COLOR;
    self.lblDeliveryTime.textColor=BLACK_COLOR;
    self.LblDeliveryMaxTime.textColor=BLACK_COLOR;
    self.lblDistance.textColor=BLACK_COLOR;
    self.lblCuisinesType.textColor=BLACK_COLOR;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if(selected)
        [self applySelectedCellChanges];
    else
        [self applyNormalCellChanges];
    
    [UIView animateWithDuration:.3 animations:^(void){
        self.selectedCellImage.alpha=selected?1.0:0.0;
    }];

    // Configure the view for the selected state
}

@end
