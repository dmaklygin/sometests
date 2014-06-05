//
//  dmCouponItemViewController.h
//  Vocxod
//
//  Created by Дмитрий on 31.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "Bet.h"

@interface dmCouponItemViewController : UIViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *couponTypeSegmentedControl;
@property (strong, nonatomic) IBOutlet UITableView *betsTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *betsTableHeight;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;
- (IBAction)onSendButtonClick:(id)sender;
- (IBAction)onCouponTypeChanged:(UISegmentedControl *)sender;
@end
