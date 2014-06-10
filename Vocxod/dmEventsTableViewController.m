//
//  dmEventsTableTableViewController.m
//  Vocxod
//
//  Created by Дмитрий on 08.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmEventsTableViewController.h"
#import "dmModelController.h"

#import "Event.h"

#import "dmLiveEventsTableViewCell.h"
#import "dmLineEventsTableViewCell.h"

#import "dmLineEventViewController.h"
#import "dmLiveEventViewController.h"

@interface dmEventsTableViewController ()
- (void)setPredicate:(NSFetchRequest *)fetchRequest;
@end

@implementation dmEventsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    //    Регистрация строк разного вида.
    [self.tableView registerNib:[UINib nibWithNibName:@"dmLiveEventsTableViewCell" bundle:nil] forCellReuseIdentifier:@"LiveEventsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"dmLineEventsTableViewCell" bundle:nil] forCellReuseIdentifier:@"LineEventsCell"];

    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([event isLive]) {
        dmLiveEventsTableViewCell *cell = (dmLiveEventsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LiveEventsCell" forIndexPath:indexPath];
        [cell configureCell:event];
        return cell;
    } else {
        dmLineEventsTableViewCell *cell = (dmLineEventsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LineEventsCell" forIndexPath:indexPath];
        [cell configureCell:event];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *segueID = [event isLive] ? @"LiveEventSegue" : @"LineEventSegue";
    
    [self performSegueWithIdentifier:segueID sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([event isLive]) {
        dmLiveEventViewController *eventViewController = (dmLiveEventViewController *)[segue destinationViewController];
        eventViewController.event = event;
    } else {
        dmLineEventViewController *eventViewController = (dmLineEventViewController *)[segue destinationViewController];
        eventViewController.event = event;
    }
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSManagedObjectContext *managedObjectContext = [dmModelController managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *eventsEntityDescription = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:eventsEntityDescription];
    
    // create Sort
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
    [fetchRequest setSortDescriptors:@[timeSortDescriptor]];
    
    [self setPredicate:fetchRequest];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (void)setPredicate:(NSFetchRequest *)fetchRequest
{
    
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
