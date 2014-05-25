//
//  dmTournament.m
//  Vocxod
//
//  Created by Дмитрий on 14.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmTournament.h"
#import "dmAppAPIClient.h"
#import "dmAppDelegate.h"
@implementation dmTournament

@dynamic id, sport_id, name, rating, inSport, events;


+ (NSArray *)insertTournaments:(NSArray *)data inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSMutableArray *tournaments = [[NSMutableArray alloc] init];
    NSMutableArray *tournamentsIDs = [[NSMutableArray alloc] init];
    for (NSDictionary *item in data) {
        [tournamentsIDs addObject:[item valueForKey:@"id"]];
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:
     [NSEntityDescription entityForName:@"Tournament" inManagedObjectContext:managedObjectContext]];
    
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat:@"(id IN %@)", tournamentsIDs]];
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey: @"id" ascending:YES]]];
    // Execute the fetch.
    NSError *error;
    NSArray *tournamentsMatchingNames = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error != nil) {
        NSLog(@"Unable to parse matching names: error = %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSPredicate *predicate;
    for (NSDictionary *attributes in data) {
        
        predicate = [NSPredicate predicateWithFormat:@"id == %@", [attributes valueForKey:@"id"]];
        NSArray *filteredArray = [tournamentsMatchingNames filteredArrayUsingPredicate:predicate];
        if (![filteredArray count]) {
            [tournaments addObject:[dmTournament insertNewTournament:attributes inManagedObjectContext:managedObjectContext]];
//            NSLog(@"insert new Tournament");
        } else {
            // Update Tournament!
            dmTournament *tournament = (dmTournament *)[filteredArray firstObject];
            [tournament upsertEvents:(NSArray *)[attributes valueForKey:@"events"]];
//            NSLog(@"update Tournament");
        }
    }
    
    NSError *saveError;
    if (![managedObjectContext save:&saveError]) {
        NSLog(@"UPsert Tournaments error %@, %@", saveError, [saveError userInfo]);
        abort();
    }
    
//    
//    for (dmTournament *tourn in tournamentsMatchingNames) {
//        [tourn setIn]
//    }
    
    return tournaments;
}

+ (dmTournament *)insertNewTournament:(NSDictionary *)attributes inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    dmAppDelegate *appDelegate = (dmAppDelegate *)[[UIApplication sharedApplication] delegate];
    dmTournament *newTournament = [NSEntityDescription insertNewObjectForEntityForName:@"Tournament" inManagedObjectContext:managedObjectContext];
    
    NSUInteger sportId = [(NSNumber *)[attributes valueForKey:@"sport_id"] integerValue];
    dmSport *sport = [appDelegate.sportController getSportById:sportId];
    
    [newTournament setValue:[attributes valueForKey:@"id"] forKey:@"id"];
    [newTournament setValue:[attributes valueForKey:@"sport_id"] forKey:@"sport_id"];
    [newTournament setValue:[attributes valueForKey:@"name"] forKey:@"name"];
    [newTournament setValue:[attributes valueForKey:@"rating"] forKey:@"rating"];
    [newTournament setInSport:sport];
    // insert or update events in tournament
    [newTournament upsertEvents:(NSArray *)[attributes valueForKey:@"events"]];
    
    return newTournament;
}


- (void)addEventsObject:(Event *)value {
    NSMutableSet *events = (NSMutableSet *)self.events;
    [events addObject:value];
    self.events = events;
}

- (void)removeEventsObject:(Event *)value {
    
}

- (void)addEvents:(NSSet *)values {
    self.events = values;
}

- (void)removeEvents:(NSSet *)values {
    
}

- (void)upsertEvents:(NSArray *)events {
    NSSet *eventsSet = [Event upsertEvents:events forTournament:self inManagedObjectContext:self.managedObjectContext];
    self.events = eventsSet;
}


@end
