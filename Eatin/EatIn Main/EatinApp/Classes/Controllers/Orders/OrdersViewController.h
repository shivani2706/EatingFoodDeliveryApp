//
//  OrdersViewController.h
//  Eatin
//
//  Created by Ved Prakash on 1/24/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersViewController : AppHolderController
@property(nonatomic, strong) NSMutableDictionary *foodItem,*popularFoodItem
;
 @property(nonatomic, strong) NSMutableDictionary *Orderitem;
@property (strong, nonatomic) IBOutlet UILabel *lblFoodTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
- (IBAction)modifyQuantityAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnQuantity;
@property (strong, nonatomic) IBOutlet UILabel *lblQuantity;

@property (strong, nonatomic) IBOutlet UILabel *lblAddOptions;
@property (strong, nonatomic) IBOutlet UILabel *lblMakeItWith;

@property (strong, nonatomic) IBOutlet UILabel *lblPickedOption;
@property (strong, nonatomic) IBOutlet UILabel *lblSpecialInstructions;
//@property (strong, nonatomic) IBOutlet UITextView *txtInstructions;
@property (strong, nonatomic) IBOutlet UILabel *lblExamples;
@property (strong, nonatomic) IBOutlet UILabel *lblCharges;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScroller;
@property(nonatomic, strong) NSString *strITEM,*strIDChechkout,*strIDRestChckout,*strQuantity,*StrPrice,*StrTotal, *strTotalDoublePrice,*StrPopularPrice,*StrPopularTrimPrice,*strTrimPrice,*selectedIndexStr,*strDeliveryCharges;

@property (strong, nonatomic) IBOutlet UIImageView *ImgViewMyCart;
@property (strong, nonatomic) IBOutlet UITextView *TxtViewInstructions;



@end
