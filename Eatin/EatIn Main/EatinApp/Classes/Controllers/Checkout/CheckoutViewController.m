//
//  CheckoutViewController.m
//  Eatin
//
//  Created by Ved Prakash on 1/24/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "CheckoutViewController.h"
#import "CartItemCell.h"
#import "CartDenominationCell.h"
#import "CartTotalCell.h"
#import "APICall.h"
#import "UIView+Toast.h"
#import "HomeViewController.h"
#define CartItemsCellIdentifier @"CellCartItems"
#define DenominationsCellIdentifier @"CellDenominations"
#define TotalAmountCellIdentifier @"CellTotalAmount"
#import "AppDelegate.h"
#define kCellDenomination @"Denomination"
#define kCellTotal @"Total"
#define kCellCartItems @"CartItems"
#define ShowResultsSegueIdentifier @"BackToProfile"
#define kTaxValue @"0.00"
#import <MBProgressHUD.h>
#import "Reachability.h"

@interface CheckoutViewController ()
{
    AppDelegate *appSharedObj;
    UIRefreshControl *refreshControl;
}
@property(assign)float totalPrice;
@property(assign)double pricez;

@end

@implementation CheckoutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)refreshTable {
    //TODO: refresh your data
    [self connected];
    [refreshControl endRefreshing];
    [self.tblCart reloadData];
}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    // networkStatus != NotReachable;
    if (networkStatus == NotReachable)
    {
        [self.view makeToast:@"Please!Connect to internet"];
        return NO;
    }
    else {
        return YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //  [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    //self.strStatus = [NSString stringWithFormat:@"%@", [self.strPickUp + self.strDelivery]];
    
    appSharedObj = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [self addCustomNavBarOfType:kNavWithSearch withTitle:@"Checkout"];
    
    
    [self calculatTotal];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tblCart addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    self.arrCartItems=[[NSMutableArray alloc] init];
    
    
    
    if(!self.calledFromMenu)
    {
        if (appSharedObj.MyCartArr.count == 0)
            
        {
            _tblCart.hidden = true;
            _imgviewChckout.hidden = false;
            _BtnCheckoutProperty.hidden = true;
            [_BtnPickUpProperty setImage:[UIImage imageNamed:@"DeselectPickUp"] forState:UIControlStateNormal];
            [_BtnDeliveryProperty setImage:[UIImage imageNamed:@"Deselectdelivery"] forState:UIControlStateNormal];
            _itemsTitleImgView.hidden=true;
            [self.view makeToast:@"Please! place your order"];
            
        }
    }
    
    
}
-(void)calculatTotal
{
    // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appSharedObj.strTotalSubValue = @"0";
    for(int i = 0 ; i < appSharedObj.MyCartArr.count ; i++)
    {
        
        double QTY = [[appSharedObj.MyCartArr[i] valueForKey:@"qty"] doubleValue];
        double PRICE = [[appSharedObj.MyCartArr[i] valueForKey:@"price"] doubleValue];
        
        double quant = [appSharedObj.strTotalSubValue doubleValue];
        quant = quant + (QTY * PRICE) ;
        self.MultipliedValue =  [NSString stringWithFormat:@"%.1f",quant];
        appSharedObj.strTotalSubValue = [ NSString stringWithFormat:@"%.1f", quant];
        
        appSharedObj.TotalPricez = [appSharedObj.stringTotal doubleValue];
        
        appSharedObj.TotalPricez = quant + [appSharedObj.strDeliveryPrice doubleValue ] ;
        
        appSharedObj.strTotalPricez = [NSString stringWithFormat:@"$%.1f",appSharedObj.TotalPricez];
        
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self prepareData];
}




-(void)prepareData
{
    [self.arrCartItems removeAllObjects];
    
    //  [self.arrCartItems addObjectsFromArray:[DataManager getCartItems]];
    
    //Add extra items for calculations
    [self.arrCartItems addObject:kCellTotal];
    //[self.arrCartItems addObject:kCellCartItems];
    [self.arrCartItems addObject:kCellDenomination];
    
    
    
    [self.tblCart reloadData];
}


