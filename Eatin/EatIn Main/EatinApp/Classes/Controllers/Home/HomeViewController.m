//
//  HomeViewController.m
//  Eatin
//
//  Created by Ved Prakash on 1/24/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "HomeViewController.h"
#import "ResultsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "APICall.h"
#import "Reachability.h"
#import "User.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define defaultTextString @"Enter your address"
//#define ShowResultsSegueIdentifier @"showResults"
//#define BASE_KEY @"AIzaSyBG2lM5lHV6a0N2_Gk3fUV3Vz8DnI8z_OU"
//#define BASE_KEY@"AIzaSyAX992zKERDTgnxVkLTntxmXSnNrlJ_7VI"
//#define BASE_KEY@"AIzaSyCngpRl83FJzRUPq9PWBMyjkREtd2LLLrM"
#define BASE_KEY@"AIzaSyAz1ppHohtpvT10KLZCK7KScmamx5QThNc"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define BASE_URL        @"http://216.55.169.45/~eatin/master/api/"
#define URL_FetchRestaurant           BASE_URL@"ws_update_user_details"


@interface HomeViewController ()<UITextFieldDelegate,CLLocationManagerDelegate>
{
    
    BOOL isSelected;
    User *objUser;
       double dbllat;
    double dbllong;
    NSDictionary *dataDic;
    NSArray *feed_dataDic;
    NSMutableArray *aryCity,*aryTypes,*arypcode,*arydata;
    NSMutableArray *aryPostalCode;
    NSDictionary *dataDic1,*dataDic2;
    NSString *strplaceid,*addressStr ;
    AppDelegate *appSharedObj;
}
@end

