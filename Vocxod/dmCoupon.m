//
//  dmCoupon.m
//  Vocxod
//
//  Created by Дмитрий on 26.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmCoupon.h"
#import "Bet.h"


@interface dmCoupon () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation dmCoupon

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.managedObjectContext = managedObjectContext;
    
    return self;
}

- (void)loadBets
{
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Bets Fetch error: %@, %@", error, [error userInfo]);
        abort();
    }
}

- (BOOL)addBet:(Coefficient *)coefficient
{
    Bet *newBet = (Bet *)[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.managedObjectContext];
    
    [newBet setValues:coefficient];
    
    return YES;
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
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"id" cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

/*
 NSFetchedResultsController delegate methods to respond to additions, removals and so on.
*/
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UIAlertView *alertView;

    switch(type) {
        case NSFetchedResultsChangeInsert:
            alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"COUPON", nil) message:NSLocalizedString(@"BET_ADDED_INTO_COUPON", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
}


@end