#pragma mark -
#pragma mark UITableView Delegate & DataSource


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight=0.0;
    if (appSharedObj.MyCartArr.count  == indexPath.row )
    {
        cellHeight=92.0;
    }
    else
    {
        cellHeight=56.0;
    }
    
    return cellHeight;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return appSharedObj.MyCartArr.count+2;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    NSMutableDictionary *item=[self.arrCartItems objectAtIndex:indexPath.row];
    //
    UITableViewCell *cell=nil;
    //      NSString *cellType=(NSString *)item;
    
    if (appSharedObj.MyCartArr.count  == indexPath.row )
    {
        CartDenominationCell *customCell=[tableView dequeueReusableCellWithIdentifier:DenominationsCellIdentifier forIndexPath:indexPath];
        cell=customCell;
        customCell.lblSubTotalValue.text = [NSString stringWithFormat:@"$%@",appSharedObj.strTotalSubValue];
        //        customCell.lblChargeValue.text=[[NSString stringWithFormat:@"%@",appSharedObj.MyCartArr]valueForKey:@"delivery_price"];
        customCell.lblChargeValue.text  = [NSString stringWithFormat:@"$%@",appSharedObj.strDeliveryPrice];
        //delivery_price
        customCell.lblTaxValue.text=[NSString stringWithFormat:@"$%@",kTaxValue];
        customCell.lblDiscountValue.text=[NSString stringWithFormat:@"$0"];
        
        
        
    }
    else if(appSharedObj.MyCartArr.count + 1 == indexPath.row )
    {
        CartTotalCell *customCell=[tableView dequeueReusableCellWithIdentifier:TotalAmountCellIdentifier forIndexPath:indexPath];
        cell=customCell;
        
        // customCell.lblTotalValue.text=[NSString stringWithFormat:@"$%@",appSharedObj.strTotalSubValue];
        //customCell.lblTotalValue.text=  appSharedObj.stringTotal;
        
        //======
        customCell.imgCellQty.hidden = true;
        customCell.lblQty.hidden = true;
        customCell.lblTitle.hidden = true;
        customCell.LblTotalGrey.hidden=false;
        customCell.lblPrice.text =  [NSString stringWithFormat:@"%@", appSharedObj.strTotalPricez];
        customCell.btnDelete.hidden = true;
        
        
    }
    else
        //CartItems
    {
        CartTotalCell *customCell=[tableView dequeueReusableCellWithIdentifier:TotalAmountCellIdentifier forIndexPath:indexPath];
        cell=customCell;
        
        
        customCell.lblTitle.text= [NSString stringWithFormat:@"%@",[appSharedObj.MyCartArr[indexPath.row] valueForKey:@"name"]];
        //customCell.lblPrice.text=[NSString stringWithFormat:@"%0.2f",[[foodItem objectForKey:@"price"] floatValue]];
        
        
        customCell.lblQty.text=[NSString stringWithFormat:@"%@",[appSharedObj.MyCartArr[indexPath.row] valueForKey:@"qty"]];
        //appSharedObj.stringPopularFoodItemQuant;
        //@"$%0.f"
        customCell.lblPrice.text = [NSString stringWithFormat:@"$%@",[appSharedObj.MyCartArr[indexPath.row] valueForKey:@"price"]];
        customCell.btnDelete.tag = indexPath.row;
        [customCell.btnDelete addTarget:self action:@selector(showGraph:) forControlEvents:UIControlEventTouchUpInside];
         customCell.LblTotalGrey.hidden=YES;
        
    }
    
    
    
    return cell;
}

