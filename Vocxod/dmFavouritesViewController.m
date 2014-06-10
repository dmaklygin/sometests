//
//  dmFavouritesViewController.m
//  Vocxod
//
//  Created by Дмитрий on 06.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmFavouritesViewController.h"
#import "Event.h"
#import "dmLiveEventViewController.h"


@interface dmFavouritesViewController ()

@end

@implementation dmFavouritesViewController

- (void)viewWillAppear:(BOOL)animated
{
    // Do any additional setup after loading the view
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}


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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"in_favourites == %@", @YES];
    [fetchRequest setPredicate:predicate];
}

@end
