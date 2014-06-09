//
//  dmTournamentController.m
//  Vocxod
//
//  Created by Dmitry Maklygin on 16.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmTournamentController.h"

@interface dmTournamentController ()

@property (nonatomic, strong) NSMutableDictionary *params;

@end

@implementation dmTournamentController

- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if (!self) {
        return nil;
    }

    self.params = [NSMutableDictionary dictionaryWithDictionary:params];
    
    return self;
}

- (NSURLSessionDataTask *)loadRemoteTournaments:(void (^)(NSArray *tournaments, NSError *error))block inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    
    if (self.version != nil) {
        [self.params setObject:self.version forKey:@"line_version"];
    }
    
    return [dmTournamentController send:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *rawTournaments = (NSArray *)[responseObject valueForKey:@"tournaments"];
        self.version = (NSNumber *)[responseObject valueForKey:@"line_version"];
        
        NSArray *tournaments = [dmTournament insertTournaments:rawTournaments inManagedObjectContext:managedObjectContext];
        if (block) {
            block(tournaments, nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

-(void)removeExpiredEventsInTournament:(NSArray *)tournaments inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext forLive:(BOOL)isLive
{
//    NSLog(@"start remove Expired Tournaments");
    for (dmTournament *tournament in tournaments) {
        NSMutableSet *newEvents = [[NSMutableSet alloc] init];
        for (Event *event in tournament.events) {
            if ([event isExpired] == YES) {
                [managedObjectContext deleteObject:event];
            } else {
                [newEvents addObject:event];
            }
        }
        if ([newEvents count] != [tournament.events count]) {
            [tournament addEvents:newEvents];
        }

    }
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Couln't remove expired objects. Error: %@, %@", error, [error userInfo]);
    }
//    NSLog(@"Expired Tournaments Removed");
}

@end
