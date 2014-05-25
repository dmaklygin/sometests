//
//  dmLiveTableViewController.h
//  Vocxod
//
//  Created by Дмитрий on 14.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dmAppDelegate.h"

@interface dmLiveTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) dmAppDelegate * appDelegate;

- (void)removeExpiredEventsInTournament:(id)sender;
@end