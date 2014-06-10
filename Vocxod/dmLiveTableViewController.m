//
//  dmLiveTableViewController.m
//  Vocxod
//
//  Created by Дмитрий on 14.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmLiveTableViewController.h"
#import "dmLineEventsTableViewController.h"
#import "dmTournament.h"
#import "dmLiveTournamentController.h"

@interface dmLiveTableViewController ()
@end

@implementation dmLiveTableViewController

- (IBAction)onMenuButtonClick:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void)removeExpiredEventsInTournament:(id)sender
{
    [self.tournamentController removeExpiredEventsInTournament:self.fetchedResultsController.fetchedObjects inManagedObjectContext:[dmModelController managedObjectContext] forLive:YES];
//    [NSTimer scheduledTimerWithTimeInterval:5
//                                     target:self
//                                   selector:@selector(removeExpiredEventsInTournament:)
//                                   userInfo:nil
//                                    repeats:NO];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    dmTournament *tournament = (dmTournament *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    dmLineEventsTableViewController *lineEventsTableViewController = (dmLineEventsTableViewController *)[segue destinationViewController];
    lineEventsTableViewController.tournament = tournament;
}

- (void)setPredicate:(NSFetchRequest *)fetchRequest
{
    NSDate *nowDate = [[NSDate alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY self.events.time < %@", nowDate];
    [fetchRequest setPredicate:predicate];
}


- (dmTournamentController *)createTournamentController
{
    return [dmLiveTournamentController instance];
}


@end
