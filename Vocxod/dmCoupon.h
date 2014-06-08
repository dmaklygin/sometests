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


typedef NS_ENUM(NSInteger, dmCouponError)
{
    dmCouponErrorEventExist
};


@interface dmCoupon : NSObject <NSFetchedResultsControllerDelegate,UIAlertViewDelegate>

@property (nonatomic) dmCouponType couponType;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

+ (instancetype)instance;

- (void)loadBets;
- (BOOL)addBetFromCoefficient:(Coefficient *)coefficient;
- (BOOL)removeBet:(Bet *)bet;

- (BOOL)canMultiType;

- (BOOL)check:(NSError *__autoreleasing *)error;

// UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
