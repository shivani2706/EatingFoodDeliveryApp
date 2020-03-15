//
//  ResultsViewController.m
//  Eatin
//
//  Created by Ved Prakash on 1/24/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "ResultsViewController.h"
#import "ResultCell.h"
#import "UIView+Toast.h"
#import "APICall.h"
#import "DetailsViewController.h"
#import "OrdersViewController.h"
#import "CheckoutViewController.h"
#import <MBProgressHUD.h>
#import "Reachability.h"
#import <CoreLocation/CoreLocation.h>
//Filter Action enums
typedef enum{
    kFilter_Popular         =       0,
    kFilter_Newest          =       1,
    kFilter_Distance        =       2,
    kFilter_Minimum         =       3,
    kFilter_Free            =       4
    
} kFilterType;

#define CellIdentifier @"ResultCell"
#define DetailsControllerSegueIdentifier @"showRestaurantDetails"

@interface ResultsViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
  //CLLocationManager *locationManager;
    
}
@property(nonatomic, strong) NSArray *arrResults,*arrRestaurantDetials;
//@property(nonatomic, strong) NSDictionary *selectedRestaurant;
@property(nonatomic, strong) NSMutableArray *selectedRestaurant, *FilterFree;
//@property(nonatomic, strong) NSMutableArray ;
@property(nonatomic, strong) NSString *strId;
@end

@implementation ResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    else
    {
        return YES;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
	// Do any additional setup after loading the view.
    appSharedObj = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    _arrRestaurantDetials = [[NSMutableArray alloc] init];
    [self setupFonts];
    
    [self addCustomNavBarOfType:kNavHome withTitle:@"Restaurants"];
    
    //self.arrResults=[DataManager nearByRestaurants];
    
    [self.tblResults reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    if(self.address.length>0)
        self.lblAddress.text=self.address;
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tblResults addSubview:refreshControl ];
    [refreshControl addTarget:self action:@selector(webservice) forControlEvents:UIControlEventValueChanged];
    
 

   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self webservice];
    });
     
  }



-(void)webservice
{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%f", appSharedObj.lat], @"lat",
                            [NSString stringWithFormat:@"%f", appSharedObj.lon], @"lng",
                            nil];

    

    if ([self connected])
    {
        [self refreshTable];
        [APICall callPostWebService:@"http://216.55.169.45/~eatin/master/api/ws_fetch_restaurants" andDictionary:params completion:^(NSDictionary* user, NSError*error, long code)
         {
             
             
             
             dispatch_async(dispatch_get_main_queue(), ^(void) {
                

                 _arrRestaurantDetials = [user valueForKey:@"data"];
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 [refreshControl endRefreshing];
                 if(_arrRestaurantDetials == nil)
                 {
                     [self.view makeToast:@"Sorry No restaurants found in Your Area"];
                     
                     
                 }
                 [_tblResults reloadData];
             });
         }];
        
        
        _strRestLat = [_arrRestaurantDetials valueForKey:@"lat"];
        _strRestLong = [_arrRestaurantDetials valueForKey:@"lng"];
    }
    
    else
    {
       
        [self.view makeToast:@"Please!connect to internet"];
    }

}
- (void)refreshTable
{
//     [self connected];
//    refreshControl = [[UIRefreshControl alloc]init];
//    [self.tblResults addSubview:refreshControl];
//    [refreshControl addTarget:self action:@selector(webservice) forControlEvents:UIControlEventValueChanged];
    
    [self.tblResults reloadData];
    //TODO: refresh your data
   
  //  [refreshControl endRefreshing];
   
}

-(void)setupFonts
{
    self.lblAddress.font=UBUNTU_LIGHT(13.0);
    
    for(UIButton *btn in self.viewFilterButtons.subviews)
    {
        //Only buttons
        if([btn isKindOfClass:[UIButton class]])
            btn.titleLabel.font=UBUNTU_REGULAR(13.0);
    }
}


