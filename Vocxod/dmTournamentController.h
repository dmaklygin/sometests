//
//  dmTournamentController.h
//  Vocxod
//
//  Created by Dmitry Maklygin on 16.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmTournament.h"
#import "dmAppAPIClient.h"

@interface dmTournamentController : dmAppAPIClient
@property (nonatomic, strong) NSNumber *version;

- (instancetype)initWithParams:(NSDictionary *)params;
- (NSURLSessionDataTask *)loadRemoteTournaments:(void (^)(NSArray *tournaments, NSError *error))block inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
-(void)removeExpiredEventsInTournament:(NSArray *)tournaments inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext forLive:(BOOL)isLive;
@end
