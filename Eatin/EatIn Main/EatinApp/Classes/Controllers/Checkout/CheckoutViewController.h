//
//  CheckoutViewController.h
//  Eatin
//
//  Created by Ved Prakash on 1/24/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutViewController : AppHolderController
@property(nonatomic, strong)NSMutableArray *arrCartItems , *arrstrings,*arrCart;
@property(strong,nonatomic) NSString *strID, *strTotal, *strRestauntantID, *strStatus, *strPickUp, *strDelivery,*MultipliedValue;

@property (strong, nonatomic) IBOutlet UITableView *tblCart;
- (IBAction)btnCheckout:(id)sender;
- (IBAction)btnPickUp:(id)sender;
- (IBAction)btnDelivery:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imgviewChckout;
@property (strong, nonatomic) IBOutlet UIButton *BtnPickUpProperty;
@property (strong, nonatomic) IBOutlet UIButton *BtnDeliveryProperty;
@property (strong, nonatomic) IBOutlet UIButton *BtnCheckoutProperty;

@property (weak, nonatomic) IBOutlet UIImageView *itemsTitleImgView;

@end
