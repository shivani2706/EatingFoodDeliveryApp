//
//  DetailsViewController.m
//  Eatin
//
//  Created by Ved Prakash on 1/24/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "DetailsViewController.h"
#import "RestaurantItemsCell.h"
#import "DetailGroupHeader.h"
#import "TabView.h"
#import "ResultsViewController.h"
#import "UIView+Toast.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "MostPopularImage.h"
#import "OrdersViewController.h"
#import "APICall.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "ResultsViewController.h"
#import "CheckoutViewController.h"
#import "DetailCollectionCell.h"
#import "DetailCollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#define ShowResultsSegueIdentifier @"showResults"
#define CellIdentifier @"ItemsCell"
#define AddToCardSegueIdentifier @"addToCart"

@interface DetailsViewController ()<UITableViewDataSource, UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIRefreshControl *refreshControl;
    AppDelegate *appSharedObj;
    int curItemIndex;
    NSDictionary *item,*popularItem;
    NSString  *strPopularPath;
    UIView *sectionView;
    BOOL collapsed;
    NSMutableArray *arrayForBool;

}

@property(nonatomic, strong) NSMutableArray *arritemsDetails,*item;
@property (nonatomic, strong) NSDictionary *selectedItem;
@end

@implementation DetailsViewController

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
        [self.view endEditing:YES];
        [self.view makeToast:@"Please!Connect to internet"];
        return NO;
    }
    else {
        return YES;
    }
}
-(void)webservice
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%@", self.str_RestaurantID], @"restaurant_id",
                            nil];
    if ([self connected])
    {
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        [APICall callPostWebService:@"http://216.55.169.45/~eatin/master/api/ws_fetch_menu" andDictionary:params completion:^(NSDictionary* user, NSError*error, long code)
         {
               [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
           
             NSArray *arritem=[user valueForKey:@"popular"];
             _arrMostPopular = arritem;
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [self.CollectionViewObj reloadData];
             
             NSArray *restaurant1 = [user valueForKey:@"data"];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             self.selectedRestaurant =restaurant1;
            
             
          
             if ([_selectedRestaurant isEqual:[NSString stringWithFormat:@"%@",@""]])
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                //[self.view makeToast:@"No Item Found for this Restaurant"];
                 
                 
             }
             else
             {
                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                  [self.tblDetails reloadData];
             }
             [self.tblDetails reloadData];
             
              [MBProgressHUD hideHUDForView:self.view animated:YES];
             NSDictionary *mainpath = [user objectForKey:@"imagepath"];
             appSharedObj.strmainpath = [mainpath valueForKey:@"imagepath"];
             
             NSDictionary *menutime = [user objectForKey:@"menutime"];
             _strMenuHours= [NSString stringWithFormat:@"%@",[menutime valueForKey:@"opening_time"]];
             _strMenuHours2 = [NSString stringWithFormat:@"%@",[menutime valueForKey:@"closing_time"]];
             
             arrayForBool=[[NSMutableArray alloc]init];
         // what if there is no restaurants..
             
             if ([[NSString stringWithFormat:@"%@",_selectedRestaurant] isEqualToString:@""] || _selectedRestaurant == nil)
             {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                 _tblDetails.hidden = true;
                 
             }
             else
             {
                 for (int i=0; i<[_selectedRestaurant  count]; i++)
                 {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                     [arrayForBool addObject:[NSNumber numberWithBool:NO]];
                     
                 }
                 
             }
             
             _strTrimMenuHours = [_strMenuHours substringToIndex:[_strMenuHours length]-3];
             _strTrimMenuHours2 =  [_strMenuHours2 substringToIndex:[_strMenuHours2 length]-3];
             self.lblMenuHours.text=_strTrimMenuHours;             self.LblmenuHours2.text =_strTrimMenuHours2;
             
         }];
        
        //self.tabsCarousel.type=iCarouselTypeRotary;
    }
    else
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:@"Please!Connect to internet"];
        
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    popularItem = nil;
    item = nil;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //-----------------
    // scoreLabel is the IBOutlet to the UILabel in IB for displaying the score.
    [self webservice];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    

    appSharedObj = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self setupFonts];
//      [self refreshTable];
    [self addCustomNavBarOfType:kNavWithSearch withTitle:_strRestaurantTitle];
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tblDetails addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
  // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    item= [[NSDictionary alloc]init];
    
    _tblDetails.delegate = self;
    _tblDetails.dataSource = self ;
    _CollectionViewObj.delegate =self;
     _CollectionViewObj.dataSource =self;
    curItemIndex=1;
}

- (void)refreshTable
{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //TODO: refresh your data
    [self connected];
    [refreshControl endRefreshing];
    [self.tblDetails reloadData];
}

