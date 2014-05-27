//
//  dmCouponViewController.h
//  Vocxod
//
//  Created by Dmitry Maklygin on 26.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "Bet.h"

@interface dmCouponViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UISegmentedControl *couponTypeSegmentedControl;
@property (strong, nonatomic) IBOutlet UITableView *betsTableView;

- (IBAction)onCouponTypeValueChanged:(id)sender;

@end
