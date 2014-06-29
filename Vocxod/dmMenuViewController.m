//
//  dmMenuTableViewController.m
//  Vocxod
//
//  Created by Дмитрий on 05.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmMenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"

#import "dmAuthorizingViewController.h"
#import "dmMainViewController.h"
#import "dmLineTableViewController.h"
#import "dmLiveTableViewController.h"
#import "dmFavouritesViewController.h"
#import "dmCouponItemViewController.h"

#import "dmUserSettings.h"

NSString * const dmMenuViewControllerItemLogin = @"dm.Vocxod.menu.item.login";
NSString * const dmMenuViewControllerItemMain = @"dm.Vocxod.menu.item.main";
NSString * const dmMenuViewControllerItemSport = @"dm.Vocxod.menu.item.sport";
NSString * const dmMenuViewControllerItemLive = @"dm.Vocxod.menu.item.live";
NSString * const dmMenuViewControllerItemFavourites = @"dm.Vocxod.menu.item.favourites";
NSString * const dmMenuViewControllerItemCoupon = @"dm.Vocxod.menu.item.coupon";

@interface dmMenuViewController ()

@property (nonatomic, strong) NSMutableArray *menuItems;

@property (nonatomic, strong) dmAuthorizingViewController *authorizingViewController;
@property (nonatomic, strong) dmMainViewController *mainViewController;
@property (nonatomic, strong) dmLineTableViewController *lineViewController;

@property (nonatomic, strong) dmLiveTableViewController *liveViewController;
@property (nonatomic, strong) dmFavouritesViewController *favouritesViewController;
@property (nonatomic, strong) dmCouponItemViewController *couponViewController;
@end

@implementation dmMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.menuTable setBackgroundView:nil];
    [self.menuTable setBackgroundColor:[UIColor clearColor]];
    
    [self.menuTable reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)menuItems
{
    if (_menuItems) {
        return _menuItems;
    }
    
    _menuItems = [[NSMutableArray alloc] initWithArray:@[dmMenuViewControllerItemLogin,
                                                         dmMenuViewControllerItemMain,
                                                         dmMenuViewControllerItemSport,
                                                         dmMenuViewControllerItemLive,
                                                         dmMenuViewControllerItemFavourites,
                                                         dmMenuViewControllerItemCoupon
                                                        ]];
    
    return _menuItems;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"prepare");
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString *menuTitle = [self.menuItems objectAtIndex:indexPath.row];

    dmUserSettings *userInfo = [dmUserSettings instance];
    if (menuTitle == dmMenuViewControllerItemLogin) {
        if ([userInfo isLogin]) {
            menuTitle = [userInfo getLogin];
        } else {
            menuTitle = dmMenuViewControllerItemLogin;
        }
    }
    
    cell.textLabel.text = NSLocalizedString(menuTitle, nil);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            self.slidingViewController.topViewController = self.authorizingViewController;
            break;
        case 1:
            self.slidingViewController.topViewController = self.mainViewController;
            break;
        case 2:
            self.slidingViewController.topViewController = self.mainViewController;
            break;
        case 3:
            self.slidingViewController.topViewController = self.lineViewController;
            break;
        case 4:
            self.slidingViewController.topViewController = self.liveViewController;
            break;
        case 5:
            self.slidingViewController.topViewController = self.favouritesViewController;
            break;
        case 6:
            self.slidingViewController.topViewController = self.couponViewController;
            break;
    }
    
    [self.slidingViewController resetTopViewAnimated:YES];
}

- (dmAuthorizingViewController *)authorizingViewController
{
    if (_authorizingViewController) {
        return _authorizingViewController;
    }
    
    _authorizingViewController = [[dmAuthorizingViewController alloc] initWithNibName:@"dmAuthorizingViewController" bundle:nil];
    
    return _authorizingViewController;
}

- (dmMainViewController *)mainViewController
{
    if (_mainViewController) {
        return _mainViewController;
    }
    
    _mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    return _mainViewController;
}

- (dmLineTableViewController *)lineViewController
{
    if (_lineViewController) {
        return _lineViewController;
    }
    _lineViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LineViewController"];
    return _lineViewController;
}


- (dmLiveTableViewController *)liveViewController
{
    if (_liveViewController) {
        return _liveViewController;
    }
    _liveViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LiveViewController"];
    return _liveViewController;
}

- (dmFavouritesViewController *)favouritesViewController
{
    if (_favouritesViewController) {
        return _favouritesViewController;
    }
    _favouritesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FavouritesViewController"];
    return _favouritesViewController;
}

- (dmCouponItemViewController *)couponViewController
{
    if (_couponViewController) {
        return _couponViewController;
    }
    _couponViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CouponViewController"];
    return _couponViewController;
}


@end
