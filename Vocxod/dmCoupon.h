//
//  dmCoupon.h
//  Vocxod
//
//  Created by Дмитрий on 26.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Coefficient.h"

typedef NS_ENUM(NSInteger, dmCouponType)
{
    dmCouponTypeSingle,
    dmCouponTypeExpress,
    dmCouponTypeSystem
};

@interface dmCoupon : NSObject <NSFetchedResultsControllerDelegate>

@property (nonatomic) dmCouponType couponType;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)loadBets;
- (BOOL)addBetFromCoefficient:(Coefficient *)coefficient;
- (BOOL)removeBet:(Bet *)bet;
@end
