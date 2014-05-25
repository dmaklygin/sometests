//
//  Event.h
//  Vocxod
//
//  Created by Dmitry Maklygin on 16.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Coefficient.h"

@class dmTournament;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * away;
@property (nonatomic, retain) NSString * home;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) dmTournament *inTournament;
@property (nonatomic, retain) NSSet *coefficients;

- (void)setValues:(NSDictionary *)attributes;

+ (NSSet *)upsertEvents:(NSArray *)data forTournament:(dmTournament *)tournament inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (Event *)createNewEvent:(NSDictionary *)attributes forTournament:(dmTournament *)tournament inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
-(BOOL)isLive;
-(BOOL)isLine;
-(BOOL)isExpired;
-(NSString *)getFormatterDate;

-(void)upsertCoefficients:(NSDictionary *)coefficients;
@end


@interface Event (CoreDataGeneratedAccessors)

- (void)addCoefficientsObject:(Coefficient *)value;
- (void)removeCoefficientsObject:(Coefficient *)value;
- (void)addCoefficients:(NSSet *)values;
- (void)removeCoefficients:(NSSet *)values;

@end