//
//  dmLineEventsTableViewController.h
//  Vocxod
//
//  Created by Дмитрий on 17.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "dmTournament.h"
#import "Event.h"

@interface dmLineEventsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (nonatomic,strong) dmTournament *tournament;
@end