#pragma mark -
#pragma mark Actions
-(void)btnColorChange:(int)tag
{
    [_BtnPopular setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_BtnDistance setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_BtnNewest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_BtnMinimum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_BtnFreeDelivery setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    switch (tag) {
        case kFilter_Popular:
        {
            
            [_BtnPopular setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
           
        }
            break;
        case kFilter_Distance:
        {
            
            
            [_BtnDistance setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
            break;
        case kFilter_Free:
        {
            
            
            [_BtnFreeDelivery setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
        }
            break;
        case kFilter_Minimum:
        {
            
                 [_BtnMinimum setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                 }
            break;
        case kFilter_Newest:
        {
           
            [_BtnNewest setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
         
        }
            break;
        default:
            break;
            
    }
}

- (IBAction)filterAction:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Run your loop here
         UIButton *btn=(UIButton *)sender;
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            //stop your HUD here
            //This is run on the main thread
            
            [self btnColorChange:(int)btn.tag];

        });
       
        
        
        switch (btn.tag)
        {
            case kFilter_Popular:
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    _tblResults.hidden=NO;
                    [_tblResults reloadData];
                    _LblNoFreeRestaurant.hidden=YES;
                    _arrRestaurantDetials = [_arrRestaurantDetials sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                        if ([[obj1 valueForKey:@"delivery_price"] integerValue] > [[obj2 valueForKey:@"delivery_price"] integerValue]) {
                            return (NSComparisonResult)NSOrderedDescending;
                        }
                        if ([[obj1 valueForKey:@"delivery_price"] integerValue] < [[obj2 valueForKey:@"delivery_price"] integerValue]) {
                            return (NSComparisonResult)NSOrderedAscending;
                        }
                        
                        return (NSComparisonResult)NSOrderedSame;
                    }];
            });
          
               
              
              
            }
                break;
            case kFilter_Distance:
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    _tblResults.hidden=NO;
                    [_tblResults reloadData];
                    _LblNoFreeRestaurant.hidden=YES;

                    
                    
                    
                    _arrRestaurantDetials = [_arrRestaurantDetials sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                                             {
                                                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                 if ([[obj1 valueForKey:@"delivery_min_time"] integerValue] > [[obj2 valueForKey:@"delivery_min_time"] integerValue]) {
                                                     return (NSComparisonResult)NSOrderedDescending;
                                                 }
                                                 if ([[obj1 valueForKey:@"delivery_min_time"] integerValue] < [[obj2 valueForKey:@"delivery_min_time"] integerValue]) {
                                                     return (NSComparisonResult)NSOrderedAscending;
                                                 }
                                                 
                                                 return (NSComparisonResult)NSOrderedSame;
                                             }];
            });
                
              
            }
                break;
            case kFilter_Free:
            {
                
       
                
                dispatch_async(dispatch_get_main_queue(), ^(void)
                               {
                                   _arrRestaurantDetials = [_arrRestaurantDetials sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                                                            {
                                                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                                if ([[obj1 valueForKey:@"delivery_price"] floatValue] == 0.0f) {
                                                                    return (NSComparisonResult)NSOrderedDescending;
                                                                }
                                                                if ([[obj1 valueForKey:@"delivery_price"] integerValue] < [[obj2 valueForKey:@"delivery_price"] integerValue]) {
                                                                    return (NSComparisonResult)NSOrderedAscending;
                                                                }
                                                                
                                                                return (NSComparisonResult)NSOrderedSame;
                                                            }];
//                    for (int i=0;i<_arrRestaurantDetials.count;i++)
//                    {
//                        if([[[_arrRestaurantDetials valueForKey:@"delivery_price"] objectAtIndex:i] floatValue]==0.0f)
//                            // if(_strResultDeliveryPrice == 0)
//                        {
//                            
//                            _FilterFree = [_arrRestaurantDetials ad];
//                            
//                            NSLog(@"%@",_FilterFree);
//                            [_tblResults reloadData];
//                            _tblResults.hidden=NO;
//                            _LblNoFreeRestaurant.hidden=YES;
//                            NSLog(@"Freeeee");
//                        }
//                        else
//                        {
//                            _tblResults.hidden=YES;
//                            [_tblResults reloadData];
//                            _LblNoFreeRestaurant.hidden=NO;
//                        }
//                    }
                    
                });
                
            }
                break;
            case kFilter_Minimum:
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    _tblResults.hidden=NO;
                    [_tblResults reloadData];
                    _LblNoFreeRestaurant.hidden=YES;
                    
                    _arrRestaurantDetials = [_arrRestaurantDetials sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                        if ([[obj1 valueForKey:@"minprice"] integerValue] > [[obj2 valueForKey:@"minprice"] integerValue]) {
                            return (NSComparisonResult)NSOrderedDescending;
                        }
                        if ([[obj1 valueForKey:@"minprice"] integerValue] < [[obj2 valueForKey:@"minprice"] integerValue]) {
                            return (NSComparisonResult)NSOrderedAscending;
                        }
                        
                        return (NSComparisonResult)NSOrderedSame;
                    }];

            });
                
                
                
            }
                break;
            case kFilter_Newest:
            {
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    _tblResults.hidden=NO;
                    [_tblResults reloadData];
                    _LblNoFreeRestaurant.hidden=YES;
                    
                    _arrRestaurantDetials = [_arrRestaurantDetials sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                                             {
                                                 
                                                 if ([[obj1 valueForKey:@"created_at"] integerValue] > [[obj2 valueForKey:@"created_at"] integerValue]) {
                                                     return (NSComparisonResult)NSOrderedDescending;
                                                 }
                                                 if ([[obj1 valueForKey:@"created_at"] integerValue] < [[obj2 valueForKey:@"created_at"] integerValue]) {
                                                     return (NSComparisonResult)NSOrderedAscending;
                                                 }
                                                 
                                                 return (NSComparisonResult)NSOrderedSame;
                                             }];
                });
                
        
            }
                break;
                
            default:
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
             [self refreshTable];
              [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
      
    });
   
}

