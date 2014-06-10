//
//  dmResultController.m
//  Vocxod
//
//  Created by Dmitry Maklygin on 12.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmSportController.h"

@interface dmSportController () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation dmSportController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.managedObjectContext = managedObjectContext;
    
    return self;
}

-(void)loadData:(void (^)(NSArray *sports, NSError *error))block {
    NSError *error;
    
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Fetch error = %@", error);
        return block(nil, error);
    }
    
    NSArray *fetchedObjects = self.fetchedResultsController.fetchedObjects;
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", @2];
//    NSArray *filteredObjects = [fetchedObjects filteredArrayUsingPredicate:predicate];
//    NSLog(@"filtered objects = %@, %lu", filteredObjects, (unsigned long)[filteredObjects count]);
//    for (dmSport *sport in fetchedObjects) {
//        NSLog(@"sport = %@", [sport valueForKey:@"id"]);
//    }
    
    if (![fetchedObjects count]) {
        [self loadRemoteData: ^(NSArray *sports, NSError *error) {
            NSLog(@" ------ Remote Sports -----");
            if (error != nil) {
                return block(nil, error);
            }
            
            [self loadData:block];
            
        }];
    } else {
        block(fetchedObjects, nil);
    }
}

- (void)loadRemoteData:(void (^)(NSArray *sports, NSError *error))block {
    [dmSport sportsWithBlock:block managedObjectContext:self.managedObjectContext];
}



- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *sportEntityDescription = [NSEntityDescription entityForName:@"Sport" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:sportEntityDescription];
    
    // create Sort
    NSSortDescriptor *ratingSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rating" ascending:NO];
    NSSortDescriptor *namesSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[ratingSortDescriptor, namesSortDescriptor]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"name" cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}


/*
 NSFetchedResultsController delegate methods to respond to additions, removals and so on.
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    NSLog(@"controllerWillChangeContent");
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    NSLog(@"didChangeObject");
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    NSLog(@"didChangeSection");
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    NSLog(@"controllerDidChangeContent");
}


- (dmSport *)getSportById:(NSUInteger)sportId
{
    NSNumber *ID = [NSNumber numberWithInteger:sportId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", ID];
    NSArray *filteredArray = [[self.fetchedResultsController fetchedObjects] filteredArrayUsingPredicate:predicate];
    if (![filteredArray count]) {
        return nil;
    }
    return [filteredArray firstObject];
}




@end
