//
//  dmLineEventsTableViewController.h
//  Vocxod
//
//  Created by Дмитрий on 17.05.14.
//  Copyright (c) 2014 DmitryCo. All rights reserved.
//
#import "dmEventsTableViewController.h"
#import "dmTournament.h"

@interface dmLineEventsTableViewController : dmEventsTableViewController
@property (nonatomic,strong) dmTournament *tournament;
@end
