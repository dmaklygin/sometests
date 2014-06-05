//
//  dmLineTableViewController.h
//  Vocxod
//
//  Created by Дмитрий on 14.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "dmAppDelegate.h"
#import "ECSlidingViewController.h"

@interface dmLineTableViewController : UITableViewController <NSFetchedResultsControllerDelegate,ECSlidingViewControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) dmAppDelegate * appDelegate;
- (IBAction)onMenuButtonClick:(id)sender;

- (void)removeExpiredEventsInTournament:(id)sender;
@end
