//
//  dmLineEventsTableViewController.m
//  Vocxod
//
//  Created by Дмитрий on 17.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmLineEventsTableViewController.h"

@implementation dmLineEventsTableViewController

- (void)setPredicate:(NSFetchRequest *)fetchRequest
{
    NSDate *nowDate = [NSDate date];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"time > %@ AND self.inTournament == %@", nowDate, self.tournament];
    [fetchRequest setPredicate:predicate];
}

@end
