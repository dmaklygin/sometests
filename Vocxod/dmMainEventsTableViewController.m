//
//  dmMainTournamentsTableViewController.m
//  Vocxod
//
//  Created by Дмитрий on 15.06.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//

#import "dmMainEventsTableViewController.h"

@interface dmMainEventsTableViewController ()

@end

@implementation dmMainEventsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithSport:(dmSport *)sport
{
    self = [super init];
    if (self) {
        self.sport = sport;
    }
    return self;
}

- (void)setPredicate:(NSFetchRequest *)fetchRequest
{
    NSPredicate *predicate;
    if (self.sport) {
        predicate = [NSPredicate predicateWithFormat:@"self.inTournament.inSport == %@", self.sport];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"1 != 1"];
    }
    [fetchRequest setPredicate:predicate];
}

- (void)setSortDescriptors:(NSFetchRequest *)fetchRequest
{
    NSSortDescriptor *sortByRating = [NSSortDescriptor sortDescriptorWithKey:@"inTournament.rating" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortByRating]];
}

- (void)setLimit:(NSFetchRequest *)fetchRequest
{
    [fetchRequest setFetchLimit:5];
}

@end