@implementation HomeViewController


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
    isSelected = false;
    appSharedObj = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    objUser = (User *)[[UIApplication sharedApplication]delegate];
     objUser= [[User alloc] init];
    
    [self.txtAddress setDelegate:self];
    [self.txtAddress setReturnKeyType:UIReturnKeyDone];
    [self.txtAddress addTarget:self
                       action:@selector(textFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    self.AddressTableView.delegate=self;
    self.AddressTableView.dataSource=self;  //---Tableview delegates-----
    [_AddressTableView reloadData];
    
  //  [self getLocationFromAddressString:@"chennai"];
    
    self.CurrentLat=[[NSMutableString alloc]init];
    self.CurrentLong=[[NSMutableString alloc]init];
    // Do any additional setup after loading the view.
    
    self.homeBgImage.image=[UIImage imageNamed:IS_IPHONE_5?@"home_bg.png":@"home_bg_5.png"];
    
    
    if (![self connected])
    {
        [self.view endEditing:YES];
        [_txtAddress resignFirstResponder];
        [self.view makeToast:@"Please!Connect to internet"];
    }
        //----------
    
    [_txtAddress setDelegate:self];
    [_txtAddress setReturnKeyType:UIReturnKeyDone];
    [_txtAddress addTarget:self
                       action:@selector(textFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    
    //-----
    _txtAddress.text= @"";
    [_AddressTableView reloadData];
    
    [self setupFonts];
    [self connected];
   // [self addCustomNavBarOfType:kNavHome withTitle:@""];
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
   // networkStatus != NotReachable;
    if (networkStatus == NotReachable)
    {
        [self.view endEditing:YES];
        return NO;
    }
    else
    {
        return YES;
    }
}


-(void)setupFonts{
    self.btnOrderNow.titleLabel.font=UBUNTU_BOLD(18.0);
    self.txtAddress.font=UBUNTU_LIGHT(17.0);
}


#pragma mark -
#pragma mark Actions

- (IBAction)activateGPSAction:(id)sender
{
    
     }

- (IBAction)orderNowAction:(id)sender
{
  
    if ([self connected]) {

    if(isSelected == true)
    {        
        if ([self connected])
        {
            [self.AddressTableView reloadData];
            [self performSegueWithIdentifier:ShowResultsSegueIdentifier sender:self];
            
        }
        else
        {
            [self.view makeToast:@"Please!Connect to internet"];
     
        }
        
    }
    else
    {
        [self.view makeToast:@"Please!Select your address"];
   }
    }
    else
    {
        [self.view makeToast:@"Please!Connect to internet"];
    }
    _txtAddress.text= @"";
    
    
}


#pragma mark -
#pragma mark TextField Delegate
- (IBAction)textFieldFinished:(id)sender
{
    if (![self connected])
    {
        [self.view endEditing:YES];
        [_txtAddress resignFirstResponder];
        [self.view makeToast:@"Please!Connect to internet"];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //Scroll down to the original position
    CGPoint pt;
    pt.x=0.0;
    pt.y=0.0;
  
    [self.scrollView setContentOffset:pt animated:YES];
   
    if ([self connected])
    {
        if(isSelected == true)
            {
                [_txtAddress setReturnKeyType:UIReturnKeyDone];
                [_txtAddress resignFirstResponder];
                 [self json];
                [self orderNowAction:nil];
            }
        else
            {
                [self.view makeToast:@"Please!Select your address"];
            }
    }
    else
    {
      [self.view makeToast:@"Please!Connect to internet"];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //Scroll the scroller up when textfield in focus
    if ([self connected])
    {
               if([textField.text isEqualToString:defaultTextString]){
            textField.text=@"";
        }
        
        CGRect bounds=[textField bounds];
         self.AddressTableView.hidden = NO;
        bounds=[textField convertRect:bounds toView:self.scrollView];
        
        CGPoint pt;
        pt.x=0.0;
        pt.y=bounds.origin.y-(IS_IPHONE_5?150.0:80.0); //We don't want to move to the top, so decrease the position to just above the keyboard.
        
        [self.scrollView setContentOffset:pt animated:YES];
        return YES;

    }
    else
    {
        [self.view makeToast:@"Please!Connect to internet"];
      
    }
  return NO;
}

// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField
{
   
    self.AddressTableView.hidden=YES;
  }


#pragma mark -
#pragma mark UIStoryboardSegue Actions

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    //Disabling automatic segue call to pass object to destination
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //Manually Called.
    
    //If segue has been called from menu we want to skip the object passing..
   // if(!self.calledFromMenu)
    {
        ResultsViewController *controller=(ResultsViewController *)segue.destinationViewController;
        if([self.txtAddress.text isEqualToString:defaultTextString])
        {
            controller.address=@"";
            [self.view makeToast:@"Please Enter Valid Address"];
            
        }
        else
        {
            controller.address=self.txtAddress.text;
        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Google Place Locations

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //if ([User connectedToNetwork ])
    {
    NSCharacterSet *charsToTrim = [NSCharacterSet characterSetWithCharactersInString:@"()   ;    ^^ ?? ? // [{]}+=_-* / ,' \\  \" ^#`<>| ^  % : @ @@"];
    NSString *str1 = [self.txtAddress.text stringByTrimmingCharactersInSet:charsToTrim];
    
    
    
    NSString *strSearch1 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?key=%@&input=%@",BASE_KEY,strSearch1];//self.txtSearchField.text
    NSURL *url=[NSURL URLWithString:urlString];
    
    //  dispatch_async(kBgQueue, ^{
    NSData* data = [NSData dataWithContentsOfURL: url];
    // [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    //  })
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    NSLog(@"Data:%@",json);
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    dataDic = [json objectForKey:@"predictions"];
    feed_dataDic=(NSArray *)dataDic;
    aryCity = [feed_dataDic valueForKey:@"description"];
    aryPostalCode=[feed_dataDic valueForKey:@"place_id"];
    
    //Write out the data to the console.
    NSLog(@"Google Data: %@", aryCity);
    NSLog(@"PlaceID=%@",aryPostalCode);
    
    if(string.length == 0 && textField.text.length==1)
    {
        aryCity=nil;
        [self.AddressTableView reloadData];
    }
    [self.AddressTableView reloadData];
    
    }
    return YES;
}

-(void)json  
    {
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?key=%@&placeid=%@",BASE_KEY,strplaceid];
    NSURL *url=[NSURL URLWithString:urlString];
    
    //  dispatch_async(kBgQueue, ^{
    NSData* data = [NSData dataWithContentsOfURL: url];
    // [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    //  })
    NSError* error;
        
        
   json = [NSJSONSerialization
                          JSONObjectWithData:data
                          
                          options:kNilOptions
                          error:&error];
       
       
         [self.view makeToast:@"Please connect to Internet"];
        
    dataDic1 = [json objectForKey:@"result"];
    dataDic2 = [dataDic1 objectForKey:@"address_components"];
    // arydata=(NSMutableArray *)dataDic2;
    for(int i=0;i<[dataDic2 count];i++)
    {
        if ([[[[dataDic2 valueForKey:@"types"]objectAtIndex:i]objectAtIndex:0] isEqualToString:@"postal_code"]) {
            aryTypes=[dataDic2 valueForKey:@"long_name"];
            
            //            strpostalcode=[aryTypes objectAtIndex:i];
        }
    }
    CLLocationCoordinate2D center;
    center=[self getLocationFromAddressString:self.txtAddress.text];
    double  latFrom = center.latitude;
    double  lonFrom = center.longitude;
    
        }
   
-(void)fetchedData:(NSData *)responseData
{
    //parse out the json data
    [_AddressTableView reloadData];
}


#pragma mark -
#pragma mark Google Places Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryCity.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.AddressTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [aryCity objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *selectedcell=(UITableViewCell *)[self.AddressTableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"Select Address");
    self.cityStr = selectedcell.textLabel.text;
    [self.AddressTableView reloadData];
    isSelected = true;
    if((self.cityStr = selectedcell.textLabel.text))
    {
        NSLog(@"Disappear!");
        self.AddressTableView.hidden=YES;
    }
    
     if(!(self.cityStr = selectedcell.textLabel.text))
     {
         _btnOrderNow.enabled = NO;
         [self.view makeToast:@"Please!Select your address"];

     }
    
    self.txtAddress.text=_cityStr;
    
    [self json];
    
}

-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr

{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    appSharedObj.lat = latitude;
    appSharedObj.lon = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
    
}

@end
