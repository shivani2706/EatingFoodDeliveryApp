//
//  OrdersViewController.m
//  Eatin
//
//  Created by Ved Prakash on 1/24/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "OrdersViewController.h"
#import "CheckoutViewController.h"
#import "AppDelegate.h"
#import "APICall.h"
#import "UIView+Toast.h"
#import <MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Reachability.h"

#define ShowCartSegueIdentifier @"showCart"

@interface OrdersViewController ()<UITextViewDelegate>
{
    UIRefreshControl *refreshControl;
    NSMutableDictionary *item;
    NSArray *ItemSelected;
    AppDelegate *appSharedObj;
    NSString *ischeckedStr,*strDelivery;
    
    
}
@end

@implementation OrdersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    strDelivery = self.strDeliveryCharges;
    if (ischeckedStr == nil)
    {
        ischeckedStr = self.selectedIndexStr;
    }
    else
    {
        ischeckedStr = nil ;
    }
    appSharedObj = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    _strQuantity=@"1";
    [_TxtViewInstructions setDelegate:self];
    
    [self addCustomNavBarOfType:kNavWithSearch withTitle:@"Add to Cart"];
    [self setupFonts];
    [self populateData];
    //    [self populatePopularData];
    //  [self addAccessory];
    
    item =[[NSMutableDictionary alloc] init];
    ItemSelected =[[NSArray alloc] init];
    
    //----------
    
    
}

-(void)setupFonts
{
    self.lblFoodTitle.font=UBUNTU_MEDIUM(14.0);
    self.lblDesc.font=UBUNTU_LIGHT(12.0);
    self.lblPrice.font=UBUNTU_REGULAR(16.0);
    
    self.lblQuantity.font=UBUNTU_MEDIUM(14.0);
    self.btnQuantity.titleLabel.font=UBUNTU_REGULAR(14.0);
    
    self.lblAddOptions.font=UBUNTU_REGULAR(14.0);
    self.lblMakeItWith.font=UBUNTU_MEDIUM(14.0);
    self.lblPickedOption.font=UBUNTU_LIGHT(12.0);
    
    self.lblSpecialInstructions.font=UBUNTU_MEDIUM(14.0);
    self.lblExamples.font=self.lblCharges.font=UBUNTU_LIGHT(10.0);
    self.TxtViewInstructions.font=UBUNTU_REGULAR(13.0);
}

- (void)refreshTable
{
    //TODO: refresh your data
    [refreshControl endRefreshing];
   }
-(void)populateData
{
    //----normal Items------
    if ([self connected])
    {
    
    if (self.foodItem)
    {
        
          [self refreshTable];
        self.lblFoodTitle.text=[self.foodItem objectForKey:@"name"];
        appSharedObj.strName = self.lblFoodTitle.text ;
        self.lblDesc.text=[self.foodItem objectForKey:@"desc"];
        self.lblPrice.text=[NSString stringWithFormat:@"$%0.f",[[self.foodItem objectForKey:@"price"] floatValue]];
        [_ImgViewMyCart sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",appSharedObj.strmainpath,[self.foodItem valueForKey:@"image"]]] placeholderImage:nil];
        _StrPrice = self.lblPrice.text;
        return;
    }
    else
    {
        //-------popularData----//
          [self refreshTable];
        self.lblFoodTitle.text=[self.popularFoodItem objectForKey:@"name"];
        self.lblDesc.text=[self.popularFoodItem objectForKey:@"desc"];
        self.lblPrice.text=[NSString stringWithFormat:@"$%0.f",[[self.popularFoodItem objectForKey:@"price"] floatValue]];
        [_ImgViewMyCart sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_popularFoodItem valueForKey:@"image"]]] placeholderImage:nil];
        _StrPopularPrice = self.lblPrice.text;
        //_StrPrice = self.lblPrice.text;
      }
    }
    else
    {
        [self.view makeToast:@"Please!connect to internet"];
        self.lblFoodTitle.hidden = true;
        self.lblDesc.hidden = true;
        self.lblPrice.hidden = true;
        _ImgViewMyCart.image = [UIImage imageNamed:@"No_img_Available"];
        [self.view makeToast:@"Please!connect to internet"];
        
    }
    
}



-(IBAction)cancelAccesoryAction:(id)sender
{
    [self.TxtViewInstructions resignFirstResponder];
    [self.contentScroller setContentOffset:CGPointZero animated:YES];
}

-(IBAction)doneAccesoryAction:(id)sender
{
    [self.TxtViewInstructions resignFirstResponder];
    [self.contentScroller setContentOffset:CGPointZero animated:YES];
}


#pragma mark -
#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if([text isEqualToString:@"\n"])
    {
        [_TxtViewInstructions resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
   // [_TxtViewInstructions setReturnKeyType:UIReturnKeyDone];
    [_TxtViewInstructions resignFirstResponder];
    
   

    return YES;
}

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    
//    //Scroll the scroller up when textfield in focus
//   
//    
//}

// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
       NSLog(@"Text field ended editing");
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    CGRect bounds=textView.bounds;
    
    bounds=[textView convertRect:bounds toView:self.contentScroller];
    
    CGPoint pt;
    pt.x=0.0;
    pt.y=bounds.origin.y - (IS_IPHONE_5?150.0:100.0);
    
    // [self.contentScroller setContentOffset:pt animated:YES];
    
    
    return YES;
    
}
#pragma mark -
#pragma mark Actions

