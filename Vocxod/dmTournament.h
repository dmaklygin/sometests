//
//  dmTournament.h
//  Vocxod
//
//  Created by Дмитрий on 14.04.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "dmSport.h"
#import "Event.h"

@class dmSport;

@interface dmTournament : NSManagedObject

@property (nonatomic, assign) NSUInteger id;
@property (nonatomic, assign) NSUInteger sport_id;
@property (nonatomic, assign) NSUInteger rating;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, retain) dmSport *inSport;
@property (nonatomic, retain) NSSet *events;


//+ (NSURLSessionDataTask *)tournamentsWithBlock:(void (^)(NSArray *tournaments, NSError *error))block withParameters:(NSDictionary*)parameters inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (NSArray *)insertTournaments:(NSArray *)data inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (dmTournament *)insertNewTournament:(NSDictionary *)attributes inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

@interface dmTournament (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
