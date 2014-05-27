//
//  Bet.m
//  Vocxod
//
//  Created by Дмитрий on 26.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "Bet.h"
#import "Coefficient.h"
#import "Event.h"

@interface Bet ()
- (NSString *)generateBetId:(Coefficient *)coefficient;
@end

@implementation Bet

@dynamic id;
@dynamic cf_value;
@dynamic mnemonic_name;
@dynamic value;
@dynamic min;
@dynamic max;
@dynamic inCoefficient;

- (void)setValues:(Coefficient *)coefficient
{
    [self setId:[self generateBetId:coefficient]];
    [self setCf_value:coefficient.value];
    [self setMnemonic_name:coefficient.name];
    [self setInCoefficient:coefficient];
}

- (NSString *)generateBetId:(Coefficient *)coefficient
{
    Event *event = (Event *)coefficient.inEvent;
    NSString *betId = [NSString stringWithFormat:@"%@-%@", [event.id stringValue], coefficient.name];
    
    return betId;
}

- (Event *)getEvent
{
    return self.inCoefficient.inEvent;
}

@end