- (IBAction)modifyQuantityAction:(id)sender {
    if([self connected])
    {

    UIButton *btn=(UIButton *)sender;
    
   int  quantity=[self.btnQuantity.currentTitle intValue];
    
   
    if(btn.tag == 1)
    {//Add Quantity
        quantity ++;
        
    }else if(btn.tag == 2){//Remove Quantity
        quantity --;
    }
    
        if(quantity == 0)
        {
            quantity=1;//Minimum 1 quantity.
        }
        
    [self.btnQuantity setTitle:[NSString stringWithFormat:@"%d",quantity] forState:UIControlStateNormal];
    _strQuantity = [NSString stringWithFormat:@"%d",quantity];
    //appSharedObj.stringQuantity = self.strQuantity;
    }
    
    else
    {
        [self.view makeToast:@"Please!connect to internet"];
    }
    
}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    // networkStatus != NotReachable;
    if (networkStatus == NotReachable) {
        return NO;
    }
    else {
        return YES;
    }
}
- (IBAction)btnAddToCartAction:(id)sender {
    
     if ([self connected])
     {
    //Add item into cart with required number of quantity
    
         if(![appSharedObj.strRestauntantIDTemp isEqualToString: appSharedObj.strRestauntantID] && appSharedObj.strRestauntantIDTemp != nil)
         {
              [self.view makeToast:@"Can't Add from multiple restaurant"];
         }
         else
         {
             if (self.foodItem)
             {
                 //        if (ischeckedStr == nil)
                 //        {
                 //              [self.view makeToast:@"Can't Add from multiple restaurant"];
                 //        }
                 //        else
                 {
                     item = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              self.foodItem, @"items",
                             nil];
                     appSharedObj.strRestauntantIDTemp = [[NSString alloc] init];
                     appSharedObj.strRestauntantIDTemp = [[item valueForKey:@"items"]  valueForKey:@"restaurant_id"];
                       appSharedObj.strDeliveryPrice =appSharedObj.strDeliveryCharge ;
                     _strTrimPrice = [_StrPrice stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
                     
                     
                     double quant = [self.strQuantity doubleValue];
                     double pricez = [_strTrimPrice doubleValue];
                     appSharedObj.stringFoodItemQuant = [NSString stringWithFormat:@"%@",self.strQuantity];
                     appSharedObj.TotalPricez = pricez;
                     _strTotalDoublePrice = [NSString stringWithFormat:@"%.f",appSharedObj.TotalPricez];
                     //  appSharedObj.strTotalSubValue = _strTotalDoublePrice;
                     
                     self.StrTotal = [NSString stringWithFormat:@"%.f",quant * pricez];
                     appSharedObj.stringTotal = self.StrTotal;
                     appSharedObj.StrPrice = self.StrPrice;
                     
                     NSMutableDictionary *DicFoodItem = [[NSMutableDictionary alloc]initWithDictionary:_foodItem];
                     [DicFoodItem setValue:_strQuantity forKey:@"qty"];
                     [appSharedObj.MyCartArr addObject:DicFoodItem];
                     [self.view makeToast:@"Item added to cart"];
                     
                     
                 }
             }
             else
             {
                 item = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                         self.popularFoodItem, @"items",
                         nil];
                 appSharedObj.strRestauntantIDTemp = [[NSString alloc] init];
                 appSharedObj.strRestauntantIDTemp = [[item valueForKey:@"items"]  valueForKey:@"restaurant_id"];
  
                 _StrPopularTrimPrice = [_StrPopularPrice stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
                 
                 appSharedObj.strDeliveryPrice =appSharedObj.strDeliveryCharge ;
                 double quant = [self.strQuantity doubleValue];
                 double pricez = [_StrPopularTrimPrice doubleValue];
                 appSharedObj.stringPopularFoodItemQuant = [NSString stringWithFormat:@"%@",self.strQuantity];
                 appSharedObj.TotalPricez = pricez;
                 _strTotalDoublePrice = [NSString stringWithFormat:@"%.f",appSharedObj.TotalPricez];
                 //appSharedObj.strTotalSubValue = _strTotalDoublePrice;
                 
                 self.StrTotal = [NSString stringWithFormat:@"%.f",quant * pricez];
                 appSharedObj.stringTotal = self.StrTotal;
                 appSharedObj.StrPrice = self.StrPopularPrice;
                 
                 NSMutableDictionary *DicPopularFoodItem = [[NSMutableDictionary alloc]initWithDictionary:_popularFoodItem];
                 [DicPopularFoodItem setValue:_strQuantity forKey:@"qty"];
                 [appSharedObj.MyCartArr addObject:DicPopularFoodItem];
                 
                 
                 
                 [self.view makeToast:@"Item added to cart"];
                 
                 
                 
             }

             
         }
         
         
         
         
        }
    //Should be called only if item is added to cart..
    // [self performSegueWithIdentifier:ShowCartSegueIdentifier sender:self];
     else
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self.view makeToast:@"Please!connect to internet"];
         
     }
}
#pragma mark -
#pragma mark UIStoryboardSegue Actions

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    //Disabling automatic segue call to pass object to destination
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CheckoutViewController *controller=(CheckoutViewController *)segue.destinationViewController;
    //    controller.arrCart = item ;
    
    appSharedObj.MyCartArr = self.strIDChechkout;
    appSharedObj.MyCartArr = self.strIDRestChckout;
    appSharedObj.strRestauntantID = self.strIDRestChckout;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
