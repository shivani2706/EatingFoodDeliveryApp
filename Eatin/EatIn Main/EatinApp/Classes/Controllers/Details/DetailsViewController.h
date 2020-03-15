//
//  DetailsViewController.h
//  Eatin
//
//  Created by Ved Prakash on 1/24/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : AppHolderController
{
 UIImageView *img;
}
@property(nonatomic, strong) NSDictionary *restaurant;

@property (strong, nonatomic) IBOutlet UIScrollView *tabScroller;
@property (strong, nonatomic) IBOutlet UIPageControl *tabPageControl;
@property (strong, nonatomic) IBOutlet UILabel *lblMenuHours;
@property (strong, nonatomic) IBOutlet UITableView *tblDetails;
@property (strong, nonatomic) IBOutlet UIScrollView *mostPopularScroller;
@property (weak, nonatomic) IBOutlet UILabel *LblmenuHours2;
@property (nonatomic, strong) NSMutableArray *arrMenuItems,*arrMostPopular,*arrTabs,*selectedRestaurant;
@property (strong, nonatomic) IBOutlet UILabel *lblMostPopular;
@property (strong, nonatomic) IBOutlet UILabel *lblNosMostPopular;
//@property (strong, nonatomic) IBOutlet iCarousel *tabsCarousel;
- (IBAction)btnNavTabAction:(id)sender;
@property(nonatomic, strong) NSString *str_RestaurantID,*strItem,*strPrice,*strTitle,*strMostPopularId,*strNosMostPopular,*strRestaurantTitle,*strTrimMenuHours,*strMenuHours,*strMenuHours2,*strTrimMenuHours2;
@property (strong, nonatomic) IBOutlet UICollectionView *CollectionViewObj;
@property (weak, nonatomic) IBOutlet UIImageView *ImgMenuHide;
@property (weak, nonatomic) IBOutlet UIImageView *NoPopularItemImg;
@property (weak, nonatomic) IBOutlet UIView *PopularViewObj;
@property (weak, nonatomic) IBOutlet UIImageView *ImgHideMenuHours;
@property (weak, nonatomic) IBOutlet UILabel *LblMenuHoursTitle;

@property (weak, nonatomic) IBOutlet UILabel *LblTo;
@property (weak, nonatomic) IBOutlet UILabel *LblDataNil;

@end
