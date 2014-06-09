//
//  dmTournamentsTableViewController.h
//  Vocxod
//
//  Created by Дмитрий on 09.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "UIViewController+ECSlidingViewController.h"
#import "dmTournamentController.h"
#import "dmModelController.h"

@interface dmTournamentsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, ECSlidingViewControllerDelegate>
@property (nonatomic, strong) dmTournamentController *tournamentController;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end
