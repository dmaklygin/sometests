//
//  dmCouponItemViewController.m
//  Vocxod
//
//  Created by Дмитрий on 31.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmCouponItemViewController.h"
#import "dmAppDelegate.h"

#import "dmCouponMultiViewCell.h"
#import "dmCouponSingleViewCell.h"

@interface dmCouponItemViewController () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) dmCoupon *coupon;
@property (nonatomic) float cellHeight;


- (void)reloadData;
- (NSString *)getIdentifier;

@end

@implementation dmCouponItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    dmAppDelegate *appDelegate = (dmAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    self.coupon = [appDelegate coupon];

//    Регистрация строк разного вида.
    [self.betsTableView registerNib:[UINib nibWithNibName:@"dmCouponSingleViewCell" bundle:nil] forCellReuseIdentifier:@"couponSingleCell"];
    [self.betsTableView registerNib:[UINib nibWithNibName:@"dmCouponMultiViewCell" bundle:nil] forCellReuseIdentifier:@"couponMultiCell"];

    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self adjustTableViewHeight];
    
    [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];

}

// Перерисовывает Представление.
- (void)reloadData
{
    [self.betsTableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onMenuButtonClick:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Bet *bet = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Configure the cell...
    cell.textLabel.text = [bet valueForKey:@"mnemonic_name"];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    dmCouponSingleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self getIdentifier] forIndexPath:indexPath];
 
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:[self getIdentifier]];
    }
 
    Bet *bet = [self.fetchedResultsController objectAtIndexPath:indexPath];
 
    cell.labelHome.text = [bet getEvent].home;
    cell.labelAway.text = [bet getEvent].away;
    cell.labelOutcomeName.text = bet.mnemonic_name;
    cell.labelCoefficientValue.text = [bet.cf_value stringValue];
 
    return cell;
 
 //    [self configureCell:cell atIndexPath:indexPath];
 // Configure the cell...
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
}



- (float)cellHeight
{
    if (_cellHeight) {
        return _cellHeight;
    }
    dmCouponSingleViewCell *cell;

    cell = (dmCouponSingleViewCell *)[self.betsTableView dequeueReusableCellWithIdentifier:[self getIdentifier]];

    _cellHeight = cell.bounds.size.height;

    return _cellHeight;
}

- (void)adjustTableViewHeight
{
    CGFloat height = self.betsTableView.contentSize.height;
    CGFloat maxHeight = self.view.frame.size.height - self.betsTableView.frame.origin.y;
    
    if (height > maxHeight) {
        height = maxHeight;
    }
    
    self.betsTableHeight.constant = height;

    [self.view setNeedsUpdateConstraints];
}

- (NSString *)getIdentifier
{
    switch (self.couponTypeSegmentedControl.selectedSegmentIndex) {
        case dmCouponTypeSingle:
            return @"couponSingleCell";
            break;
        case dmCouponTypeExpress:
            return @"couponMultiCell";
            break;
    }
    return @"couponMultiCell";
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *betsDescription = [NSEntityDescription entityForName:@"Bet" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:betsDescription];
    
    NSSortDescriptor *sortById = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortById]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


/*
 NSFetchedResultsController delegate methods to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
 // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.betsTableView beginUpdates];
}

 
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    
    self.cellHeight = 0;
 
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.betsTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(UITableViewCell *)[self.betsTableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeDelete:
            [self.betsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}
 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.betsTableView endUpdates];
}

- (IBAction)onSendButtonClick:(id)sender {
    
    UIAlertView *alertView;
    NSError *error;
    if (![self.coupon check:&error]) {
        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"COUPON", nil) message:error.description delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    NSLog(@"SendButton click");
}

- (IBAction)onCouponTypeChanged:(UISegmentedControl *)sender {
    UIAlertView *alertView;
        
    if (sender.selectedSegmentIndex == 2 && [self.fetchedResultsController.fetchedObjects count] < 3) {
        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"COUPON", nil) message:NSLocalizedString(@"SYSTEM_TYPE_REQUIRED_MIN_3_BETS", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [self.couponTypeSegmentedControl setSelectedSegmentIndex:0];
        return;
    } else if (sender.selectedSegmentIndex > 0 && ![self.coupon canMultiType]) {
        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"COUPON", nil) message:NSLocalizedString(@"DO_NOT_SWITCH_COUPON_TO_MULTI", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [self.couponTypeSegmentedControl setSelectedSegmentIndex:0];
        return;
    }
        
    [self.coupon setCouponType:sender.selectedSegmentIndex];
        
    self.cellHeight = 0;
        
    [self reloadData];
}



@end