#pragma mark -
#pragma mark UITableView Delegate & DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

//    if(_FilterFree.count == 0)
//    {
//        return 0;
//    }
//   
    return [_arrRestaurantDetials count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResultCell *cell=[_tblResults dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *restaurant=[self.arrRestaurantDetials objectAtIndex:indexPath.row];
    //  [MBProgressHUD hideHUDForView:self.view animated:YES];
   // NSData *data = [NSData dataWithContentsOfURL:[restaurant valueForKey:@"image"]];
    NSURL *url = [NSURL URLWithString:[restaurant valueForKey:@"image"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data] ;
    [cell.cellImage setImage:img];
  

    cell.LblDeliveryMaxTime.text = [restaurant valueForKey:@"delivery_max_time"];
    cell.lblTitle.text=[restaurant valueForKey:@"name"];
        cell.lblCuisinesType.text=[restaurant valueForKey:@"type"];
    cell.lblDeliveryTime.text=[restaurant valueForKey:@"delivery_min_time"];
    cell.lblMinValue.text =[NSString stringWithFormat:@"$%@", [restaurant valueForKey:@"minprice"]];
   cell.lblDeliveryValue.text =[NSString stringWithFormat:@"$%@", [restaurant valueForKey:@"delivery_price"]];
   _strResultDeliveryPrice = [NSString stringWithFormat:@"$%@", [restaurant valueForKey:@"delivery_price"]];
    
    //-------Distance calculate----------------
    _strRestLat = [restaurant valueForKey:@"lat"];
    _strRestLong = [restaurant valueForKey:@"lng"];

    float latA = appSharedObj.lat ;
    float logA =appSharedObj.lon;
    
    float latB = [_strRestLat floatValue];
    float logB = [ _strRestLong floatValue];
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:latA
                                                  longitude:logA];
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:latB longitude:logB];
    CLLocationDistance distance = [locA distanceFromLocation:locB];

     cell.lblDistance.text= [NSString stringWithFormat:@"%.1fmil",(distance/1609.344)];
    
    //----------------------------------------------------

    
    return cell;
       
   }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.tblResults deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *restaurant=[self.arrRestaurantDetials objectAtIndex:indexPath.row];

    _strId = [restaurant valueForKey:@"id"];
    appSharedObj.strRestauntantID = [restaurant valueForKey:@"id"];
    
     _strResultDeliveryPrice =[NSString stringWithFormat:@"%@",[restaurant valueForKey:@"delivery_price"]];
       self.selectedRestaurant=restaurant;
        
    _strRestaurantName = [restaurant valueForKey:@"name"];


    appSharedObj.strDeliveryCharge = _strResultDeliveryPrice;
    
        if(appSharedObj.strRestauntantID ==[_selectedRestaurant valueForKey:@"id"] )
        {
         [self performSegueWithIdentifier:DetailsControllerSegueIdentifier sender:self];
        }

}

#pragma mark -
#pragma mark UIStoryboardSegue Actions

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    //Disabling automatic segue call to create cell selection effect
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
     //Manually Called.
    if(!self.calledFromMenu)
    {
        DetailsViewController *controller=(DetailsViewController *)segue.destinationViewController;
        
        controller.str_RestaurantID = self.strId;
        controller.strRestaurantTitle= _strRestaurantName;
        
    }
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
