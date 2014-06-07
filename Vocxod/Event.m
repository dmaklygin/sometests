//
//  Event.m
//  Vocxod
//
//  Created by Dmitry Maklygin on 16.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "Event.h"
#import "dmTournament.h"


@implementation Event

@dynamic away;
@dynamic home;
@dynamic id;
@dynamic status;
@dynamic time;
@dynamic current_second;
@dynamic in_favourites;
@dynamic inTournament;
@dynamic coefficients;


- (void)setValues:(NSDictionary *)attributes {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* serverDate = [dateFormatter dateFromString:[attributes valueForKey:@"time"]];
    
    NSNumber *eventId = [attributes valueForKey:@"id"];
    [self setId:eventId];

    if ([[attributes valueForKey:@"away"] isKindOfClass:[NSNumber class]]) {
        [self setValue:[[attributes valueForKey:@"away"] stringValue] forKey:@"away"];
    } else {
        [self setValue:[attributes valueForKey:@"away"] forKey:@"away"];
    }
    
    [self setValue:[attributes valueForKey:@"home"] forKey:@"home"];
    [self setValue:[attributes valueForKey:@"status"] forKey:@"status"];
    [self setValue:serverDate forKey:@"time"];

    NSNumber *currentSecond = [attributes valueForKey:@"current_second"];
    if (currentSecond != nil) {
        self.current_second = currentSecond;
    }
    
    // insert or update events in tournament
    NSMutableDictionary *coefficients = [NSMutableDictionary dictionaryWithDictionary:[attributes valueForKey:@"cs"]];
    [coefficients addEntriesFromDictionary:[attributes valueForKey:@"cse"]];
    [self upsertCoefficients:coefficients];

}

- (void)upsertCoefficients:(NSDictionary *)coefficients
{
    NSMutableArray *currentCoefficients = [NSMutableArray arrayWithArray:[self.coefficients allObjects]];
    NSPredicate *predicate;
    
    for (NSString *coefficientName in coefficients) {
        
        NSArray *coefficientData = coefficients[coefficientName];
        
        predicate = [NSPredicate predicateWithFormat:@"name == %@", coefficientName];
        NSArray *filteredArray = [currentCoefficients filteredArrayUsingPredicate:predicate];
        if (![filteredArray count]) {
            Coefficient *coefficient = [NSEntityDescription insertNewObjectForEntityForName:@"Coefficient" inManagedObjectContext:[self managedObjectContext]];
            [coefficient setName:coefficientName];
            [coefficient setValues:coefficientData forEvent:self];
            [currentCoefficients addObject:coefficient];
        } else {
            Coefficient *coefficient = [filteredArray firstObject];
            [coefficient setValues:coefficientData forEvent:self];
        }
    }
    
    // update coefficients Set
//    self.coefficients = [NSSet setWithArray:currentCoefficients];
    [self setCoefficients:[NSSet setWithArray:currentCoefficients]];
    
    
}

// update coefficients Set
//- (void)setCoefficients:(NSSet *)coefficients
//{
//    [self willChangeValueForKey:@"coefficients"];
//    self.coefficients = coefficients;
//    [self didChangeValueForKey:@"coefficients"];
//}


+ (NSSet *)upsertEvents:(NSArray *)data forTournament:(dmTournament *)tournament inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSMutableArray *events = [NSMutableArray arrayWithArray:[tournament.events allObjects]];
    
    NSPredicate *predicate;
    for (NSDictionary *attributes in data) {
        predicate = [NSPredicate predicateWithFormat:@"id == %@", [attributes valueForKey:@"id"]];
        NSArray *filteredArray = [events filteredArrayUsingPredicate:predicate];
        if (![filteredArray count]) {
            [events addObject:[Event createNewEvent:attributes forTournament:tournament inManagedObjectContext:managedObjectContext]];
//            NSLog(@"insert new Event");
        } else {
            Event *event = [filteredArray firstObject];
            [event setValues:attributes];
//            NSLog(@"update Event");
        }
    }
    
    // update events array
    NSSet *eventsSet = [NSSet setWithArray:events];
    
    return eventsSet;
}

+ (Event *)createNewEvent:(NSDictionary *)attributes forTournament:(dmTournament *)tournament inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:managedObjectContext];
    
    [event setValues:attributes];
    [event setInTournament:tournament];
    
    return event;
}

-(BOOL)isLive
{
    NSDate *nowDate = [NSDate date];
    switch([self.time compare:nowDate]) {
        case NSOrderedAscending:
        case NSOrderedSame:
            return YES;
        case NSOrderedDescending:
            return NO;
            
    }
}

-(BOOL)isLine
{
    return ![self isLive];
}

-(BOOL)isExpired
{
    Coefficient *eventEnded = [self getCoefficientByName:@"coeff_SCORE_ENDED"];
    if (eventEnded != nil) {
        if ([eventEnded.value integerValue] == 1) {
            return YES;
        }
    }
    
    if ([self.status isEqual: @0]) {
        return YES;
    }
    return NO;
}

-(NSString *)getFormatterDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    return [formatter stringFromDate:self.time];
}

- (Coefficient *)getCoefficientByName:(NSString *)mnemonicName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", mnemonicName];
    NSSet *filteredSet = [self.coefficients filteredSetUsingPredicate:predicate];
    NSEnumerator *enumerator = [filteredSet objectEnumerator];
    Coefficient *coefficient;
    
    while ((coefficient = [enumerator nextObject])) {
        return coefficient;
    }
    
    return nil;
}

// Текущий тайм/период/половина матча
- (NSNumber *)getPart
{
    Coefficient *coefficient = [self getCoefficientByName:@"coeff_SCORE_HALF"];
    if (coefficient != nil) {
        return coefficient.value;
    }
    return nil;
}



- (void)addCoefficientsObject:(Coefficient *)value
{
    NSMutableSet *coefficients = (NSMutableSet *)self.coefficients;
    [coefficients addObject:value];
    self.coefficients = coefficients;
}

- (void)removeCoefficientsObject:(Coefficient *)value
{
    
}

- (void)addCoefficients:(NSSet *)values
{
    self.coefficients = values;
}

- (void)removeCoefficients:(NSSet *)values
{
    
}

@end
