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

#import "dmTournamentTableViewCell.h"
#import "dmEventTableViewCell.h"

#import "UIAlertView+AFNetworking.h"

#import "MBProgressHUD.h"


@interface dmLiveTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) MBProgressHUD *loader;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSTimer *updaterTimer;

@end

@implementation dmLiveTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    
    self.appDelegate = (dmAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [self.appDelegate managedObjectContext];
    
    self.loader = [[MBProgressHUD alloc] initWithView:self.tableView];
    [self.tableView addSubview:self.loader];
    
    // Загрузка данных из БД
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // Перерисовка таблицы
    [self.tableView reloadData];
    
    // Загрузка данных
    [self reload:nil];
    
    // Таймер релоадит каждые 5 секунд
    [self updaterTimer];
    
//    [self removeExpiredEventsInTournament:nil];
    
}

- (void)dealloc {
    // Release any properties that are loaded in viewDidLoad or can be recreated lazily.
    self.fetchedResultsController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
}


- (void)reload:(id)sender
{
    NSLog(@"RELOAD!!!");
    NSURLSessionDataTask *task = [self.appDelegate.liveTournamentController loadRemoteTournaments:^(NSArray *tournaments, NSError *error) {
        if (!error) {
            [self removeExpiredEventsInTournament:nil];
            [self.tableView reloadData];
            [self.loader hide:YES];
            [self.refreshControl endRefreshing];
        }
    } inManagedObjectContext:self.managedObjectContext];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [self.refreshControl beginRefreshing];
    [self.loader show:YES];
}


- (IBAction)onMenuButtonClick:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void)removeExpiredEventsInTournament:(id)sender
{
    [self.appDelegate.liveTournamentController removeExpiredEventsInTournament:self.fetchedResultsController.fetchedObjects inManagedObjectContext:self.managedObjectContext forLive:YES];
//    [NSTimer scheduledTimerWithTimeInterval:5
//                                     target:self
//                                   selector:@selector(removeExpiredEventsInTournament:)
//                                   userInfo:nil
//                                    repeats:NO];
}

- (NSTimer *)updaterTimer
{
    if (_updaterTimer != nil) {
        return _updaterTimer;
    }
    
    _updaterTimer = [NSTimer timerWithTimeInterval:10
                                           target:self
                                         selector:@selector(reload:)
                                         userInfo:nil
                                          repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_updaterTimer forMode:NSDefaultRunLoopMode];
    
    return _updaterTimer;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(dmTournamentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    @try {
        dmTournament *tournament = [self.fetchedResultsController objectAtIndexPath:indexPath];
        // Configure the cell...
        cell.labelTournamentName.text = [tournament valueForKey:@"name"];
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@, %@", exception, [exception userInfo]);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    dmTournamentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //    return tournament.name;
    NSUInteger sportId = (NSUInteger)[[[[self.fetchedResultsController sections] objectAtIndex:section] name] integerValue];
    dmSport *sport = [self.appDelegate.sportController getSportById:sportId];
    if (sport != nil) {
        return sport.name;
    }
    return @"";
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    dmTournament *tournament = (dmTournament *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    dmLineEventsTableViewController *lineEventsTableViewController = (dmLineEventsTableViewController *)[segue destinationViewController];
    lineEventsTableViewController.tournament = tournament;
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *tournamentsEntityDescription = [NSEntityDescription entityForName:@"Tournament" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:tournamentsEntityDescription];
    
    // create Sort
    NSSortDescriptor *sportSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sport_id" ascending:YES];
    NSSortDescriptor *namesSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rating" ascending:NO];
    [fetchRequest setSortDescriptors:@[sportSortDescriptor, namesSortDescriptor]];
    

    NSDate *nowDate = [[NSDate alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY self.events.time < %@", nowDate];
    [fetchRequest setPredicate:predicate];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"sport_id" cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

/*
 NSFetchedResultsController delegate methods to respond to additions, removals and so on.
 */
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
            NSLog(@"NSFetchedResultsChangeMove!!!!");
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}



@end
