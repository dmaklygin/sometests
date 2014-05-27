//
//  dmCoupon.m
//  Vocxod
//
//  Created by Дмитрий on 26.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmCoupon.h"
#import "Bet.h"

NSString * const dmCouponErrorDomain = @"dmCouponErrorDomain";

@interface dmCoupon () <NSFetchedResultsControllerDelegate, UIAlertViewDelegate>
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

- (BOOL)addBetFromCoefficient:(Coefficient *)coefficient
{
    if (coefficient.bet != nil) {
        [self removeBet:coefficient.bet];
        return NO;
    }
    
    NSError *error;
    UIAlertView *alertView;
    if (![self validateBetFromCoefficient:coefficient withError:&error]) {
        switch (error.code) {
            case dmCouponErrorEventExist:
                alertView = [[UIAlertView alloc]
                             initWithTitle:NSLocalizedString(@"COUPON", nil)
                             message:NSLocalizedString(@"BET_CREATE_ERROR_EVENT_EXIST", nil)
                             delegate:self
                             cancelButtonTitle:@"CANCEL"
                             otherButtonTitles:@"BET_CHANGE",@"BET_REMOVE",@"SINGLE", nil
                             ];
                [alertView show];
                break;
        }
        return NO;
    }
    
    Bet *newBet = (Bet *)[NSEntityDescription insertNewObjectForEntityForName:@"Bet" inManagedObjectContext:self.managedObjectContext];
    [newBet setValues:coefficient];
    
    return YES;
}

- (BOOL)removeBet:(Bet *)bet
{
    [self.managedObjectContext deleteObject:bet];

    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Couln't remove Bet. Error: %@, %@", error, [error userInfo]);
        return NO;
    }
    return YES;
}

- (BOOL)validateBetFromCoefficient:(Coefficient *)coefficient withError:(NSError * __autoreleasing *)error
{
    Event *existEvent;
    
    for (Bet *currentBet in self.fetchedResultsController.fetchedObjects) {
        if ([currentBet getEvent] == coefficient.inEvent) {
            existEvent = [currentBet getEvent];
            break;
        }
    }
    
    if (existEvent && self.couponType == dmCouponTypeExpress) {
        *error = [[NSError alloc] initWithDomain:dmCouponErrorDomain code:dmCouponErrorEventExist userInfo:@{@"existEvent": existEvent}];
        return NO;
    }
    
    //  @TODO Проверка на связанные события. Не забыть!!!
    
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
        case NSFetchedResultsChangeDelete:
            alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"COUPON", nil) message:NSLocalizedString(@"BET_REMOVED_FROM_COUPON", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
}

//
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex = %ld", (long)buttonIndex);
}


@end
