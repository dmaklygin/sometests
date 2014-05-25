//
//  dmResultController.h
//  Vocxod
//
//  Created by Dmitry Maklygin on 12.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "dmSport.h"

@interface dmSportController : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

-(void)loadData:(void (^)(NSArray *sports, NSError *error))block;
- (dmSport *)getSportById:(NSUInteger)sportId;


@end
