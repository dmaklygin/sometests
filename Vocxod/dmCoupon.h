//
//  dmCoupon.h
//  Vocxod
//
//  Created by Дмитрий on 26.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Coefficient.h"

@interface dmCoupon : NSObject <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)loadBets;
- (BOOL)addBet:(Coefficient *)coefficient;
@end