#pragma mark -
#pragma mark View Components Setup

-(void)setupFonts{
    self.lblMenuHours.font=UBUNTU_LIGHT(13.0);
    self.LblmenuHours2.font=UBUNTU_LIGHT(13.0);
    self.lblMostPopular.font=UBUNTU_MEDIUM(14.0);
    self.lblNosMostPopular.font=UBUNTU_MEDIUM(14.0);
}

#pragma mark - CollectionView
#pragma mark DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_arrMostPopular isEqual:[NSString stringWithFormat:@"%@",@"No Popular Menu items have been found"]])
    {
        
         _NoPopularItemImg.hidden = false;
        _CollectionViewObj.hidden = YES;
     //        _tblDetails.frame = CGRectMake(0, 138, 375, 84);
         _tblDetails.frame = CGRectMake(0, 93, 320, 246);
        return 0;
    }
    else
    {
       //return [self.arrMostPopular count];
        if (self.arrMostPopular.count > 0 )
        {
             [self refreshTable];
            _PopularViewObj.hidden=false;
                      int i = self.arrMostPopular.count;
            _strNosMostPopular = [NSString stringWithFormat:@"%d",i] ;
            NSString *str =@" dishes";
            _strNosMostPopular = [_strNosMostPopular stringByAppendingString:str];
            [_lblNosMostPopular setText:_strNosMostPopular] ;
            
        }
        else if (self.arrMostPopular.count == 0 )
        {
           
            _PopularViewObj.hidden=true;
           
             _NoPopularItemImg.hidden = false;
        }
        return [self.arrMostPopular count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCollectionCell *cell = (DetailCollectionCell *)[_CollectionViewObj dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *PopularRestaurantDict = [self.arrMostPopular objectAtIndex:indexPath.row];

  //  cell.CollectionImg.image =[UIImage imageNamed:[PopularRestaurantDict objectForKey:@"image"]];
    [cell.CollectionImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[PopularRestaurantDict valueForKey:@"image"]]] placeholderImage:nil];

    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    popularItem =[self.arrMostPopular objectAtIndex:indexPath.row];
    _strMostPopularId= [_arrMostPopular valueForKey:@"id"];
    
   // self.selectedRestaurant=popularItem;
    
    [self performSegueWithIdentifier:AddToCardSegueIdentifier sender:self];
}

#pragma mark -
#pragma mark UITableView Delegate & DataSource

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

