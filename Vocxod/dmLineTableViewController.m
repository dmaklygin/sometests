//
//  dmLineTableViewController.m
//  Vocxod
//
//  Created by Дмитрий on 14.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmLineTableViewController.h"
#import "dmLineEventsTableViewController.h"

#import "dmTournament.h"
#import "dmTournamentTableViewCell.h"

//#import "UIRefreshControl+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"

#import "dmAppDelegate.h"
#import "MBProgressHUD.h"


@interface dmLineTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) MBProgressHUD *loader;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSTimer *updaterTimer;

@end

@implementation dmLineTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setRefreshControl];
    
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
    
    // Таймер релоадит каждые 60 секунд
    [self updaterTimer];
    
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
    
    NSURLSessionDataTask *task = [self.appDelegate.prematchTournamentController loadRemoteTournaments:^(NSArray *tournaments, NSError *error) {
        if (!error) {
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            [self.loader hide:YES];
            NSLog(@"tournaments = %@", tournaments);
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
    [self.appDelegate.prematchTournamentController removeExpiredEventsInTournament:self.fetchedResultsController.fetchedObjects inManagedObjectContext:self.managedObjectContext forLive:NO];
    [NSTimer scheduledTimerWithTimeInterval:5
                                     target:self
                                   selector:@selector(removeExpiredEventsInTournament:)
                                   userInfo:nil
                                    repeats:NO];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIRefreshControl *)setRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    //    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Update"];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    
    return self.refreshControl;
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
    dmTournament *tournament = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Configure the cell...
    cell.labelTournamentName.text = [tournament valueForKey:@"name"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    dmTournamentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
//    @TODO будем использовать другой класс Ячейки, где будут Виды спорта, как секции.
//    NSDictionary *event = [tournament.events objectAtIndex:indexPath.row];
//
//    // Configure the cell...
//    cell.labelHome.text = [event objectForKey:@"home"];
//    cell.labelAway.text = [event objectForKey:@"away"];
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    dmTournament *tournament = [_tournaments objectAtIndex:section];
//    return tournament.name;
    NSUInteger sportId = (NSUInteger)[[[[self.fetchedResultsController sections] objectAtIndex:section] name] integerValue];
    dmSport *sport = [self.appDelegate.sportController getSportById:sportId];
    if (sport != nil) {
        return sport.name;
    }
    return @"";
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
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
    
    NSDate *nowDate = [NSDate date];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY self.events.time > %@", nowDate];
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
            [self configureCell:(dmTournamentTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
