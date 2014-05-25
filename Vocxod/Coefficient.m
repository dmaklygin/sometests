//
//  Coefficient.m
//  Vocxod
//
//  Created by Дмитрий on 25.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "Coefficient.h"
#import "Event.h"
#import "dmAppDelegate.h"

@implementation Coefficient

@dynamic cid;
@dynamic direction;
@dynamic name;
@dynamic uid;
@dynamic value;
@dynamic inEvent;

- (void)setValues:(NSArray *)values forEvent:(Event *)event
{
    NSNumber *previousValue = self.value;
    NSNumber *value = values[2];
    NSNumber *direction = [NSNumber numberWithDouble:([value doubleValue] - [previousValue doubleValue])];
    
    [self setValue:values[0] forKey:@"uid"];
    [self setValue:values[1] forKey:@"cid"];
    [self setValue:value forKey:@"value"];
    [self setValue:direction forKey:@"direction"];
    [self setInEvent:event];
}

- (NSString *)getOutcomeName
{
    dmAppDelegate *appDelegate = (dmAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return [appDelegate.outcomesController getOutcomeName:self.name];
}

@end
