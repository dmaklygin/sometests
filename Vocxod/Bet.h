//
//  Bet.h
//  Vocxod
//
//  Created by Дмитрий on 26.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;
@class Coefficient;

@interface Bet : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * cf_value;
@property (nonatomic, retain) NSString * mnemonic_name;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSNumber * min;
@property (nonatomic, retain) NSNumber * max;
@property (nonatomic, retain) Coefficient *inCoefficient;

- (void)setValues:(Coefficient *)coefficient;
- (Event *)getEvent;

@end