//    UIView *view=[DetailGroupHeader loadInstanceFromNib];
//    
//    DetailGroupHeader *headerView=(DetailGroupHeader *)view;
//    
//    headerView.lblTitle.text=[[self.selectedRestaurant objectAtIndex:section] objectForKey:@"type"];
//   
//    headerView.btnReveal.indexPath=[NSIndexPath indexPathForRow:0 inSection:section];
    
    
// [headerView.btnReveal addTarget:self action:@selector(hideTable:) forControlEvents:UIControlEventTouchUpInside];
//    sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 280,25)];
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(3, 93, 320,46)];

    sectionView.tag=section;
    
    img=[[UIImageView alloc]initWithFrame:CGRectMake(302, 3 , 15, 15)];
    img.image=[UIImage imageNamed:@"reveal_food_category.png"];
   
    UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, _tblDetails.frame.size.width, 22)];
    viewLabel.backgroundColor=[UIColor clearColor];
    viewLabel.textColor=[UIColor whiteColor];
    viewLabel.font=[UIFont systemFontOfSize:13];
    viewLabel.text=[NSString stringWithFormat:@" %@",[[self.selectedRestaurant objectAtIndex:section] objectForKey:@"type"]];
    viewLabel.backgroundColor=[UIColor colorWithRed:167/255.0 green:0/255.0 blue:8/255.0 alpha:1.0];
    viewLabel.layer.shadowRadius = 3.0;
    viewLabel.layer.shadowOpacity = 0.5;
    
    UIColor *endColor = [UIColor colorWithRed:167/255.0 green:0/255.0 blue:8/255.0 alpha:1.0];
    NSArray *gradientColors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],(id)[endColor CGColor], nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = gradientColors;
    [gradientLayer setStartPoint:CGPointMake(0.0, 0.5)];
    [gradientLayer setEndPoint:CGPointMake(1.0, 0.5)];
    [viewLabel.layer insertSublayer: gradientLayer atIndex:0];
    [sectionView addSubview:viewLabel];
    [sectionView addSubview:img];
    
    // Add UITapGestureRecognizer to SectionView
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    
    return  sectionView;
    
  //  return view;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        return 60;
    }
    return 0;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
        if ([[NSString stringWithFormat:@"%@",_selectedRestaurant] isEqualToString:@""] || _selectedRestaurant == nil)
        {
          
            _tblDetails.hidden = true;
            
            //_ImgHideMenuHours.hidden=false;
            _NoPopularItemImg.hidden=false;
            _NoPopularItemImg.hidden=NO;
            _lblMenuHours.hidden=YES;
            _LblmenuHours2.hidden=YES;
            _LblTo.hidden=YES;
            _LblMenuHoursTitle.hidden=YES;
            _LblDataNil.hidden=NO;
            
            return NO;
           
        }
        else
        {
              _NoPopularItemImg.hidden=YES;
                       _tblDetails.hidden = false;
            _ImgHideMenuHours.hidden=true;
                      //   _NoPopularItemImg.hidden=true;
            _lblMenuHours.hidden=NO;
            _LblmenuHours2.hidden=NO;
            _LblTo.hidden=NO;
            _LblMenuHoursTitle.hidden=NO;
            _LblDataNil.hidden=YES;

            
            return _selectedRestaurant.count;

            }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

       return [[[self.selectedRestaurant objectAtIndex:section] valueForKey:@"items"] count];
  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantItemsCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    

    NSDictionary *items= [[[self.selectedRestaurant objectAtIndex:indexPath.section] objectForKey:@"items"] objectAtIndex:indexPath.row];
    //-------------------------
    if (cell == nil)
    {
     RestaurantItemsCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    
    BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
    
    /********** If the section supposed to be closed *******************/
    if(!manyCells)
    {
                cell.hidden=YES;
                      }
    else
    {
        cell.hidden=NO;
        [cell.itemImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",appSharedObj.strmainpath,[items valueForKey:@"image"]]] placeholderImage:nil];
        // cell.itemImage.image=[UIImage imageNamed:[item objectForKey:@"imagepath"]];
        cell.lblTitle.text=[items objectForKey:@"name"];
        
        _strTitle = [items valueForKey:@"name"];
        appSharedObj.strTitleTotal = self.strTitle;
        cell.lblDesc.text=[items objectForKey:@"desc"];
        cell.lblPrice.text=[NSString stringWithFormat:@"$%0.f",[[items objectForKey:@"price"] floatValue]];
        //cell.lblPrice.text = _strPrice;
        _strPrice=  [items valueForKey:@"price"];
        
        
    }
    
    
    
       return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    item = [[[self.selectedRestaurant objectAtIndex:indexPath.section] objectForKey:@"items"] objectAtIndex:indexPath.row];
    //indexPath.section
   // self.selectedItem=self.selectedRestaurant;
    
   _strItem = [item valueForKey:@"restaurant_id"];
    //-----------------
    
    [_arrMenuItems replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
    
    [_tblDetails reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    //----------------
    //self.selectedRestaurant=item;
    [self performSegueWithIdentifier:AddToCardSegueIdentifier sender:self];

}




- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        collapsed = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
       for (int i=0; i<[self.selectedRestaurant count]; i++) {
            if (indexPath.section==i) {
            [arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            
            }
        }
    [_tblDetails reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    //!!!FIX for issue #1 Cell position wrong------------
    if(cell.layer.position.x != 0){
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    }
    
    //4. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}





#pragma mark -
#pragma Actions




- (IBAction)btnSearchAction:(id)sender {
}

- (IBAction)btnFilterAction:(id)sender {
}

- (IBAction)btnNavTabAction:(id)sender {
    //Handling Tab menu navigations
    UIButton *btn=(UIButton *)sender;
    
    if(btn.tag == 1)
    {//Navigate previous
        curItemIndex --;
    }
    else if(btn.tag == 2)
    {//Navigate Next
        curItemIndex ++;
    }
    
    
    if(curItemIndex < 0)
        curItemIndex = 0;
    else if(curItemIndex >= self.arrTabs.count)
        curItemIndex=self.selectedRestaurant.count-1;
    
   // [self.tabsCarousel scrollToItemAtIndex:curItemIndex animated:YES];
    
    //Change the pagecontrol accordingly, we are showing max 3 so it should stop at >=3
    if(curItemIndex>=2)
        self.tabPageControl.currentPage=2;
    else if(curItemIndex < 2 && curItemIndex>=0)
        self.tabPageControl.currentPage=curItemIndex;
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
        OrdersViewController *controller=(OrdersViewController *)segue.destinationViewController;
        controller.foodItem = item;
        //        controller.Orderitem=item;
        //        controller.Orderitem = popularItem;
        controller.popularFoodItem = popularItem;
        controller.StrPopularPrice = [popularItem valueForKey:@"price"];
        appSharedObj.StrPrice  = _strPrice;
        appSharedObj.strPopularPrice  = _strPrice;
        controller.strITEM = self.strItem;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
