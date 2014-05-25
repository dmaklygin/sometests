//
//  Coefficient.h
//  Vocxod
//
//  Created by Дмитрий on 25.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"

@class Event;

@interface Coefficient : NSManagedObject

@property (nonatomic, retain) NSNumber * cid;
@property (nonatomic, retain) NSNumber * direction;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) Event *inEvent;

- (void)setValues:(NSArray *)values forEvent:(Event *)event;
- (NSString *)getOutcomeName;

@end

