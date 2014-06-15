//
//  dmResultController.h
//  Vocxod
//
//  Created by Dmitry Maklygin on 12.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "dmSport.h"
#import "dmModelController.h"

@interface dmSportController : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (instancetype)instance;
- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

-(void)loadData:(void (^)(NSArray *sports, NSError *error))block;
- (dmSport *)getSportById:(NSUInteger)sportId;


@end
