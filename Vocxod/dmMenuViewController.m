//
//  dmMenuTableViewController.m
//  Vocxod
//
//  Created by Дмитрий on 05.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmMenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"

#import "dmMainViewController.h"
#import "dmLineTableViewController.h"
#import "dmLiveTableViewController.h"
#import "dmFavouritesViewController.h"
#import "dmCouponItemViewController.h"

@interface dmMenuViewController ()
@property (nonatomic, strong) NSMutableArray *menuItems;

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
    
    _menuItems = [[NSMutableArray alloc] initWithArray:@[NSLocalizedString(@"MAIN", nil),
                                                         NSLocalizedString(@"SPORT", nil),
                                                         NSLocalizedString(@"LIVE", nil),
                                                         NSLocalizedString(@"FAVOURITES", nil),
                                                         NSLocalizedString(@"COUPON", nil)
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
    NSString *menuItem = [self.menuItems objectAtIndex:indexPath.row];

    cell.textLabel.text = menuItem;
    
//    cell.backgroundColor = [UIColor clearColor];
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
    
//    NSString *menuItem = self.menuItems[indexPath.row];
    
    switch (indexPath.row) {
        case 0:
            self.slidingViewController.topViewController = self.mainViewController;
            break;
        case 1:
            self.slidingViewController.topViewController = self.lineViewController;
            break;
        case 2:
            self.slidingViewController.topViewController = self.liveViewController;
            break;
        case 4:
            self.slidingViewController.topViewController = self.couponViewController;
            break;
        default:
            break;
    }
    
    [self.slidingViewController resetTopViewAnimated:YES];
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

- (dmCouponItemViewController *)couponViewController
{
    if (_couponViewController) {
        return _couponViewController;
    }
    _couponViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CouponViewController"];
    return _couponViewController;
}


@end
