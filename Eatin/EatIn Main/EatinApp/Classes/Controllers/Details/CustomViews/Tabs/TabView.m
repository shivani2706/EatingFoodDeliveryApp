//
//  TabView.m
//  EatinApp
//
//  Created by Ved Prakash on 1/27/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "TabView.h"

@implementation TabView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.lblTitle.font=UBUNTU_REGULAR(16.0);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
