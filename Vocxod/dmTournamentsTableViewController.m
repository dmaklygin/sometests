//
//  dmTournamentsTableViewController.m
//  Vocxod
//
//  Created by Дмитрий on 09.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmTournamentsTableViewController.h"

#import "dmTournament.h"

#import "dmTournamentTableViewCell.h"

#import "UIAlertView+AFNetworking.h"
#import "MBProgressHUD.h"

@interface dmTournamentsTableViewController ()


@property (nonatomic, strong) MBProgressHUD *loader;
@property (nonatomic, strong) NSTimer *updaterTimer;

- (void)setPredicate:(NSFetchRequest *)fetchRequest;
- (void)configureCell:(UITableViewCell *)cell withTournament:(dmTournament *)tournament;
- (void)removeExpiredEventsInTournament:(id)sender;
- (dmTournamentController *)createTournamentController;
@end

@implementation dmTournamentsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    [self setRefreshControl];
    
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
}

- (void)dealloc {
    // Release any properties that are loaded in viewDidLoad or can be recreated lazily.
    self.fetchedResultsController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIRefreshControl *)setRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    
    return self.refreshControl;
}

- (void)reload:(id)sender
{
    NSURLSessionDataTask *task = [self.tournamentController loadRemoteTournaments:^(NSArray *tournaments, NSError *error) {
        if (!error) {
            [self removeExpiredEventsInTournament:nil];
            [self.tableView reloadData];
            [self.loader hide:YES];
            [self.refreshControl endRefreshing];
        }
    } inManagedObjectContext:[dmModelController managedObjectContext]];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
    [self.refreshControl beginRefreshing];
    [self.loader show:YES];
}

- (NSTimer *)updaterTimer
{
    if (_updaterTimer != nil) {
        return _updaterTimer;
    }
    
    _updaterTimer = [NSTimer timerWithTimeInterval:[self getTimerPeriod]
                                            target:self
                                          selector:@selector(reload:)
                                          userInfo:nil
                                           repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_updaterTimer forMode:NSDefaultRunLoopMode];
    
    return _updaterTimer;
}

- (int)getTimerPeriod
{
    return 10;
}

- (void)removeExpiredEventsInTournament:(id)sender
{
    
}

- (dmTournamentController *)tournamentController
{
    if (_tournamentController) {
        return _tournamentController;
    }
    
    _tournamentController = [self createTournamentController];
    
    return _tournamentController;
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

- (void)configureCell:(UITableViewCell *)cell withTournament:(dmTournament *)tournament
{
    dmTournamentTableViewCell *dmCell = (dmTournamentTableViewCell *)cell;
    dmCell.labelTournamentName.text = [tournament valueForKey:@"name"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    dmTournamentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    dmTournament *tournament = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Configure the cell.
    [self configureCell:cell withTournament:tournament];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSArray *tournamentsInSection = [sectionInfo objects];
    
    if ([tournamentsInSection count]) {
        dmTournament *tournament = [tournamentsInSection objectAtIndex:0];
        return tournament.inSport.name;
    }
    
    return @"";
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSManagedObjectContext *managedObjectContext = [dmModelController managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *tournamentsEntityDescription = [NSEntityDescription
                                                         entityForName:@"Tournament"
                                                         inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:tournamentsEntityDescription];
    
    // create Sort
    NSSortDescriptor *sportSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sport_id" ascending:YES];
    NSSortDescriptor *namesSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rating" ascending:NO];
    [fetchRequest setSortDescriptors:@[sportSortDescriptor, namesSortDescriptor]];
    
    [self setPredicate:fetchRequest];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"sport_id" cacheName:nil];
    
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

- (dmTournamentController *)createTournamentController
{
    return nil;
}


@end
