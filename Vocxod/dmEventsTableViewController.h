//
//  dmEventsTableTableViewController.h
//  Vocxod
//
//  Created by Дмитрий on 08.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface dmEventsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end
