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


@end
