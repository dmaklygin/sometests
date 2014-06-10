//
//  dmLiveEventsTableViewController.m
//  Vocxod
//
//  Created by Дмитрий on 19.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmLiveEventsTableViewController.h"
#import "dmLiveEventViewController.h"

@interface dmLiveEventsTableViewController ()
@end

@implementation dmLiveEventsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//#pragma mark - Table view data source
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self performSegueWithIdentifier:@"LiveEventSegue" sender:self];
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    dmLiveEventViewController *eventViewController = (dmLiveEventViewController *)[segue destinationViewController];
    eventViewController.event = event;
}

- (void)setPredicate:(NSFetchRequest *)fetchRequest
{
    NSDate *nowDate = [NSDate date];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"time < %@ AND self.inTournament == %@", nowDate, self.tournament];
    [fetchRequest setPredicate:predicate];
}

@end
