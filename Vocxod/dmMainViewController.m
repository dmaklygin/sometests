//
//  dmMainViewController.m
//  Vocxod
//
//  Created by Дмитрий on 14.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//
#import "UIViewController+ECSlidingViewController.h"
#import "dmMainViewController.h"
#import "dmMainEventsTableViewController.h"


@interface dmMainViewController ()
@property (nonatomic, strong) NSFetchedResultsController *sportsResultsController;
@end

@implementation dmMainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dataSource = self;
    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)unwindToMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    NSUInteger count = [self.sportsResultsController.fetchedObjects count];
    if (!count) {
        count = 1;
    }
    return count;
}


#pragma mark - ViewPagerDataSource
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    
    if ([self.sportsResultsController.fetchedObjects count]) {
        dmSport *sport = [self.sportsResultsController.fetchedObjects objectAtIndex:index];
        label.text = [NSString stringWithFormat:@"%@", sport.name];
    } else {
        label.text = @"noname";
    }
    
    [label sizeToFit];
    
    return label;
}

#pragma mark - ViewPagerDataSource
- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
//    ContentViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
//    
//    return cvc;
    dmMainEventsTableViewController *eventsTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainEventsTableViewController"];
    
    if ([self.sportsResultsController.fetchedObjects count]) {
        dmSport *sport = [self.sportsResultsController.fetchedObjects objectAtIndex:index];
        eventsTableViewController.sport = sport;
    }
    
    
    return eventsTableViewController;
}


- (NSFetchedResultsController *)sportsResultsController
{
    if (_sportsResultsController) {
        return _sportsResultsController;
    }
    
    _sportsResultsController = [[dmSportController instance] fetchedResultsController];

    return _sportsResultsController;
}


@end
