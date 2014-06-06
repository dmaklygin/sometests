//
//  dmLiveTableViewController.h
//  Vocxod
//
//  Created by Дмитрий on 14.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dmAppDelegate.h"
#import "UIViewController+ECSlidingViewController.h"

@interface dmLiveTableViewController : UITableViewController <NSFetchedResultsControllerDelegate,ECSlidingViewControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) dmAppDelegate * appDelegate;
- (IBAction)onMenuButtonClick:(id)sender;

- (void)removeExpiredEventsInTournament:(id)sender;
@end