-(void)showGraph:(UIButton*)sender
{
  //  NSLog(@"%ld", (long)sender.tag);
    
    [appSharedObj.MyCartArr removeObjectAtIndex:sender.tag];
    [self calculatTotal];
    if (appSharedObj.MyCartArr.count == 0)
    {
        
        _tblCart.hidden = true;
        _imgviewChckout.hidden = false;
        _BtnCheckoutProperty.hidden = true;
        [_BtnPickUpProperty setImage:[UIImage imageNamed:@"DeselectPickUp"] forState:UIControlStateNormal];
        [_BtnDeliveryProperty setImage:[UIImage imageNamed:@"Deselectdelivery"] forState:UIControlStateNormal];
        _itemsTitleImgView.hidden=true;
        [self.view makeToast:@"Please! place your order"];
        
        
        
        appSharedObj.strRestauntantIDTemp = nil;
        
    }
    // refresh inteface after updating data source
    [self.tblCart reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCheckout:(id)sender
{
    // idhar error h sayad
    if (appSharedObj.MyCartArr.count == 0)
    {
        
     
        _tblCart.hidden = true;
        _imgviewChckout.hidden = false;
        _BtnCheckoutProperty.hidden = true;
        [_BtnPickUpProperty setImage:[UIImage imageNamed:@"DeselectPickUp"] forState:UIControlStateNormal];
        [_BtnDeliveryProperty setImage:[UIImage imageNamed:@"Deselectdelivery"] forState:UIControlStateNormal];
        _itemsTitleImgView.hidden=true;
        [self.view makeToast:@"Please! place your order"];
         appSharedObj.strRestauntantIDTemp = nil;
    }
    else
    {
        appSharedObj.strID = [appSharedObj.MyCartArr valueForKey:@"id"];
        appSharedObj.stringFoodItemQuant =[appSharedObj.MyCartArr valueForKey:@"qty"];
        appSharedObj.StrPrice = [appSharedObj.MyCartArr valueForKey:@"price"];
        
        //  NSArray *myArray= @[@{@"id" : [appSharedObj.MyCartArr valueForKey:@"id"] , @"qty" : [appSharedObj.MyCartArr valueForKey:@"qty"], @"price" : [appSharedObj.MyCartArr valueForKey:@"price"]}];
        NSArray *myArray= @[@{@"id" : appSharedObj.strID , @"qty" :appSharedObj.stringFoodItemQuant, @"price" : appSharedObj.StrPrice}];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:myArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%@", jsonString], @"id",
                                [NSString stringWithFormat:@"%@",appSharedObj.stringTotal], @"total",
                                [NSString stringWithFormat:@"%@",appSharedObj.strRestauntantID  ], @"restaurant_id",
                                [NSString stringWithFormat:@"%@", _strPickUp], @"status",
                                nil];
        
        
        if( [self connected])
        {
            [APICall callPostWebService:@"http://216.55.169.45/~eatin/master/api/ws_post_order" andDictionary:params completion:^(NSDictionary* user, NSError*error, long code)
             {
                 if (user)
                 {
                   //  NSLog(@"%@",user);
                     [self.view makeToast:@"Thank you!your order has been recorded"];
                     
                     double delayInSeconds = 2.0;
                     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                     dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                                    {
                                        //                 [self performSegueWithIdentifier:ShowResultsSegueIdentifier sender:self];
                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                    });
                 }
             }];
        }
        else
        {
            [self.view makeToast:@"Please!Connect to internet"];
        }
    }
    
}

- (IBAction)btnPickUp:(id)sender
{
    _strPickUp = [NSString stringWithFormat:@"2"];
    
    if (appSharedObj.MyCartArr.count == 0)
    {
        _BtnPickUpProperty.enabled = false;
        _BtnDeliveryProperty.enabled = false;
        [_BtnDeliveryProperty setImage:[UIImage imageNamed:@"Deselectdelivery"] forState:UIControlStateNormal];
        [_BtnPickUpProperty setImage:[UIImage imageNamed:@"DeselectPickUp"] forState:UIControlStateNormal];
        [self.view makeToast:@"Please! place your order"];
    }
    
    else
    {
        [_BtnPickUpProperty setImage:[UIImage imageNamed:@"SelectPickUp"] forState:UIControlStateNormal];
        [_BtnDeliveryProperty setImage:[UIImage imageNamed:@"Deselectdelivery"] forState:UIControlStateNormal];
     //   NSLog(@"%@",self.strPickUp);
    }
    
}

- (IBAction)btnDelivery:(id)sender
{
    
    
    if (appSharedObj.MyCartArr.count == 0)
    {
        
        _BtnPickUpProperty.enabled = false;
        _BtnDeliveryProperty.enabled = false;
        [_BtnDeliveryProperty setImage:[UIImage imageNamed:@"Deselectdelivery"] forState:UIControlStateNormal];
        [_BtnPickUpProperty setImage:[UIImage imageNamed:@"DeselectPickUp"] forState:UIControlStateNormal];
        [self.view makeToast:@"Please! place your order"];
        
    }
    else
    {
        _strPickUp = [NSString stringWithFormat:@"1"];
        [_BtnDeliveryProperty setImage:[UIImage imageNamed:@"SelectDelivery"] forState:UIControlStateNormal];
        [_BtnPickUpProperty setImage:[UIImage imageNamed:@"DeselectPickUp"] forState:UIControlStateNormal];
    }
    
}


#pragma mark -
#pragma mark UIStoryboardSegue Actions

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    //Disabling automatic segue call to pass object to destination
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    HomeViewController *controller=(HomeViewController *)segue.destinationViewController;
    
    
}


@end
