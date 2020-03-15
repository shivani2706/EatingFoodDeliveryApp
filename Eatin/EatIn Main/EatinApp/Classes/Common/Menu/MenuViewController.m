//
//  MenuViewController.m
//  EatinApp
//
//  Created by Ved Prakash on 1/28/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"
#import <QuartzCore/QuartzCore.h>


#define CellIdentifier @"MenuCell"

@interface MenuViewController () <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)NSArray *arrMenu;

@end

@implementation MenuViewController

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
    
    self.backgroundImage.image=[UIImage imageNamed:IS_IPHONE_5?@"menu_bg_5.png":@"menu_bg.png"];
    
    [self.tblMenu registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    //Creating array of dictionaries containing Title and icon image name
//    self.arrMenu=@[@{@"title": @"Home",@"icon":@"menu_home.png"},
//                   @{@"title": @"Profile",@"icon":@"menu_profile.png"},
//                   @{@"title": @"Cart",@"icon":@"menu_cart.png"},
//                   @{@"title": @"Order Status",@"icon":@"menu_order.png"},
//                  @{@"title": @"About",@"icon":@"menu_info.png"}];
    
   self.arrMenu=@[@{@"title": @"Home",@"icon":@"menu_home.png"},
  @{@"title": @"Cart",@"icon":@"menu_cart.png"}];

    
  
    [self.viewControllerHolder.layer setShadowRadius:5.0];
    [self.viewControllerHolder.layer setShadowColor:[[UIColor blackColor] CGColor]];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenuAction:)];
    [self.viewControllerHolder addGestureRecognizer:tapGesture];
    
    //Hide the tableview beyond x position for animation
    CGRect rect=self.tblMenu.frame;
    rect.origin.x=-rect.size.width;
    self.tblMenu.frame=rect;
}

-(IBAction)closeMenuAction:(id)sender
{
    //Forward message for closing menu to the delegated parent class
    if([self.delegate respondsToSelector:@selector(menuDidClose)]){
        [self.delegate menuDidClose];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.arrMenu.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *menu=[self.arrMenu objectAtIndex:indexPath.row];
    cell.cellImage.image=[UIImage imageNamed:[menu objectForKey:@"icon"]];
    cell.lblTitle.text=[menu objectForKey:@"title"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   int type= indexPath.row+1;
    if([self.delegate respondsToSelector:@selector(menuDidSelect:)])
    {
        [self.delegate menuDidSelect:type];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
